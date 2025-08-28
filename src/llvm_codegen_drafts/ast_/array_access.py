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

        array = llvm_eval(self.in_ports[0], irbuilder)
        index = llvm_eval(self.in_ports[1], irbuilder)

        # Cloud Sisal Arrays' indices start from 1 by default
        # hence the {index}-1

        label = self.out_ports[0].label if self.out_ports[0].renamed else ""
        if type(index) is not int:
            indexIR = irbuilder.sub(index, ll.Constant(ll.IntType(64), 1))
        else:
            indexIR = index - 1
        # if index < 0:
        #    raise CodeGenError("Literal array index is out of bounds", self.location)
        new_var = None
        # array_type = type(array)
        if not isinstance(type(array), ll.PointerType):
            if type(indexIR) is not int:
                source_port = Edge.edge_to[self.in_ports[0].id].from_
                array_ptr = irbuilder.alloca(source_port.type.llvm_type)
                irbuilder.store(array, array_ptr)
                array = array_ptr  # irbuilder.gep(array_ptr, [ll.Constant(ll.IntType(64), 0)])
            else:
                new_var = irbuilder.extract_element(array, indexIR, name=label)
        if not new_var:
            new_var = irbuilder.gep(array, [ll.Constant(ll.IntType(64), 0), indexIR])
            new_var = irbuilder.load(new_var)

        self.out_ports[0].value = new_var
