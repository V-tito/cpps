#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array initialization
"""
import llvmlite.ir as ll
import llvmlite.binding as llvm
from ..type import ArrayType

# import llvmlite.binding as llvm
from ..node import Node
from ..llvm.llvm_codegen import llvm_eval
from ..edge import Edge

# from ..error import CodeGenError


class ArrayInit(Node):
    def get_type_size_in_ir(self, irbuilder, element_type, count):
        """
        Generate IR that computes the size at runtime using GEP arithmetic.
        This avoids needing the size at IR generation time.
        """
        # Create a dummy allocation of 1 element
        dummy = irbuilder.alloca(element_type)

        # Create a GEP at index 'count' and get the byte difference
        # This works because LLVM's GEP uses type sizes internally
        ptr_start = irbuilder.ptrtoint(dummy, ll.IntType(64))
        ptr_end = irbuilder.gep(dummy, [ll.Constant(ll.IntType(32), count)])
        ptr_end_casted = irbuilder.ptrtoint(ptr_end, ll.IntType(64))

        size = irbuilder.sub(ptr_end_casted, ptr_start)
        return size

    def is_output_array(self):
        output_array = False
        for edge in Edge.edges_from[self.out_ports[0].id]:
            if edge.to.node.name == "Lambda":
                output_array = True
                break
            elif edge.to.node.name == "ArrayInit":
                if edge.to.node.is_output_array():
                    output_array = True
                    break
        return output_array

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index
        type_ = self.out_ports[0].type
        output_array = self.is_output_array()
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
        if not output_array:
            ptr = irbuilder.alloca(type_.llvm_type())
        else:
            arg = self.get_type_size_in_ir(irbuilder, type_.llvm_type(), 1)
            ptr = irbuilder.call(
                irbuilder.module.malloc,
                [arg],
            )
        ptr = irbuilder.bitcast(ptr, ll.PointerType())
        etyp = (
            type_.element.llvm_type()
            if not isinstance(type_.element, ArrayType)
            else ll.PointerType() if output_array else type_.llvm_type()
        )
        zero = ll.Constant(ll.IntType(32), 0)
        for index, item in enumerate(items):
            indexIR = ll.Constant(ll.IntType(32), index)
            indices = [indexIR] if output_array else [zero, indexIR]
            target = irbuilder.gep(
                ptr,
                indices,
                source_etype=etyp,
            )
            int_ = irbuilder.ptrtoint(target, ll.IntType(64))
            target = irbuilder.inttoptr(int_, ll.PointerType())
            irbuilder.store(item, target)

        record_type = ll.LiteralStructType([ll.PointerType(), ll.IntType(32)])
        if output_array:
            size = self.get_type_size_in_ir(irbuilder, record_type, 1)
            new_var = irbuilder.call(irbuilder.module.malloc, [size])
        else:
            new_var = irbuilder.alloca(record_type, name=self.out_ports[0].label)
        addr = irbuilder.gep(
            new_var,
            [zero, zero],
            source_etype=record_type,
        )
        # int_ = irbuilder.ptrtoint(addr, ll.IntType(64))
        # addr2 = irbuilder.inttoptr(int_, ll.PointerType())
        irbuilder.store(ptr, addr)
        count = irbuilder.gep(
            new_var,
            [zero, ll.Constant(ll.IntType(32), 1)],
            source_etype=record_type,
        )
        # int_ = irbuilder.ptrtoint(count, ll.IntType(64))
        # count = irbuilder.inttoptr(int_, ll.PointerType())
        irbuilder.store(ll.Constant(ll.IntType(32), type_.count), count)
        # new_var = ll.PointerType(new_var)

        self.out_ports[0].value = new_var

    # def count_dimensions:
