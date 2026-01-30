import llvmlite.ir as ll
import llvmlite.binding as llvm
from ..edge import Edge


# где-то здесь будет определение модуля, вероятно, классом с методом, который будет его инициализировать
class LlModule(ll.Module):
    def __init__(self, name: str, functions: dict, definitions: dict = {}):
        super().__init__(name)
        self.builder = ll.IRBuilder(None)
        self.engine = None
        self.modref = None
        self.inputs = []
        self.output = None
        for _, f in functions.items():
            f.module = self
            # self.add_global(
            f.to_llvm(self.builder)

    def __str__(self):
        return super().__str__()

    def set_inputs(self, types: dict):
        self.inputs = types

    def get_input_types(self):
        return self.inputs.values()

    def get_input_ctypes(self):
        from ctypes import POINTER
        from ..type import ArrayType

        return [
            _type.ctype() if type(_type) is not ArrayType else POINTER(_type.ctype())
            for _type in self.inputs.values()
        ]

    def get_input_names(self):
        return self.inputs.keys()

    def set_output(self, types):
        if len(types) > 0:
            self.output = types

    def get_output_ctype(self):
        if self.output:
            from ..type import RecordType

            ctypes = [(name, _type.ctype) for name, _type in self.output.items()]
            return RecordType.make_ctypes_struct(fields=ctypes[:])
        else:
            return self.output

    def bitcode_gen(self, target_triple=None):
        module = llvm.parse_assembly(str(self))
        llvm.initialize_native_target()
        llvm.initialize_native_asmprinter()
        if not target_triple:
            target = llvm.Target.from_default_triple()
        else:
            target = llvm.Target.from_triple(target_triple)
        target_machine = target.create_target_machine()
        engine = llvm.create_mcjit_compiler(module, target_machine)
        engine.finalize_object()
        engine.run_static_constructors()
        self.engine = engine
        self.modref = module
        return module.as_bitcode()
        # from ..ast_.function import create_main

        # self.functions += [create_main()]

    def run_on_jit(self, args: list):
        from ctypes import CFUNCTYPE

        if not self.engine:
            self.bitcode_gen()
        func_ptr = self.engine.get_function_address("main")
        out = self.get_output_ctype()
        inp = self.get_input_ctypes()
        cfunctup = CFUNCTYPE(out, *inp)
        cfunc = cfunctup(func_ptr)
        args_formatted = (
            argtype.to_ctype(arg) for arg, argtype in zip(args, self.get_input_types())
        )
        res = cfunc(*args_formatted)
        return res


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
