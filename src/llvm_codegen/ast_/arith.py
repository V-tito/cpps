import sys
from ..node import Node
from ..port import Port
from ..edge import Edge
from ..llvm.llvm_codegen import llvm_eval

import llvmlite.ir as ll


class Binary(Node):
    def to_llvm(
        self, irbuilder: ll.IRBuilder
    ):  # как быть с функциями? они создают отдельное пространство, в котором разные операторы генерируют блоки. к функции вызов eval может прийти только от вызова. есть операторы, создающие новые блоки. передавать функцию? но по ней не определишь конкретный блок. можно ли по блоку определить функцию? если ООП, то должно быть можно. а блок по irbuilder-у?

        int_operator_map = {
            "+": lambda x, y, label="": irbuilder.add(
                x, y, name=label
            ),  # а можно ли здесь ссылаться на irbuilder, если мапа не в самой функции?
            "-": lambda x, y, label="": irbuilder.sub(x, y, name=label),
            "*": lambda x, y, label="": irbuilder.mul(x, y, name=label),
            "/": lambda x, y, label="": irbuilder.sdiv(
                x, y, name=label
            ),  # тут зависит от типа....
            # "**": lambda x, y: как реализовать степень в llvmlite?
            ">": lambda x, y, label="": irbuilder.icmp_signed(
                ">", x, y, name=label
            ),  # тут для целочисленных со знаком; надо реализовать словарик в зависимости от типа
            "<": lambda x, y, label="": irbuilder.icmp_signed("<", x, y, name=label),
            "=": lambda x, y, label="": irbuilder.icmp_signed("=", x, y, name=label),
            "!=": lambda x, y, label="": irbuilder.icmp_signed("!=", x, y, name=label),
            ">=": lambda x, y, label="": irbuilder.icmp_signed(">=", x, y, name=label),
            "<=": lambda x, y, label="": irbuilder.icmp_signed("<=", x, y, name=label),
            "&": lambda x, y, label="": irbuilder.and_(x, y, name=label),
            "|": lambda x, y, label="": irbuilder.or_(x, y, name=label),
        }
        float_operator_map = {
            "+": lambda x, y, label="": irbuilder.fadd(
                x, y, name=label
            ),  # а можно ли здесь ссылаться на irbuilder, если мапа не в самой функции?
            "-": lambda x, y, label="": irbuilder.fsub(x, y, name=label),
            "*": lambda x, y, label="": irbuilder.fmul(x, y, name=label),
            "/": lambda x, y, label="": irbuilder.fdiv(
                x, y, name=label
            ),  # тут зависит от типа....
            # "**": lambda x, y: как реализовать степень в llvmlite?
            ">": lambda x, y, label="": irbuilder.fcmp_unordered(
                ">", x, y, name=label
            ),  # тут для целочисленных со знаком; надо реализовать словарик в зависимости от типа
            "<": lambda x, y, label="": irbuilder.fcmp_unordered("<", x, y, name=label),
            "=": lambda x, y, label="": irbuilder.fcmp_unordered("=", x, y, name=label),
            "!=": lambda x, y, label="": irbuilder.fcmp_unordered(
                "!=", x, y, name=label
            ),
            ">=": lambda x, y, label="": irbuilder.fcmp_unordered(
                ">=", x, y, name=label
            ),
            "<=": lambda x, y, label="": irbuilder.fcmp_unordered(
                "<=", x, y, name=label
            ),
        }
        left = llvm_eval(self.in_ports[0], irbuilder)
        right = llvm_eval(self.in_ports[1], irbuilder)
        operator = self.operator  # есть же у binary такое поле?
        isintl = isinstance(left.type, ll.IntType)
        isintr = isinstance(right.type, ll.IntType)

        if self.out_ports[0].label:
            label = self.out_ports[0].label
        else:
            label = ""

        # error handling; prev errcond set during llvm_eval
        errcond = irbuilder.or_(
            self.in_ports[0].error_cond, self.in_ports[1].error_cond
        )
        if self.operator == "/":
            zero_division = (
                irbuilder.icmp_signed("==", right, right.type(0))
                if isintr
                else irbuilder.fcmp_unordered("==", right, right.type(0))
            )

        if isintl and isintr:
            res = int_operator_map[operator](left, right, label)
        else:
            if isintl:
                print(isinstance(ll.types.DoubleType(), ll.types.Type))
                left = irbuilder.sitofp(left, typ=ll.DoubleType())
            if isintr:
                right = irbuilder.sitofp(right, ll.DoubleType)
            isfl = (isinstance(left.type, ll.FloatType)) | (
                isinstance(left.type, ll.DoubleType)
            )
            isfr = (isinstance(right.type, ll.FloatType)) | (
                isinstance(right.type, ll.DoubleType)
            )
            if isfl and isfr:
                res = float_operator_map[operator](
                    left, right, label
                )  # добавить сюда else res=error(числовой)
        self.out_ports[0].value = res  # ура я могу


class Unary(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        int_operator_map = {
            "+": lambda x, label="": irbuilder.add(
                ll.Constant(ll.IntType(64), 0), x, name=label
            ),  # затычка в целом после редукций identity не должно возникать
            "-": lambda x, label="": irbuilder.neg(x, name=label),  # целочисленное
            "!": lambda x, label="": irbuilder.not_(x, name=label),
        }

        float_operator_map = {
            "+": lambda x, label="": irbuilder.fadd(
                ll.Constant(type(x), 0), x, name=label
            ),  # затычка
            "-": lambda x, label="": irbuilder.fneg(x, name=label),  # целочисленное
        }
        operand = llvm_eval(self.in_ports[0], irbuilder)
        operator = self.operator
        if isinstance(operand.type, ll.IntType):
            res = int_operator_map[operator](operand)
        else:
            if (isinstance(operand.type, ll.FloatType)) | (
                isinstance(operand.type, ll.DoubleType)
            ):
                res = float_operator_map[operator](operand)
        self.out_ports[0].value = res
