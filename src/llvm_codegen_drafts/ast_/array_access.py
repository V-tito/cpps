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
from ..type import ArrayType


class ArrayAccess(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # inputs: array, index

        dope_struct_ptr = llvm_eval(
            self.in_ports[0], irbuilder
        )  # this should become a dope struct
        array_ptr = irbuilder.gep(
            dope_struct_ptr,
            [ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 0)],
        )
        array_ptr = irbuilder.load(array_ptr)
        bounds = irbuilder.gep(
            dope_struct_ptr,
            [ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 1)],
        )
        bounds_count = irbuilder.load(bounds)
        # array_ptr would be gep array 0
        # bounds would be gep array 1
        index = llvm_eval(self.in_ports[1], irbuilder)

        # Cloud Sisal Arrays' indices start from 1 by default
        # hence the {index}-1

        label = self.out_ports[0].label if self.out_ports[0].renamed else ""
        if type(index) is not int:
            indexIR = irbuilder.sub(index, ll.Constant(ll.IntType(64), 1))
        else:
            indexIR = ll.Constant(ll.IntType(64), index - 1)
            if index - 1 < 0:
                raise CodeGenError(
                    "Literal array index is out of bounds", self.location
                )
            # the following commented code if for branching with error value; it'd be returned when error values are developed
            # poison = irbuilder.append_basic_block("poison")
            # not_poison = irbuilder.append_basic_block("not_poison")
            # follower = irbuilder.append_basic_block("follower")
            # with irbuilder.goto_block(follower):
            """new_var = irbuilder.phi(
                (
                    self.out_ports[0].type.llvm_type()
                    if not isinstance(self.out_ports[0].type, ArrayType)
                    else self.out_ports[0].type.make_dope_struct_type()
                ),
                name=label,
            )"""
            # cond = irbuilder.icmp_unsigned("<", indexIR, bounds_count)
            # irbuilder.cbranch(cond, not_poison, poison)
            # irbuilder.position_at_end(follower)
            # array_type = type(array)
            # with irbuilder.goto_block(not_poison):
        print(array_ptr.type)
        # if not isinstance(type(array_ptr), ll.PointerType):
        #    source_port = Edge.edge_to[self.in_ports[0].id].from_
        #    new_ptr = irbuilder.alloca(source_port.type.llvm_type())
        #    irbuilder.store(array_ptr, new_ptr)
        #    array_ptr = new_ptr  # irbuilder.gep(array_ptr, [ll.Constant(ll.IntType(64), 0)])
        res = irbuilder.gep(array_ptr, [ll.Constant(ll.IntType(32), 0), indexIR])
        res = irbuilder.load(res, name=label)
        # new_var.add_incoming(res, not_poison)
        # irbuilder.branch(follower)
        # with irbuilder.goto_block(poison):
        """res = irbuilder.sub(
                ll.Constant(ll.IntType(32), 0),
                ll.Constant(ll.IntType(32), 1),
                flags=["nuw"],
            )"""
        # new_var.add_incoming(res, poison)
        # irbuilder.branch(follower)

        self.out_ports[0].value = res
