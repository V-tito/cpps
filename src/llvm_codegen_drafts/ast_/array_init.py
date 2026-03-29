#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array initialization
"""
import llvmlite.ir as ll

# import llvmlite.binding as llvm
from ..node import Node
from ..llvm.llvm_codegen import llvm_eval

# from ..error import CodeGenError


class ArrayInit(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index
        type_ = self.out_ports[0].type
        # dim = type_.dimensions()
        # print(dim)
        # if dim>1:
        #     items=[]
        items = [llvm_eval(i_p, irbuilder) for i_p in self.in_ports]
        # the following is for the future where actual multidimentional arrays exist:
        # here'd be type-check for nested arrays.
        # call a different eval function for nested arrays? i'd most def prefer to allocate matrixes in row if this is tangible.
        # different eval that returns evaluated lower-level elements as a python array in a corresponding order. add separator, somehow (empty int??)???
        # check what column-major order is (if it doesn't presume a11, a12, a13..., im in trouble)
        # check where node's port type is set (should be in parser)
        # check whether dimensions would show properly
        # arrange function: if self.dimensions==1, returns [eval(in_ports)].append(sep) (or maybe just allocate them right away
        # since we should know the indices at this point - assuming arrays are always rectangular?) else recursion
        # are all arrays required to be rectangular tho? if not, fill with errors where len is less than needed
        # check if required to be rectangular (ask to parse a "broken" example).
        # (return len alongside the arr? pass down the dope, so the underlying arrays can fill it in themselves?)

        type_.count = len(items)
        dim = type_.dimensions()
        ptr = irbuilder.alloca(type_.llvm_type())
        #
        for index, item in enumerate(items):
            indexIR = ll.Constant(ll.IntType(32), index)
            target = irbuilder.gep(ptr, [ll.Constant(ll.IntType(32), 0), indexIR])
            irbuilder.store(item, target)

        record_type = ll.LiteralStructType([ptr.type, ll.IntType(64)])
        new_var = irbuilder.alloca(record_type, name=self.out_ports[0].label)
        addr = irbuilder.gep(
            new_var, [ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 0)]
        )
        irbuilder.store(ptr, addr)
        count = irbuilder.gep(
            new_var, [ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 1)]
        )
        irbuilder.store(ll.Constant(ll.IntType(64), type_.count), count)
        # new_var = ll.PointerType(new_var)

        self.out_ports[0].value = new_var

    # def count_dimensions:
