#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator call
"""

from ..node import Node
from ..edge import Edge
from .function import Function
import llvmlite.ir as ll
from ..llvm.llvm_codegen import llvm_eval
from ..type import ArrayType


class FunctionCall(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # check if there is special implementation for this function:
        if self.callee not in FunctionCall.overriden_functions:

            args = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]
            errors = [i_p.err_cond for i_p in self.in_ports]

            # timeout = False

            if self.callee in Function.functions:
                called_function = irbuilder.module.get_global(
                    self.callee
                )  # what if callee not translated?

                result = None
                parent_function = self.get_containing_function()
                # pack args into error structs:
                errored_args = []
                for i_p in self.in_ports:
                    errored_arg = i_p.type.make_errored_val(i_p, irbuilder)
                    errored_args.append(errored_arg)

                # if the function has multiple outputs:
                if len(self.out_ports) > 1:
                    name = "call_result"
                    # result = irbuilder.call(called_function, args, name=name)
                    # with errors
                    result = irbuilder.call(called_function, errored_args, name=name)
                    for port_index, o_p in enumerate(self.out_ports):
                        port_result = irbuilder.extract_value(
                            result, port_index, name=f"value_{port_index}"
                        )
                        o_p.value = port_result
                # if the function has one output:
                else:
                    name = (
                        self.out_ports[0].label if self.out_ports[0].renamed else "call"
                    )

                    # result = irbuilder.call(called_function, args, name=name)
                    # with errors
                    result = irbuilder.call(called_function, errored_args, name=name)
                    self.out_ports[0].value = result
                # and here we shall extract errvals and normal vals
                for o_p in self.out_ports:
                    if isinstance(self.out_ports[0].type, ArrayType):
                        malloc = irbuilder.extract_value(o_p.value, 0)
                        err = irbuilder.extract_value(o_p.value, 2)
                        o_p.error_cond = err
                        parent_function.mallocs.add(malloc)
                        parent_function.mallocs.add(err)
                        if self.out_ports[0].type.is_output_array:
                            parent_function.preserved_mallocs.add(malloc)
                            parent_function.mallocs.add(err)
                    else:
                        err = irbuilder.extract_value(o_p.value, 0)
                        val = irbuilder.extract_value(o_p.value, 1)
                        o_p.error_cond = err
                        o_p.value = val

        else:
            FunctionCall.overriden_functions[self.callee](self, irbuilder)


"""Overriden implementations (used instead of Function's to_llvm method)"""

from ..llvm.llvmlite_helpers import i32one, i32zero, i64, calc_memsize_at_runtime
from ..type import get_array_descriptor


def remh(self, irbuilder: ll.IRBuilder):
    """Remove first element of an array"""
    name = self.out_ports[0].label if self.out_ports[0].renamed else ""
    src_port = Edge.edge_to[self.in_ports[0].id].from_
    src_type = src_port.type
    old_ptr = irbuilder.extract_value(self.in_ports[0].value, 0)
    old_len = irbuilder.extract_value(self.in_ports[0].value, 1)
    new_len = irbuilder.sub(old_len, i32one)
    new_ptr = irbuilder.gep(
        old_ptr, [i32one], source_etype=src_type.element.llvm_type()
    )
    result = irbuilder.insert_value(get_array_descriptor(None), new_ptr, 0)
    result = irbuilder.insert_value(result, new_len, 1, name=name)
    self.out_ports[0].value = result


def reml(self, irbuilder):
    """Remove last element of an array"""
    name = self.out_ports[0].label if self.out_ports[0].renamed else ""
    old_len = irbuilder.extract_value(self.in_ports[0].value, 1)
    new_len = irbuilder.sub(old_len, i32one)
    result = irbuilder.insert_value(self.in_ports[0].value, new_len, 1, name=name)
    self.out_ports[0].value = result


def size(self, irbuilder: ll.IRBuilder):
    args = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]
    arr_descriptor = args[0]
    name = self.out_ports[0].label if self.out_ports[0].renamed else "call"

    result = irbuilder.extract_value(arr_descriptor, 1)
    # process_timeout()
    result = irbuilder.zext(
        result,
        i64,
        name=name,
    )
    self.out_ports[0].value = result


def addh(self, irbuilder: ll.IRBuilder):
    """Add first element to an array"""
    name = self.out_ports[0].label if self.out_ports[0].renamed else ""
    src_port = Edge.edge_to[self.in_ports[0].id].from_
    src_type = src_port.type
    old_ptr = irbuilder.extract_value(self.in_ports[0].value, 0)
    old_len = irbuilder.extract_value(self.in_ports[0].value, 1)
    new_len = irbuilder.add(old_len, i32one)
    old_size = calc_memsize_at_runtime(irbuilder, src_type.element.llvm_type(), old_len)
    new_size = calc_memsize_at_runtime(irbuilder, src_type.element.llvm_type(), new_len)
    new_ptr = irbuilder.call(irbuilder.module.malloc, [new_size])
    new_head = llvm_eval(self.in_ports[0], irbuilder)
    irbuilder.store(new_head, new_ptr)
    e1_ptr = irbuilder.gep(new_ptr, [i32one], source_etype=src_type.element.llvm_type())
    irbuilder.call(irbuilder.module.memcpy, [old_ptr, e1_ptr, old_size])
    result = irbuilder.insert_value(get_array_descriptor(None), new_ptr, 0)
    result = irbuilder.insert_value(result, new_len, 1, name=name)
    self.out_ports[0].value = result


def addl(self, irbuilder: ll.IRBuilder):
    """Add last element to an array"""
    name = self.out_ports[0].label if self.out_ports[0].renamed else ""
    old_len = irbuilder.extract_value(self.in_ports[0].value, 1)
    new_len = irbuilder.add(old_len, i32one)
    old_ptr = irbuilder.extract_value(self.in_ports[0].value, 0)
    new_ptr = irbuilder.call(irbuilder.module.realloc, [old_ptr, new_len])
    new_last = llvm_eval(self.out_ports[1])  # TODO err check here
    new_last_ptr = irbuilder.gep(new_ptr, [old_len], source_etype=new_last.type)
    irbuilder.store(new_last, new_last_ptr)
    result = irbuilder.insert_value(get_array_descriptor(None), new_ptr, 0)
    result = irbuilder.insert_value(result, new_len, 1, name=name)
    self.out_ports[0].value = result


FunctionCall.overriden_functions = {
    "remh": remh,
    "reml": reml,
    "size": size,
    "addh": addh,
    "addl": addl,
}

# FunctionCall.built_in_functions = ["size"]


class BuiltInFunctionCall(Node):
    pass
