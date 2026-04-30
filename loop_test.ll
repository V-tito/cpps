; ModuleID = ""
target triple = "unknown-unknown-unknown"
target datalayout = ""

declare i32 @"printf"(ptr %".1", ...)

declare ptr @"malloc"(i64 %".1")

define {ptr, i32} @"sisal_main"()
{
entry:
  br label %"Loop_1_entry"
Loop_1_entry:
  br label %"Loop_1_header"
Loop_1_header:
  %"i" = phi  i64 [1, %"Loop_1_entry"], [%".3", %"Loop_1_latch"]
  %"i.1" = phi  i64 [1, %"Loop_1_entry"], [%".3", %"Loop_1_latch"]
  %".4" = icmp sle i64 %"i", 10
  %".7" = sub i64 10, 1
  %".8" = trunc i64 %".7" to i32
  %".9" = add i32 %".8", 1
  %".10" = alloca i64
  %".11" = ptrtoint ptr %".10" to i64
  %".12" = getelementptr i64, ptr %".10", i32 %".9" = add i32 %".8", 1
  %".13" = ptrtoint ptr %".12" to i64
  %".14" = sub i64 %".13", %".11"
  %".15" = call ptr @"malloc"(i64 %".14")
  %".16" = insertvalue {ptr, i32} zeroinitializer, ptr %".15", 0
  %"reduction_array" = insertvalue {ptr, i32} %".16", i32 0, 1
  br i1 %".4", label %"Loop_1_body_start", label %"Loop_1_follower"
Loop_1_body_start:
  %"s" = add i64 0, 1
  br label %"Loop_1_body_end"
Loop_1_body_end:
  br i1 true, label %"Loop_1_reduction_1_cond_true", label %"Loop_1_reduction_1_cond_false"
Loop_1_latch:
  %".3" = add i64 %"i", 1
  br label %"Loop_1_header"
Loop_1_follower:
  ret {ptr, i32} %"reduction_array"
Loop_1_reduction_0_init:
  br label %"Loop_1_latch"
Loop_1_reduction_1_cond_true:
  %".18" = extractvalue {ptr, i32} %"reduction_array", 1
  %".19" = add i32 %".18", 1
  %".20" = getelementptr i64, ptr %".15", i32 %".19"
  %".21" = ptrtoint ptr %".20" to i64
  %".22" = inttoptr i64 %".21" to ptr
  store i64 %"s", ptr %".22"
  %".24" = insertvalue {ptr, i32} %"reduction_array", i32 %".19", 1
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_cond_false:
  br label %"Loop_1_reduction_0_init"
}

define i32 @"main"()
{
.2:
  %".3" = call {ptr, i32} @"sisal_main"()
  %".4" = alloca [13 x i8]
  store [13 x i8] c"Function0: [\00", ptr %".4"
  %".6" = call i32 (ptr, ...) @"printf"(ptr %".4")
  %".7" = extractvalue {ptr, i32} %".3", 0
  %".8" = extractvalue {ptr, i32} %".3", 1
  call void @"array_print_loop_0"(ptr %".7", i32 %".8")
  %".10" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".10"
  %".12" = call i32 (ptr, ...) @"printf"(ptr %".10")
  ret i32 0
}

define void @"array_print_loop_0"(ptr %".1", i32 %".2")
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
