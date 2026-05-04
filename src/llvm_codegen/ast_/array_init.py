#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array initialization
"""

import math
import llvmlite.ir as ll
import llvmlite.binding as llvm
from ..type import ArrayType, get_array_descriptor

# import llvmlite.binding as llvm
from ..node import Node
from ..llvm.llvm_codegen import llvm_eval, heap_allocation_helper
from ..llvm.llvmlite_helpers import (
    calc_memsize_at_runtime,
    i32,
    i64,
)

# from ..error import CodeGenError


class ArrayInit(Node):

    def mark_heap_allocation(self):
        type_ = self.out_ports[0].type
        output_array = type_.is_output_array
        dim = type_.dimensions()
        if output_array and dim > 1:
            for i_p in self.in_ports:
                i_p.type.is_output_array = True
                heap_allocation_helper(i_p)

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index
        type_ = self.out_ports[0].type
        items = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]
        type_.count = len(items)
        arg = calc_memsize_at_runtime(
            irbuilder, type_.element.llvm_type(), type_.count
        )  # here either elemtype+count or get raw
        ptr = irbuilder.call(
            irbuilder.module.malloc,
            [arg],
        )
        # calloc array of i1 errors
        error = irbuilder.call(
            irbuilder.module.calloc,
            [ll.IntType(64)(math.ceil(type_.count / 8))],
        )
        parent_function = self.get_containing_function()
        parent_function.mallocs.add(ptr)
        parent_function.mallocs.add(error)
        if self.out_ports[0].type.is_output_array:
            parent_function.preserved_mallocs.add(ptr)
            parent_function.preserved_mallocs.add(error)
        etyp = (
            type_.element.llvm_type()
            if not isinstance(type_.element, ArrayType)
            else type_.element.errored_llvm_type()
        )

        for index, i_p in enumerate(self.in_ports):
            indexIR = i32(index)
            target = irbuilder.gep(
                ptr,
                [indexIR],
                source_etype=etyp,
            )
            int_ = irbuilder.ptrtoint(target, i64)
            target = irbuilder.inttoptr(int_, ll.PointerType())
            ok_block = irbuilder.append_basic_block(f"{i_p.label}_not_error")
            err_block = irbuilder.append_basic_block(f"{i_p.label}_error")
            next = irbuilder.append_basic_block(f"{i_p.label}_next")
            irbuilder.cbranch(i_p.error_cond, err_block, ok_block)
            with irbuilder.goto_block(err_block):
                # errors inited to zeros, so no action needed??? check in text
                irbuilder.branch(next)
            with irbuilder.goto_block(ok_block):
                irbuilder.store(
                    i_p.value, target
                )  # storing undef is undef behaviour, so we want to avoid store in array in error branch
                irbuilder.store(ll.IntType(1)(1), error)
                irbuilder.branch(next)
            irbuilder.position_at_start(next)

        record_type = (
            type_.errored_llvm_type()
        )  # ll.LiteralStructType([ll.PointerType(), i32])
        new_var = ll.Constant(record_type, None)
        new_var = irbuilder.insert_value(new_var, ptr, 0)
        new_var = irbuilder.insert_value(new_var, i32(type_.count), 1)
        new_var = irbuilder.insert_value(new_var, error, 2)
        self.out_ports[0].value = new_var
        self.out_ports[0].error_cond = error
