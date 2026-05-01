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

            # timeout = False
            # check if it isn't a built in function:
            if self.callee in Function.functions:
                called_function = irbuilder.module.get_global(self.callee)

                result = None
                parent_function = self.get_containing_function()

                # if the function has multiple outputs:
                if len(self.out_ports) > 1:
                    name = "call_result"
                    result = irbuilder.call(called_function, args, name=name)
                    for port_index, o_p in enumerate(self.out_ports):
                        port_result = irbuilder.extract_value(
                            result, port_index, name=f"value_{port_index}"
                        )
                        o_p.value = port_result
                        if isinstance(o_p.type, ArrayType):
                            parent_function.mallocs.add(port_result)
                            if o_p.type.is_output_array:
                                parent_function.preserved_mallocs.add(port_result)
                # if the function has one output:
                else:
                    name = (
                        self.out_ports[0].label if self.out_ports[0].renamed else "call"
                    )

                    result = irbuilder.call(called_function, args, name=name)
                    self.out_ports[0].value = result
                    if isinstance(self.out_ports[0].type, ArrayType):
                        parent_function.mallocs.add(result)
                        if self.out_ports[0].type.is_output_array:
                            parent_function.preserved_mallocs.add(result)
        else:
            FunctionCall.overriden_functions[self.callee](self, irbuilder)


"""Overriden implementations (used instead of Function's to_llvm method)"""


def remh(self, irbuilder):
    """Remove first element of an array"""
    """   name = (self.out_ports[0].label
            if self.out_ports[0].renamed else '')
    src_port = Edge.edge_to[self.in_ports[0].id].from_
    result_type = src_port.type
    result = llvmVariable(name, result_type.llvm_type)
    block.add_variable(result)
    arg_vars = [str(llvm_eval(i_p, block)) for i_p in self.in_ports]
    args = ", ".join(arg_vars)
    block.add_code(llvmAssignment(result, f"{self.callee}({args})"))
    self.out_ports[0].value = result"""


def reml(self, irbuilder):
    """Remove last element of an array"""
    """name = (self.out_ports[0].label
            if self.out_ports[0].renamed else "reml_call")
    src_port = Edge.edge_to[self.in_ports[0].id].from_
    result_type = src_port.type
    result = llvmVariable(name, result_type.llvm_type)
    block.add_variable(result)
    arg_vars = [str(llvm_eval(i_p, block)) for i_p in self.in_ports]
    args = ", ".join(arg_vars)
    block.add_code(llvmAssignment(result, f"{self.callee}({args})"))
    self.out_ports[0].value = result"""


def size(self, irbuilder: ll.IRBuilder):
    args = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]
    arr_descriptor_ptr = args[0]
    name = self.out_ports[0].label if self.out_ports[0].renamed else "call"

    result_ptr = irbuilder.gep(
        arr_descriptor_ptr,
        [ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 1)],
        source_etype=self.in_ports[0].type.make_dope_struct_type(),
    )
    # process_timeout()
    result = irbuilder.zext(
        irbuilder.load(
            result_ptr,
            typ=ll.IntType(32),
        ),
        ll.IntType(64),
        name=name,
    )
    self.out_ports[0].value = result


FunctionCall.overriden_functions = {"remh": remh, "reml": reml, "size": size}

# FunctionCall.built_in_functions = ["size"]


class BuiltInFunctionCall(Node):
    pass
