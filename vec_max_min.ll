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

define {{i1, {ptr, i32}}, {i1, {ptr, i32}}} @"sisal_main"({i1, {ptr, i32}} %".1", {i1, {ptr, i32}} %".2")
{
entry:
  br label %"Loop_1_entry"
Loop_1_entry:
  %".5" = insertvalue {i1, i64} zeroinitializer, i64 1, 1
  %".6" = insertvalue {i1, i64} %".5", i1 0, 0
  %".7" = extractvalue {i1, {ptr, i32}} %".1", 0
  br i1 %".7", label %"FunctionCall_err_block", label %"FunctionCall_correct_exec_block"
Loop_1_header_start:
  %"allocated_size_red_2" = phi  i32 [%".238", %"FunctionCall_phi_block"], [%".287", %"Loop_1_latch"]
  %".232" = phi  {i1, {ptr, i32}} [%".247", %"FunctionCall_phi_block"], [%".233", %"Loop_1_latch"]
  %"allocated_size_red_1" = phi  i32 [%".181", %"FunctionCall_phi_block"], [%".230", %"Loop_1_latch"]
  %".175" = phi  {i1, {ptr, i32}} [%".190", %"FunctionCall_phi_block"], [%".176", %"Loop_1_latch"]
  %"i" = phi  {i1, i64} [%".6", %"FunctionCall_phi_block"], [%".27", %"Loop_1_latch"]
  %"i_index" = phi  {i1, i64} [%".6", %"FunctionCall_phi_block"], [%".27", %"Loop_1_latch"]
  %".22" = or i1 %".17", %".18"
  br i1 %".22", label %"Scatter_err_block", label %"Scatter_correct_exec_block"
Loop_1_header_end:
  %".19" = phi  i1 [1, %"Scatter_err_block"], [%".30", %"Scatter_correct_exec_block"]
  br i1 %".19", label %"Loop_1_body_start", label %"Loop_1_follower"
Loop_1_body_start:
  %".32" = extractvalue {i1, {ptr, i32}} %".1", 0
  %".34" = extractvalue {i1, i64} %"i", 0
  %".35" = or i1 %".34", %".32"
  br i1 %".35", label %"ArrayAccess_err_block", label %"array_access_out_of_bounds_check"
Loop_1_body_end:
  %".191" = insertvalue {i1, i1} zeroinitializer, i1 true, 1
  %".192" = insertvalue {i1, i1} %".191", i1 0, 0
  %".193" = extractvalue {i1, {ptr, i32}} %".175", 0
  %".194" = extractvalue {i1, i1} %".192", 0
  %".195" = extractvalue {i1, i64} %"maximum", 0
  %".196" = or i1 %".193", %".194"
  %".248" = insertvalue {i1, i1} zeroinitializer, i1 true, 1
  %".249" = insertvalue {i1, i1} %".248", i1 0, 0
  br i1 %".196", label %"Loop_1_reduction_1_error", label %"Loop_1_reduction_1_cond_block"
Loop_1_latch:
  %".24" = extractvalue {i1, i64} %"i", 1
  %".25" = add i64 %".24", 1
  %".26" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".27" = insertvalue {i1, i64} %".26", i64 %".25", 1
  br label %"Loop_1_header_start"
Loop_1_follower:
  %".292" = insertvalue {{i1, {ptr, i32}}, {i1, {ptr, i32}}} zeroinitializer, {i1, {ptr, i32}} %".175", 0
  %".293" = insertvalue {{i1, {ptr, i32}}, {i1, {ptr, i32}}} %".292", {i1, {ptr, i32}} %".232", 1
  ret {{i1, {ptr, i32}}, {i1, {ptr, i32}}} %".293"
FunctionCall_err_block:
  %".16" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"FunctionCall_phi_block"
FunctionCall_correct_exec_block:
  %".11" = extractvalue {i1, {ptr, i32}} %".1", 1
  %".12" = extractvalue {ptr, i32} %".11", 1
  %"call" = zext i32 %".12" to i64
  %".13" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".14" = insertvalue {i1, i64} %".13", i64 %"call", 1
  br label %"FunctionCall_phi_block"
FunctionCall_phi_block:
  %".10" = phi  {i1, i64} [%".14", %"FunctionCall_correct_exec_block"], [%".16", %"FunctionCall_err_block"]
  %".17" = extractvalue {i1, i64} %".6", 0
  %".18" = extractvalue {i1, i64} %".10", 0
  %".177" = extractvalue {i1, i64} %".10", 1
  %".178" = extractvalue {i1, i64} %".6", 1
  %".179" = sub i64 %".177", %".178"
  %".180" = add i64 %".179", 1
  %".181" = trunc i64 %".180" to i32
  %".182" = alloca {i1, i64}
  %".183" = ptrtoint ptr %".182" to i64
  %".184" = getelementptr {i1, i64}, ptr %".182", i32 %".181"
  %".185" = ptrtoint ptr %".184" to i64
  %".186" = sub i64 %".185", %".183"
  %".187" = call ptr @"malloc"(i64 %".186")
  %".188" = insertvalue {ptr, i32} zeroinitializer, ptr %".187", 0
  %"reduction_array" = insertvalue {ptr, i32} %".188", i32 0, 1
  %".189" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".190" = insertvalue {i1, {ptr, i32}} %".189", {ptr, i32} %"reduction_array", 1
  %".234" = extractvalue {i1, i64} %".10", 1
  %".235" = extractvalue {i1, i64} %".6", 1
  %".236" = sub i64 %".234", %".235"
  %".237" = add i64 %".236", 1
  %".238" = trunc i64 %".237" to i32
  %".239" = alloca {i1, i64}
  %".240" = ptrtoint ptr %".239" to i64
  %".241" = getelementptr {i1, i64}, ptr %".239", i32 %".238"
  %".242" = ptrtoint ptr %".241" to i64
  %".243" = sub i64 %".242", %".240"
  %".244" = call ptr @"malloc"(i64 %".243")
  %".245" = insertvalue {ptr, i32} zeroinitializer, ptr %".244", 0
  %"reduction_array.1" = insertvalue {ptr, i32} %".245", i32 0, 1
  %".246" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".247" = insertvalue {i1, {ptr, i32}} %".246", {ptr, i32} %"reduction_array.1", 1
  br label %"Loop_1_header_start"
Scatter_err_block:
  br label %"Loop_1_header_end"
Scatter_correct_exec_block:
  %".28" = extractvalue {i1, i64} %"i", 1
  %".29" = extractvalue {i1, i64} %".10", 1
  %".30" = icmp sle i64 %".28", %".29"
  br label %"Loop_1_header_end"
If1error_in_a_condition:
  %".87" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  %".88" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"If1follower"
ArrayAccess_err_block:
  %".50" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block"
ArrayAccess_correct_exec_block:
  %".46" = extractvalue {ptr, i32} %".38", 0
  %".47" = getelementptr {i1, i64}, ptr %".46", i32 %".41"
  %".48" = load {i1, i64}, ptr %".47"
  br label %"ArrayAccess_phi_block"
ArrayAccess_phi_block:
  %".51" = phi  {i1, i64} [%".50", %"ArrayAccess_err_block"], [%".48", %"ArrayAccess_correct_exec_block"]
  %".52" = extractvalue {i1, {ptr, i32}} %".2", 0
  %".54" = extractvalue {i1, i64} %"i", 0
  %".55" = or i1 %".54", %".52"
  br i1 %".55", label %"ArrayAccess_err_block.1", label %"array_access_out_of_bounds_check.1"
array_access_out_of_bounds_check:
  %".37" = extractvalue {i1, i64} %"i", 1
  %".38" = extractvalue {i1, {ptr, i32}} %".1", 1
  %".39" = extractvalue {ptr, i32} %".38", 1
  %".40" = trunc i64 %".37" to i32
  %".41" = sub i32 %".40", 1
  %".42" = icmp slt i32 %".41", 0
  %".43" = icmp slt i32 %".39", %".41"
  %".44" = or i1 %".42", %".43"
  br i1 %".44", label %"ArrayAccess_err_block", label %"ArrayAccess_correct_exec_block"
ArrayAccess_err_block.1:
  %".70" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block.1"
ArrayAccess_correct_exec_block.1:
  %".66" = extractvalue {ptr, i32} %".58", 0
  %".67" = getelementptr {i1, i64}, ptr %".66", i32 %".61"
  %".68" = load {i1, i64}, ptr %".67"
  br label %"ArrayAccess_phi_block.1"
ArrayAccess_phi_block.1:
  %".71" = phi  {i1, i64} [%".70", %"ArrayAccess_err_block.1"], [%".68", %"ArrayAccess_correct_exec_block.1"]
  %".72" = extractvalue {i1, i64} %".51", 0
  %".73" = extractvalue {i1, i64} %".51", 1
  %".74" = extractvalue {i1, i64} %".71", 0
  %".75" = extractvalue {i1, i64} %".71", 1
  %".77" = or i1 %".72", %".74"
  br i1 %".77", label %"Binary_err_block", label %"Binary_correct_exec_block"
array_access_out_of_bounds_check.1:
  %".57" = extractvalue {i1, i64} %"i", 1
  %".58" = extractvalue {i1, {ptr, i32}} %".2", 1
  %".59" = extractvalue {ptr, i32} %".58", 1
  %".60" = trunc i64 %".57" to i32
  %".61" = sub i32 %".60", 1
  %".62" = icmp slt i32 %".61", 0
  %".63" = icmp slt i32 %".59", %".61"
  %".64" = or i1 %".62", %".63"
  br i1 %".64", label %"ArrayAccess_err_block.1", label %"ArrayAccess_correct_exec_block.1"
Binary_err_block:
  br label %"Binary_phi_block"
Binary_correct_exec_block:
  %"binary output (<)" = icmp slt i64 %".73", %".75"
  br label %"Binary_phi_block"
Binary_phi_block:
  %".80" = phi  i1 [undef, %"Binary_err_block"], [%"binary output (<)", %"Binary_correct_exec_block"]
  %".81" = insertvalue {i1, i1} zeroinitializer, i1 %".77", 0
  %".82" = insertvalue {i1, i1} %".81", i1 %".80", 1
  %".83" = extractvalue {i1, i1} %".82", 0
  %".84" = extractvalue {i1, i1} %".82", 1
  br i1 %".83", label %"If1error_in_a_condition", label %"If1noeror_cond0"
If1true0:
  %".89" = extractvalue {i1, {ptr, i32}} %".1", 0
  %".91" = extractvalue {i1, i64} %"i", 0
  %".92" = or i1 %".91", %".89"
  br i1 %".92", label %"ArrayAccess_err_block.2", label %"array_access_out_of_bounds_check.2"
If1false0:
  %".131" = extractvalue {i1, {ptr, i32}} %".2", 0
  %".133" = extractvalue {i1, i64} %"i", 0
  %".134" = or i1 %".133", %".131"
  br i1 %".134", label %"ArrayAccess_err_block.4", label %"array_access_out_of_bounds_check.4"
If1noeror_cond0:
  br i1 %".84", label %"If1true0", label %"If1false0"
If1follower:
  %"maximum" = phi  {i1, i64} [%".88", %"If1error_in_a_condition"], [%".128", %"If1true0_end"], [%".170", %"If1false0_end"]
  %"minimum" = phi  {i1, i64} [%".87", %"If1error_in_a_condition"], [%".108", %"If1true0_end"], [%".150", %"If1false0_end"]
  br label %"Loop_1_body_end"
If1true0_end:
  br label %"If1follower"
ArrayAccess_err_block.2:
  %".107" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block.2"
ArrayAccess_correct_exec_block.2:
  %".103" = extractvalue {ptr, i32} %".95", 0
  %".104" = getelementptr {i1, i64}, ptr %".103", i32 %".98"
  %".105" = load {i1, i64}, ptr %".104"
  br label %"ArrayAccess_phi_block.2"
ArrayAccess_phi_block.2:
  %".108" = phi  {i1, i64} [%".107", %"ArrayAccess_err_block.2"], [%".105", %"ArrayAccess_correct_exec_block.2"]
  %".109" = extractvalue {i1, {ptr, i32}} %".2", 0
  %".111" = extractvalue {i1, i64} %"i", 0
  %".112" = or i1 %".111", %".109"
  br i1 %".112", label %"ArrayAccess_err_block.3", label %"array_access_out_of_bounds_check.3"
array_access_out_of_bounds_check.2:
  %".94" = extractvalue {i1, i64} %"i", 1
  %".95" = extractvalue {i1, {ptr, i32}} %".1", 1
  %".96" = extractvalue {ptr, i32} %".95", 1
  %".97" = trunc i64 %".94" to i32
  %".98" = sub i32 %".97", 1
  %".99" = icmp slt i32 %".98", 0
  %".100" = icmp slt i32 %".96", %".98"
  %".101" = or i1 %".99", %".100"
  br i1 %".101", label %"ArrayAccess_err_block.2", label %"ArrayAccess_correct_exec_block.2"
ArrayAccess_err_block.3:
  %".127" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block.3"
ArrayAccess_correct_exec_block.3:
  %".123" = extractvalue {ptr, i32} %".115", 0
  %".124" = getelementptr {i1, i64}, ptr %".123", i32 %".118"
  %".125" = load {i1, i64}, ptr %".124"
  br label %"ArrayAccess_phi_block.3"
ArrayAccess_phi_block.3:
  %".128" = phi  {i1, i64} [%".127", %"ArrayAccess_err_block.3"], [%".125", %"ArrayAccess_correct_exec_block.3"]
  br label %"If1true0_end"
array_access_out_of_bounds_check.3:
  %".114" = extractvalue {i1, i64} %"i", 1
  %".115" = extractvalue {i1, {ptr, i32}} %".2", 1
  %".116" = extractvalue {ptr, i32} %".115", 1
  %".117" = trunc i64 %".114" to i32
  %".118" = sub i32 %".117", 1
  %".119" = icmp slt i32 %".118", 0
  %".120" = icmp slt i32 %".116", %".118"
  %".121" = or i1 %".119", %".120"
  br i1 %".121", label %"ArrayAccess_err_block.3", label %"ArrayAccess_correct_exec_block.3"
If1false0_end:
  br label %"If1follower"
ArrayAccess_err_block.4:
  %".149" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block.4"
ArrayAccess_correct_exec_block.4:
  %".145" = extractvalue {ptr, i32} %".137", 0
  %".146" = getelementptr {i1, i64}, ptr %".145", i32 %".140"
  %".147" = load {i1, i64}, ptr %".146"
  br label %"ArrayAccess_phi_block.4"
ArrayAccess_phi_block.4:
  %".150" = phi  {i1, i64} [%".149", %"ArrayAccess_err_block.4"], [%".147", %"ArrayAccess_correct_exec_block.4"]
  %".151" = extractvalue {i1, {ptr, i32}} %".1", 0
  %".153" = extractvalue {i1, i64} %"i", 0
  %".154" = or i1 %".153", %".151"
  br i1 %".154", label %"ArrayAccess_err_block.5", label %"array_access_out_of_bounds_check.5"
array_access_out_of_bounds_check.4:
  %".136" = extractvalue {i1, i64} %"i", 1
  %".137" = extractvalue {i1, {ptr, i32}} %".2", 1
  %".138" = extractvalue {ptr, i32} %".137", 1
  %".139" = trunc i64 %".136" to i32
  %".140" = sub i32 %".139", 1
  %".141" = icmp slt i32 %".140", 0
  %".142" = icmp slt i32 %".138", %".140"
  %".143" = or i1 %".141", %".142"
  br i1 %".143", label %"ArrayAccess_err_block.4", label %"ArrayAccess_correct_exec_block.4"
ArrayAccess_err_block.5:
  %".169" = insertvalue {i1, i64} zeroinitializer, i1 1, 0
  br label %"ArrayAccess_phi_block.5"
ArrayAccess_correct_exec_block.5:
  %".165" = extractvalue {ptr, i32} %".157", 0
  %".166" = getelementptr {i1, i64}, ptr %".165", i32 %".160"
  %".167" = load {i1, i64}, ptr %".166"
  br label %"ArrayAccess_phi_block.5"
ArrayAccess_phi_block.5:
  %".170" = phi  {i1, i64} [%".169", %"ArrayAccess_err_block.5"], [%".167", %"ArrayAccess_correct_exec_block.5"]
  br label %"If1false0_end"
array_access_out_of_bounds_check.5:
  %".156" = extractvalue {i1, i64} %"i", 1
  %".157" = extractvalue {i1, {ptr, i32}} %".1", 1
  %".158" = extractvalue {ptr, i32} %".157", 1
  %".159" = trunc i64 %".156" to i32
  %".160" = sub i32 %".159", 1
  %".161" = icmp slt i32 %".160", 0
  %".162" = icmp slt i32 %".158", %".160"
  %".163" = or i1 %".161", %".162"
  br i1 %".163", label %"ArrayAccess_err_block.5", label %"ArrayAccess_correct_exec_block.5"
Loop_1_reduction_0_init:
  %".176" = phi  {i1, {ptr, i32}} [%".200", %"Loop_1_reduction_1_error"], [%".221", %"arr_size_exceeds_allocated"], [%".228", %"arr_size_exceeds_allocated_not"], [%".175", %"Loop_1_reduction_1_cond_false"]
  %".230" = phi  i32 [%".208", %"arr_size_exceeds_allocated"], [%"allocated_size_red_1", %"arr_size_exceeds_allocated_not"], [%"allocated_size_red_1", %"Loop_1_reduction_1_cond_false"], [undef, %"Loop_1_reduction_1_error"]
  %".250" = extractvalue {i1, {ptr, i32}} %".232", 0
  %".251" = extractvalue {i1, i1} %".249", 0
  %".252" = extractvalue {i1, i64} %"minimum", 0
  %".253" = or i1 %".250", %".251"
  br i1 %".253", label %"Loop_1_reduction_2_error", label %"Loop_1_reduction_2_cond_block"
Loop_1_reduction_1_cond_true:
  %".202" = extractvalue {i1, {ptr, i32}} %".175", 1
  %".203" = extractvalue {ptr, i32} %".202", 1
  %".204" = add i32 %".203", 1
  %".205" = insertvalue {ptr, i32} %".202", i32 %".204", 1
  %".206" = icmp ugt i32 %".204", %"allocated_size_red_1"
  br i1 %".206", label %"arr_size_exceeds_allocated", label %"arr_size_exceeds_allocated_not"
Loop_1_reduction_1_cond_false:
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_error:
  %".200" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 1, 0
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_cond_block:
  %".198" = extractvalue {i1, i1} %".192", 1
  br i1 %".198", label %"Loop_1_reduction_1_cond_true", label %"Loop_1_reduction_1_cond_false"
arr_size_exceeds_allocated:
  %".208" = mul i32 2, %"allocated_size_red_1"
  %".209" = alloca {i1, i64}
  %".210" = ptrtoint ptr %".209" to i64
  %".211" = getelementptr {i1, i64}, ptr %".209", i32 %".208"
  %".212" = ptrtoint ptr %".211" to i64
  %".213" = sub i64 %".212", %".210"
  %".214" = call ptr @"realloc"(ptr %".187", i64 %".213")
  %".215" = getelementptr {i1, i64}, ptr %".214", i32 %".203"
  %".216" = ptrtoint ptr %".215" to i64
  %".217" = inttoptr i64 %".216" to ptr
  store {i1, i64} %"maximum", ptr %".217"
  %".219" = insertvalue {ptr, i32} %".205", ptr %".214", 0
  %".220" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".221" = insertvalue {i1, {ptr, i32}} %".220", {ptr, i32} %".219", 1
  br label %"Loop_1_reduction_0_init"
arr_size_exceeds_allocated_not:
  %".223" = getelementptr {i1, i64}, ptr %".187", i32 %".203"
  %".224" = ptrtoint ptr %".223" to i64
  %".225" = inttoptr i64 %".224" to ptr
  store {i1, i64} %"maximum", ptr %".225"
  %".227" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".228" = insertvalue {i1, {ptr, i32}} %".227", {ptr, i32} %".205", 1
  br label %"Loop_1_reduction_0_init"
Loop_1_reduction_1_init:
  %".233" = phi  {i1, {ptr, i32}} [%".257", %"Loop_1_reduction_2_error"], [%".278", %"arr_size_exceeds_allocated.1"], [%".285", %"arr_size_exceeds_allocated_not.1"], [%".232", %"Loop_1_reduction_2_cond_false"]
  %".287" = phi  i32 [%".265", %"arr_size_exceeds_allocated.1"], [%"allocated_size_red_2", %"arr_size_exceeds_allocated_not.1"], [%"allocated_size_red_2", %"Loop_1_reduction_2_cond_false"], [undef, %"Loop_1_reduction_2_error"]
  br label %"Loop_1_latch"
Loop_1_reduction_2_cond_true:
  %".259" = extractvalue {i1, {ptr, i32}} %".232", 1
  %".260" = extractvalue {ptr, i32} %".259", 1
  %".261" = add i32 %".260", 1
  %".262" = insertvalue {ptr, i32} %".259", i32 %".261", 1
  %".263" = icmp ugt i32 %".261", %"allocated_size_red_2"
  br i1 %".263", label %"arr_size_exceeds_allocated.1", label %"arr_size_exceeds_allocated_not.1"
Loop_1_reduction_2_cond_false:
  br label %"Loop_1_reduction_1_init"
Loop_1_reduction_2_error:
  %".257" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 1, 0
  br label %"Loop_1_reduction_1_init"
Loop_1_reduction_2_cond_block:
  %".255" = extractvalue {i1, i1} %".249", 1
  br i1 %".255", label %"Loop_1_reduction_2_cond_true", label %"Loop_1_reduction_2_cond_false"
arr_size_exceeds_allocated.1:
  %".265" = mul i32 2, %"allocated_size_red_2"
  %".266" = alloca {i1, i64}
  %".267" = ptrtoint ptr %".266" to i64
  %".268" = getelementptr {i1, i64}, ptr %".266", i32 %".265"
  %".269" = ptrtoint ptr %".268" to i64
  %".270" = sub i64 %".269", %".267"
  %".271" = call ptr @"realloc"(ptr %".244", i64 %".270")
  %".272" = getelementptr {i1, i64}, ptr %".271", i32 %".260"
  %".273" = ptrtoint ptr %".272" to i64
  %".274" = inttoptr i64 %".273" to ptr
  store {i1, i64} %"minimum", ptr %".274"
  %".276" = insertvalue {ptr, i32} %".262", ptr %".271", 0
  %".277" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".278" = insertvalue {i1, {ptr, i32}} %".277", {ptr, i32} %".276", 1
  br label %"Loop_1_reduction_1_init"
arr_size_exceeds_allocated_not.1:
  %".280" = getelementptr {i1, i64}, ptr %".244", i32 %".260"
  %".281" = ptrtoint ptr %".280" to i64
  %".282" = inttoptr i64 %".281" to ptr
  store {i1, i64} %"minimum", ptr %".282"
  %".284" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".285" = insertvalue {i1, {ptr, i32}} %".284", {ptr, i32} %".262", 1
  br label %"Loop_1_reduction_1_init"
}

define i32 @"main"({ptr, i32} %".1", {ptr, i32} %".2")
{
.4:
  %".5" = extractvalue {ptr, i32} %".1", 0
  %".6" = extractvalue {ptr, i32} %".1", 1
  %".7" = alloca {i1, i64}
  %".8" = ptrtoint ptr %".7" to i64
  %".9" = getelementptr {i1, i64}, ptr %".7", i32 %".6"
  %".10" = ptrtoint ptr %".9" to i64
  %".11" = sub i64 %".10", %".8"
  %".12" = call ptr @"malloc"(i64 %".11")
  br label %"array_converter_loop_header"
array_converter_loop_header:
  %".14" = phi  i32 [0, %".4"], [%".24", %"array_converter_loop_latch"]
  %".15" = icmp slt i32 %".14", %".6"
  br i1 %".15", label %"array_converter_loop_body_start", label %"array_converter_loop_follower"
array_converter_loop_body_start:
  %".17" = getelementptr i64, ptr %".5", i32 %".14"
  %".18" = load i64, ptr %".17"
  %".19" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".20" = insertvalue {i1, i64} %".19", i64 %".18", 1
  %".21" = getelementptr {i1, i64}, ptr %".12", i32 %".14"
  store {i1, i64} %".20", ptr %".21"
  br label %"array_converter_loop_latch"
array_converter_loop_latch:
  %".24" = add i32 %".14", 1
  br label %"array_converter_loop_header"
array_converter_loop_follower:
  %".26" = insertvalue {ptr, i32} zeroinitializer, ptr %".12", 0
  %".27" = insertvalue {ptr, i32} %".26", i32 %".6", 1
  %".28" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".29" = insertvalue {i1, {ptr, i32}} %".28", {ptr, i32} %".27", 1
  %".30" = extractvalue {ptr, i32} %".2", 0
  %".31" = extractvalue {ptr, i32} %".2", 1
  %".32" = alloca {i1, i64}
  %".33" = ptrtoint ptr %".32" to i64
  %".34" = getelementptr {i1, i64}, ptr %".32", i32 %".31"
  %".35" = ptrtoint ptr %".34" to i64
  %".36" = sub i64 %".35", %".33"
  %".37" = call ptr @"malloc"(i64 %".36")
  br label %"array_converter_loop_header.1"
array_converter_loop_header.1:
  %".39" = phi  i32 [0, %"array_converter_loop_follower"], [%".49", %"array_converter_loop_latch.1"]
  %".40" = icmp slt i32 %".39", %".31"
  br i1 %".40", label %"array_converter_loop_body_start.1", label %"array_converter_loop_follower.1"
array_converter_loop_body_start.1:
  %".42" = getelementptr i64, ptr %".30", i32 %".39"
  %".43" = load i64, ptr %".42"
  %".44" = insertvalue {i1, i64} zeroinitializer, i1 0, 0
  %".45" = insertvalue {i1, i64} %".44", i64 %".43", 1
  %".46" = getelementptr {i1, i64}, ptr %".37", i32 %".39"
  store {i1, i64} %".45", ptr %".46"
  br label %"array_converter_loop_latch.1"
array_converter_loop_latch.1:
  %".49" = add i32 %".39", 1
  br label %"array_converter_loop_header.1"
array_converter_loop_follower.1:
  %".51" = insertvalue {ptr, i32} zeroinitializer, ptr %".37", 0
  %".52" = insertvalue {ptr, i32} %".51", i32 %".31", 1
  %".53" = insertvalue {i1, {ptr, i32}} zeroinitializer, i1 0, 0
  %".54" = insertvalue {i1, {ptr, i32}} %".53", {ptr, i32} %".52", 1
  %".55" = call {{i1, {ptr, i32}}, {i1, {ptr, i32}}} @"sisal_main"({i1, {ptr, i32}} %".29", {i1, {ptr, i32}} %".54")
  %".56" = alloca [3 x i8]
  store [3 x i8] c"{\0a\00", ptr %".56"
  %".58" = call i32 (ptr, ...) @"printf"(ptr %".56")
  %".59" = extractvalue {{i1, {ptr, i32}}, {i1, {ptr, i32}}} %".55", 0
  %".60" = extractvalue {i1, {ptr, i32}} %".59", 0
  br i1 %".60", label %"val_errored", label %"val_not_errored"
val_errored:
  %".62" = alloca [15 x i8]
  store [15 x i8] c"Lambda0: ERROR\00", ptr %".62"
  %".64" = call i32 (ptr, ...) @"printf"(ptr %".62")
  br label %"end_printf"
val_not_errored:
  %".66" = extractvalue {i1, {ptr, i32}} %".59", 1
  %".67" = alloca [11 x i8]
  store [11 x i8] c"Lambda0: [\00", ptr %".67"
  %".69" = call i32 (ptr, ...) @"printf"(ptr %".67")
  %".70" = extractvalue {ptr, i32} %".66", 0
  %".71" = extractvalue {ptr, i32} %".66", 1
  call void @"array_print_loop_0"(ptr %".70", i32 %".71")
  %".73" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".73"
  %".75" = call i32 (ptr, ...) @"printf"(ptr %".73")
  br label %"end_printf"
end_printf:
  %".77" = extractvalue {{i1, {ptr, i32}}, {i1, {ptr, i32}}} %".55", 1
  %".78" = alloca [3 x i8]
  store [3 x i8] c",\0a\00", ptr %".78"
  %".80" = call i32 (ptr, ...) @"printf"(ptr %".78")
  %".81" = extractvalue {i1, {ptr, i32}} %".77", 0
  br i1 %".81", label %"val_errored.1", label %"val_not_errored.1"
val_errored.1:
  %".83" = alloca [15 x i8]
  store [15 x i8] c"Lambda1: ERROR\00", ptr %".83"
  %".85" = call i32 (ptr, ...) @"printf"(ptr %".83")
  br label %"end_printf.1"
val_not_errored.1:
  %".87" = extractvalue {i1, {ptr, i32}} %".77", 1
  %".88" = alloca [11 x i8]
  store [11 x i8] c"Lambda1: [\00", ptr %".88"
  %".90" = call i32 (ptr, ...) @"printf"(ptr %".88")
  %".91" = extractvalue {ptr, i32} %".87", 0
  %".92" = extractvalue {ptr, i32} %".87", 1
  call void @"array_print_loop_1"(ptr %".91", i32 %".92")
  %".94" = alloca [2 x i8]
  store [2 x i8] c"]\00", ptr %".94"
  %".96" = call i32 (ptr, ...) @"printf"(ptr %".94")
  br label %"end_printf.1"
end_printf.1:
  %".98" = alloca [3 x i8]
  store [3 x i8] c"\0a}\00", ptr %".98"
  %".100" = call i32 (ptr, ...) @"printf"(ptr %".98")
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

