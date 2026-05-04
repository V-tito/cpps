import llvmlite.ir as ll

i1 = ll.IntType(1)
i32 = ll.IntType(32)
i64 = ll.IntType(64)

i32zero = i32(0)
i32one = i32(1)


def printf_str(irbuilder, printf, str_val):
    c_str_val = ll.Constant(
        ll.ArrayType(ll.IntType(8), len(str_val)), bytearray(str_val.encode("utf-8"))
    )
    c_str = irbuilder.alloca(c_str_val.type)
    irbuilder.store(c_str_val, c_str)
    irbuilder.call(printf, [c_str])


memsizes = {}


def calc_memsize_at_runtime(irbuilder: ll.IRBuilder, element_type, count):
    try:
        return memsizes[irbuilder.function][element_type][count]
    except:
        """
        Generate IR that computes the size at runtime using GEP arithmetic.
        This avoids needing the size at IR generation time.
        """
        # Create a dummy allocation of 1 element
        dummy = irbuilder.alloca(element_type)
        if type(count) == int:
            new_count = i32(count)
        else:
            new_count = count
        # Create a GEP at index 'count' and get the byte difference
        # This works because LLVM's GEP uses type sizes internally
        ptr_start = irbuilder.ptrtoint(dummy, i64)
        ptr_end = irbuilder.gep(dummy, [new_count])
        ptr_end_casted = irbuilder.ptrtoint(ptr_end, i64)

        size = irbuilder.sub(ptr_end_casted, ptr_start)
        if not irbuilder.function in memsizes:
            memsizes[irbuilder.function] = {}
        if not element_type in memsizes[irbuilder.function]:
            memsizes[irbuilder.function][element_type] = {}
        memsizes[irbuilder.function][element_type][count] = size
        return size
