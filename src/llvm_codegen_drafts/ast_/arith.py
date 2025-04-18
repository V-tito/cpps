from ctypes import CFUNCTYPE, c_int
import sys
from ..node import Node
from ..port import Port
from ..edge import Edge
from ..llvm.codegen import llvm_eval

import llvmlite.ir as ll
import llvmlite.binding as llvm

class Binary(Node):
    def llvm_ir(self,irbuilder: ll.IRBuilder): #как быть с функциями? они создают отдельное пространство, в котором разные операторы генерируют блоки. к функции вызов eval может прийти только от вызова. есть операторы, создающие новые блоки. передавать функцию? но по ней не определишь конкретный блок. можно ли по блоку определить функцию? если ООП, то должно быть можно. а блок по irbuilder-у?
        
        operator_map={"+": lambda x,y: irbuilder.add(x,y), #а можно ли здесь ссылаться на irbuilder, если мапа не в самой функции?
          "-": lambda x,y: irbuilder.sub(x,y),
          "*": lambda x,y: irbuilder.mul(x,y),
          "/": lambda x,y: irbuilder.sdiv(x,y), #тут зависит от типа....
          #"**": lambda x, y: как реализовать степень в llvmlite?
          ">": lambda x, y: irbuilder.icmp_signed('>',x,y), #тут для целочисленных со знаком; надо реализовать словарик в зависимости от типа
        "<": lambda x, y: irbuilder.icmp_signed('<',x,y),
        "=": lambda x, y: irbuilder.icmp_signed('==',x,y),
        "!=": lambda x, y: irbuilder.icmp_signed('!=',x,y),
        ">=": lambda x, y: irbuilder.icmp_signed('>=',x,y),
        "<=": lambda x, y: irbuilder.icmp_signed('<=',x,y),
        "&": lambda x, y: irbuilder.and_(x,y),
        "|": lambda x, y: irbuilder.or_(x,y)
        }
        
        left=llvm_eval(self.in_ports[0],irbuilder)
        right=llvm_eval(self.in_ports[1],irbuilder)
        operator=self.operator #есть же у binary такое поле?
        res=operator_map[operator](left,right)
        self.out_ports[0].value = res #опять же, норм ли его возвращать с точки зрения специфики llvm и llvmlite?
    
class Unary (Node):

    def llvm_ir(self,irbuilder:ll.IRBuilder):
        
        operator_map={
            "+": lambda x: x,
            "-": lambda x: irbuilder.neg (x),#целочисленное
            "!": lambda x: irbuilder.not_(x)
        }

        operand=llvm_eval(self.in_ports[0],irbuilder)
        operator=self.operator
        res=operator_map[operator](operand)
        self.out_ports[0].value = res
