#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
"""generate llvm"""

from .llvm_codegen import LlModule


def ir_to_llvm(module_name, functions: dict, definitions: dict):
    return LlModule(module_name, functions, definitions)
