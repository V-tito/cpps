#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array access
"""

from ..node import Node
from ..llvm.llvm_codegen import llvm_eval

from ..error import CodeGenError


class ArrayAccess(Node):

    def to_llvm(self, irbuilder):
        # inputs: array, index

        array = llvm_eval(self.in_ports[0], irbuilder)
        index = llvm_eval(self.in_ports[1], irbuilder)

        # Cloud Sisal Arrays' indices start from 1 by default
        # hence the {index}-1

        label = self.out_ports[0].label if self.out_ports[0].renamed else ""

        index = index - 1
        if index < 0:
            raise CodeGenError("Literal array index is out of bounds", self.location)
        new_var = irbuilder.extract_value(array, index, name=label)

        self.out_ports[0].value = new_var
