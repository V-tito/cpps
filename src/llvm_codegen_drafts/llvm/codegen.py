import llvmlite.ir as ll
import llvmlite.binding as llvm
from ..edge import Edge

llvm.initialize()
llvm.initialize_native_target()
llvm.initialize_native_asmprinter()

#где-то здесь будет определение модуля, вероятно, классом с методом, который будет его инициализировать

def llvm_eval(in_port, irbuilder):
    port = Edge.edge_to[in_port.id].from_
    if port.value is None:
        port.node.llvm_ir(irbuilder)
    in_port.value=port.value
    return port.value