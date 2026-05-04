#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Type for code generator
"""

import re
import json
import llvmlite.ir as ll
import ctypes as ct
from .llvm.llvmlite_helpers import printf_str

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

    def add_printf(self, irbuilder: ll.IRBuilder, printf, val, label=None):
        str_val = f"{label}: {self.fmt}\00" if label else f"{self.fmt}\00"
        c_str_val = ll.Constant(
            ll.ArrayType(ll.IntType(8), len(str_val)),
            bytearray(str_val.encode("utf-8")),
        )
        c_str = irbuilder.alloca(c_str_val.type)
        irbuilder.store(c_str_val, c_str)
        irbuilder.call(printf, [c_str, val])

    def errored_llvm_type(self):
        return ll.LiteralStructType([ll.IntType(1), self.llvm_type()])

    def make_errored_val(self, port, irbuilder: ll.IRBuilder):
        ret = self.errored_llvm_type(None)
        ret = irbuilder.insert_value(ret, port.err_cond, 0)
        ret = irbuilder.insert_value(ret, port.value, 1)
        return ret

    @property
    def internal_type(self):
        return self.__llvm_type__

    def to_ctype(self, value):
        return self.ctype(value)


class IntegerType(Type):
    __llvm_type__ = ll.IntType(64)
    ctype = ct.c_int64
    fmt = "%ld"


class RealType(Type):
    __llvm_type__ = ll.DoubleType()
    ctype = ct.c_double
    fmt = "%f"


class BooleanType(Type):
    __llvm_type__ = ll.IntType(1)
    ctype = ct.c_bool
    fmt = "%d"


def remove_spec_symbols(string):
    return re.sub("[^a-zA-Z0-9]", "_", string).replace(".", "_")


class ArrayType(Type):
    count = 0  # default element count todo determine by optimizer
    ctypes_ = []
    is_output_array = False

    def llvm_type(self):
        return get_array_descriptor()

    def raw_type(self):
        return ll.ArrayType(
            self.element.llvm_type(),
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

    def errored_llvm_type(self):
        return ll.LiteralStructType(
            [ll.PointerType(), ll.IntType(32), ll.PointerType()]
        )

    def make_errored_val(self, port, irbuilder: ll.IRBuilder):
        return port.value

    def get_fmt_string(self):
        res = f"[{f"{self.element.get_fmt_string()}, "*(self.count-1)+f"{self.element.get_fmt_string()}"}]\00"
        return res

    def create_loop_func(self, irbuilder: ll.IRBuilder, printf):
        loop_ftype = ll.FunctionType(ll.VoidType(), [ll.PointerType(), ll.IntType(32)])
        loop_func = ll.Function(
            irbuilder.module,
            loop_ftype,
            f"array_print_loop_{irbuilder.module.array_print_loop_count}",
        )
        irbuilder.module.array_print_loop_count += 1
        arr_ptr = loop_func.args[0]
        count = loop_func.args[1]
        entry = loop_func.append_basic_block("entry")
        array_loop_header = loop_func.append_basic_block("array_loop_header")
        array_loop_comma = loop_func.append_basic_block("array_loop_comma")
        print_comma = loop_func.append_basic_block("print_comma")
        no_comma = loop_func.append_basic_block("no_comma")
        array_loop_block = loop_func.append_basic_block("array_print_loop")
        array_loop_follower = loop_func.append_basic_block("array_loop_follower")
        with irbuilder.goto_block(entry):
            str_val = ", \00"
            c_str_val = ll.Constant(
                ll.ArrayType(ll.IntType(8), len(str_val)),
                bytearray(str_val.encode("utf-8")),
            )
            c_str = irbuilder.alloca(c_str_val.type)
            irbuilder.store(c_str_val, c_str)
            irbuilder.branch(array_loop_header)
        with irbuilder.goto_block(array_loop_header):
            i = irbuilder.phi(ll.IntType(32))
            cond = irbuilder.icmp_unsigned("==", i, count)
            irbuilder.cbranch(cond, array_loop_follower, array_loop_comma)
            i.add_incoming(ll.Constant(ll.IntType(32), 0), entry)
        with irbuilder.goto_block(array_loop_comma):
            print_cond = irbuilder.icmp_unsigned(
                "!=", i, ll.Constant(ll.IntType(32), 0)
            )
            irbuilder.cbranch(print_cond, print_comma, no_comma)
        with irbuilder.goto_block(print_comma):
            irbuilder.call(printf, [c_str])
            irbuilder.branch(array_loop_block)
        with irbuilder.goto_block(no_comma):
            irbuilder.branch(array_loop_block)
        with irbuilder.goto_block(array_loop_block):
            elem_ptr = irbuilder.gep(
                arr_ptr,
                [i],  # ll.Constant(ll.IntType(32), 0),
                source_etype=self.element.llvm_type(),
            )
            elem = irbuilder.load(elem_ptr, typ=self.element.llvm_type())
            self.element.add_printf(irbuilder, printf, elem)
            new_i = irbuilder.add(i, ll.Constant(ll.IntType(32), 1))
            i.add_incoming(new_i, array_loop_block)
            irbuilder.branch(array_loop_header)
        with irbuilder.goto_block(array_loop_follower):
            irbuilder.ret_void()
        return loop_func

    def add_printf(self, irbuilder, printf, val, label=None):
        str_val = f"{label}: [\00" if label else "[\00"
        printf_str(irbuilder, printf, str_val)
        # valtype = self.make_dope_struct_type()
        arr_ptr = irbuilder.extract_value(val, 0)

        count = irbuilder.extract_value(val, 1)

        loopf = self.create_loop_func(irbuilder, printf)
        irbuilder.call(loopf, [arr_ptr, count])
        str_val = "]\00"
        printf_str(irbuilder, printf, str_val)

    """    def print_arr(self, ptr):
        dope_struct = ptr[0]
        arr_ptr = dope_struct.ptr
        count = dope_struct.count
        res = ""
        for i in range(0, count):
            elem = arr_ptr[i]
            if type(self.element) == ArrayType:
                res += self.element.print_arr(elem)
            else:
                res += str(elem) + " "
        res += "\n"
        return res"""  # idk

    def convert_top_level_array(self, vals):
        if not self.ctypes_:
            sizes = ArrayType.get_dim_sizes(vals, self.dimensions())
            prev_ctype = self.bottom_element_type().ctype
            underlying_ctypes = []
            for i in range(0, self.dimensions()):
                prev_arr_type = prev_ctype * sizes[i]
                underlying_ptr = ct.POINTER(prev_arr_type)
                dope_struct = RecordType.make_ctypes_struct(
                    [("ptr", underlying_ptr), ("count", ct.c_long)]
                )
                underlying_ctypes.append((dope_struct, prev_arr_type, underlying_ptr))
                prev_ctype = dope_struct
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
        underlying_val = ctypes_[self.dimensions() - 1][1](*converted_elems)
        val_ptr = ctypes_[self.dimensions() - 1][2](underlying_val)
        dope_struct = ctypes_[self.dimensions() - 1][0](
            val_ptr, ct.c_long(len(converted_elems))
        )
        return dope_struct

    # for cpp input
    def to_ctype(self, values):
        return self.convert_top_level_array(values)

    # potentially for return without printing main
    def make_retval(self):
        if type(self.element) != ArrayType:
            prev_arr_type = self.element.ctype
        else:
            prev_arr_type = self.element.make_retval()
        underlying_ptr = ct.POINTER(prev_arr_type)
        dope_struct = RecordType.make_ctypes_struct(
            [("ptr", underlying_ptr), ("count", ct.c_long)]
        )
        return dope_struct

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


class RecordType(Type):

    def __init__(self, type_object):
        # TODO adjust to errors here
        class WidenedLitStruct(ll.LiteralStructType):
            def __init__(self, names, elems, packed=False):
                super().__init__(elems, packed)
                self.names_to_indices = names
                # TODO adjust to errored

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
    def get_errtyp(self):
        return ll.IntType(len(self.fields))

    def names_to_indices(self):
        names = {}
        for index, field in enumerate(self.fields.keys()):
            names[field] = index
        return names

    @classmethod
    def make_ctypes_struct(cls, fields: list):
        class Struct(ct.Structure):
            _fields_ = fields

            def __str__(self):
                res = "{\n"
                for field in self._fields_:
                    val = getattr(self, field[0])
                    res += f"{field[0]} : {val} \n"
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

    def get_fmt_string(self):
        res = (
            "{"
            + f"{[f"{field[0]}: {field[1].get_fmt_string()},\n" for field in self.fields.items()]}"
            + "}\00"
        )
        return res

    def add_printf(self, irbuilder, printf, val, label=None):
        str_val = f"{label}: " + "{\n\00"
        printf_str(irbuilder, printf, str_val)
        for i, field in enumerate(self.fields.items()):
            label_ = field[0]
            typ = field[1]
            if isinstance(val, ll.PointerType):
                field_val = irbuilder.load(
                    irbuilder.gep(
                        val,
                        [
                            ll.Constant(ll.IntType(32), 0),
                            ll.Constant(ll.IntType(32), i),
                        ],
                    )
                )
            else:
                field_val = irbuilder.extract_value(val, i)
            typ.add_printf(irbuilder, printf, field_val, label_)
            str_val = ",\n\00"
            printf_str(irbuilder, printf, str_val)
        str_val = "}\n\00"
        printf_str(irbuilder, printf, str_val)


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


def get_array_descriptor():
    return ll.LiteralStructType([ll.PointerType(), ll.IntType(32)])
