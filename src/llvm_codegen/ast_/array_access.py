#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array access
"""

from ..node import Node
from ..llvm.llvm_codegen import llvm_eval, heap_allocation_helper
import llvmlite.ir as ll
from ..llvm.llvmlite_helpers import i32, i32constant, i32one, i64
from ..error import CodeGenError
from ..type import ArrayType


class ArrayAccess(Node):
    def mark_heap_allocation(self):
        if isinstance(self.out_ports[0].type, ArrayType):
            if self.out_ports[0].type.is_output_array:
                self.in_ports[0].type.is_output_array = True
                heap_allocation_helper(self.in_ports[0])

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index

        dope_struct = llvm_eval(
            self.in_ports[0], irbuilder
        )  # this should become a dope struct
        array_ptr = irbuilder.extract_value(dope_struct, 0)

        bounds = irbuilder.extract_value(dope_struct, 1)

        # array_ptr would be gep array 0
        # bounds would be gep array 1
        index = llvm_eval(self.in_ports[1], irbuilder)

        # Cloud Sisal Arrays' indices start from 1 by default
        # hence the {index}-1

        label = self.out_ports[0].label if self.out_ports[0].renamed else ""
        if type(index) is not int:
            if index.type == i64:
                index = irbuilder.trunc(index, i32)
            indexIR = irbuilder.sub(index, i32one)
        else:
            indexIR = i32constant(index - 1)
            if index - 1 < 0:
                raise CodeGenError(
                    "Literal array index is out of bounds", self.location
                )
        res = irbuilder.gep(
            array_ptr,
            [indexIR],
            source_etype=(self.in_ports[0].type.element.llvm_type()),
        )
        res = irbuilder.load(
            res,
            name=label,
            typ=(self.in_ports[0].type.element.llvm_type()),
        )

        self.out_ports[0].value = res
