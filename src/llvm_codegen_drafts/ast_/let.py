#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator let
"""
from ..node import Node#, to_cpp_method
from ..llvm.llvm_codegen import llvm_eval
import llvmlite.ir as ll
import llvmlite as llvm


class Let(Node):

    copy_parent_input_values = True

    #@to_cpp_method
    def to_llvm(self, irbuilder: ll.IRBuilder):
        # initialization code:
        for i_p, init_i_p in zip(self.in_ports, self.init.in_ports):
            init_i_p.value = i_p.value
        self.init.to_llvm(irbuilder, self.body.in_ports)

        self.body.let = self

        for b_i_p, let_i_p in zip(self.body.in_ports[-len(self.in_ports):],
                                  self.in_ports):
            b_i_p.value = let_i_p.value

        # body:
        for o_p, b_o_p in zip(self.out_ports, self.body.out_ports):
            o_p.value = llvm_eval(b_o_p, irbuilder)


class LetBody(Node):

    #@to_cpp_method
    def to_llvm(self, irbuilder: ll.IRBuilder):
        # initialization code:
        for i_p, let_i_p in zip(self.in_ports, self.let.in_ports):
            i_p.value = let_i_p.value
