#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array access
"""

from ..node import Node
from ..llvm.llvm_codegen import llvm_eval
import llvmlite.ir as ll
from ..error import CodeGenError


class RecordAccess(Node):
    def to_llvm(self, irbuilder:ll.IRBuilder):
        # inputs: array, index

        record = llvm_eval(self.in_ports[0], irbuilder)
        indices=record.type.names_to_indices()

        pointer = irbuilder.gep(indices[self.field])
        # Cloud Sisal Arrays' indices start from 1 by default
        # hence the {index}-1
        new_var=irbuilder.load(pointer)
        self.out_ports[0].value = new_var
