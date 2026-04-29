#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator if
"""
from ..node import Node, to_llvm_method
from ..llvm.llvm_codegen import llvm_eval, BranchCount, heap_allocation_helper
import llvmlite.ir as ll
from ..type import ArrayType


class If(Node):

    name = "if"
    copy_parent_input_values = True

    @to_llvm_method
    def to_llvm(self, irbuilder: ll.IRBuilder):

        BranchCount.count += 1  # надо инкапсуляцию

        cond_blocks = self.condition.to_llvm(self, irbuilder)
        follower = irbuilder.append_basic_block(name=f"If{BranchCount.count}follower")
        # evaluate branches:
        for o_p in self.out_ports:
            irbuilder.position_at_end(follower)
            o_p.value = irbuilder.phi(o_p.type.llvm_type(), name=o_p.label)
            for index, then_block in enumerate(cond_blocks):
                irbuilder.position_at_start(then_block)
                self.branches[index].to_llvm(self, o_p, irbuilder, follower)
        irbuilder.position_at_end(follower)

    def mark_heap_allocation(self):
        for br in self.branches:
            for o_p, b_o_p in zip(self.out_ports, br.out_ports):
                if isinstance(o_p.type, ArrayType):
                    if o_p.type.is_output_array:
                        b_o_p.type.is_output_array
                        heap_allocation_helper(b_o_p)
            for i_p in self.in_ports:
                b_i_p = next(port for port in br.in_ports if port.label == i_p.label)
                if isinstance(b_i_p.type, ArrayType):
                    if b_i_p.type.is_output_array:
                        i_p.type.is_output_array = True
                        heap_allocation_helper(i_p)


class Branch(Node):

    def to_llvm(self, parent_if, result_port, irbuilder: ll.IRBuilder, follower):
        for i_p, p_ip in zip(self.in_ports, parent_if.in_ports):
            i_p.value = p_ip.value
        result_port.value.add_incoming(
            llvm_eval(self.out_ports[result_port.index], irbuilder), irbuilder.block
        )
        result_port.value._clear_string_cache()
        try:
            irbuilder.branch(follower)
        except AssertionError:
            pass


class Condition(Node):
    def to_llvm(self, parent_if, irbuilder: ll.IRBuilder):

        branches = []

        for i_p, p_ip in zip(self.in_ports, parent_if.in_ports):
            i_p.value = p_ip.value

        for condition_index, o_p in enumerate(self.out_ports):
            cond_result = llvm_eval(o_p, irbuilder)
            truebr = irbuilder.append_basic_block(
                name=f"If{BranchCount.count}true{condition_index}"
            )
            falsebr = irbuilder.append_basic_block(
                name=f"If{BranchCount.count}false{condition_index}"
            )
            irbuilder.cbranch(cond_result, truebr, falsebr)
            irbuilder.position_at_start(falsebr)
            branches.append(truebr)
        branches.append(irbuilder.block)

        return branches
