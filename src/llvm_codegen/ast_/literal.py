#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator literal
"""

from ..node import Node
import llvmlite.ir as ll
import llvmlite as llvm


class Literal(Node):

    needs_init = True

    def to_llvm(self, irbuilder: ll.IRBuilder):
        val = ll.Constant(self.out_ports[0].type.llvm_type(), self.value)
        self.value = val
        self.out_ports[0].value = self.value
        self.out_ports[0].error_cond = ll.IntType(1)(1)
