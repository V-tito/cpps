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

define {i1, i64} @"Fib"({i1, i64} %".1")
{
entry:
  %".3" = insertvalue {i1, i64} zeroinitializer, i64 2, 1
  %".4" = insertvalue {i1, i64} %".3", i1 0, 0
  %".5" = extractvalue {i1, i64} %".1", 0
  %".6" = extractvalue {i1, i64} %".1", 1
  %".7" = extractvalue {i1, i64} %".4", 0
  %".8" = extractvalue {i1, i64} %".4", 1
  %".10" = or i1 %".5", %".7"
  br i1 %".10", label %"Binary_err_block", label %"Binary_correct_exec_block"
If1error_in_a_condition:
  %".20" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"If1follower"
Binary_err_block:
  br label %"Binary_phi_block"
Binary_correct_exec_block:
  %"binary output (<)" = icmp slt i64 %".6", %".8"
  br label %"Binary_phi_block"
Binary_phi_block:
  %".13" = phi  i1 [undef, %"Binary_err_block"], [%"binary output (<)", %"Binary_correct_exec_block"]
  %".14" = insertvalue {i1, i1} zeroinitializer, i1 %".10", 0
  %".15" = insertvalue {i1, i1} %".14", i1 %".13", 1
  %".16" = extractvalue {i1, i1} %".15", 0
  %".17" = extractvalue {i1, i1} %".15", 1
  br i1 %".16", label %"If1error_in_a_condition", label %"If1noeror_cond0"
If1true0:
  br label %"If1true0_end"
If1false0:
  %".23" = insertvalue {i1, i64} zeroinitializer, i64 1, 1
  %".24" = insertvalue {i1, i64} %".23", i1 0, 0
  %".25" = extractvalue {i1, i64} %".1", 0
  %".26" = extractvalue {i1, i64} %".1", 1
  %".27" = extractvalue {i1, i64} %".24", 0
  %".28" = extractvalue {i1, i64} %".24", 1
  %".30" = or i1 %".25", %".27"
  br i1 %".30", label %"Binary_err_block.1", label %"Binary_correct_exec_block.1"
If1noeror_cond0:
  br i1 %".17", label %"If1true0", label %"If1false0"
If1follower:
  %"function_result" = phi  {i1, i64} [%".20", %"If1error_in_a_condition"], [%".1", %"If1true0_end"], [%".59", %"If1false0_end"]
  ret {i1, i64} %"function_result"
If1true0_end:
  br label %"If1follower"
If1false0_end:
  br label %"If1follower"
Binary_err_block.1:
  br label %"Binary_phi_block.1"
Binary_correct_exec_block.1:
  %"binary output (-)" = sub i64 %".26", %".28"
  br label %"Binary_phi_block.1"
Binary_phi_block.1:
  %".33" = phi  i64 [undef, %"Binary_err_block.1"], [%"binary output (-)", %"Binary_correct_exec_block.1"]
  %".34" = insertvalue {i1, i64} zeroinitializer, i1 %".30", 0
  %".35" = insertvalue {i1, i64} %".34", i64 %".33", 1
  %"call" = call {i1, i64} @"Fib"({i1, i64} %".35")
  %".36" = insertvalue {i1, i64} zeroinitializer, i64 2, 1
  %".37" = insertvalue {i1, i64} %".36", i1 0, 0
  %".38" = extractvalue {i1, i64} %".1", 0
  %".39" = extractvalue {i1, i64} %".1", 1
  %".40" = extractvalue {i1, i64} %".37", 0
  %".41" = extractvalue {i1, i64} %".37", 1
  %".43" = or i1 %".38", %".40"
  br i1 %".43", label %"Binary_err_block.2", label %"Binary_correct_exec_block.2"
Binary_err_block.2:
  br label %"Binary_phi_block.2"
Binary_correct_exec_block.2:
  %"binary output (-).1" = sub i64 %".39", %".41"
  br label %"Binary_phi_block.2"
Binary_phi_block.2:
  %".46" = phi  i64 [undef, %"Binary_err_block.2"], [%"binary output (-).1", %"Binary_correct_exec_block.2"]
  %".47" = insertvalue {i1, i64} zeroinitializer, i1 %".43", 0
  %".48" = insertvalue {i1, i64} %".47", i64 %".46", 1
  %"call.1" = call {i1, i64} @"Fib"({i1, i64} %".48")
  %".49" = extractvalue {i1, i64} %"call", 0
  %".50" = extractvalue {i1, i64} %"call", 1
  %".51" = extractvalue {i1, i64} %"call.1", 0
  %".52" = extractvalue {i1, i64} %"call.1", 1
  %".54" = or i1 %".49", %".51"
  br i1 %".54", label %"Binary_err_block.3", label %"Binary_correct_exec_block.3"
Binary_err_block.3:
  br label %"Binary_phi_block.3"
Binary_correct_exec_block.3:
  %"binary output (+)" = add i64 %".50", %".52"
  br label %"Binary_phi_block.3"
Binary_phi_block.3:
  %".57" = phi  i64 [undef, %"Binary_err_block.3"], [%"binary output (+)", %"Binary_correct_exec_block.3"]
  %".58" = insertvalue {i1, i64} zeroinitializer, i1 %".54", 0
  %".59" = insertvalue {i1, i64} %".58", i64 %".57", 1
  br label %"If1false0_end"
}

define {i1, i64} @"sisal_main"({i1, i64} %".1")
{
entry:
  %"call" = call {i1, i64} @"Fib"({i1, i64} %".1")
  ret {i1, i64} %"call"
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

