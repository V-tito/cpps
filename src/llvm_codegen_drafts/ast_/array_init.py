#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array initialization
"""

import llvmlite.ir as ll
import llvmlite.binding as llvm
from ..type import ArrayType, get_array_descriptor

# import llvmlite.binding as llvm
from ..node import Node
from ..llvm.llvm_codegen import llvm_eval, heap_allocation_helper
from ..edge import Edge
from ..llvm.llvmlite_helpers import (
    calc_memsize_at_runtime,
    i32constant,
    i32zero,
    i32,
    i64,
)

# from ..error import CodeGenError


class ArrayInit(Node):

    def mark_heap_allocation(self):
        type_ = self.out_ports[0].type
        output_array = type_.is_output_array
        dim = type_.dimensions()
        # print(dim)
        if output_array and dim > 1:
            for i_p in self.in_ports:
                i_p.type.is_output_array = True
                heap_allocation_helper(i_p)

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index
        type_ = self.out_ports[0].type
        output_array = type_.is_output_array
        items = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]

        type_.count = len(items)
        dim = type_.dimensions()
        if not output_array:
            ptr = irbuilder.alloca(type_.llvm_type())
        else:
            arg = calc_memsize_at_runtime(irbuilder, type_.llvm_type(), 1)
            ptr = irbuilder.call(
                irbuilder.module.malloc,
                [arg],
            )
        ptr = irbuilder.bitcast(ptr, ll.PointerType())
        etyp = (
            type_.element.llvm_type()
            if not isinstance(type_.element, ArrayType)
            else get_array_descriptor()
        )
        for index, item in enumerate(items):
            indexIR = i32constant(index)
            indices = [indexIR] if output_array else [i32zero, indexIR]
            target = irbuilder.gep(
                ptr,
                indices,
                source_etype=etyp,
            )
            int_ = irbuilder.ptrtoint(target, i64)
            target = irbuilder.inttoptr(int_, ll.PointerType())
            irbuilder.store(item, target)

        record_type = ll.LiteralStructType([ll.PointerType(), i32])
        new_var = ll.Constant(record_type, None)
        new_var = irbuilder.insert_value(new_var, ptr, 0)
        new_var = irbuilder.insert_value(new_var, i32constant(type_.count), 1)
        # irbuilder.alloca(record_type, name=self.out_ports[0].label)
        # addr = irbuilder.gep(
        #    new_var,
        #    [zero, zero],
        #    source_etype=record_type,
        # )
        # int_ = irbuilder.ptrtoint(addr, ll.IntType(64))
        # addr2 = irbuilder.inttoptr(int_, ll.PointerType())
        # irbuilder.store(ptr, addr)
        # count = irbuilder.gep(
        ##    new_var,
        #    [zero, ll.Constant(ll.IntType(32), 1)],
        #    source_etype=record_type,
        # )
        # int_ = irbuilder.ptrtoint(count, ll.IntType(64))
        # count = irbuilder.inttoptr(int_, ll.PointerType())
        # irbuilder.store(ll.Constant(ll.IntType(32), type_.count), count)
        # new_var = ll.PointerType(new_var)
        self.out_ports[0].value = new_var

    # def count_dimensions:
