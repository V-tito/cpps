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


class FunctionCall(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # check if there is special implementation for this function:
        if self.callee not in FunctionCall.overriden_functions:

            args = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]

            # timeout = False
            # check if it isn't a built in function:
            if self.callee in Function.functions:
                called_function = irbuilder.module.get_global(self.callee)
                # timeout_pragma = called_function.get_pragma("max_time")
                """if timeout_pragma:
                    result_name, exec_code = time_limited_execution_llvm(
                                             Function.functions[self.callee],
                                             args)
                    block.add_code(exec_code)
                    timeout = True"""

                result = None

                """def process_timeout():
                if timeout:
                    block.add_code(llvmAssignment(result,
                                   f"{result_name}.retval"))
                else:
                    block.add_code(llvmAssignment(result,
                                   f"{self.callee}({args})"))"""

                # if the function has multiple outputs:
                if len(self.out_ports) > 1:
                    name = "call_result"
                    result = irbuilder.call(called_function, args, name=name)
                    # process_timeout()
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

                    result = irbuilder.call(called_function, args, name=name)
                    # process_timeout()
                    self.out_ports[0].value = result
        """else:
            FunctionCall.overriden_functions[self.callee](self, block)"""


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


FunctionCall.overriden_functions = {
    "remh": remh,
    "reml": reml,
}

FunctionCall.built_in_functions = ["size"]


class BuiltInFunctionCall(Node):
    pass
