#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator record initialization
"""

from ..node import Node
from ..llvm.llvm_codegen import llvm_eval
import llvmlite.ir as ll
from ..error import CodeGenError


class RecordInit(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index

        items = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]
        types = [ll.IntType(len(items))] + [item.type for item in items]

        record_type = ll.LiteralStructType(types)

        new_var = record_type(None)
        bitmask = ll.IntType(len(items))(0)

        for port_index, value in enumerate(items):
            irbuilder.insert_value(new_var, value, port_index + 1)
            bitmask = irbuilder.add(bitmask, bitmask.type(1))
            if port_index + 1 < len(items):
                bitmask = irbuilder.shl(bitmask, 1)
        irbuilder.insert_value(new_var, bitmask, 0)

        self.out_ports[0].value = irbuilder.load(new_var, typ=record_type)
