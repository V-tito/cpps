; ModuleID = ""
target triple = "x86_64-linux-gnu"
target datalayout = ""

declare i32 @"printf"(ptr %".1", ...)

declare ptr @"malloc"(i64 %".1")

define {ptr, i32} @"sisal_main"({ptr, i32} %".1", {ptr, i32} %".2", i64 %".3", i64 %".4", i64 %".5")
{
entry:
  br label %"Loop_1_entry"
Loop_1_entry:
  br label %"Loop_1_header"
Loop_1_header:
  %"i" = phi  i64 [1, %"Loop_1_entry"], [%".8", %"Loop_1_latch"]
  %"i.1" = phi  i64 [1, %"Loop_1_entry"], [%".8", %"Loop_1_latch"]
  %".9" = icmp sle i64 %"i", %".3"
  %".73" = sub i64 %".3", 1
  %".74" = trunc i64 %".73" to i32
  %".75" = add i32 %".74", 1
  %".76" = alloca {ptr, i32}, i32 %".75"
  %".77" = insertvalue {ptr, i32} zeroinitializer, ptr %".76", 0
  %"reduction_array.1" = insertvalue {ptr, i32} %".77", i32 0, 1
  br i1 %".9", label %"Loop_1_body_start", label %"Loop_1_follower"
Loop_1_body_start:
  br label %"Loop_2_entry"
Loop_1_body_end:
  br i1 true, label %"Loop_1_reduction_1_cond_true", label %"Loop_1_reduction_1_cond_false"
Loop_1_latch:
  %".8" = add i64 %"i", 1
  br label %"Loop_1_header"
Loop_1_follower:
  ret {ptr, i32} %"reduction_array.1"
Loop_2_entry:
  br label %"Loop_2_header"
Loop_2_header:
  %"j" = phi  i64 [1, %"Loop_2_entry"], [%".12", %"Loop_2_latch"]
  %"j.1" = phi  i64 [1, %"Loop_2_entry"], [%".12", %"Loop_2_latch"]
  %".13" = icmp sle i64 %"j", %".4"
  %".54" = sub i64 %".4", 1
  %".55" = trunc i64 %".54" to i32
  %".56" = add i32 %".55", 1
  %".57" = alloca i64, i32 %".56"
  %".58" = insertvalue {ptr, i32} zeroinitializer, ptr %".57", 0
  %"reduction_array" = insertvalue {ptr, i32} %".58", i32 0, 1
  br i1 %".13", label %"Loop_2_body_start", label %"Loop_2_follower"
Loop_2_body_start:
  br label %"Loop_3_entry"
Loop_2_body_end:
  br i1 true, label %"Loop_2_reduction_1_cond_true", label %"Loop_2_reduction_1_cond_false"
Loop_2_latch:
  %".12" = add i64 %"j", 1
  br label %"Loop_2_header"
Loop_2_follower:
  br label %"Loop_1_body_end"
Loop_3_entry:
  br label %"Loop_3_header"
Loop_3_header:
  %".44" = phi  i64 [0, %"Loop_3_entry"], [%".45", %"Loop_3_latch"]
  %"k" = phi  i64 [1, %"Loop_3_entry"], [%".16", %"Loop_3_latch"]
  %"k.1" = phi  i64 [1, %"Loop_3_entry"], [%".16", %"Loop_3_latch"]
  %".17" = icmp sle i64 %"k", %".5"
  br i1 %".17", label %"Loop_3_body_start", label %"Loop_3_follower"
Loop_3_body_start:
  %".19" = extractvalue {ptr, i32} %".1", 0
  %".20" = extractvalue {ptr, i32} %".1", 1
  %".21" = trunc i64 %"i" to i32
  %".22" = sub i32 %".21", 1
  %".23" = getelementptr {ptr, i32}, ptr %".19", i32 %".22"
  %".24" = load {ptr, i32}, ptr %".23"
  %".25" = extractvalue {ptr, i32} %".24", 0
  %".26" = extractvalue {ptr, i32} %".24", 1
  %".27" = trunc i64 %"k" to i32
  %".28" = sub i32 %".27", 1
  %".29" = getelementptr i64, ptr %".25", i32 %".28"
  %".30" = load i64, ptr %".29"
  %".31" = extractvalue {ptr, i32} %".2", 0
  %".32" = extractvalue {ptr, i32} %".2", 1
  %".33" = trunc i64 %"k" to i32
  %".34" = sub i32 %".33", 1
  %".35" = getelementptr {ptr, i32}, ptr %".31", i32 %".34"
  %".36" = load {ptr, i32}, ptr %".35"
  %".37" = extractvalue {ptr, i32} %".36", 0
  %".38" = extractvalue {ptr, i32} %".36", 1
  %".39" = trunc i64 %"j" to i32
  %".40" = sub i32 %".39", 1
  %".41" = getelementptr i64, ptr %".37", i32 %".40"
  %".42" = load i64, ptr %".41"
  %"Sij" = mul i64 %".30", %".42"
  br label %"Loop_3_body_end"
Loop_3_body_end:
  br i1 true, label %"Loop_3_reduction_1_cond_true", label %"Loop_3_reduction_1_cond_false"
Loop_3_latch:
  %".16" = add i64 %"k", 1
  br label %"Loop_3_header"
Loop_3_follower:
  br label %"Loop_2_body_end"
Loop_3_reduction_0_init:
  %".45" = phi  i64 [%".47", %"Loop_3_reduction_1_cond_true"], [%".44", %"Loop_3_reduction_1_cond_false"]
  br label %"Loop_3_latch"
Loop_3_reduction_1_cond_true:
  %".47" = add i64 %"Sij", %".44"
  br label %"Loop_3_reduction_0_init"
Loop_3_reduction_1_cond_false:
  br label %"Loop_3_reduction_0_init"
Loop_2_reduction_0_init:
  br label %"Loop_2_latch"
Loop_2_reduction_1_cond_true:
  %".60" = extractvalue {ptr, i32} %"reduction_array", 1
  %".61" = add i32 %".60", 1
  %".62" = getelementptr i64, ptr %".57", i32 %".61"
  %".63" = ptrtoint ptr %".62" to i64
  %".64" = inttoptr i64 %".63" to ptr
  store i64 %".44", ptr %".64"
  %".66" = insertvalue {ptr, i32} %"reduction_array", i32 %".61", 1
  br label %"Loop_2_reduction_0_init"
Loop_2_reduction_1_cond_false:
  br label %"Loop_2_reduction_0_init"
Loop_1_reduction_0_init:
  br label %"Loop_1_latch"
Loop_1_reduction_1_cond_true:
  %".79" = extractvalue {ptr, i32} %"reduction_array.1", 1
  %".80" = add i32 %".79", 1
  %".81" = getelementptr {ptr, i32}, ptr %".76", i32 %".80"
  %".82" = ptrtoint ptr %".81" to i64
  %".83" = inttoptr i64 %".82" to ptr
  store {ptr, i32} %"reduction_array", ptr %".83"
  %".85" = insertvalue {ptr, i32} %"reduction_array.1", i32 %".80", 1
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_cond_false:
  br label %"Loop_1_reduction_0_init"
}

define i32 @"main"({ptr, i32} %".1", {ptr, i32} %".2", i64 %".3", i64 %".4", i64 %".5")
{
.7:
  %".8" = call {ptr, i32} @"sisal_main"({ptr, i32} %".1", {ptr, i32} %".2", i64 %".3", i64 %".4", i64 %".5")
  %".9" = alloca [13 x i8]
  store [13 x i8] c"Function0: [\00", ptr %".9"
  %".11" = call i32 (ptr, ...) @"printf"(ptr %".9")
  %".12" = extractvalue {ptr, i32} %".8", 0
  %".13" = extractvalue {ptr, i32} %".8", 1
  call void @"array_print_loop_0"(ptr %".12", i32 %".13")
  %".15" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".15"
  %".17" = call i32 (ptr, ...) @"printf"(ptr %".15")
  ret i32 0
}

define void @"array_print_loop_0"(ptr %".1", i32 %".2")
{
entry:
  %".4" = alloca [3 x i8]
  store [3 x i8] c", \00", ptr %".4"
  br label %"array_loop_header"
array_loop_header:
  %".7" = phi  i32 [0, %"entry"], [%".26", %"array_print_loop"]
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
  %".15" = getelementptr {ptr, i32}, ptr %".1", i32 %".7"
  %".16" = load {ptr, i32}, ptr %".15"
  %".17" = alloca [2 x i8]
  store [2 x i8] c"[\00", ptr %".17"
  %".19" = call i32 (ptr, ...) @"printf"(ptr %".17")
  %".20" = extractvalue {ptr, i32} %".16", 0
  %".21" = extractvalue {ptr, i32} %".16", 1
  call void @"array_print_loop_1"(ptr %".20", i32 %".21")
  %".23" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".23"
  %".25" = call i32 (ptr, ...) @"printf"(ptr %".23")
  %".26" = add i32 %".7", 1
  br label %"array_loop_header"
array_loop_follower:
  ret void
}

define void @"array_print_loop_1"(ptr %".1", i32 %".2")
{
entry:
  %".4" = alloca [3 x i8]
  store [3 x i8] c", \00", ptr %".4"
  br label %"array_loop_header"
array_loop_header:
  %".7" = phi  i32 [0, %"entry"], [%".20", %"array_print_loop"]
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
  %".15" = getelementptr i64, ptr %".1", i32 %".7"
  %".16" = load i64, ptr %".15"
  %".17" = alloca [4 x i8]
  store [4 x i8] c"%ld\00", ptr %".17"
  %".19" = call i32 (ptr, ...) @"printf"(ptr %".17", i64 %".16")
  %".20" = add i32 %".7", 1
  br label %"array_loop_header"
array_loop_follower:
  ret void
}
