#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array access
"""

from ..node import Node
from ..llvm.llvm_codegen import llvm_eval
import llvmlite.ir as ll
from ..error import CodeGenError
from ..llvm.llvmlite_helpers import i32zero


class RecordAccess(Node):
    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index

        record = llvm_eval(self.in_ports[0], irbuilder)
        indices = record.type.names_to_indices()
        if isinstance(record, ll.PointerType):
            errptr = irbuilder.gep(
                record,
                [i32zero, i32zero],
                source_etype=self.out_ports[0].type.llvm_type(),
            )
            pointer = irbuilder.gep(
                record,
                [i32zero, indices[self.field]],
                source_etype=self.out_ports[0].type.llvm_type(),
            )
            # Cloud Sisal Arrays' indices start from 1 by default
            # hence the {index}-1
            new_var = irbuilder.load(pointer, typ=self.out_ports[0].type.llvm_type())
        else:
            new_var = irbuilder.extract_value(record, indices[self.field])
        self.out_ports[0].value = new_var
