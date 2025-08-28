#!/usr/bin/env python
# -*- coding: utf-8 -*-
#

import sys
from codegen.load_json import load_json
from codegen.load_graphml import load_graphml
from utils.system import get_piped_input


def compile_ir(ir, module_name):
    from codegen.parse_ir import parse_ir
    from codegen.cpp.ir_to_cpp import ir_to_cpp

    functions, definitions = parse_ir(load_json(ir))
    return str(ir_to_cpp(module_name, functions, definitions))


def compile_to_llvm(ir, module_name):
    from llvm_codegen_drafts.parse_ir import parse_ir
    from llvm_codegen_drafts.llvm.ir_to_llvm import ir_to_llvm

    functions, definitions = parse_ir(load_json(ir))
    return str(ir_to_llvm(module_name, functions, definitions))


def compile_to_llvm_bitcode(ir, target_triple=None):
    import llvmlite.binding as llvm

    module = llvm.parse_assembly(ir)
    llvm.initialize_all_targets()
    llvm.initialize_all_asmprinters()
    llvm.initialize_native_target()
    llvm.initialize_native_asmprinter()
    if not target_triple:
        target = llvm.Target.from_default_triple()
    else:
        pass
    target_machine = target.create_target_machine()
    engine = llvm.create_mcjit_compiler(module, target_machine)
    engine.finalize_object()
    engine.run_static_constructors()
    return module.as_bitcode()


def main(args):
    """The main function"""
    # check if there is piped-in input_text
    # otherwise load it from specified file
    if "-i" in args:
        file_name = args[args.index("-i") + 1]
        module_name = file_name.split(".")[:-1]
        with open(file_name, "r", encoding="UTF-8") as src_file:
            input_text = src_file.read()
            if file_name.lower().endswith(".json"):
                ir_ = load_json(input_text)
            elif file_name.lower().endswith(".gml"):
                ir_ = load_graphml(input_text)
            else:
                raise Exception("Wrong format")
    else:
        input_text = get_piped_input()
        ir_ = load_json(input_text)
        module_name = "piped_input"
    # from codegen.parse_ir import parse_ir

    # functions = parse_ir(ir_)
    # TODO parse definitions also
    # from codegen.cpp.ir_to_cpp import ir_to_cpp

    print(compile_ir(ir_, module_name))

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
