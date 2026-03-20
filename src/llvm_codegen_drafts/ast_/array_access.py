#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator array access
"""

from ..node import Node
from ..llvm.llvm_codegen import llvm_eval
import llvmlite.ir as ll
from ..port import Port
from ..edge import Edge
from ..error import CodeGenError


class ArrayAccess(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index

        dope_struct_ptr = llvm_eval(self.in_ports[0], irbuilder) #this should become a dope struct
        array_ptr=irbuilder.gep(dope_struct_ptr,[ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 0)])
        bounds=irbuilder.gep(dope_struct_ptr,[ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 1)])
        #array_ptr would be gep array 0
        #bounds would be gep array 1
        index = llvm_eval(self.in_ports[1], irbuilder)

        # Cloud Sisal Arrays' indices start from 1 by default
        # hence the {index}-1

        label = self.out_ports[0].label if self.out_ports[0].renamed else ""
        if type(index) is not int:
            indexIR = irbuilder.sub(index, ll.Constant(ll.IntType(64), 1))
        else:
            indexIR = ll.Constant(ll.IntType(64),index - 1)
            if index-1 < 0:
                raise CodeGenError("Literal array index is out of bounds", self.location)
        poison=irbuilder.append_basic_block("poison")
        not_poison=irbuilder.append_basic_block("not_poison")
        follower=irbuilder.append_basic_block("follower")
        with irbuilder.goto_block(follower):
            new_var = irbuilder.phi(self.out_ports[0].type.llvm_type(),name=label)
        cond=irbuilder.icmp_unsigned("<",indexIR,bounds)
        irbuilder.cbranch(cond,not_poison,poison)
        # array_type = type(array)
        with irbuilder.goto_block(not_poison):
            if not isinstance(type(array_ptr), ll.PointerType):
                source_port = Edge.edge_to[self.in_ports[0].id].from_
                new_ptr = irbuilder.alloca(source_port.type.llvm_type())
                irbuilder.store(array_ptr, new_ptr)
                array_ptr = new_ptr  # irbuilder.gep(array_ptr, [ll.Constant(ll.IntType(64), 0)])
                res = irbuilder.gep(array_ptr, [ll.Constant(ll.IntType(32), 0), indexIR])
                res = irbuilder.load(res, name=label)
                new_var.add_incoming(not_poison,res)
                irbuilder.branch(follower)
        with irbuilder.goto_block(poison):
            res=irbuilder.sub(ll.Constant(ll.IntType(32), 0),ll.Constant(ll.IntType(32), 1),flags=("nuw"))
            new_var.add_incoming(poison,res)
            irbuilder.branch(follower)

        self.out_ports[0].value = new_var
