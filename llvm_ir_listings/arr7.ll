; ModuleID = ""
target triple = "x86_64-linux-gnu"
target datalayout = ""

declare i32 @"printf"(ptr %".1", ...)

declare ptr @"malloc"(i64 %".1")

define ptr @"sisal_main"()
{
entry:
  %".2" = alloca [3 x i64]
  %".3" = ptrtoint ptr %".2" to i64
  %".4" = getelementptr [3 x i64], ptr %".2", i32 1
  %".5" = ptrtoint ptr %".4" to i64
  %".6" = sub i64 %".5", %".3"
  %".7" = call ptr @"malloc"(i64 %".6")
  %".8" = getelementptr i64, ptr %".7", i32 0
  %".9" = ptrtoint ptr %".8" to i64
  %".10" = inttoptr i64 %".9" to ptr
  store i64 1, ptr %".10"
  %".12" = getelementptr i64, ptr %".7", i32 1
  %".13" = ptrtoint ptr %".12" to i64
  %".14" = inttoptr i64 %".13" to ptr
  store i64 2, ptr %".14"
  %".16" = getelementptr i64, ptr %".7", i32 2
  %".17" = ptrtoint ptr %".16" to i64
  %".18" = inttoptr i64 %".17" to ptr
  store i64 3, ptr %".18"
  %".20" = alloca {ptr, i32}
  %".21" = ptrtoint ptr %".20" to i64
  %".22" = getelementptr {ptr, i32}, ptr %".20", i32 1
  %".23" = ptrtoint ptr %".22" to i64
  %".24" = sub i64 %".23", %".21"
  %".25" = call ptr @"malloc"(i64 %".24")
  %".26" = getelementptr {ptr, i32}, ptr %".25", i32 0, i32 0
  store ptr %".7", ptr %".26"
  %".28" = getelementptr {ptr, i32}, ptr %".25", i32 0, i32 1
  store i32 3, ptr %".28"
  %".30" = alloca [3 x i64]
  %".31" = ptrtoint ptr %".30" to i64
  %".32" = getelementptr [3 x i64], ptr %".30", i32 1
  %".33" = ptrtoint ptr %".32" to i64
  %".34" = sub i64 %".33", %".31"
  %".35" = call ptr @"malloc"(i64 %".34")
  %".36" = getelementptr i64, ptr %".35", i32 0
  %".37" = ptrtoint ptr %".36" to i64
  %".38" = inttoptr i64 %".37" to ptr
  store i64 4, ptr %".38"
  %".40" = getelementptr i64, ptr %".35", i32 1
  %".41" = ptrtoint ptr %".40" to i64
  %".42" = inttoptr i64 %".41" to ptr
  store i64 5, ptr %".42"
  %".44" = getelementptr i64, ptr %".35", i32 2
  %".45" = ptrtoint ptr %".44" to i64
  %".46" = inttoptr i64 %".45" to ptr
  store i64 6, ptr %".46"
  %".48" = alloca {ptr, i32}
  %".49" = ptrtoint ptr %".48" to i64
  %".50" = getelementptr {ptr, i32}, ptr %".48", i32 1
  %".51" = ptrtoint ptr %".50" to i64
  %".52" = sub i64 %".51", %".49"
  %".53" = call ptr @"malloc"(i64 %".52")
  %".54" = getelementptr {ptr, i32}, ptr %".53", i32 0, i32 0
  store ptr %".35", ptr %".54"
  %".56" = getelementptr {ptr, i32}, ptr %".53", i32 0, i32 1
  store i32 3, ptr %".56"
  %".58" = alloca [3 x i64]
  %".59" = ptrtoint ptr %".58" to i64
  %".60" = getelementptr [3 x i64], ptr %".58", i32 1
  %".61" = ptrtoint ptr %".60" to i64
  %".62" = sub i64 %".61", %".59"
  %".63" = call ptr @"malloc"(i64 %".62")
  %".64" = getelementptr i64, ptr %".63", i32 0
  %".65" = ptrtoint ptr %".64" to i64
  %".66" = inttoptr i64 %".65" to ptr
  store i64 7, ptr %".66"
  %".68" = getelementptr i64, ptr %".63", i32 1
  %".69" = ptrtoint ptr %".68" to i64
  %".70" = inttoptr i64 %".69" to ptr
  store i64 8, ptr %".70"
  %".72" = getelementptr i64, ptr %".63", i32 2
  %".73" = ptrtoint ptr %".72" to i64
  %".74" = inttoptr i64 %".73" to ptr
  store i64 9, ptr %".74"
  %".76" = alloca {ptr, i32}
  %".77" = ptrtoint ptr %".76" to i64
  %".78" = getelementptr {ptr, i32}, ptr %".76", i32 1
  %".79" = ptrtoint ptr %".78" to i64
  %".80" = sub i64 %".79", %".77"
  %".81" = call ptr @"malloc"(i64 %".80")
  %".82" = getelementptr {ptr, i32}, ptr %".81", i32 0, i32 0
  store ptr %".63", ptr %".82"
  %".84" = getelementptr {ptr, i32}, ptr %".81", i32 0, i32 1
  store i32 3, ptr %".84"
  %".86" = alloca [3 x ptr]
  %".87" = ptrtoint ptr %".86" to i64
  %".88" = getelementptr [3 x ptr], ptr %".86", i32 1
  %".89" = ptrtoint ptr %".88" to i64
  %".90" = sub i64 %".89", %".87"
  %".91" = call ptr @"malloc"(i64 %".90")
  %".92" = getelementptr ptr, ptr %".91", i32 0
  %".93" = ptrtoint ptr %".92" to i64
  %".94" = inttoptr i64 %".93" to ptr
  store ptr %".25", ptr %".94"
  %".96" = getelementptr ptr, ptr %".91", i32 1
  %".97" = ptrtoint ptr %".96" to i64
  %".98" = inttoptr i64 %".97" to ptr
  store ptr %".53", ptr %".98"
  %".100" = getelementptr ptr, ptr %".91", i32 2
  %".101" = ptrtoint ptr %".100" to i64
  %".102" = inttoptr i64 %".101" to ptr
  store ptr %".81", ptr %".102"
  %".104" = alloca {ptr, i32}
  %".105" = ptrtoint ptr %".104" to i64
  %".106" = getelementptr {ptr, i32}, ptr %".104", i32 1
  %".107" = ptrtoint ptr %".106" to i64
  %".108" = sub i64 %".107", %".105"
  %".109" = call ptr @"malloc"(i64 %".108")
  %".110" = getelementptr {ptr, i32}, ptr %".109", i32 0, i32 0
  store ptr %".91", ptr %".110"
  %".112" = getelementptr {ptr, i32}, ptr %".109", i32 0, i32 1
  store i32 3, ptr %".112"
  ret ptr %".109"
}

define i32 @"main"()
{
.2:
  %".3" = call ptr @"sisal_main"()
  %".4" = alloca [13 x i8]
  store [13 x i8] c"Function0: [\00", ptr %".4"
  %".6" = call i32 (ptr, ...) @"printf"(ptr %".4")
  %".7" = getelementptr {ptr, i32}, ptr %".3", i32 0, i32 0
  %".8" = load ptr, ptr %".7"
  %".9" = getelementptr {ptr, i32}, ptr %".3", i32 0, i32 1
  %".10" = load i32, ptr %".9"
  call void @"array_print_loop_0"(ptr %".8", i32 %".10")
  %".12" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".12"
  %".14" = call i32 (ptr, ...) @"printf"(ptr %".12")
  ret i32 0
}

define void @"array_print_loop_0"(ptr %".1", i32 %".2")
{
entry:
  %".4" = alloca [3 x i8]
  store [3 x i8] c", \00", ptr %".4"
  br label %"array_loop_header"
array_loop_header:
  %".7" = phi  i32 [0, %"entry"], [%".28", %"array_print_loop"]
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
  %".15" = getelementptr [3 x ptr], ptr %".1", i32 0, i32 %".7"
  %".16" = load ptr, ptr %".15"
  %".17" = alloca [2 x i8]
  store [2 x i8] c"[\00", ptr %".17"
  %".19" = call i32 (ptr, ...) @"printf"(ptr %".17")
  %".20" = getelementptr {ptr, i32}, ptr %".16", i32 0, i32 0
  %".21" = load ptr, ptr %".20"
  %".22" = getelementptr {ptr, i32}, ptr %".16", i32 0, i32 1
  %".23" = load i32, ptr %".22"
  call void @"array_print_loop_1"(ptr %".21", i32 %".23")
  %".25" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".25"
  %".27" = call i32 (ptr, ...) @"printf"(ptr %".25")
  %".28" = add i32 %".7", 1
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
  %".7" = phi  i32 [1, %"entry"], [%".20", %"array_print_loop"]
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
  %".15" = getelementptr [3 x i64], ptr %".1", i32 0, i32 %".7"
  %".16" = load i64, ptr %".15"
  %".17" = alloca [4 x i8]
  store [4 x i8] c"%ld\00", ptr %".17"
  %".19" = call i32 (ptr, ...) @"printf"(ptr %".17", i64 %".16")
  %".20" = add i32 %".7", 1
  br label %"array_loop_header"
array_loop_follower:
  ret void
}
