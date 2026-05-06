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

define {i1, {ptr, i32}} @"sisal_main"({i1, {ptr, i32}} %".1", {i1, {ptr, i32}} %".2", {i1, i64} %".3", {i1, i64} %".4", {i1, i64} %".5")
{
entry:
  br label %"Loop_1_entry"
Loop_1_entry:
  %".8" = insertvalue {i1, i64} zeroinitializer, i64 1, 1
  %".9" = insertvalue {i1, i64} %".8", i1 0, 0
  %".10" = extractvalue {i1, i64} %".9", 0
  %".11" = extractvalue {i1, i64} %".3", 0
  %".243" = extractvalue {i1, i64} %".3", 1
  %".244" = extractvalue {i1, i64} %".9", 1
  %".245" = sub i64 %".243", %".244"
  %".246" = add i64 %".245", 1
  %".247" = trunc i64 %".246" to i32
  %".248" = alloca {i1, {ptr, i32}}
  %".249" = ptrtoint ptr %".248" to i64
  %".250" = getelementptr {i1, {ptr, i32}}, ptr %".248", i32 %".247"
  %".251" = ptrtoint ptr %".250" to i64
  %".252" = sub i64 %".251", %".249"
  %".253" = call ptr @"malloc"(i64 %".252")
  %".254" = insertvalue {ptr, i32} zeroinitializer, ptr %".253", 0
  %"reduction_array.1" = insertvalue {ptr, i32} %".254", i32 0, 1
  %".255" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".256" = insertvalue {i1, {ptr, i32}} %".255", {ptr, i32} %"reduction_array.1", 1
  br label %"Loop_1_header_start"
Loop_1_header_start:
  %"allocated_size_red_1.1" = phi  i32 [%".247", %"Loop_1_entry"], [%".296", %"Loop_1_latch"]
  %".241" = phi  {i1, {ptr, i32}} [%".256", %"Loop_1_entry"], [%".242", %"Loop_1_latch"]
  %"i" = phi  {i1, i64} [%".9", %"Loop_1_entry"], [%".20", %"Loop_1_latch"]
  %"i_index" = phi  {i1, i64} [%".9", %"Loop_1_entry"], [%".20", %"Loop_1_latch"]
  %".15" = or i1 %".10", %".11"
  br i1 %".15", label %"Scatter_err_block", label %"Scatter_correct_exec_block"
Loop_1_header_end:
  %".12" = phi  i1 [1, %"Scatter_err_block"], [%".23", %"Scatter_correct_exec_block"]
  br i1 %".12", label %"Loop_1_body_start", label %"Loop_1_follower"
Loop_1_body_start:
  br label %"Loop_2_entry"
Loop_1_body_end:
  %".257" = insertvalue {i1, i1} zeroinitializer, i1 true, 1
  %".258" = insertvalue {i1, i1} %".257", i1 0, 0
  %".259" = extractvalue {i1, {ptr, i32}} %".241", 0
  %".260" = extractvalue {i1, i1} %".258", 0
  %".261" = extractvalue {i1, {ptr, i32}} %".180", 0
  %".262" = or i1 %".259", %".260"
  br i1 %".262", label %"Loop_1_reduction_1_error", label %"Loop_1_reduction_1_cond_block"
Loop_1_latch:
  %".17" = extractvalue {i1, i64} %"i", 1
  %".18" = add i64 %".17", 1
  %".19" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".20" = insertvalue {i1, i64} %".19", i64 %".18", 1
  br label %"Loop_1_header_start"
Loop_1_follower:
  ret {i1, {ptr, i32}} %".241"
Scatter_err_block:
  br label %"Loop_1_header_end"
Scatter_correct_exec_block:
  %".21" = extractvalue {i1, i64} %"i", 1
  %".22" = extractvalue {i1, i64} %".3", 1
  %".23" = icmp sle i64 %".21", %".22"
  br label %"Loop_1_header_end"
Loop_2_entry:
  %".26" = insertvalue {i1, i64} zeroinitializer, i64 1, 1
  %".27" = insertvalue {i1, i64} %".26", i1 0, 0
  %".28" = extractvalue {i1, i64} %".27", 0
  %".29" = extractvalue {i1, i64} %".4", 0
  %".182" = extractvalue {i1, i64} %".4", 1
  %".183" = extractvalue {i1, i64} %".27", 1
  %".184" = sub i64 %".182", %".183"
  %".185" = add i64 %".184", 1
  %".186" = trunc i64 %".185" to i32
  %".187" = alloca {i1, i64}
  %".188" = ptrtoint ptr %".187" to i64
  %".189" = getelementptr {i1, i64}, ptr %".187", i32 %".186"
  %".190" = ptrtoint ptr %".189" to i64
  %".191" = sub i64 %".190", %".188"
  %".192" = call ptr @"malloc"(i64 %".191")
  %".193" = insertvalue {ptr, i32} zeroinitializer, ptr %".192", 0
  %"reduction_array" = insertvalue {ptr, i32} %".193", i32 0, 1
  %".194" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".195" = insertvalue {i1, {ptr, i32}} %".194", {ptr, i32} %"reduction_array", 1
  br label %"Loop_2_header_start"
Loop_2_header_start:
  %"allocated_size_red_1" = phi  i32 [%".186", %"Loop_2_entry"], [%".235", %"Loop_2_latch"]
  %".180" = phi  {i1, {ptr, i32}} [%".195", %"Loop_2_entry"], [%".181", %"Loop_2_latch"]
  %"j" = phi  {i1, i64} [%".27", %"Loop_2_entry"], [%".38", %"Loop_2_latch"]
  %"j_index" = phi  {i1, i64} [%".27", %"Loop_2_entry"], [%".38", %"Loop_2_latch"]
  %".33" = or i1 %".28", %".29"
  br i1 %".33", label %"Scatter_err_block.1", label %"Scatter_correct_exec_block.1"
Loop_2_header_end:
  %".30" = phi  i1 [1, %"Scatter_err_block.1"], [%".41", %"Scatter_correct_exec_block.1"]
  br i1 %".30", label %"Loop_2_body_start", label %"Loop_2_follower"
Loop_2_body_start:
  br label %"Loop_3_entry"
Loop_2_body_end:
  %".196" = insertvalue {i1, i1} zeroinitializer, i1 true, 1
  %".197" = insertvalue {i1, i1} %".196", i1 0, 0
  %".198" = extractvalue {i1, {ptr, i32}} %".180", 0
  %".199" = extractvalue {i1, i1} %".197", 0
  %".200" = extractvalue {i1, i64} %".153", 0
  %".201" = or i1 %".198", %".199"
  br i1 %".201", label %"Loop_2_reduction_1_error", label %"Loop_2_reduction_1_cond_block"
Loop_2_latch:
  %".35" = extractvalue {i1, i64} %"j", 1
  %".36" = add i64 %".35", 1
  %".37" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".38" = insertvalue {i1, i64} %".37", i64 %".36", 1
  br label %"Loop_2_header_start"
Loop_2_follower:
  br label %"Loop_1_body_end"
Scatter_err_block.1:
  br label %"Loop_2_header_end"
Scatter_correct_exec_block.1:
  %".39" = extractvalue {i1, i64} %"j", 1
  %".40" = extractvalue {i1, i64} %".4", 1
  %".41" = icmp sle i64 %".39", %".40"
  br label %"Loop_2_header_end"
Loop_3_entry:
  %".44" = insertvalue {i1, i64} zeroinitializer, i64 1, 1
  %".45" = insertvalue {i1, i64} %".44", i1 0, 0
  %".46" = extractvalue {i1, i64} %".45", 0
  %".47" = extractvalue {i1, i64} %".5", 0
  %".155" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".156" = insertvalue {i1, i64} %".155", i64 0, 1
  br label %"Loop_3_header_start"
Loop_3_header_start:
  %".153" = phi  {i1, i64} [%".156", %"Loop_3_entry"], [%".154", %"Loop_3_latch"]
  %"k" = phi  {i1, i64} [%".45", %"Loop_3_entry"], [%".56", %"Loop_3_latch"]
  %"k_index" = phi  {i1, i64} [%".45", %"Loop_3_entry"], [%".56", %"Loop_3_latch"]
  %".51" = or i1 %".46", %".47"
  br i1 %".51", label %"Scatter_err_block.2", label %"Scatter_correct_exec_block.2"
Loop_3_header_end:
  %".48" = phi  i1 [1, %"Scatter_err_block.2"], [%".59", %"Scatter_correct_exec_block.2"]
  br i1 %".48", label %"Loop_3_body_start", label %"Loop_3_follower"
Loop_3_body_start:
  %".61" = extractvalue {i1, {ptr, i32}} %".1", 0
  %".63" = extractvalue {i1, i64} %"i", 0
  %".64" = or i1 %".63", %".61"
  br i1 %".64", label %"ArrayAccess_err_block", label %"array_access_out_of_bounds_check"
Loop_3_body_end:
  %".157" = insertvalue {i1, i1} zeroinitializer, i1 true, 1
  %".158" = insertvalue {i1, i1} %".157", i1 0, 0
  %".159" = extractvalue {i1, i64} %".153", 0
  %".160" = extractvalue {i1, i1} %".158", 0
  %".161" = extractvalue {i1, i64} %".151", 0
  %".162" = or i1 %".159", %".160"
  %".163" = or i1 %".162", %".161"
  br i1 %".163", label %"Loop_3_reduction_1_error", label %"Loop_3_reduction_1_cond_block"
Loop_3_latch:
  %".53" = extractvalue {i1, i64} %"k", 1
  %".54" = add i64 %".53", 1
  %".55" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".56" = insertvalue {i1, i64} %".55", i64 %".54", 1
  br label %"Loop_3_header_start"
Loop_3_follower:
  br label %"Loop_2_body_end"
Scatter_err_block.2:
  br label %"Loop_3_header_end"
Scatter_correct_exec_block.2:
  %".57" = extractvalue {i1, i64} %"k", 1
  %".58" = extractvalue {i1, i64} %".5", 1
  %".59" = icmp sle i64 %".57", %".58"
  br label %"Loop_3_header_end"
ArrayAccess_err_block:
  %".79" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block"
ArrayAccess_correct_exec_block:
  %".75" = extractvalue {ptr, i32} %".67", 0
  %".76" = getelementptr {i1, {ptr, i32}}, ptr %".75", i32 %".70"
  %".77" = load {i1, {ptr, i32}}, ptr %".76"
  br label %"ArrayAccess_phi_block"
ArrayAccess_phi_block:
  %".80" = phi  {i1, {ptr, i32}} [%".79", %"ArrayAccess_err_block"], [%".77", %"ArrayAccess_correct_exec_block"]
  %".81" = extractvalue {i1, {ptr, i32}} %".80", 0
  %".83" = extractvalue {i1, i64} %"k", 0
  %".84" = or i1 %".83", %".81"
  br i1 %".84", label %"ArrayAccess_err_block.1", label %"array_access_out_of_bounds_check.1"
array_access_out_of_bounds_check:
  %".66" = extractvalue {i1, i64} %"i", 1
  %".67" = extractvalue {i1, {ptr, i32}} %".1", 1
  %".68" = extractvalue {ptr, i32} %".67", 1
  %".69" = trunc i64 %".66" to i32
  %".70" = sub i32 %".69", 1
  %".71" = icmp slt i32 %".70", 0
  %".72" = icmp slt i32 %".68", %".70"
  %".73" = or i1 %".71", %".72"
  br i1 %".73", label %"ArrayAccess_err_block", label %"ArrayAccess_correct_exec_block"
ArrayAccess_err_block.1:
  %".99" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block.1"
ArrayAccess_correct_exec_block.1:
  %".95" = extractvalue {ptr, i32} %".87", 0
  %".96" = getelementptr {i1, i64}, ptr %".95", i32 %".90"
  %".97" = load {i1, i64}, ptr %".96"
  br label %"ArrayAccess_phi_block.1"
ArrayAccess_phi_block.1:
  %".100" = phi  {i1, i64} [%".99", %"ArrayAccess_err_block.1"], [%".97", %"ArrayAccess_correct_exec_block.1"]
  %".101" = extractvalue {i1, {ptr, i32}} %".2", 0
  %".103" = extractvalue {i1, i64} %"k", 0
  %".104" = or i1 %".103", %".101"
  br i1 %".104", label %"ArrayAccess_err_block.2", label %"array_access_out_of_bounds_check.2"
array_access_out_of_bounds_check.1:
  %".86" = extractvalue {i1, i64} %"k", 1
  %".87" = extractvalue {i1, {ptr, i32}} %".80", 1
  %".88" = extractvalue {ptr, i32} %".87", 1
  %".89" = trunc i64 %".86" to i32
  %".90" = sub i32 %".89", 1
  %".91" = icmp slt i32 %".90", 0
  %".92" = icmp slt i32 %".88", %".90"
  %".93" = or i1 %".91", %".92"
  br i1 %".93", label %"ArrayAccess_err_block.1", label %"ArrayAccess_correct_exec_block.1"
ArrayAccess_err_block.2:
  %".119" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block.2"
ArrayAccess_correct_exec_block.2:
  %".115" = extractvalue {ptr, i32} %".107", 0
  %".116" = getelementptr {i1, {ptr, i32}}, ptr %".115", i32 %".110"
  %".117" = load {i1, {ptr, i32}}, ptr %".116"
  br label %"ArrayAccess_phi_block.2"
ArrayAccess_phi_block.2:
  %".120" = phi  {i1, {ptr, i32}} [%".119", %"ArrayAccess_err_block.2"], [%".117", %"ArrayAccess_correct_exec_block.2"]
  %".121" = extractvalue {i1, {ptr, i32}} %".120", 0
  %".123" = extractvalue {i1, i64} %"j", 0
  %".124" = or i1 %".123", %".121"
  br i1 %".124", label %"ArrayAccess_err_block.3", label %"array_access_out_of_bounds_check.3"
array_access_out_of_bounds_check.2:
  %".106" = extractvalue {i1, i64} %"k", 1
  %".107" = extractvalue {i1, {ptr, i32}} %".2", 1
  %".108" = extractvalue {ptr, i32} %".107", 1
  %".109" = trunc i64 %".106" to i32
  %".110" = sub i32 %".109", 1
  %".111" = icmp slt i32 %".110", 0
  %".112" = icmp slt i32 %".108", %".110"
  %".113" = or i1 %".111", %".112"
  br i1 %".113", label %"ArrayAccess_err_block.2", label %"ArrayAccess_correct_exec_block.2"
ArrayAccess_err_block.3:
  %".139" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block.3"
ArrayAccess_correct_exec_block.3:
  %".135" = extractvalue {ptr, i32} %".127", 0
  %".136" = getelementptr {i1, i64}, ptr %".135", i32 %".130"
  %".137" = load {i1, i64}, ptr %".136"
  br label %"ArrayAccess_phi_block.3"
ArrayAccess_phi_block.3:
  %".140" = phi  {i1, i64} [%".139", %"ArrayAccess_err_block.3"], [%".137", %"ArrayAccess_correct_exec_block.3"]
  %".141" = extractvalue {i1, i64} %".100", 0
  %".142" = extractvalue {i1, i64} %".100", 1
  %".143" = extractvalue {i1, i64} %".140", 0
  %".144" = extractvalue {i1, i64} %".140", 1
  %".146" = or i1 %".141", %".143"
  br i1 %".146", label %"Binary_err_block", label %"Binary_correct_exec_block"
array_access_out_of_bounds_check.3:
  %".126" = extractvalue {i1, i64} %"j", 1
  %".127" = extractvalue {i1, {ptr, i32}} %".120", 1
  %".128" = extractvalue {ptr, i32} %".127", 1
  %".129" = trunc i64 %".126" to i32
  %".130" = sub i32 %".129", 1
  %".131" = icmp slt i32 %".130", 0
  %".132" = icmp slt i32 %".128", %".130"
  %".133" = or i1 %".131", %".132"
  br i1 %".133", label %"ArrayAccess_err_block.3", label %"ArrayAccess_correct_exec_block.3"
Binary_err_block:
  br label %"Binary_phi_block"
Binary_correct_exec_block:
  %"Sij" = mul i64 %".142", %".144"
  br label %"Binary_phi_block"
Binary_phi_block:
  %".149" = phi  i64 [undef, %"Binary_err_block"], [%"Sij", %"Binary_correct_exec_block"]
  %".150" = insertvalue {i1, i64} zeroinitializer, i1 %".146", 0
  %".151" = insertvalue {i1, i64} %".150", i64 %".149", 1
  br label %"Loop_3_body_end"
Loop_3_reduction_0_init:
  %".154" = phi  {i1, i64} [%".167", %"Loop_3_reduction_1_error"], [%".173", %"Loop_3_reduction_1_cond_true"], [%".153", %"Loop_3_reduction_1_cond_false"]
  br label %"Loop_3_latch"
Loop_3_reduction_1_cond_true:
  %".169" = extractvalue {i1, i64} %".153", 1
  %".170" = extractvalue {i1, i64} %".151", 1
  %".171" = add i64 %".169", %".170"
  %".172" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".173" = insertvalue {i1, i64} %".172", i64 %".171", 1
  br label %"Loop_3_reduction_0_init"
Loop_3_reduction_1_cond_false:
  br label %"Loop_3_reduction_0_init"
Loop_3_reduction_1_error:
  %".167" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"Loop_3_reduction_0_init"
Loop_3_reduction_1_cond_block:
  %".165" = extractvalue {i1, i1} %".158", 1
  br i1 %".165", label %"Loop_3_reduction_1_cond_true", label %"Loop_3_reduction_1_cond_false"
Loop_2_reduction_0_init:
  %".181" = phi  {i1, {ptr, i32}} [%".205", %"Loop_2_reduction_1_error"], [%".226", %"arr_size_exceeds_allocated"], [%".233", %"arr_size_exceeds_allocated_not"], [%".180", %"Loop_2_reduction_1_cond_false"]
  %".235" = phi  i32 [%".213", %"arr_size_exceeds_allocated"], [%"allocated_size_red_1", %"arr_size_exceeds_allocated_not"], [%"allocated_size_red_1", %"Loop_2_reduction_1_cond_false"], [undef, %"Loop_2_reduction_1_error"]
  br label %"Loop_2_latch"
Loop_2_reduction_1_cond_true:
  %".207" = extractvalue {i1, {ptr, i32}} %".180", 1
  %".208" = extractvalue {ptr, i32} %".207", 1
  %".209" = add i32 %".208", 1
  %".210" = insertvalue {ptr, i32} %".207", i32 %".209", 1
  %".211" = icmp ugt i32 %".209", %"allocated_size_red_1"
  br i1 %".211", label %"arr_size_exceeds_allocated", label %"arr_size_exceeds_allocated_not"
Loop_2_reduction_1_cond_false:
  br label %"Loop_2_reduction_0_init"
Loop_2_reduction_1_error:
  %".205" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 1, 0
  br label %"Loop_2_reduction_0_init"
Loop_2_reduction_1_cond_block:
  %".203" = extractvalue {i1, i1} %".197", 1
  br i1 %".203", label %"Loop_2_reduction_1_cond_true", label %"Loop_2_reduction_1_cond_false"
arr_size_exceeds_allocated:
  %".213" = mul i32 2, %"allocated_size_red_1"
  %".214" = alloca {i1, i64}
  %".215" = ptrtoint ptr %".214" to i64
  %".216" = getelementptr {i1, i64}, ptr %".214", i32 %".213"
  %".217" = ptrtoint ptr %".216" to i64
  %".218" = sub i64 %".217", %".215"
  %".219" = call ptr @"realloc"(ptr %".192", i64 %".218")
  %".220" = getelementptr {i1, i64}, ptr %".219", i32 %".208"
  %".221" = ptrtoint ptr %".220" to i64
  %".222" = inttoptr i64 %".221" to ptr
  store {i1, i64} %".153", ptr %".222"
  %".224" = insertvalue {ptr, i32} %".210", ptr %".219", 0
  %".225" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".226" = insertvalue {i1, {ptr, i32}} %".225", {ptr, i32} %".224", 1
  br label %"Loop_2_reduction_0_init"
arr_size_exceeds_allocated_not:
  %".228" = getelementptr {i1, i64}, ptr %".192", i32 %".208"
  %".229" = ptrtoint ptr %".228" to i64
  %".230" = inttoptr i64 %".229" to ptr
  store {i1, i64} %".153", ptr %".230"
  %".232" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".233" = insertvalue {i1, {ptr, i32}} %".232", {ptr, i32} %".210", 1
  br label %"Loop_2_reduction_0_init"
Loop_1_reduction_0_init:
  %".242" = phi  {i1, {ptr, i32}} [%".266", %"Loop_1_reduction_1_error"], [%".287", %"arr_size_exceeds_allocated.1"], [%".294", %"arr_size_exceeds_allocated_not.1"], [%".241", %"Loop_1_reduction_1_cond_false"]
  %".296" = phi  i32 [%".274", %"arr_size_exceeds_allocated.1"], [%"allocated_size_red_1.1", %"arr_size_exceeds_allocated_not.1"], [%"allocated_size_red_1.1", %"Loop_1_reduction_1_cond_false"], [undef, %"Loop_1_reduction_1_error"]
  br label %"Loop_1_latch"
Loop_1_reduction_1_cond_true:
  %".268" = extractvalue {i1, {ptr, i32}} %".241", 1
  %".269" = extractvalue {ptr, i32} %".268", 1
  %".270" = add i32 %".269", 1
  %".271" = insertvalue {ptr, i32} %".268", i32 %".270", 1
  %".272" = icmp ugt i32 %".270", %"allocated_size_red_1.1"
  br i1 %".272", label %"arr_size_exceeds_allocated.1", label %"arr_size_exceeds_allocated_not.1"
Loop_1_reduction_1_cond_false:
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_error:
  %".266" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 1, 0
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_cond_block:
  %".264" = extractvalue {i1, i1} %".258", 1
  br i1 %".264", label %"Loop_1_reduction_1_cond_true", label %"Loop_1_reduction_1_cond_false"
arr_size_exceeds_allocated.1:
  %".274" = mul i32 2, %"allocated_size_red_1.1"
  %".275" = alloca {i1, {ptr, i32}}
  %".276" = ptrtoint ptr %".275" to i64
  %".277" = getelementptr {i1, {ptr, i32}}, ptr %".275", i32 %".274"
  %".278" = ptrtoint ptr %".277" to i64
  %".279" = sub i64 %".278", %".276"
  %".280" = call ptr @"realloc"(ptr %".253", i64 %".279")
  %".281" = getelementptr {i1, {ptr, i32}}, ptr %".280", i32 %".269"
  %".282" = ptrtoint ptr %".281" to i64
  %".283" = inttoptr i64 %".282" to ptr
  store {i1, {ptr, i32}} %".180", ptr %".283"
  %".285" = insertvalue {ptr, i32} %".271", ptr %".280", 0
  %".286" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".287" = insertvalue {i1, {ptr, i32}} %".286", {ptr, i32} %".285", 1
  br label %"Loop_1_reduction_0_init"
arr_size_exceeds_allocated_not.1:
  %".289" = getelementptr {i1, {ptr, i32}}, ptr %".253", i32 %".269"
  %".290" = ptrtoint ptr %".289" to i64
  %".291" = inttoptr i64 %".290" to ptr
  store {i1, {ptr, i32}} %".180", ptr %".291"
  %".293" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".294" = insertvalue {i1, {ptr, i32}} %".293", {ptr, i32} %".271", 1
  br label %"Loop_1_reduction_0_init"
}

define i32 @"main"({ptr, i32} %".1", {ptr, i32} %".2", i64 %".3", i64 %".4", i64 %".5")
{
.7:
  %".8" = extractvalue {ptr, i32} %".1", 0
  %".9" = extractvalue {ptr, i32} %".1", 1
  %".10" = alloca {i1, {ptr, i32}}
  %".11" = ptrtoint ptr %".10" to i64
  %".12" = getelementptr {i1, {ptr, i32}}, ptr %".10", i32 %".9"
  %".13" = ptrtoint ptr %".12" to i64
  %".14" = sub i64 %".13", %".11"
  %".15" = call ptr @"malloc"(i64 %".14")
  br label %"array_converter_loop_header"
array_converter_loop_header:
  %".17" = phi  i32 [0, %".7"], [%".50", %"array_converter_loop_latch"]
  %".18" = icmp slt i32 %".17", %".9"
  br i1 %".18", label %"array_converter_loop_body_start", label %"array_converter_loop_follower"
array_converter_loop_body_start:
  %".20" = getelementptr {ptr, i32}, ptr %".8", i32 %".17"
  %".21" = load {ptr, i32}, ptr %".20"
  %".22" = extractvalue {ptr, i32} %".21", 0
  %".23" = extractvalue {ptr, i32} %".21", 1
  %".24" = alloca {i1, i64}
  %".25" = ptrtoint ptr %".24" to i64
  %".26" = getelementptr {i1, i64}, ptr %".24", i32 %".23"
  %".27" = ptrtoint ptr %".26" to i64
  %".28" = sub i64 %".27", %".25"
  %".29" = call ptr @"malloc"(i64 %".28")
  br label %"array_converter_loop_header.1"
array_converter_loop_latch:
  %".50" = add i32 %".17", 1
  br label %"array_converter_loop_header"
array_converter_loop_follower:
  %".52" = insertvalue {ptr, i32} zeroinitializer, ptr %".15", 0
  %".53" = insertvalue {ptr, i32} %".52", i32 %".9", 1
  %".54" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".55" = insertvalue {i1, {ptr, i32}} %".54", {ptr, i32} %".53", 1
  %".56" = extractvalue {ptr, i32} %".2", 0
  %".57" = extractvalue {ptr, i32} %".2", 1
  %".58" = alloca {i1, {ptr, i32}}
  %".59" = ptrtoint ptr %".58" to i64
  %".60" = getelementptr {i1, {ptr, i32}}, ptr %".58", i32 %".57"
  %".61" = ptrtoint ptr %".60" to i64
  %".62" = sub i64 %".61", %".59"
  %".63" = call ptr @"malloc"(i64 %".62")
  br label %"array_converter_loop_header.2"
array_converter_loop_header.1:
  %".31" = phi  i32 [0, %"array_converter_loop_body_start"], [%".41", %"array_converter_loop_latch.1"]
  %".32" = icmp slt i32 %".31", %".23"
  br i1 %".32", label %"array_converter_loop_body_start.1", label %"array_converter_loop_follower.1"
array_converter_loop_body_start.1:
  %".34" = getelementptr i64, ptr %".22", i32 %".31"
  %".35" = load i64, ptr %".34"
  %".36" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".37" = insertvalue {i1, i64} %".36", i64 %".35", 1
  %".38" = getelementptr {i1, i64}, ptr %".29", i32 %".31"
  store {i1, i64} %".37", ptr %".38"
  br label %"array_converter_loop_latch.1"
array_converter_loop_latch.1:
  %".41" = add i32 %".31", 1
  br label %"array_converter_loop_header.1"
array_converter_loop_follower.1:
  %".43" = insertvalue {ptr, i32} zeroinitializer, ptr %".29", 0
  %".44" = insertvalue {ptr, i32} %".43", i32 %".23", 1
  %".45" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".46" = insertvalue {i1, {ptr, i32}} %".45", {ptr, i32} %".44", 1
  %".47" = getelementptr {i1, {ptr, i32}}, ptr %".15", i32 %".17"
  store {i1, {ptr, i32}} %".46", ptr %".47"
  br label %"array_converter_loop_latch"
array_converter_loop_header.2:
  %".65" = phi  i32 [0, %"array_converter_loop_follower"], [%".98", %"array_converter_loop_latch.2"]
  %".66" = icmp slt i32 %".65", %".57"
  br i1 %".66", label %"array_converter_loop_body_start.2", label %"array_converter_loop_follower.2"
array_converter_loop_body_start.2:
  %".68" = getelementptr {ptr, i32}, ptr %".56", i32 %".65"
  %".69" = load {ptr, i32}, ptr %".68"
  %".70" = extractvalue {ptr, i32} %".69", 0
  %".71" = extractvalue {ptr, i32} %".69", 1
  %".72" = alloca {i1, i64}
  %".73" = ptrtoint ptr %".72" to i64
  %".74" = getelementptr {i1, i64}, ptr %".72", i32 %".71"
  %".75" = ptrtoint ptr %".74" to i64
  %".76" = sub i64 %".75", %".73"
  %".77" = call ptr @"malloc"(i64 %".76")
  br label %"array_converter_loop_header.3"
array_converter_loop_latch.2:
  %".98" = add i32 %".65", 1
  br label %"array_converter_loop_header.2"
array_converter_loop_follower.2:
  %".100" = insertvalue {ptr, i32} zeroinitializer, ptr %".63", 0
  %".101" = insertvalue {ptr, i32} %".100", i32 %".57", 1
  %".102" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".103" = insertvalue {i1, {ptr, i32}} %".102", {ptr, i32} %".101", 1
  %".104" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".105" = insertvalue {i1, i64} %".104", i64 %".3", 1
  %".106" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".107" = insertvalue {i1, i64} %".106", i64 %".4", 1
  %".108" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".109" = insertvalue {i1, i64} %".108", i64 %".5", 1
  %".110" = call {i1, {ptr, i32}} @"sisal_main"({i1, {ptr, i32}} %".55", {i1, {ptr, i32}} %".103", {i1, i64} %".105", {i1, i64} %".107", {i1, i64} %".109")
  %".111" = extractvalue {i1, {ptr, i32}} %".110", 0
  br i1 %".111", label %"val_errored", label %"val_not_errored"
array_converter_loop_header.3:
  %".79" = phi  i32 [0, %"array_converter_loop_body_start.2"], [%".89", %"array_converter_loop_latch.3"]
  %".80" = icmp slt i32 %".79", %".71"
  br i1 %".80", label %"array_converter_loop_body_start.3", label %"array_converter_loop_follower.3"
array_converter_loop_body_start.3:
  %".82" = getelementptr i64, ptr %".70", i32 %".79"
  %".83" = load i64, ptr %".82"
  %".84" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".85" = insertvalue {i1, i64} %".84", i64 %".83", 1
  %".86" = getelementptr {i1, i64}, ptr %".77", i32 %".79"
  store {i1, i64} %".85", ptr %".86"
  br label %"array_converter_loop_latch.3"
array_converter_loop_latch.3:
  %".89" = add i32 %".79", 1
  br label %"array_converter_loop_header.3"
array_converter_loop_follower.3:
  %".91" = insertvalue {ptr, i32} zeroinitializer, ptr %".77", 0
  %".92" = insertvalue {ptr, i32} %".91", i32 %".71", 1
  %".93" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".94" = insertvalue {i1, {ptr, i32}} %".93", {ptr, i32} %".92", 1
  %".95" = getelementptr {i1, {ptr, i32}}, ptr %".63", i32 %".65"
  store {i1, {ptr, i32}} %".94", ptr %".95"
  br label %"array_converter_loop_latch.2"
val_errored:
  %".113" = alloca [15 x i8]
  store [15 x i8] c"Lambda0: ERROR\00", ptr %".113"
  %".115" = call i32 (ptr, ...) @"printf"(ptr %".113")
  br label %"end_printf"
val_not_errored:
  %".117" = extractvalue {i1, {ptr, i32}} %".110", 1
  %".118" = alloca [11 x i8]
  store [11 x i8] c"Lambda0: [\00", ptr %".118"
  %".120" = call i32 (ptr, ...) @"printf"(ptr %".118")
  %".121" = extractvalue {ptr, i32} %".117", 0
  %".122" = extractvalue {ptr, i32} %".117", 1
  call void @"array_print_loop_0"(ptr %".121", i32 %".122")
  %".124" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".124"
  %".126" = call i32 (ptr, ...) @"printf"(ptr %".124")
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
  %".7" = phi  i32 [0, %"entry"], [%".34", %"end_printf"]
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
  %".15" = getelementptr {i1, {ptr, i32}}, ptr %".1", i32 %".7"
  %".16" = load {i1, {ptr, i32}}, ptr %".15"
  %".17" = extractvalue {i1, {ptr, i32}} %".16", 0
  br i1 %".17", label %"val_errored", label %"val_not_errored"
array_loop_follower:
  ret void
val_errored:
  %".19" = alloca [6 x i8]
  store [6 x i8] c"ERROR\00", ptr %".19"
  %".21" = call i32 (ptr, ...) @"printf"(ptr %".19")
  br label %"end_printf"
val_not_errored:
  %".23" = extractvalue {i1, {ptr, i32}} %".16", 1
  %".24" = alloca [2 x i8]
  store [2 x i8] c"[\00", ptr %".24"
  %".26" = call i32 (ptr, ...) @"printf"(ptr %".24")
  %".27" = extractvalue {ptr, i32} %".23", 0
  %".28" = extractvalue {ptr, i32} %".23", 1
  call void @"array_print_loop_1"(ptr %".27", i32 %".28")
  %".30" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".30"
  %".32" = call i32 (ptr, ...) @"printf"(ptr %".30")
  br label %"end_printf"
end_printf:
  %".34" = add i32 %".7", 1
  br label %"array_loop_header"
}

define void @"array_print_loop_1"(ptr %".1", i32 %".2")
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

