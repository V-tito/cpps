#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
code generator if
"""
from ..node import Node, to_llvm_method
from ..llvm.llvm_codegen import llvm_eval, BranchCount
import llvmlite.ir as ll


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
            o_p.value = irbuilder.phi(o_p.type.llvm_type)
            for index, then_block in enumerate(cond_blocks):
                irbuilder.position_at_start(then_block)
                self.branches[index].to_llvm(self, o_p, irbuilder, follower)
        irbuilder.position_at_end(follower)


class Branch(Node):
    def to_llvm(self, parent_if, result_port, irbuilder: ll.IRBuilder, follower):
        for i_p, p_ip in zip(self.in_ports, parent_if.in_ports):
            i_p.value = p_ip.value

            result_port.value.add_incoming(
                llvm_eval(self.out_ports[result_port.index], irbuilder), irbuilder.block
            )
            irbuilder.branch(follower)


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
