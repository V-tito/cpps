#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Type for code generator
"""
import re
import json
import llvmlite.ir as ll
from ctypes import *

# from .codegen_state import global_no_error
"""Type classes have load_from_json_code and save_to_json_code
 methods. They return C++ code for those corresponding purposes
"""


class Type:
    def __init__(self, type_object):
        self.location = type_object["location"]
        for extra_field in ["type_name", "custom_type"]:
            if extra_field in type_object:
                self.__dict__[extra_field] = type_object[extra_field]

        if "fields" in type_object:
            self.fields = {}
            for field, type_ in type_object["fields"].items():
                self.fields[field] = get_type(type_)

        if "name" in type_object:
            self.name = type_object["name"]
        else:
            self.element = get_type(type_object["element"])
            self.multi_type = type_object["multi_type"]

    def llvm_type(self):
        if "custom_type" in self.__dict__ and self.custom_type:
            return self.type_name  # TBD
        else:
            return self.__llvm_type__

    @property
    def internal_type(self):
        return self.__llvm_type__

    def to_ctype(self, value):
        return self.ctype(value)

    """def save_to_json_code(self, target_object, object_):
        if global_no_error:
            return f"{target_object} = {object_};"
        else:
            return f'if ({object_}.error) {target_object} = "ERROR"; else {target_object} = {object_};"""


class IntegerType(Type):
    __llvm_type__ = ll.IntType(64)
    ctype = c_int64

    '''def load_from_json_code(self, name, src_object):
        return f"{self.cpp_type} {name} = {src_object}.asInt();"'''


class RealType(Type):
    __llvm_type__ = ll.DoubleType()
    ctype = c_double

    '''def load_from_json_code(self, name, src_object):
        return f"{self.cpp_type} {name} = {src_object}.asFloat();"'''


class BooleanType(Type):
    __llvm_type__ = ll.IntType(1)
    ctype = c_bool
    '''def load_from_json_code(self, name, src_object):
        return f"{self.cpp_type} {name} = {src_object}.asBool();"'''


def remove_spec_symbols(string):
    return re.sub("[^a-zA-Z0-9]", "_", string).replace(".", "_")


class ArrayType(Type):
    count = 0  # default element count todo determine by optimizer
    ctypes_ = []

    def llvm_type(self):
        return ll.ArrayType(
            (
                self.element.llvm_type()
                if not isinstance(self.element, ArrayType)
                else self.element.make_dope_struct_type()
            ),
            self.count,
        )

    def __init__(self, type_object):
        super().__init__(type_object)

    @classmethod
    def get_dim_sizes(cls, vals, depth):
        sizes = []
        if depth > 1:
            sizes = ArrayType.get_dim_sizes(vals[0], depth - 1)
        sizes.append(len(vals))
        return sizes

    def convert_top_level_array(self, vals):
        if not self.ctypes_:
            sizes = ArrayType.get_dim_sizes(vals, self.dimensions())
            prev_ctype = self.bottom_element_type().ctype
            underlying_ctypes = []
            for i in range(0, self.dimensions()):
                prev_arr_type = prev_ctype * sizes[i]
                underlying_ptr = POINTER(prev_arr_type)
                dope_struct = RecordType.make_ctypes_struct(
                    [("ptr", underlying_ptr), ("count", c_long)]
                )
                ptr = POINTER(dope_struct)
                underlying_ctypes.append(
                    (dope_struct, ptr, prev_arr_type, underlying_ptr)
                )
                prev_ctype = ptr
                self.ctypes_ = underlying_ctypes
        try:
            return self.convert_array(vals, self.ctypes_)
        except Exception as e:
            print(e)
            self.ctypes_ = []
            return self.convert_top_level_array(vals)

    def convert_array(self, vals, ctypes_):
        converted_elems = []
        if self.dimensions() > 1:
            for val in vals:
                converted_elems.append(self.element.convert_array(val, ctypes_))
        else:
            for val in vals:
                converted_elems.append(self.element.to_ctype(val))
        underlying_val = ctypes_[self.dimensions() - 1][2](*converted_elems)
        val_ptr = ctypes_[self.dimensions() - 1][3](underlying_val)
        dope_struct = ctypes_[self.dimensions() - 1][0](
            val_ptr, c_long(len(converted_elems))
        )
        ptr = ctypes_[self.dimensions() - 1][1](dope_struct)
        return ptr

    def to_ctype(self, values):
        return self.convert_top_level_array(values)

    def make_retval(self):
        if type(self.element) != ArrayType:
            prev_arr_type = self.element.ctype
            underlying_ptr = POINTER(prev_arr_type)
            dope_struct = RecordType.make_ctypes_struct(
                [("ptr", underlying_ptr), ("count", c_long)]
            )
            ptr = POINTER(dope_struct)
            return ptr
        else:
            return

    def dimensions(self):
        return 1 + (
            self.element.dimensions() if "element" in self.element.__dict__ else 0
        )

    def bottom_element_type(self):
        """returns the type of single element of an array"""
        return (
            self.element.bottom_element_type()
            if type(self.element) == ArrayType
            else self.element
        )

    def make_dope_struct_type(self):
        res = ll.LiteralStructType([ll.PointerType(self.llvm_type()), ll.IntType(64)])
        res = ll.PointerType(res)
        return res

    """def load_from_json_code(self, name, src_object):
        from .cpp.cpp_codegen import indent_cpp

        index_name = "index_for_" + remove_spec_symbols(name)
        item_name = "item_for_" + remove_spec_symbols(name)
        retval = (
            f"{self.cpp_type} {name};\n"
            f"for(unsigned int {index_name} = 0;\n"
            f"{index_name} < {src_object}.size();\n++{index_name})\n"
            "{\n"
            + indent_cpp(
                self.element.load_from_json_code(
                    item_name, (f"{src_object}" f"[{index_name}]")
                )
                + f"\n{name}.push_back({item_name});"
            )
            + "\n}"
        )

        return retval

    def save_to_json_code(self, target_object, object_):
        from .cpp.cpp_codegen import indent_cpp

        index = "index_for_" + remove_spec_symbols(target_object)
        item_name = "item_for_" + remove_spec_symbols(target_object)

        return (
            (
                f"if ({object_}.error)"
                "{\n" + indent_cpp(f'{target_object}="ERROR";') + "\n}\nelse\n"
            )
            * (not global_no_error)
            + f"for(unsigned int {index} = 0;\n"
            f"    {index} < size({object_});"
            f"\n    ++{index})"
            "\n{\n"
            + indent_cpp(f"Json::Value {item_name};")
            + "\n"
            + indent_cpp(
                self.element.save_to_json_code(item_name, object_ + f"[{index}]")
            )
            + "\n"
            + indent_cpp(f"{target_object}.append({item_name});")
            + "\n}"
        )
"""


class StreamType(Type):
    @property
    def cpp_type(self):
        if "custom_type" in self.__dict__ and self.custom_type:
            return self.type_name
        else:
            return f"vector<{self.element.cpp_type}>"


class AnyType(Type):
    @property
    def cpp_type(self):
        return "auto"


"""def get_struct_string(name: str, fields: list[str]):
    from .cpp.cpp_codegen import indent_cpp

    set_error_code = (
        "\nvoid set_error(){\n"
        + ";\n".join([str(field) + ".set_error()" for field, _ in fields.items()])
        + ";\n}"
    )
    extra = ("bool error;" + set_error_code) * (not global_no_error)
    field_defs = "\n".join(
        [f"{str(type_.cpp_type)} {str(field)};" for field, type_ in fields.items()]
    )
    return "struct " + name + "{\n" + indent_cpp(field_defs + "\n" + extra) + "\n};"
"""


class RecordType(Type):

    def __init__(self, type_object):
        class WidenedLitStruct(ll.LiteralStructType):
            def __init__(self, names, elems, packed=False):
                super().__init__(elems, packed)
                self.names_to_indices = names

        super().__init__(type_object)
        self.__llvm_type__ = WidenedLitStruct(
            self.names_to_indices, [field.llvm_type() for field in self.fields.values()]
        )
        self.ctype = RecordType.make_ctypes_struct(
            [(key, type_.ctype) for key, type_ in self.fields.items()]
        )

    ctypes_count = 0

    # static, contains description of corresponding C++
    # structs as strings

    def names_to_indices(self):
        names = {}
        for index, field in enumerate(self.fields.keys()):
            names[field] = index
        return names

    @classmethod
    def make_ctypes_struct(cls, fields: list):
        class Struct(Structure):
            _fields_ = fields

            def __str__(self):
                res = "{\n"
                for field in self._fields_:
                    res += f"{field[0]} : {getattr(self,field[0])} \n"
                res += "}"
                return res

        Struct.__name__ = "record" + str(cls.ctypes_count)
        cls.ctypes_count += 1  # TODO utilize hash&cpp stuff
        return Struct

    def to_ctype(self, value: dict):
        ctyped_items = []
        for key, type_ in self.fields.items():
            ctyped_items.append(type_.to_ctype(value[key]))
        ctype = self.ctype
        res = ctype(*ctyped_items)
        return res

    '''def get_struct(self):
        """returns a C++ struct based on this record"""

        if hash(self) not in RecordType.cpp_structs:
            name = "record" + str(len(RecordType.cpp_structs))
            struct_str = get_struct_string(name, self.fields)
            RecordType.cpp_structs[hash(self)] = dict(name=name, string=struct_str)
        return RecordType.cpp_structs[hash(self)]


    

    # declare struct and put it on the list "bool" if global_no_error else
    # use it as type
    def load_from_json_code(self, name, src_object):
        ret_str = "\n".join(
            [
                type_.load_from_json_code(
                    name + f"_{field}", src_object + f'["{field}"]'
                )
                for field, type_ in self.fields.items()
            ]
        )
        ret_str += "\n" + self.get_struct()["name"] + " " + name + ";"
        ret_str += "\n" + "\n".join(
            [
                f"{name}.{field} = {name}_{field};"
                for field, type_ in self.fields.items()
            ]
        )

        return ret_str

    def save_to_json_code(self, target_object, object_):
        return "\n".join(
            [
                type_.save_to_json_code(
                    target_object + f'["{field}"]', object_ + f".{field}"
                )
                for field, type_ in self.fields.items()
            ]
        )'''


type_map = {
    "integer": IntegerType,
    "real": RealType,
    "boolean": BooleanType,
    "array": ArrayType,
    "stream": StreamType,
    "any": AnyType,
    "record": RecordType,
}


def get_type(type_data: dict):
    if "name" in type_data:
        if type_data["name"] in type_map:
            return type_map[type_data["name"]](type_data)
        else:
            raise Exception(f"type {type_data['name']} is not supported")
    elif "element" in type_data:
        if "multi_type" in type_data:
            if type_data["multi_type"].lower() == "stream":
                return StreamType(type_data)
        return ArrayType(type_data)


def get_integer():
    """helper for creating indices"""
    return IntegerType({"name": "integer", "location": "not applicable"})
