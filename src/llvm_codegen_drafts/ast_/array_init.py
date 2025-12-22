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

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index

        items = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]
        type_ = self.out_ports[0].type
        type_.count = len(items)
        ptr = irbuilder.alloca(type_.llvm_type())
        #
        for index, item in enumerate(items):
            indexIR = ll.Constant(ll.IntType(64), index)
            target = irbuilder.gep(ptr, [ll.Constant(ll.IntType(64), 0), indexIR])
            irbuilder.store(item, target)

        new_var = irbuilder.load(ptr)

        self.out_ports[0].value = new_var
