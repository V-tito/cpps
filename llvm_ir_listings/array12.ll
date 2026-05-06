; ModuleID = ""
target triple = "unknown-unknown-unknown"
target datalayout = ""

declare i32 @"printf"(ptr %".1", ...)

declare ptr @"malloc"(i64 %".1")

declare ptr @"calloc"(i64 %".1")

declare ptr @"realloc"(ptr %".1", i64 %".2")

declare void @"llvm.memcpy.p0.p0.i64"(ptr %".1", ptr %".2", i64 %".3", i1 %".4")

declare i64 @"sizeof"(ptr %".1", ptr %".2", i64 %".3")

declare i64 @"llvm.powi.i64"(i64 %".1", i64 %".2")

declare double @"llvm.pow.f64"(double %".1", double %".2")

declare void @"free"(ptr %".1")

define {i1, {ptr, i32}} @"sisal_main"({i1, i64} %".1")
{
entry:
  %".3" = alloca {i1, i64}
  %".4" = ptrtoint ptr %".3" to i64
  %".5" = getelementptr {i1, i64}, ptr %".3", i32 3
  %".6" = ptrtoint ptr %".5" to i64
  %".7" = sub i64 %".6", %".4"
  %".8" = call ptr @"malloc"(i64 %".7")
  %".9" = getelementptr {i1, i64}, ptr %".8", i32 0
  %".10" = ptrtoint ptr %".9" to i64
  %".11" = inttoptr i64 %".10" to ptr
  store {i1, i64} %".1", ptr %".11"
  %".13" = getelementptr {i1, i64}, ptr %".8", i32 1
  %".14" = ptrtoint ptr %".13" to i64
  %".15" = inttoptr i64 %".14" to ptr
  store {i1, i64} %".1", ptr %".15"
  %".17" = getelementptr {i1, i64}, ptr %".8", i32 2
  %".18" = ptrtoint ptr %".17" to i64
  %".19" = inttoptr i64 %".18" to ptr
  store {i1, i64} %".1", ptr %".19"
  %".21" = insertvalue {ptr, i32} zeroinitializer, ptr %".8", 0
  %".22" = insertvalue {ptr, i32} %".21", i32 3, 1
  %".23" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".24" = insertvalue {i1, {ptr, i32}} %".23", {ptr, i32} %".22", 1
  %".25" = call ptr @"malloc"(i64 %".7")
  %".26" = getelementptr {i1, i64}, ptr %".25", i32 0
  %".27" = ptrtoint ptr %".26" to i64
  %".28" = inttoptr i64 %".27" to ptr
  store {i1, i64} %".1", ptr %".28"
  %".30" = getelementptr {i1, i64}, ptr %".25", i32 1
  %".31" = ptrtoint ptr %".30" to i64
  %".32" = inttoptr i64 %".31" to ptr
  store {i1, i64} %".1", ptr %".32"
  %".34" = getelementptr {i1, i64}, ptr %".25", i32 2
  %".35" = ptrtoint ptr %".34" to i64
  %".36" = inttoptr i64 %".35" to ptr
  store {i1, i64} %".1", ptr %".36"
  %".38" = insertvalue {ptr, i32} zeroinitializer, ptr %".25", 0
  %".39" = insertvalue {ptr, i32} %".38", i32 3, 1
  %".40" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".41" = insertvalue {i1, {ptr, i32}} %".40", {ptr, i32} %".39", 1
  %".42" = call ptr @"malloc"(i64 %".7")
  %".43" = getelementptr {i1, i64}, ptr %".42", i32 0
  %".44" = ptrtoint ptr %".43" to i64
  %".45" = inttoptr i64 %".44" to ptr
  store {i1, i64} %".1", ptr %".45"
  %".47" = getelementptr {i1, i64}, ptr %".42", i32 1
  %".48" = ptrtoint ptr %".47" to i64
  %".49" = inttoptr i64 %".48" to ptr
  store {i1, i64} %".1", ptr %".49"
  %".51" = getelementptr {i1, i64}, ptr %".42", i32 2
  %".52" = ptrtoint ptr %".51" to i64
  %".53" = inttoptr i64 %".52" to ptr
  store {i1, i64} %".1", ptr %".53"
  %".55" = insertvalue {ptr, i32} zeroinitializer, ptr %".42", 0
  %".56" = insertvalue {ptr, i32} %".55", i32 3, 1
  %".57" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".58" = insertvalue {i1, {ptr, i32}} %".57", {ptr, i32} %".56", 1
  %".59" = alloca {i1, {ptr, i32}}
  %".60" = ptrtoint ptr %".59" to i64
  %".61" = getelementptr {i1, {ptr, i32}}, ptr %".59", i32 3
  %".62" = ptrtoint ptr %".61" to i64
  %".63" = sub i64 %".62", %".60"
  %".64" = call ptr @"malloc"(i64 %".63")
  %".65" = getelementptr {i1, {ptr, i32}}, ptr %".64", i32 0
  %".66" = ptrtoint ptr %".65" to i64
  %".67" = inttoptr i64 %".66" to ptr
  store {i1, {ptr, i32}} %".24", ptr %".67"
  %".69" = getelementptr {i1, {ptr, i32}}, ptr %".64", i32 1
  %".70" = ptrtoint ptr %".69" to i64
  %".71" = inttoptr i64 %".70" to ptr
  store {i1, {ptr, i32}} %".41", ptr %".71"
  %".73" = getelementptr {i1, {ptr, i32}}, ptr %".64", i32 2
  %".74" = ptrtoint ptr %".73" to i64
  %".75" = inttoptr i64 %".74" to ptr
  store {i1, {ptr, i32}} %".58", ptr %".75"
  %".77" = insertvalue {ptr, i32} zeroinitializer, ptr %".64", 0
  %".78" = insertvalue {ptr, i32} %".77", i32 3, 1
  %".79" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".80" = insertvalue {i1, {ptr, i32}} %".79", {ptr, i32} %".78", 1
  %".81" = extractvalue {i1, {ptr, i32}} %".80", 0
  %".82" = insertvalue {i1, i64} zeroinitializer, i64 2, 1
  %".83" = insertvalue {i1, i64} %".82", i1 0, 0
  %".85" = extractvalue {i1, i64} %".83", 0
  %".86" = or i1 %".85", %".81"
  br i1 %".86", label %"ArrayAccess_err_block", label %"array_access_out_of_bounds_check"
ArrayAccess_err_block:
  %".101" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block"
ArrayAccess_correct_exec_block:
  %".97" = extractvalue {ptr, i32} %".89", 0
  %".98" = getelementptr {i1, {ptr, i32}}, ptr %".97", i32 %".92"
  %".99" = load {i1, {ptr, i32}}, ptr %".98"
  br label %"ArrayAccess_phi_block"
ArrayAccess_phi_block:
  %".102" = phi  {i1, {ptr, i32}} [%".101", %"ArrayAccess_err_block"], [%".99", %"ArrayAccess_correct_exec_block"]
  ret {i1, {ptr, i32}} %".102"
array_access_out_of_bounds_check:
  %".88" = extractvalue {i1, i64} %".83", 1
  %".89" = extractvalue {i1, {ptr, i32}} %".80", 1
  %".90" = extractvalue {ptr, i32} %".89", 1
  %".91" = trunc i64 %".88" to i32
  %".92" = sub i32 %".91", 1
  %".93" = icmp slt i32 %".92", 0
  %".94" = icmp slt i32 %".90", %".92"
  %".95" = or i1 %".93", %".94"
  br i1 %".95", label %"ArrayAccess_err_block", label %"ArrayAccess_correct_exec_block"
}

define i32 @"main"(i64 %".1")
{
.3:
  %".4" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".5" = insertvalue {i1, i64} %".4", i64 %".1", 1
  %".6" = call {i1, {ptr, i32}} @"sisal_main"({i1, i64} %".5")
  %".7" = extractvalue {i1, {ptr, i32}} %".6", 0
  br i1 %".7", label %"val_errored", label %"val_not_errored"
val_errored:
  %".9" = alloca [15 x i8]
  store [15 x i8] c"Lambda0: ERROR\00", ptr %".9"
  %".11" = call i32 (ptr, ...) @"printf"(ptr %".9")
  br label %"end_printf"
val_not_errored:
  %".13" = extractvalue {i1, {ptr, i32}} %".6", 1
  %".14" = alloca [11 x i8]
  store [11 x i8] c"Lambda0: [\00", ptr %".14"
  %".16" = call i32 (ptr, ...) @"printf"(ptr %".14")
  %".17" = extractvalue {ptr, i32} %".13", 0
  %".18" = extractvalue {ptr, i32} %".13", 1
  call void @"array_print_loop_0"(ptr %".17", i32 %".18")
  %".20" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".20"
  %".22" = call i32 (ptr, ...) @"printf"(ptr %".20")
  br label %"end_printf"
end_printf:
  ret i32 0
}

define void @"array_print_loop_0"(ptr %".1", i32 %".2")
{
entry:
  %".4" = alloca [3 x i8]
  store [3 x i8] c", \00", ptr %".4"
  br label %"array_loop_header"
array_loop_header:
  %".7" = phi  i32 [0, %"entry"], [%".28", %"end_printf"]
  %".8" = icmp eq i32 %".7", %".2"
  br i1 %".8", label %"array_loop_follower", label %"array_loop_comma"
array_loop_comma:
  %".10" = icmp ne i32 %".7", 0
  br i1 %".10", label %"print_comma", label %"no_comma"
print_comma:
  %".12" = call i32 (ptr, ...) @"printf"(ptr %".4")
  br label %"array_print_loop"
no_comma:
  br label %"array_print_loop"
array_print_loop:
  %".15" = getelementptr {i1, i64}, ptr %".1", i32 %".7"
  %".16" = load {i1, i64}, ptr %".15"
  %".17" = extractvalue {i1, i64} %".16", 0
  br i1 %".17", label %"val_errored", label %"val_not_errored"
array_loop_follower:
  ret void
val_errored:
  %".19" = alloca [6 x i8]
  store [6 x i8] c"ERROR\00", ptr %".19"
  %".21" = call i32 (ptr, ...) @"printf"(ptr %".19")
  br label %"end_printf"
val_not_errored:
  %".23" = extractvalue {i1, i64} %".16", 1
  %".24" = alloca [4 x i8]
  store [4 x i8] c"%ld\00", ptr %".24"
  %".26" = call i32 (ptr, ...) @"printf"(ptr %".24", i64 %".23")
  br label %"end_printf"
end_printf:
  %".28" = add i32 %".7", 1
  br label %"array_loop_header"
}

