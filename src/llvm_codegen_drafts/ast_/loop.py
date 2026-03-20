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
            copy_port_values(self.in_ports, self.range_gen.in_ports[-len(self.in_ports) :])
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
        self.header=irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_header"
        )
        self.loop_body_block = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_body"
        )
        self.latch=irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_latch"
        )
        self.follower = irbuilder.append_basic_block(
            name=f"Loop_{LoopExpression.count}_follower"
        )
        self.phi_vars=[]
        
        self.copy_port_values_to_children(irbuilder)

        copy_port_labels(self.out_ports, self.returns.out_ports)

        # add a reference to the loop to eachReduction node within Returns node:
        self.returns.copy_loop_object_to_all_reductions(
            self
        )

        for o_p, r_o_p in zip(self.out_ports, self.returns.out_ports):
            # calculate out-ports' values
            o_p.value = llvm_eval(r_o_p, self.loop_block)
        red_names = ", ".join([r.name for r in self.reduction_values])
        red_ops = ", ".join([str(r) for r in self.reduction_operators])
        if self.reduction_values:
            #need to make smth for parallel for
            self.pragma_block.add_code(
                f"#pragma omp parallel for reduction({red_ops}:{red_names})"  # + priv_names
            )

class Body(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        self.name_child_ports()
        with irbuilder.goto_block(self.loop_object.loop_body_block):

            for o_p in self.out_ports:
                if o_p.label in [i_p.label for i_p in self.in_ports]:
                    # TODO where possible? only with old and initial?
                    llvm_eval(o_p, irbuilder)
                    self.loop_object.phi_vars+=o_p.label
                else:
                    llvm_eval(o_p, irbuilder)
                self.loop_object.private_vars += [o_p.value]


class Returns(Node):
    """Returns node. It is assumed that each output port is always connected
    to a Reduction node inside"""

    def copy_loop_object_to_all_reductions(self, loop_object):
        """copy loop to all reduction nodes
        """
        for node in self.nodes:
            if type(node) == Reduction:
                node.loop_object = loop_object


class Reduction(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        """Reduction node. Receives a boolean (1st port),
        which is a condition for including a new item,
        determined by value (2nd port)"""
        irbuilder.position_at_start(self.loop_object.header)
        if self.operator == "array":
            #need to figure out wtf to do with cond (i guess new array every time it is)
            #keep length somewhere (when figure out dope structs - likely in there)
            
            ptr=irbuilder.alloca(self.out_ports[0].type.llvm_type())
            record_type = ll.LiteralStructType([type(ptr),ll.IntType(64)])
            reduction_value = irbuilder.alloca(record_type, name="reduction_array")
            addr=irbuilder.gep(reduction_value,0)
            irbuilder.store(ptr,addr)
            count=irbuilder.gep(reduction_value,1)
            irbuilder.store(ll.Constant(type(input_value),0),count)
        else:
            reduction_value=irbuilder.phi(type(input_value))
            if self.operator == "sum":
                reduction_value.add_incoming(ll.Constant(type(input_value),0),self.loop_object.predecessor)
                self.loop_object.reduction_values += [reduction_value]
                self.loop_object.reduction_operators = ["sis_sum"]
            if self.operator == "product":
                reduction_value.add_incoming(ll.Constant(type(input_value),1),self.loop_object.predecessor)
                self.loop_object.reduction_values += [reduction_value]
                self.loop_object.reduction_operators = ["sis_product"]
            
        with irbuilder.goto_block(self.loop_object.latch):
            input_value = llvm_eval(self.in_ports[1], irbuilder)
            cond = llvm_eval(self.in_ports[0], irbuilder)
            with irbuilder.if_else(cond) as (then, otherwise):
                with then:
                    if self.operator == "array":
                        counter=irbuilder.add(irbuilder.load(count),ll.Constant(ll.IntType(64),1))
                        new_elem=irbuilder.gep(ptr,ll.Constant(ll.IntType(64),0),counter)
                        irbuilder.store(input_value,new_elem)
                        irbuilder.store(counter,count)
                    else:
                        if self.operator == "value":
                            new_value = input_value
                        elif self.operator == "sum":
                            if  isinstance(type(input_value),ll.IntType):
                                new_value=irbuilder.add(input_value,reduction_value,name="reduction_sum.next")
                                
                            else:
                                if isinstance(type(input_value),ll.DoubleType):
                                    new_value=irbuilder.fadd(input_value,reduction_value,name="reduction_sum.next")
                                else:
                                    raise CodeGenError("Failed to recognize reduction value type")
                        elif self.operator == "product":
                            if  isinstance(type(input_value),ll.IntType):
                                new_value=irbuilder.mul(input_value,reduction_value,name="reduction_product.next")
                            else:
                                if isinstance(type(input_value),ll.DoubleType):
                                    new_value=irbuilder.fmul(input_value,reduction_value,name="reduction_product.next")
                                else:
                                    raise CodeGenError("Failed to recognize reduction value type")
                        reduction_value.add_incoming(new_value,then)
        # emit instructions for when the predicate is true
                with otherwise:
                    if self.operator != "array":
                        new_value=reduction_value
                        reduction_value.add_incoming(new_value,otherwise)
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
        with irbuilder.goto_block(self.loop_object.header):
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
                with irbuilder.goto_block(self.loop_object.latch):
                    element = irbuilder.add(
                    self.out_ports[0].value, ll.Constant(ll.IntType(32), 1)
                )
                self.out_ports[0].value.add_incoming(element, self.loop_object.latch)
                cond=irbuilder.icmp_signed("<", self.out_ports[0].value, right)
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
                    new_value=irbuilder.phi(i_p.type.llvm_type())
                    new_value.add_incoming(i_p.value,self.loop_object.predecessor)
                    new_value.add_incoming(next(o_p.value for o_p in self.loop_object.body.out_ports if o_p.label==i_p.label),self.loop_object.latch)
                    i_p.value=new_value

            cond = llvm_eval(self.out_ports[0], irbuilder)
            irbuilder.cbranch(
                cond, self.loop_object.loop_body_block, self.loop_object.follower
            )


class PostCondition(Condition):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        with irbuilder.goto_block(self.loop_object.header):
            cond = irbuilder.phi(ll.IntType(1))
            cond.add_incoming(ll.Constant(ll.IntType(1),0),self.loop_object.predecessor)
            for i_p in self.in_ports:
                if i_p.label in self.loop_object.phi_vars:
                    new_value=irbuilder.phi(i_p.type.llvm_type())
                    new_value.add_incoming(i_p.value,self.loop_object.predecessor)
                    new_value.add_incoming(next(o_p.value for o_p in self.loop_object.body.out_ports if o_p.label==i_p.label),self.loop_object.latch)
                    i_p.value=new_value
            cond.add_incoming(llvm_eval(self.out_ports[0], irbuilder),self.loop_object.latch) 
            irbuilder.cbranch(cond, self.loop_object.loop_body_block, self.loop_object.follower)


class OldValue(Node):

    def to_llvm(self, irbuilder: ll.IRBuilder):
        old_value = llvm_eval(self.in_ports[0], irbuilder)        
        #olds_block = CppBlock()
        self.out_ports[0].value = old_value
        # TODO create olds block in LoopExpression object?
