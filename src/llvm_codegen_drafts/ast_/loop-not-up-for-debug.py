from ..node import Node, to_llvm_method
from ..llvm.llvm_codegen import llvm_eval
from ..error import CodeGenError
from ..edge import get_src_node
from ..port import copy_port_values, copy_port_labels

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
        """Copy C++ values assigned to ports between child nodes.
        ex. if variable was created in init, it must be copied to
        body and reduction, etc.
        """

        # Init's input values are added separately because the class
        # is shared between Loop and Let:

        if self.init:
            copy_port_values(self.in_ports, self.init.in_ports[-len(self.in_ports) :])
            irbuilder.goto_block(self.init_block)
            self.init.to_llvm(irbuilder)

        if self.range_gen:
            self.range_gen.to_llvm(irbuilder)

        if self.body:
            copy_port_values(
                self.get_out_ports_list([self.range_gen, self.init]), self.body.in_ports
            )
            copy_port_values(self.in_ports, self.body.in_ports[-len(self.in_ports) :])

        if self.body:
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
        self.init_block = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_init"
        )
        self.follower = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_follower"
        )
        self.loop_body_block = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_body"
        )
        self.copy_port_values_to_children(irbuilder)

        copy_port_labels(self.out_ports, self.returns.out_ports)

        # add a reference to current C++ block to eachReduction node
        # within Returns node:
        self.returns.copy_cpp_blocks_to_all_reductions(
            self.loop_block, block, self.init_block
        )

        for o_p, r_o_p in zip(self.out_ports, self.returns.out_ports):
            # calculate out-ports' values and add variables for
            # them to the C++ block:
            o_p.value = CppVariable(o_p.label, o_p.type.cpp_type)
            o_p_value = llvm_eval(r_o_p, self.loop_block)
            block.add_variable(o_p.value)
            block.add_code(CppAssignment(o_p.value, r_o_p.value))

        for var in self.loop_block.variables:
            block.add_variable(var)
        self.loop_block.variables = []
        red_names = ", ".join([r.name for r in self.reduction_values])
        red_ops = ", ".join([str(r) for r in self.reduction_operators])
        if self.reduction_values:
            priv_names = (
                " private(" + ", ".join([str(p) for p in self.private_vars]) + ")"
                if self.private_vars
                else ""
            )
            self.pragma_block.add_code(
                f"#pragma omp parallel for reduction({red_ops}:{red_names})"  # + priv_names
            )
        block.add_code(f"// loop end: {result_vars_list}")


# copy order in parser:
# cond:
# init , range_gen, body (prepended)
# body:
# init, range_gen
# returns:
# init, range_gen, body

# 0: element, 1: index


class Body(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        self.name_child_ports()
        irbuilder.position_at_start(self.loop_object.loop_body_block)

        for o_p in self.out_ports:
            if o_p.label in [i_p.label for i_p in self.in_ports]:
                # TODO where possible? only with old and initial?
                new_value = llvm_eval(o_p, irbuilder)
                o_p.value = next(
                    i_p.value for i_p in self.in_ports if o_p.label == i_p.label
                )
                if self.loop_object.latch:
                    irbuilder.goto_block(self.loop_object.latch)
                else:
                    self.loop_object.latch = irbuilder.append_basic_block("latch")

                o_p.value = irbuilder.phi(o_p.value.type, name=o_p.label + ".next")
                o_p.value.add_incoming(new_value, self.loop_object.init_block)
                o_p
                # TODO is strict typing in sisal?
            else:
                llvm_eval(o_p, block)

            self.loop_object.private_vars += [o_p.value]


class Returns(Node):
    """Returns node. It is assumed that each output port is always connected
    to a Reduction node inside"""

    def copy_cpp_blocks_to_all_reductions(self, loop_body_block, loop_bock, init_block):
        """copy loop body and overall loop blocks variables
        to all reduction nodes
        """
        for node in self.nodes:
            if type(node) == Reduction:
                node.loop_body_block = loop_body_block
                node.loop_block = loop_bock
                node.init_block = init_block


class Reduction(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        """Reduction node. Receives a boolean (1st port),
        which is a condition for including a new item,
        determined by value (2nd port)"""
        block_ = CppBlock()
        block_.add_code("// loop reduction:")
        block.add_code(block_)
        block = block_
        cond = llvm_eval(self.in_ports[0], block)
        input_value = llvm_eval(self.in_ports[1], block)

        cond_header = f"if({cond})" "{" if cond != True else ""
        cond_footer = "}" if cond != True else ""

        if self.operator == "array":

            reduction_value = CppVariable(
                "reduction_array", f"Array<{self.in_ports[1].type.cpp_type}>"
            )
            self.loop_body_block.add_code(
                cond_header
                + f"{reduction_value}.push_back({input_value});"
                + cond_footer
            )

        elif self.operator == "value":
            reduction_value = CppVariable("reduction_value", f"{input_value.type_}")
            self.loop_block.add_code(
                cond_header + f"{reduction_value} = {input_value};" + cond_footer
            )
        elif self.operator == "sum":
            reduction_value = CppVariable("reduction_sum", f"{input_value.type_}")
            self.init_block.add_code(CppAssignment(reduction_value, 0))
            self.loop_body_block.add_code(
                cond_header + f"{reduction_value} += {input_value};" + cond_footer
            )
            self.loop_object.reduction_values += [reduction_value]
            self.loop_object.reduction_operators = ["sis_sum"]
        elif self.operator == "product":
            reduction_value = CppVariable("reduction_product", f"{input_value.type_}")
            self.init_block.add_code(CppAssignment(reduction_value, 1))
            self.loop_body_block.add_code(
                cond_header + f"{reduction_value} *= {input_value};" + cond_footer
            )
            self.loop_object.reduction_values += [reduction_value]
            self.loop_object.reduction_operators = ["sis_product"]

        self.init_block.add_variable(reduction_value)
        self.out_ports[0].value = reduction_value


class RangeGen(Node):
    """Range generation node."""

    def to_llvm(self, irbuilder: ll.IRBuilder):
        # out ports go like var, var1_index, var2, var2_index, e.t.c.
        self.name_child_ports()
        # copy LoopExpression's input values:
        for i_p, loop_i_p in zip(self.in_ports, self.loop_object.in_ports):
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
        irbuilder.position_at_start(self.loop_object.init_block)
        # o_p: element, index
        input_var = llvm_eval(self.in_ports[0], irbuilder)

        input_node = get_src_node(self.in_ports[0])
        if type(input_node) == RangeNumeric:
            left = input_node.in_ports[0].value
            right = input_node.in_ports[1].value
            self.out_ports[0].value = irbuilder.phi(
                input_node.in_ports[0].value.type.llvm_type,
                name=self.out_ports[0].label,
            )
            self.out_ports[0].value.add_incoming(left, self.loop_object.predecessor)
            self.loop_object.latch = irbuilder.append_basic_block(name="latch")
            irbuilder.goto_block(self.loop_object.latch)
            element = irbuilder.add(
                self.out_ports[0].value, ll.Constant(ll.IntType(32), 1)
            )
            self.out_ports[0].value.add_incoming(element, self.loop_object.latch)
            irbuilder.branch(self.loop_object.init_block)

        else:
            pass
        # TODO non-int ranges


class Condition(Node):
    """Not used directly (inherited classes are used instead)"""


class PreCondition(Condition):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        irbuilder.goto_block(self.loop_object.init_block)
        cond = llvm_eval(self.out_ports[0], irbuilder)
        irbuilder.cbranch(
            cond, self.loop_object.loop_body_block, self.loop_object.follower
        )


class PostCondition(Condition):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        irbuilder.goto_block(self.loop_object.loop_body_block)
        cond = llvm_eval(self.out_ports[0], irbuilder)
        irbuilder.cbranch(cond, self.loop_object.init_block, self.loop_object.follower)


class OldValue(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        old_value = llvm_eval(self.in_ports[0], irbuilder)        olds_block = CppBlock()
        self.out_ports[0].value = old_value
        # TODO create olds block in LoopExpression object?
