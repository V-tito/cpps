import sys
from ..node import Node
from ..port import Port
from ..edge import Edge
from ..llvm.llvm_codegen import llvm_eval

import llvmlite.ir as ll


class Binary(Node):
    def to_llvm(self, irbuilder: ll.IRBuilder):

        int_operator_map = {
            "+": lambda x, y, label="": irbuilder.add(x, y, name=label),
            "-": lambda x, y, label="": irbuilder.sub(x, y, name=label),
            "*": lambda x, y, label="": irbuilder.mul(x, y, name=label),
            "/": lambda x, y, label="": irbuilder.sdiv(x, y, name=label),
            ">": lambda x, y, label="": irbuilder.icmp_signed(">", x, y, name=label),
            "<": lambda x, y, label="": irbuilder.icmp_signed("<", x, y, name=label),
            "=": lambda x, y, label="": irbuilder.icmp_signed("=", x, y, name=label),
            "!=": lambda x, y, label="": irbuilder.icmp_signed("!=", x, y, name=label),
            ">=": lambda x, y, label="": irbuilder.icmp_signed(">=", x, y, name=label),
            "<=": lambda x, y, label="": irbuilder.icmp_signed("<=", x, y, name=label),
            "&": lambda x, y, label="": irbuilder.and_(x, y, name=label),
            "|": lambda x, y, label="": irbuilder.or_(x, y, name=label),
            "**": lambda x, pow, label="": irbuilder.call(
                irbuilder.module.int_power, [x, pow], name=label
            ),
        }
        float_operator_map = {
            "+": lambda x, y, label="": irbuilder.fadd(x, y, name=label),
            "-": lambda x, y, label="": irbuilder.fsub(x, y, name=label),
            "*": lambda x, y, label="": irbuilder.fmul(x, y, name=label),
            "/": lambda x, y, label="": irbuilder.fdiv(x, y, name=label),
            ">": lambda x, y, label="": irbuilder.fcmp_unordered(">", x, y, name=label),
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
            "**": lambda x, pow, label="": irbuilder.call(
                irbuilder.module.double_power, [x, pow], name=label
            ),
        }
        left = llvm_eval(self.in_ports[0], irbuilder)
        right = llvm_eval(self.in_ports[1], irbuilder)
        operator = self.operator
        isintl = isinstance(left.type, ll.IntType)
        isintr = isinstance(right.type, ll.IntType)

        if self.out_ports[0].label:
            label = self.out_ports[0].label
        else:
            label = ""

        # prepare error handling
        error_block = irbuilder.append_basic_block(
            f"{self.name if hasattr(self,'name') else self.__class__.__name__ }_err_block"
        )
        no_error_block = irbuilder.append_basic_block(
            f"{self.name if hasattr(self,'name') else self.__class__.__name__ }_correct_exec_block"
        )
        phi_block = irbuilder.append_basic_block(
            f"{self.name if hasattr(self,'name') else self.__class__.__name__ }_phi_block"
        )
        with irbuilder.goto_block(error_block):
            irbuilder.branch(phi_block)

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
            errcond = irbuilder.or_(errcond, zero_division)
            # TODO check if both are allowed types (parser shouldnt allow that tho)
        irbuilder.cbranch(
            errcond,
            error_block,
            no_error_block,
        )
        irbuilder.position_at_start(no_error_block)
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
                res = float_operator_map[operator](left, right, label)
        self.out_ports[0].value = res
        self.out_ports[0].error_cond = errcond
        # considering branching between predecessor, noerrstart and any blocks created in fn done by fn
        # (since the func knows of its inner blocks and port conditions)

        # finish error handling
        irbuilder.branch(phi_block)
        irbuilder.position_at_start(phi_block)
        for o_p in self.out_ports:
            phi = irbuilder.phi(o_p.type.llvm_type())
            phi.add_incoming(phi.type(ll.Undefined), o_p.error_block)
            phi.add_incoming(o_p.value, o_p.no_error_end_block)
            o_p.value = phi


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
        # prepare error handling
        error_block = irbuilder.append_basic_block(
            f"{self.name if hasattr(self,'name') else self.__class__.__name__ }_err_block"
        )
        no_error_block = irbuilder.append_basic_block(
            f"{self.name if hasattr(self,'name') else self.__class__.__name__ }_correct_exec_block"
        )
        phi_block = irbuilder.append_basic_block(
            f"{self.name if hasattr(self,'name') else self.__class__.__name__ }_phi_block"
        )
        with irbuilder.goto_block(error_block):
            irbuilder.branch(phi_block)

        # error handling
        errcond = irbuilder.or_(
            self.in_ports[0].error_cond, self.in_ports[1].error_cond
        )
        irbuilder.cbranch(
            errcond,
            error_block,
            no_error_block,
        )
        irbuilder.position_at_start(no_error_block)

        if isinstance(operand.type, ll.IntType):
            res = int_operator_map[operator](operand)
        else:
            if (isinstance(operand.type, ll.FloatType)) | (
                isinstance(operand.type, ll.DoubleType)
            ):
                res = float_operator_map[operator](operand)
        self.out_ports[0].value = res
        self.out_ports[0].error_cond = errcond

        # finish error handling
        irbuilder.branch(phi_block)
        irbuilder.position_at_start(phi_block)
        for o_p in self.out_ports:
            phi = irbuilder.phi(o_p.type.llvm_type())
            phi.add_incoming(phi.type(ll.Undefined), o_p.error_block)
            phi.add_incoming(o_p.value, o_p.no_error_end_block)
            o_p.value = phi
