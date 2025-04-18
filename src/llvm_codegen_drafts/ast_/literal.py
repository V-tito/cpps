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

    def llvm_ir(self, irbuilder: ll.IRBuilder): #все еще что делает needs_init и надо ли здесь объявлять константу? наверное, надо.
        # if self.value == True:
        #    self.value = "true"

        # literal_variable = CppVariable("literal", self.out_ports[0].type.cpp_type)
        # block.add_variable(literal_variable)
        # block.add_code(CppAssignment(literal_variab
        val=ll.Constant(self.value)
        self.value=val
        self.out_ports[0].value = self.value
