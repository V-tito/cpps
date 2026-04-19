from ..node import Node, to_llvm_method
from ..llvm.llvm_codegen import llvm_eval
from ..error import CodeGenError
from ..edge import get_src_node
from ..port import copy_port_values, copy_port_labels
from ..type import ArrayType

# from ..cpp import template
# from ..codegen_state import global_no_error
import llvmlite.ir as ll


class LoopExpression(Node):

    count = 0

    copy_parent_input_values = True

    def __init__(self, data):
        super().__init__(data)
        LoopExpression.count += 1
        self.reduction_values = []
        self.reduction_operators = []
        self.private_vars = []
        for node_name in ["init", "body", "condition", "range_gen", "returns"]:
            if node_name not in self.__dict__:
                # for easy checks:
                self.__dict__[node_name] = None
            else:
                # copy LoopObject reference to all it's subnodes:
                self.__dict__[node_name].loop_object = self
                for node in self.__dict__[node_name].nodes:
                    node.loop_object = self

    @staticmethod
    def get_out_ports_list(nodes):
        retval = []
        for node in nodes:
            if node:
                retval += node.out_ports
        return retval

    def copy_port_values_to_children(self, irbuilder: ll.IRBuilder):
        """Copy values assigned to ports between child nodes.
        ex. if variable was created in init, it must be copied to
        body and reduction, etc.
        """
        # Init's input values are added separately because the class
        # is shared between Loop and Let:
        if self.init:
            copy_port_values(self.in_ports, self.init.in_ports[-len(self.in_ports) :])
            irbuilder.position_at_start(self.predecessor)
            self.init.to_llvm(irbuilder)

        if self.range_gen:
            copy_port_values(
                self.in_ports, self.range_gen.in_ports[-len(self.in_ports) :]
            )
            self.range_gen.to_llvm(irbuilder)

        if self.body:
            copy_port_values(
                self.get_out_ports_list([self.range_gen, self.init]), self.body.in_ports
            )
            copy_port_values(self.in_ports, self.body.in_ports[-len(self.in_ports) :])
            self.body.to_llvm(irbuilder)

        if self.condition:
            copy_port_values(
                self.in_ports, self.condition.in_ports[-len(self.in_ports) :]
            )
            copy_port_values(
                self.get_out_ports_list([self.body]), self.condition.in_ports
            )
            self.condition.to_llvm(irbuilder)

        copy_port_values(
            self.get_out_ports_list([self.body, self.range_gen, self.init]),
            self.returns.in_ports,
        )

        copy_port_values(self.in_ports, self.returns.in_ports[-len(self.in_ports) :])

    @to_llvm_method
    def to_llvm(self, irbuilder: ll.IRBuilder):
        # create a comment containing names of variables being calculated
        # in the loop:
        result_vars_list = ", ".join(port.label for port in self.out_ports)
        self.predecessor = irbuilder.block
        args = [
            (
                port.type.llvm_type()
                if not isinstance(port.type, ArrayType)
                else ll.PointerType()
            )
            for port in self.in_ports
        ]
        ret_types = [
            (
                port.type.llvm_type()
                if not isinstance(port.type, ArrayType)
                else ll.PointerType()
            )
            for port in self.out_ports
        ]
        # format types for llvmlite
        if len(ret_types) == 0:
            ret_type = ll.VoidType()
        else:
            if len(ret_types) == 1:
                ret_type = ret_types[0]
            else:
                ret_type = ll.LiteralStructType(ret_types)
        # self.loop_func_type = ll.FunctionType()
        self.header = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_header"
        )
        self.loop_body_block = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_body"
        )
        self.latch = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_latch"
        )
        self.follower = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_follower"
        )  # ret would be in here
        self.phi_vars = []

        self.copy_port_values_to_children(irbuilder)

        copy_port_labels(self.out_ports, self.returns.out_ports)

        # add a reference to the loop to eachReduction node within Returns node:
        self.returns.copy_loop_object_to_all_reductions(self)

        for o_p, r_o_p in zip(self.out_ports, self.returns.out_ports):
            # тут надо будет распаковывать возвращаемые значения функции. load(gep) и вот это вот всё
            # сначала в follower-е идет упаковка редукций в структурку (если массивы есть, то их разместить на куче)
            # потом в активном блоке распаковка значений из структурки
            # calculate out-ports' values
            o_p.value = llvm_eval(r_o_p, irbuilder)
        if not (self.predecessor.is_terminated):
            with irbuilder.goto_block(self.predecessor):
                irbuilder.branch(self.header)
        if not (self.latch.is_terminated):
            with irbuilder.goto_block(self.latch):
                irbuilder.branch(self.header)
        irbuilder.position_at_end(self.follower)


class Body(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        self.name_child_ports()
        with irbuilder.goto_block(
            self.loop_object.loop_body_block
        ):  # loop_body_block будет в функции loop

            for o_p in self.out_ports:
                if o_p.label in [i_p.label for i_p in self.in_ports]:
                    # TODO where possible? only with old and initial?
                    llvm_eval(o_p, irbuilder)
                    self.loop_object.phi_vars += o_p.label
                else:
                    llvm_eval(o_p, irbuilder)
                self.loop_object.private_vars += [o_p.value]


class Returns(Node):
    """Returns node. It is assumed that each output port is always connected
    to a Reduction node inside"""

    def copy_loop_object_to_all_reductions(self, loop_object):
        """copy loop to all reduction nodes"""
        for node in self.nodes:
            if type(node) == Reduction:
                node.loop_object = loop_object


class Reduction(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        """Reduction node. Receives a boolean (1st port),
        which is a condition for including a new item,
        determined by value (2nd port)"""
        # with goto и header будет в loop func
        if self.operator == "array":
            with irbuilder.goto_block(self.loop_object.header):
                ptr = irbuilder.alloca(self.out_ports[0].type.llvm_type())
                record_type = ll.LiteralStructType([ll.PointerType(), ll.IntType(32)])
                reduction_value = irbuilder.alloca(record_type, name="reduction_array")
                addr = irbuilder.gep(
                    reduction_value,
                    [ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 0)],
                    source_etype=record_type,
                )
                int_ = irbuilder.ptrtoint(addr, ll.IntType(64))
                addr = irbuilder.inttoptr(int_, ll.PointerType())
                irbuilder.store(ptr, addr)
                count = irbuilder.gep(
                    reduction_value,
                    [ll.Constant(ll.IntType(32), 0), ll.Constant(ll.IntType(32), 1)],
                    source_etype=record_type,
                )
                int_ = irbuilder.ptrtoint(count, ll.IntType(64))
                count = irbuilder.inttoptr(int_, ll.PointerType())
                irbuilder.store(ll.Constant(ll.IntType(32), 0), count)
        else:
            irbuilder.position_at_start(self.loop_object.header)
            reduction_value = irbuilder.phi(self.in_ports[1].type.llvm_type())
            irbuilder.position_at_start(self.loop_object.latch)
            next_reduction_value = irbuilder.phi(self.in_ports[1].type.llvm_type())
            if self.operator == "sum":
                reduction_value.add_incoming(
                    ll.Constant(self.in_ports[1].type.llvm_type(), 0),
                    self.loop_object.predecessor,
                )
                self.loop_object.reduction_values += [next_reduction_value]
                self.loop_object.reduction_operators = ["sis_sum"]
            elif self.operator == "product":
                reduction_value.add_incoming(
                    ll.Constant(self.in_ports[1].type.llvm_type(), 1),
                    self.loop_object.predecessor,
                )
                self.loop_object.reduction_values += [next_reduction_value]
                self.loop_object.reduction_operators = ["sis_product"]
            else:
                reduction_value.add_incoming(
                    ll.Constant(self.in_ports[1].type.llvm_type(), 1),
                    self.loop_object.predecessor,
                )

        with irbuilder.goto_block(self.loop_object.loop_body_block):
            input_value = llvm_eval(self.in_ports[1], irbuilder)
            cond = llvm_eval(self.in_ports[0], irbuilder)
            then = irbuilder.append_basic_block("reduction_cond")
            otherwise = irbuilder.append_basic_block("not_reduction_cond")
            irbuilder.cbranch(cond, then, otherwise)
            with irbuilder.goto_block(then):
                if self.operator == "array":
                    counter = irbuilder.add(
                        irbuilder.load(count, typ=ll.IntType(32)),
                        ll.Constant(ll.IntType(32), 1),
                    )
                    new_elem = irbuilder.gep(
                        ptr,
                        [
                            ll.Constant(ll.IntType(32), 0),
                            counter,
                        ],
                        source_etype=ptr.allocated_type,
                    )
                    irbuilder.store(input_value, new_elem)
                    irbuilder.store(counter, count)
                else:
                    if self.operator == "value":
                        new_value = input_value
                    elif self.operator == "sum":
                        if isinstance(input_value.type, ll.IntType):
                            new_value = irbuilder.add(
                                input_value,
                                reduction_value,
                            )

                        else:
                            if isinstance(input_value.type, ll.DoubleType):
                                new_value = irbuilder.fadd(
                                    input_value,
                                    reduction_value,
                                )
                            else:
                                raise CodeGenError(
                                    "Failed to recognize reduction value type"
                                )
                    elif self.operator == "product":
                        if isinstance(input_value.type, ll.IntType):
                            new_value = irbuilder.mul(
                                input_value,
                                reduction_value,
                            )
                        else:
                            if isinstance(input_value.type, ll.DoubleType):
                                new_value = irbuilder.fmul(
                                    input_value,
                                    reduction_value,
                                )
                            else:
                                raise CodeGenError(
                                    "Failed to recognize reduction value type"
                                )
                    next_reduction_value.add_incoming(new_value, then)
                    irbuilder.branch(self.loop_object.latch)
                    # emit instructions for when the predicate is true
            with irbuilder.goto_block(otherwise):
                if self.operator != "array":
                    new_value = reduction_value
                    next_reduction_value.add_incoming(new_value, otherwise)
                irbuilder.branch(self.loop_object.latch)
        reduction_value.add_incoming(next_reduction_value, self.loop_object.latch)

        self.out_ports[0].value = reduction_value


class RangeGen(Node):
    """Range generation node."""

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # out ports go like var, var1_index, var2, var2_index, e.t.c.
        self.name_child_ports()
        # copy LoopExpression's input values:
        for i_p, loop_i_p in zip(
            self.in_ports, self.loop_object.in_ports
        ):  # here it wouldn't be in ports but FUNC ARGS!
            i_p.value = loop_i_p.value
        for o_p in self.out_ports:
            # assuming it's always a Scatter Node
            scatter = get_src_node(o_p)
            if type(scatter) != Scatter:
                raise CodeGenError(f"expected scatter node in {self.id}" f"({self})")
            scatter.loop_object = self.loop_object
            llvm_eval(o_p, irbuilder)


class RangeNumeric(Node):

    def to_llvm(self, irbuilder):
        for i_p in self.in_ports:
            llvm_eval(i_p, irbuilder)


class Scatter(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        with irbuilder.goto_block(self.loop_object.header):
            # o_p: element, index
            input_var = llvm_eval(self.in_ports[0], irbuilder)
            input_node = get_src_node(self.in_ports[0])
            if type(input_node) == RangeNumeric:
                left = input_node.in_ports[0].value
                right = input_node.in_ports[1].value
                self.out_ports[0].value = irbuilder.phi(
                    input_node.in_ports[0].value.type,
                    name=self.out_ports[0].label,
                )
                self.out_ports[1].value = irbuilder.phi(  # STUB!
                    input_node.in_ports[0].value.type,
                    name=self.out_ports[0].label,
                )
                self.out_ports[0].value.add_incoming(
                    left, self.loop_object.predecessor
                )  # тут будет func entry
                self.out_ports[1].value.add_incoming(  # STUB!
                    left, self.loop_object.predecessor
                )
                with irbuilder.goto_block(self.loop_object.latch):
                    element = irbuilder.add(
                        self.out_ports[0].value, ll.Constant(ll.IntType(64), 1)
                    )
                self.out_ports[0].value.add_incoming(element, self.loop_object.latch)
                self.out_ports[1].value.add_incoming(
                    element, self.loop_object.latch
                )  # STUB!
                cond = irbuilder.icmp_signed("<=", self.out_ports[0].value, right)
                irbuilder.cbranch(
                    cond, self.loop_object.loop_body_block, self.loop_object.follower
                )

            else:
                pass
            # TODO non-int ranges


class Condition(Node):
    """Not used directly (inherited classes are used instead)"""


class PreCondition(Condition):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        with irbuilder.goto_block(self.loop_object.header):
            for i_p in self.in_ports:
                if i_p.label in self.loop_object.phi_vars:
                    new_value = irbuilder.phi(i_p.type.llvm_type())
                    new_value.add_incoming(
                        i_p.value, self.loop_object.predecessor
                    )  # entry
                    new_value.add_incoming(
                        next(
                            o_p.value
                            for o_p in self.loop_object.body.out_ports
                            if o_p.label == i_p.label
                        ),
                        self.loop_object.latch,
                    )
                    i_p.value = new_value

            cond = llvm_eval(self.out_ports[0], irbuilder)
            irbuilder.cbranch(
                cond, self.loop_object.loop_body_block, self.loop_object.follower
            )


class PostCondition(Condition):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        with irbuilder.goto_block(self.loop_object.header):
            cond = irbuilder.phi(ll.IntType(1))
            cond.add_incoming(
                ll.Constant(ll.IntType(1), 0), self.loop_object.predecessor  # entry
            )
            for i_p in self.in_ports:
                if i_p.label in self.loop_object.phi_vars:
                    new_value = irbuilder.phi(i_p.type.llvm_type())
                    new_value.add_incoming(i_p.value, self.loop_object.predecessor)
                    new_value.add_incoming(
                        next(
                            o_p.value
                            for o_p in self.loop_object.body.out_ports
                            if o_p.label == i_p.label
                        ),
                        self.loop_object.latch,
                    )
                    i_p.value = new_value
            cond.add_incoming(
                llvm_eval(self.out_ports[0], irbuilder), self.loop_object.latch
            )
            irbuilder.cbranch(
                cond, self.loop_object.loop_body_block, self.loop_object.follower
            )


class OldValue(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        old_value = llvm_eval(self.in_ports[0], irbuilder)
        # olds_block = CppBlock()
        self.out_ports[0].value = old_value
        # TODO create olds block in LoopExpression object?
