#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array initialization
"""
import llvmlite.ir as ll

# import llvmlite.binding as llvm
from ..node import Node
from ..llvm.llvm_codegen import llvm_eval

# from ..error import CodeGenError


class ArrayInit(Node):

    def to_llvm(self, irbuilder):
        # inputs: array, index

        items = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]
        type_ = self.out_ports[0].type.llvm_type(len(items))

        new_var = ll.Constant(type_, items)

        self.out_ports[0].value = new_var
