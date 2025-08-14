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

        if_results = []

        BranchCount.count += 1  # надо инкапсуляцию

        follower = irbuilder.append_basic_block(name=f"If{BranchCount.count}follower")

        for _, o_p in enumerate(self.out_ports):
            if_result = irbuilder.alloca(self.o_p.type.llvm_type, name=o_p.label)
            if_results.append(if_result)
            o_p.value = if_result

        cond_blocks = self.condition.to_llvm(self, irbuilder)

        # evaluate branches:
        for o_p in self.out_ports:
            for index, then_block in enumerate(cond_blocks):
                irbuilder.goto_block(then_block)
                self.branches[index].to_llvm(self, o_p, irbuilder, follower)


class Branch(Node):
    def to_llvm(self, parent_if, result_port, irbuilder: ll.IRBuilder, follower):
        for i_p, p_ip in zip(self.in_ports, parent_if.in_ports):
            i_p.value = p_ip.value

            irbuilder.store(
                result_port.value, llvm_eval(self.out_ports[result_port.index])
            )
            irbuilder.branch(follower)


class Condition(Node):
    def to_llvm(self, parent_if, irbuilder):

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
            irbuilder.goto_block(falsebr)
            branches.append(truebr)
        branches.append(irbuilder.block)

        return branches
