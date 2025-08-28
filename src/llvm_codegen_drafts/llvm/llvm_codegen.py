import llvmlite.ir as ll
import llvmlite.binding as llvm

# import llvmlite.binding as llvm
from ..edge import Edge


# где-то здесь будет определение модуля, вероятно, классом с методом, который будет его инициализировать
class LlModule(ll.Module):
    def __init__(self, name: str, functions: dict, definitions: dict = {}):
        super().__init__(name)
        self.builder = ll.IRBuilder(None)
        for _, f in functions.items():
            f.module = self
            # self.add_global(
            f.to_llvm(self.builder)

    def __str__(self):
        return super().__str__()

        # from ..ast_.function import create_main

        # self.functions += [create_main()]


class BranchCount:
    count = 0


def llvm_eval(in_port, irbuilder):
    current_block = irbuilder.block
    port = Edge.edge_to[in_port.id].from_
    if port.value is None:
        port.node.to_llvm(irbuilder)
    in_port.value = port.value
    irbuilder.goto_block(current_block)
    return port.value
