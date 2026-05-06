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

define {{i1, double}, {i1, i64}} @"sisal_main"({i1, i64} %".1", {i1, i64} %".2", {i1, double} %".3")
{
entry:
  %".5" = insertvalue {i1, i64} zeroinitializer, i64 0, 1
  %".6" = insertvalue {i1, i64} %".5", i1 0, 0
  %".7" = extractvalue {i1, i64} %".1", 0
  %".8" = extractvalue {i1, i64} %".1", 1
  %".9" = extractvalue {i1, i64} %".6", 0
  %".10" = extractvalue {i1, i64} %".6", 1
  %".12" = or i1 %".7", %".9"
  br i1 %".12", label %"Binary_err_block", label %"Binary_correct_exec_block"
If1error_in_a_condition:
  %".22" = insertvalue {i1, double} zeroinitializer, i1 1, 0
  %".23" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"If1follower"
Binary_err_block:
  br label %"Binary_phi_block"
Binary_correct_exec_block:
  %"binary output (>)" = icmp sgt i64 %".8", %".10"
  br label %"Binary_phi_block"
Binary_phi_block:
  %".15" = phi  i1 [undef, %"Binary_err_block"], [%"binary output (>)", %"Binary_correct_exec_block"]
  %".16" = insertvalue {i1, i1} zeroinitializer, i1 %".12", 0
  %".17" = insertvalue {i1, i1} %".16", i1 %".15", 1
  %".18" = extractvalue {i1, i1} %".17", 0
  %".19" = extractvalue {i1, i1} %".17", 1
  br i1 %".18", label %"If1error_in_a_condition", label %"If1noeror_cond0"
If1true0:
  %".24" = extractvalue {i1, double} %".3", 0
  %".25" = extractvalue {i1, double} %".3", 1
  br i1 %".24", label %"Unary_err_block", label %"Unary_correct_exec_block"
If1false0:
  %".46" = insertvalue {i1, i64} zeroinitializer, i64 2, 1
  %".47" = insertvalue {i1, i64} %".46", i1 0, 0
  %".48" = extractvalue {i1, i64} %".47", 0
  %".49" = extractvalue {i1, i64} %".47", 1
  %".50" = extractvalue {i1, double} %".3", 0
  %".51" = extractvalue {i1, double} %".3", 1
  %".53" = or i1 %".48", %".50"
  br i1 %".53", label %"Binary_err_block.2", label %"Binary_correct_exec_block.2"
If1noeror_cond0:
  br i1 %".19", label %"If1true0", label %"If1false0"
If1follower:
  %"function_result1" = phi  {i1, i64} [%".23", %"If1error_in_a_condition"], [%".43", %"If1true0_end"], [%".70", %"If1false0_end"]
  %"function_result0" = phi  {i1, double} [%".22", %"If1error_in_a_condition"], [%".32", %"If1true0_end"], [%".59", %"If1false0_end"]
  %".74" = insertvalue {{i1, double}, {i1, i64}} zeroinitializer, {i1, double} %"function_result0", 0
  %".75" = insertvalue {{i1, double}, {i1, i64}} %".74", {i1, i64} %"function_result1", 1
  ret {{i1, double}, {i1, i64}} %".75"
If1true0_end:
  br label %"If1follower"
Unary_err_block:
  br label %"Unary_phi_block"
Unary_correct_exec_block:
  %".28" = fneg double %".25"
  br label %"Unary_phi_block"
Unary_phi_block:
  %".30" = phi  double [undef, %"Unary_err_block"], [%".28", %"Unary_correct_exec_block"]
  %".31" = insertvalue {i1, double} zeroinitializer, i1 %".24", 0
  %".32" = insertvalue {i1, double} %".31", double %".30", 1
  %".33" = extractvalue {i1, i64} %".1", 0
  %".34" = extractvalue {i1, i64} %".1", 1
  %".35" = extractvalue {i1, i64} %".2", 0
  %".36" = extractvalue {i1, i64} %".2", 1
  %".38" = or i1 %".33", %".35"
  br i1 %".38", label %"Binary_err_block.1", label %"Binary_correct_exec_block.1"
Binary_err_block.1:
  br label %"Binary_phi_block.1"
Binary_correct_exec_block.1:
  %"binary output (+)" = add i64 %".34", %".36"
  br label %"Binary_phi_block.1"
Binary_phi_block.1:
  %".41" = phi  i64 [undef, %"Binary_err_block.1"], [%"binary output (+)", %"Binary_correct_exec_block.1"]
  %".42" = insertvalue {i1, i64} zeroinitializer, i1 %".38", 0
  %".43" = insertvalue {i1, i64} %".42", i64 %".41", 1
  br label %"If1true0_end"
If1false0_end:
  br label %"If1follower"
Binary_err_block.2:
  br label %"Binary_phi_block.2"
Binary_correct_exec_block.2:
  %".55" = sitofp i64 %".49" to double
  %"binary output (*)" = fmul double %".55", %".51"
  br label %"Binary_phi_block.2"
Binary_phi_block.2:
  %".57" = phi  double [undef, %"Binary_err_block.2"], [%"binary output (*)", %"Binary_correct_exec_block.2"]
  %".58" = insertvalue {i1, double} zeroinitializer, i1 %".53", 0
  %".59" = insertvalue {i1, double} %".58", double %".57", 1
  %".60" = extractvalue {i1, i64} %".1", 0
  %".61" = extractvalue {i1, i64} %".1", 1
  %".62" = extractvalue {i1, i64} %".2", 0
  %".63" = extractvalue {i1, i64} %".2", 1
  %".65" = or i1 %".60", %".62"
  br i1 %".65", label %"Binary_err_block.3", label %"Binary_correct_exec_block.3"
Binary_err_block.3:
  br label %"Binary_phi_block.3"
Binary_correct_exec_block.3:
  %"binary output (-)" = sub i64 %".61", %".63"
  br label %"Binary_phi_block.3"
Binary_phi_block.3:
  %".68" = phi  i64 [undef, %"Binary_err_block.3"], [%"binary output (-)", %"Binary_correct_exec_block.3"]
  %".69" = insertvalue {i1, i64} zeroinitializer, i1 %".65", 0
  %".70" = insertvalue {i1, i64} %".69", i64 %".68", 1
  br label %"If1false0_end"
}

define i32 @"main"(i64 %".1", i64 %".2", double %".3")
{
.5:
  %".6" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".7" = insertvalue {i1, i64} %".6", i64 %".1", 1
  %".8" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".9" = insertvalue {i1, i64} %".8", i64 %".2", 1
  %".10" = insertvalue {i1, double} zeroinitializer, i1 0, 0
  %".11" = insertvalue {i1, double} %".10", double %".3", 1
  %".12" = call {{i1, double}, {i1, i64}} @"sisal_main"({i1, i64} %".7", {i1, i64} %".9", {i1, double} %".11")
  %".13" = alloca [3 x i8]
  store [3 x i8] c"{\0a\00", ptr %".13"
  %".15" = call i32 (ptr, ...) @"printf"(ptr %".13")
  %".16" = extractvalue {{i1, double}, {i1, i64}} %".12", 0
  %".17" = extractvalue {i1, double} %".16", 0
  br i1 %".17", label %"val_errored", label %"val_not_errored"
val_errored:
  %".19" = alloca [15 x i8]
  store [15 x i8] c"Lambda0: ERROR\00", ptr %".19"
  %".21" = call i32 (ptr, ...) @"printf"(ptr %".19")
  br label %"end_printf"
val_not_errored:
  %".23" = extractvalue {i1, double} %".16", 1
  %".24" = alloca [12 x i8]
  store [12 x i8] c"Lambda0: %f\00", ptr %".24"
  %".26" = call i32 (ptr, ...) @"printf"(ptr %".24", double %".23")
  br label %"end_printf"
end_printf:
  %".28" = extractvalue {{i1, double}, {i1, i64}} %".12", 1
  %".29" = alloca [3 x i8]
  store [3 x i8] c",\0a\00", ptr %".29"
  %".31" = call i32 (ptr, ...) @"printf"(ptr %".29")
  %".32" = extractvalue {i1, i64} %".28", 0
  br i1 %".32", label %"val_errored.1", label %"val_not_errored.1"
val_errored.1:
  %".34" = alloca [15 x i8]
  store [15 x i8] c"Lambda1: ERROR\00", ptr %".34"
  %".36" = call i32 (ptr, ...) @"printf"(ptr %".34")
  br label %"end_printf.1"
val_not_errored.1:
  %".38" = extractvalue {i1, i64} %".28", 1
  %".39" = alloca [13 x i8]
  store [13 x i8] c"Lambda1: %ld\00", ptr %".39"
  %".41" = call i32 (ptr, ...) @"printf"(ptr %".39", i64 %".38")
  br label %"end_printf.1"
end_printf.1:
  %".43" = alloca [3 x i8]
  store [3 x i8] c"\0a}\00", ptr %".43"
  %".45" = call i32 (ptr, ...) @"printf"(ptr %".43")
  ret i32 0
}

