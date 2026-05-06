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

define {i1, i64} @"sisal_main"({i1, i64} %".1")
{
entry:
  br label %"Loop_1_entry"
Loop_1_entry:
  %".4" = insertvalue {i1, i64} zeroinitializer, i64 1, 1
  %".5" = insertvalue {i1, i64} %".4", i1 0, 0
  %".6" = extractvalue {i1, i64} %".5", 0
  %".7" = extractvalue {i1, i64} %".1", 0
  %".23" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".24" = insertvalue {i1, i64} %".23", i64 1, 1
  br label %"Loop_1_header_start"
Loop_1_header_start:
  %".21" = phi  {i1, i64} [%".24", %"Loop_1_entry"], [%".22", %"Loop_1_latch"]
  %"i" = phi  {i1, i64} [%".5", %"Loop_1_entry"], [%".16", %"Loop_1_latch"]
  %"i_index" = phi  {i1, i64} [%".5", %"Loop_1_entry"], [%".16", %"Loop_1_latch"]
  %".11" = or i1 %".6", %".7"
  br i1 %".11", label %"Scatter_err_block", label %"Scatter_correct_exec_block"
Loop_1_header_end:
  %".8" = phi  i1 [1, %"Scatter_err_block"], [%".19", %"Scatter_correct_exec_block"]
  br i1 %".8", label %"Loop_1_body_start", label %"Loop_1_follower"
Loop_1_body_start:
Loop_1_body_end:
  %".25" = insertvalue {i1, i1} zeroinitializer, i1 true, 1
  %".26" = insertvalue {i1, i1} %".25", i1 0, 0
  %".27" = extractvalue {i1, i64} %".21", 0
  %".28" = extractvalue {i1, i1} %".26", 0
  %".29" = extractvalue {i1, i64} %"i", 0
  %".30" = or i1 %".27", %".28"
  %".31" = or i1 %".30", %".29"
  br i1 %".31", label %"Loop_1_reduction_1_error", label %"Loop_1_reduction_1_cond_block"
Loop_1_latch:
  %".13" = extractvalue {i1, i64} %"i", 1
  %".14" = add i64 %".13", 1
  %".15" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".16" = insertvalue {i1, i64} %".15", i64 %".14", 1
  br label %"Loop_1_header_start"
Loop_1_follower:
  ret {i1, i64} %".21"
Scatter_err_block:
  br label %"Loop_1_header_end"
Scatter_correct_exec_block:
  %".17" = extractvalue {i1, i64} %"i", 1
  %".18" = extractvalue {i1, i64} %".1", 1
  %".19" = icmp sle i64 %".17", %".18"
  br label %"Loop_1_header_end"
Loop_1_reduction_0_init:
  %".22" = phi  {i1, i64} [%".35", %"Loop_1_reduction_1_error"], [%".41", %"Loop_1_reduction_1_cond_true"], [%".21", %"Loop_1_reduction_1_cond_false"]
  br label %"Loop_1_latch"
Loop_1_reduction_1_cond_true:
  %".37" = extractvalue {i1, i64} %".21", 1
  %".38" = extractvalue {i1, i64} %"i", 1
  %".39" = mul i64 %".37", %".38"
  %".40" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".41" = insertvalue {i1, i64} %".40", i64 %".39", 1
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_cond_false:
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_error:
  %".35" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_cond_block:
  %".33" = extractvalue {i1, i1} %".26", 1
  br i1 %".33", label %"Loop_1_reduction_1_cond_true", label %"Loop_1_reduction_1_cond_false"
}

define i32 @"main"(i64 %".1")
{
.3:
  %".4" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".5" = insertvalue {i1, i64} %".4", i64 %".1", 1
  %".6" = call {i1, i64} @"sisal_main"({i1, i64} %".5")
  %".7" = extractvalue {i1, i64} %".6", 0
  br i1 %".7", label %"val_errored", label %"val_not_errored"
val_errored:
  %".9" = alloca [15 x i8]
  store [15 x i8] c"Lambda0: ERROR\00", ptr %".9"
  %".11" = call i32 (ptr, ...) @"printf"(ptr %".9")
  br label %"end_printf"
val_not_errored:
  %".13" = extractvalue {i1, i64} %".6", 1
  %".14" = alloca [13 x i8]
  store [13 x i8] c"Lambda0: %ld\00", ptr %".14"
  %".16" = call i32 (ptr, ...) @"printf"(ptr %".14", i64 %".13")
  br label %"end_printf"
end_printf:
  ret i32 0
}

