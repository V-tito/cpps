; ModuleID = '<string>'
source_filename = "<string>"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "unknown-unknown-unknown"

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias noundef ptr @realloc(ptr allocptr nocapture, i64 noundef) local_unnamed_addr #2

; Function Attrs: nounwind memory(readwrite, argmem: read)
define { i1, { ptr, i32 } } @sisal_main({ i1, { ptr, i32 } } %.1, { i1, { ptr, i32 } } %.2, { i1, i64 } %.3, { i1, i64 } %.4, { i1, i64 } %.5) local_unnamed_addr #3 {
entry:
  %.11 = extractvalue { i1, i64 } %.3, 0
  %.243 = extractvalue { i1, i64 } %.3, 1
  %.247 = trunc i64 %.243 to i32
  %0 = sext i32 %.247 to i64
  %.250.idx = mul nsw i64 %0, 24
  %.253 = tail call ptr @malloc(i64 %.250.idx)
  %.254 = insertvalue { ptr, i32 } zeroinitializer, ptr %.253, 0
  %reduction_array.1 = insertvalue { ptr, i32 } %.254, i32 0, 1
  %.256 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %reduction_array.1, 1
  %.23235 = icmp sgt i64 %.243, 0
  %or.cond236 = or i1 %.11, %.23235
  br i1 %or.cond236, label %Loop_2_entry.lr.ph, label %Loop_1_follower

Loop_2_entry.lr.ph:                               ; preds = %entry
  %.4.fr = freeze { i1, i64 } %.4
  %.5.fr = freeze { i1, i64 } %.5
  %.2.fr = freeze { i1, { ptr, i32 } } %.2
  %.29 = extractvalue { i1, i64 } %.4.fr, 0
  %.182 = extractvalue { i1, i64 } %.4.fr, 1
  %.186 = trunc i64 %.182 to i32
  %1 = sext i32 %.186 to i64
  %.189.idx = mul nsw i64 %1, 12
  %.41112 = icmp sgt i64 %.182, 0
  %or.cond1113 = or i1 %.29, %.41112
  %.47 = extractvalue { i1, i64 } %.5.fr, 0
  %.58 = extractvalue { i1, i64 } %.5.fr, 1
  %.594 = icmp sgt i64 %.58, 0
  %or.cond25 = or i1 %.47, %.594
  %.61 = extractvalue { i1, { ptr, i32 } } %.1, 0
  %.67 = extractvalue { i1, { ptr, i32 } } %.1, 1
  %.68 = extractvalue { ptr, i32 } %.67, 1
  %.75 = extractvalue { ptr, i32 } %.67, 0
  %.101 = extractvalue { i1, { ptr, i32 } } %.2.fr, 0
  %.107 = extractvalue { i1, { ptr, i32 } } %.2.fr, 1
  %.108 = extractvalue { ptr, i32 } %.107, 1
  %.115 = extractvalue { ptr, i32 } %.107, 0
  br label %Loop_2_entry

Loop_1_follower:                                  ; preds = %Loop_1_reduction_0_init, %entry
  %.241.lcssa = phi { i1, { ptr, i32 } } [ %.256, %entry ], [ %.242, %Loop_1_reduction_0_init ]
  ret { i1, { ptr, i32 } } %.241.lcssa

Loop_2_entry:                                     ; preds = %Loop_2_entry.lr.ph, %Loop_1_reduction_0_init
  %.21240 = phi i64 [ 1, %Loop_2_entry.lr.ph ], [ %.18, %Loop_1_reduction_0_init ]
  %i239 = phi { i1, i64 } [ { i1 false, i64 1 }, %Loop_2_entry.lr.ph ], [ %.20, %Loop_1_reduction_0_init ]
  %.241238 = phi { i1, { ptr, i32 } } [ %.256, %Loop_2_entry.lr.ph ], [ %.242, %Loop_1_reduction_0_init ]
  %allocated_size_red_1.1237 = phi i32 [ %.247, %Loop_2_entry.lr.ph ], [ %.296, %Loop_1_reduction_0_init ]
  %.192 = tail call ptr @malloc(i64 %.189.idx)
  %.193 = insertvalue { ptr, i32 } zeroinitializer, ptr %.192, 0
  %reduction_array = insertvalue { ptr, i32 } %.193, i32 0, 1
  %.195 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %reduction_array, 1
  br i1 %or.cond1113, label %Loop_3_entry.lr.ph, label %Loop_2_follower

Loop_3_entry.lr.ph:                               ; preds = %Loop_2_entry
  %.63 = extractvalue { i1, i64 } %i239, 0
  %.64 = or i1 %.61, %.63
  %.69 = trunc i64 %.21240 to i32
  %.70 = add i32 %.69, -1
  %.71 = icmp slt i32 %.70, 0
  %.72 = icmp slt i32 %.68, %.70
  %.73 = or i1 %.71, %.72
  %2 = zext nneg i32 %.70 to i64
  %.76 = getelementptr { i1, { ptr, i32 } }, ptr %.75, i64 %2
  br i1 %or.cond25, label %Loop_3_entry.us.preheader, label %Loop_3_entry.lr.ph.split

Loop_3_entry.us.preheader:                        ; preds = %Loop_3_entry.lr.ph
  %brmerge = select i1 %.64, i1 true, i1 %.73
  br label %Loop_3_entry.us

Loop_3_entry.us:                                  ; preds = %Loop_3_entry.us.preheader, %Loop_2_reduction_0_init.us
  %.39117.us = phi i64 [ %.36.us, %Loop_2_reduction_0_init.us ], [ 1, %Loop_3_entry.us.preheader ]
  %j116.us = phi { i1, i64 } [ %.38.us, %Loop_2_reduction_0_init.us ], [ { i1 false, i64 1 }, %Loop_3_entry.us.preheader ]
  %.180115.us = phi { i1, { ptr, i32 } } [ %.181.us, %Loop_2_reduction_0_init.us ], [ %.195, %Loop_3_entry.us.preheader ]
  %allocated_size_red_1114.us = phi i32 [ %.235.us, %Loop_2_reduction_0_init.us ], [ %.186, %Loop_3_entry.us.preheader ]
  %.123.us = extractvalue { i1, i64 } %j116.us, 0
  %.129.us = trunc i64 %.39117.us to i32
  %.130.us = add i32 %.129.us, -1
  %3 = zext nneg i32 %.130.us to i64
  br i1 %.101, label %Loop_3_body_start.lr.ph.split.us.us, label %Loop_3_body_start.lr.ph.split.us152

Loop_2_reduction_1_cond_block.us:                 ; preds = %Loop_3_header_start.Loop_3_follower_crit_edge.us
  %.207.us = extractvalue { i1, { ptr, i32 } } %.180115.us, 1
  %.208.us = extractvalue { ptr, i32 } %.207.us, 1
  %.209.us = add i32 %.208.us, 1
  %.210.us = insertvalue { ptr, i32 } %.207.us, i32 %.209.us, 1
  %.211.us = icmp ugt i32 %.209.us, %allocated_size_red_1114.us
  br i1 %.211.us, label %arr_size_exceeds_allocated.us, label %arr_size_exceeds_allocated_not.us

arr_size_exceeds_allocated_not.us:                ; preds = %Loop_2_reduction_1_cond_block.us
  %4 = sext i32 %.208.us to i64
  %.228.us = getelementptr { i1, i64 }, ptr %.192, i64 %4
  store { i1, i64 } %.us-phi.us, ptr %.228.us, align 4
  %.233.us = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.210.us, 1
  br label %Loop_2_reduction_0_init.us

arr_size_exceeds_allocated.us:                    ; preds = %Loop_2_reduction_1_cond_block.us
  %.213.us = shl i32 %allocated_size_red_1114.us, 1
  %5 = sext i32 %.213.us to i64
  %.216.idx.us = mul nsw i64 %5, 12
  %.219.us = tail call ptr @realloc(ptr %.192, i64 %.216.idx.us)
  %6 = sext i32 %.208.us to i64
  %.220.us = getelementptr { i1, i64 }, ptr %.219.us, i64 %6
  store { i1, i64 } %.us-phi.us, ptr %.220.us, align 4
  %.224.us = insertvalue { ptr, i32 } %.210.us, ptr %.219.us, 0
  %.226.us = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.224.us, 1
  br label %Loop_2_reduction_0_init.us

Loop_2_reduction_0_init.us:                       ; preds = %arr_size_exceeds_allocated.us, %arr_size_exceeds_allocated_not.us, %Loop_3_header_start.Loop_3_follower_crit_edge.us
  %.181.us = phi { i1, { ptr, i32 } } [ %.226.us, %arr_size_exceeds_allocated.us ], [ %.233.us, %arr_size_exceeds_allocated_not.us ], [ { i1 true, { ptr, i32 } zeroinitializer }, %Loop_3_header_start.Loop_3_follower_crit_edge.us ]
  %.235.us = phi i32 [ %.213.us, %arr_size_exceeds_allocated.us ], [ %allocated_size_red_1114.us, %arr_size_exceeds_allocated_not.us ], [ undef, %Loop_3_header_start.Loop_3_follower_crit_edge.us ]
  %.36.us = add i64 %.39117.us, 1
  %.38.us = insertvalue { i1, i64 } zeroinitializer, i64 %.36.us, 1
  %.41.us = icmp sle i64 %.36.us, %.182
  %or.cond1.us = select i1 %.29, i1 true, i1 %.41.us
  br i1 %or.cond1.us, label %Loop_3_entry.us, label %Loop_2_follower

Loop_3_body_start.us119:                          ; preds = %Loop_3_body_start.us119.preheader, %ArrayAccess_phi_block.3.us
  %.578.us120 = phi i64 [ %.54.us148, %ArrayAccess_phi_block.3.us ], [ 1, %Loop_3_body_start.us119.preheader ]
  %k7.us121 = phi { i1, i64 } [ %.56.us149, %ArrayAccess_phi_block.3.us ], [ { i1 false, i64 1 }, %Loop_3_body_start.us119.preheader ]
  %.1536.us = phi { i1, i64 } [ %.154.us, %ArrayAccess_phi_block.3.us ], [ zeroinitializer, %Loop_3_body_start.us119.preheader ]
  br i1 %brmerge, label %ArrayAccess_phi_block.us124, label %ArrayAccess_correct_exec_block.us122

ArrayAccess_correct_exec_block.us122:             ; preds = %Loop_3_body_start.us119
  %.77.us123 = load { i1, { ptr, i32 } }, ptr %.76, align 8
  br label %ArrayAccess_phi_block.us124

ArrayAccess_phi_block.us124:                      ; preds = %Loop_3_body_start.us119, %ArrayAccess_correct_exec_block.us122
  %.80.us125 = phi { i1, { ptr, i32 } } [ %.77.us123, %ArrayAccess_correct_exec_block.us122 ], [ { i1 true, { ptr, i32 } zeroinitializer }, %Loop_3_body_start.us119 ]
  %.81.us126 = extractvalue { i1, { ptr, i32 } } %.80.us125, 0
  %.83.us127 = extractvalue { i1, i64 } %k7.us121, 0
  %.84.us128 = or i1 %.83.us127, %.81.us126
  br i1 %.84.us128, label %ArrayAccess_phi_block.1.us138, label %array_access_out_of_bounds_check.1.us129

array_access_out_of_bounds_check.1.us129:         ; preds = %ArrayAccess_phi_block.us124
  %.87.us130 = extractvalue { i1, { ptr, i32 } } %.80.us125, 1
  %.88.us131 = extractvalue { ptr, i32 } %.87.us130, 1
  %7 = add i64 %.578.us120, -1
  %tmp332 = trunc i64 %7 to i32
  %.91.us134 = icmp slt i32 %tmp332, 0
  %tmp331 = trunc i64 %7 to i32
  %.92.us135 = icmp slt i32 %.88.us131, %tmp331
  %.93.us136 = or i1 %.91.us134, %.92.us135
  br i1 %.93.us136, label %ArrayAccess_phi_block.1.us138, label %ArrayAccess_correct_exec_block.1.us137

ArrayAccess_correct_exec_block.1.us137:           ; preds = %array_access_out_of_bounds_check.1.us129
  %.95.us = extractvalue { ptr, i32 } %.87.us130, 0
  %tmp330 = trunc i64 %7 to i32
  %8 = zext nneg i32 %tmp330 to i64
  %.96.us = getelementptr { i1, i64 }, ptr %.95.us, i64 %8
  %.97.us = load { i1, i64 }, ptr %.96.us, align 4
  br label %ArrayAccess_phi_block.1.us138

ArrayAccess_phi_block.1.us138:                    ; preds = %ArrayAccess_correct_exec_block.1.us137, %array_access_out_of_bounds_check.1.us129, %ArrayAccess_phi_block.us124
  %.100.us = phi { i1, i64 } [ %.97.us, %ArrayAccess_correct_exec_block.1.us137 ], [ { i1 true, i64 0 }, %array_access_out_of_bounds_check.1.us129 ], [ { i1 true, i64 0 }, %ArrayAccess_phi_block.us124 ]
  br i1 %.83.us127, label %ArrayAccess_phi_block.2.us, label %array_access_out_of_bounds_check.2.us139

array_access_out_of_bounds_check.2.us139:         ; preds = %ArrayAccess_phi_block.1.us138
  %9 = add i64 %.578.us120, -1
  %tmp329 = trunc i64 %9 to i32
  %.111.us142 = icmp slt i32 %tmp329, 0
  %tmp328 = trunc i64 %9 to i32
  %.112.us143 = icmp slt i32 %.108, %tmp328
  %.113.us144 = or i1 %.111.us142, %.112.us143
  br i1 %.113.us144, label %ArrayAccess_phi_block.2.us, label %ArrayAccess_correct_exec_block.2.us145

ArrayAccess_correct_exec_block.2.us145:           ; preds = %array_access_out_of_bounds_check.2.us139
  %tmp = trunc i64 %9 to i32
  %10 = zext nneg i32 %tmp to i64
  %.116.us146 = getelementptr { i1, { ptr, i32 } }, ptr %.115, i64 %10
  %.117.us147 = load { i1, { ptr, i32 } }, ptr %.116.us146, align 8
  br label %ArrayAccess_phi_block.2.us

ArrayAccess_phi_block.2.us:                       ; preds = %ArrayAccess_correct_exec_block.2.us145, %array_access_out_of_bounds_check.2.us139, %ArrayAccess_phi_block.1.us138
  %.120.us = phi { i1, { ptr, i32 } } [ %.117.us147, %ArrayAccess_correct_exec_block.2.us145 ], [ { i1 true, { ptr, i32 } zeroinitializer }, %array_access_out_of_bounds_check.2.us139 ], [ { i1 true, { ptr, i32 } zeroinitializer }, %ArrayAccess_phi_block.1.us138 ]
  %.121.us = extractvalue { i1, { ptr, i32 } } %.120.us, 0
  %.124.us = or i1 %.123.us, %.121.us
  br i1 %.124.us, label %ArrayAccess_phi_block.3.us, label %array_access_out_of_bounds_check.3.us

array_access_out_of_bounds_check.3.us:            ; preds = %ArrayAccess_phi_block.2.us
  %11 = trunc i64 %3 to i32
  %12 = trunc i64 %3 to i32
  %13 = icmp slt i32 %12, 0
  %.127.us = extractvalue { i1, { ptr, i32 } } %.120.us, 1
  %.128.us = extractvalue { ptr, i32 } %.127.us, 1
  %.132.us = icmp slt i32 %.128.us, %11
  %.133.us = or i1 %13, %.132.us
  br i1 %.133.us, label %ArrayAccess_phi_block.3.us, label %ArrayAccess_correct_exec_block.3.us

ArrayAccess_correct_exec_block.3.us:              ; preds = %array_access_out_of_bounds_check.3.us
  %.135.us = extractvalue { ptr, i32 } %.127.us, 0
  %.136.us = getelementptr { i1, i64 }, ptr %.135.us, i64 %3
  %.137.us = load { i1, i64 }, ptr %.136.us, align 4
  br label %ArrayAccess_phi_block.3.us

ArrayAccess_phi_block.3.us:                       ; preds = %ArrayAccess_correct_exec_block.3.us, %array_access_out_of_bounds_check.3.us, %ArrayAccess_phi_block.2.us
  %.140.us = phi { i1, i64 } [ %.137.us, %ArrayAccess_correct_exec_block.3.us ], [ { i1 true, i64 0 }, %array_access_out_of_bounds_check.3.us ], [ { i1 true, i64 0 }, %ArrayAccess_phi_block.2.us ]
  %.141.us = extractvalue { i1, i64 } %.100.us, 0
  %.142.us = extractvalue { i1, i64 } %.100.us, 1
  %.143.us = extractvalue { i1, i64 } %.140.us, 0
  %.144.us = extractvalue { i1, i64 } %.140.us, 1
  %.146.us = or i1 %.141.us, %.143.us
  %Sij.us = mul i64 %.144.us, %.142.us
  %.149.us = select i1 %.146.us, i64 undef, i64 %Sij.us
  %.159.us = extractvalue { i1, i64 } %.1536.us, 0
  %.163.us = or i1 %.159.us, %.146.us
  %.169.us = extractvalue { i1, i64 } %.1536.us, 1
  %.171.us = add i64 %.149.us, %.169.us
  %.173.us = insertvalue { i1, i64 } zeroinitializer, i64 %.171.us, 1
  %.154.us = select i1 %.163.us, { i1, i64 } { i1 true, i64 0 }, { i1, i64 } %.173.us
  %.54.us148 = add i64 %.578.us120, 1
  %.56.us149 = insertvalue { i1, i64 } zeroinitializer, i64 %.54.us148, 1
  %.59.us150.not = icmp sgt i64 %.54.us148, %.58
  br i1 %.59.us150.not, label %Loop_3_header_start.Loop_3_follower_crit_edge.us, label %Loop_3_body_start.us119

Loop_3_body_start.lr.ph.split.us152:              ; preds = %Loop_3_entry.us
  br i1 %.47, label %Loop_3_body_start.us9.preheader, label %Loop_3_body_start.us119.preheader

Loop_3_body_start.us119.preheader:                ; preds = %Loop_3_body_start.lr.ph.split.us152
  br label %Loop_3_body_start.us119

Loop_3_body_start.us9.preheader:                  ; preds = %Loop_3_body_start.lr.ph.split.us152
  br label %Loop_3_body_start.us9

Loop_3_header_start.Loop_3_follower_crit_edge.us: ; preds = %ArrayAccess_phi_block.3.us, %Loop_3_body_start.us.us153, %Loop_3_body_start.us.us153.us226, %Loop_3_body_start.us.us153.us, %Loop_3_body_start.us.us74.us.us
  %.us-phi.us = phi { i1, i64 } [ { i1 true, i64 0 }, %Loop_3_body_start.us.us74.us.us ], [ { i1 true, i64 0 }, %Loop_3_body_start.us.us153.us ], [ { i1 true, i64 0 }, %Loop_3_body_start.us.us153.us226 ], [ { i1 true, i64 0 }, %Loop_3_body_start.us.us153 ], [ %.154.us, %ArrayAccess_phi_block.3.us ]
  %.198.us = extractvalue { i1, { ptr, i32 } } %.180115.us, 0
  br i1 %.198.us, label %Loop_2_reduction_0_init.us, label %Loop_2_reduction_1_cond_block.us

Loop_3_body_start.lr.ph.split.us.us:              ; preds = %Loop_3_entry.us
  br i1 %.47, label %Loop_3_body_start.us.us.preheader, label %Loop_3_body_start.lr.ph.split.us.split.us176

Loop_3_body_start.us.us.preheader:                ; preds = %Loop_3_body_start.lr.ph.split.us.us
  br label %Loop_3_body_start.us.us

Loop_3_body_start.us.us153:                       ; preds = %Loop_3_body_start.us.us153.preheader, %Loop_3_body_start.us.us153
  %.578.us.us154 = phi i64 [ %.54.us.us173, %Loop_3_body_start.us.us153 ], [ 1, %Loop_3_body_start.us.us153.preheader ]
  %.54.us.us173 = add i64 %.578.us.us154, 1
  %.59.us.us.not = icmp sgt i64 %.54.us.us173, %.58
  br i1 %.59.us.us.not, label %Loop_3_header_start.Loop_3_follower_crit_edge.us, label %Loop_3_body_start.us.us153

Loop_3_body_start.lr.ph.split.us.split.us176:     ; preds = %Loop_3_body_start.lr.ph.split.us.us
  br i1 %.64, label %Loop_3_body_start.us.us74.us.us.preheader, label %Loop_3_body_start.lr.ph.split.us.split.split.us177

Loop_3_body_start.us.us74.us.us.preheader:        ; preds = %Loop_3_body_start.lr.ph.split.us.split.us176
  br label %Loop_3_body_start.us.us74.us.us

Loop_3_body_start.lr.ph.split.us.split.split.us177: ; preds = %Loop_3_body_start.lr.ph.split.us.split.us176
  br i1 %.73, label %Loop_3_body_start.us.us153.us.preheader, label %Loop_3_body_start.lr.ph.split.us.split.split.us177.split

Loop_3_body_start.us.us153.us.preheader:          ; preds = %Loop_3_body_start.lr.ph.split.us.split.split.us177
  br label %Loop_3_body_start.us.us153.us

Loop_3_body_start.us.us153.us:                    ; preds = %Loop_3_body_start.us.us153.us.preheader, %Loop_3_body_start.us.us153.us
  %.578.us.us154.us = phi i64 [ %.54.us.us173.us, %Loop_3_body_start.us.us153.us ], [ 1, %Loop_3_body_start.us.us153.us.preheader ]
  %.54.us.us173.us = add i64 %.578.us.us154.us, 1
  %.59.us.us.us.not = icmp sgt i64 %.54.us.us173.us, %.58
  br i1 %.59.us.us.us.not, label %Loop_3_header_start.Loop_3_follower_crit_edge.us, label %Loop_3_body_start.us.us153.us

Loop_3_body_start.lr.ph.split.us.split.split.us177.split: ; preds = %Loop_3_body_start.lr.ph.split.us.split.split.us177
  %.81.us.us160 = load i1, ptr %.76, align 1
  %.81.us.us160.fr = freeze i1 %.81.us.us160
  br i1 %.81.us.us160.fr, label %Loop_3_body_start.us.us153.us226.preheader, label %Loop_3_body_start.us.us153.preheader

Loop_3_body_start.us.us153.preheader:             ; preds = %Loop_3_body_start.lr.ph.split.us.split.split.us177.split
  br label %Loop_3_body_start.us.us153

Loop_3_body_start.us.us153.us226.preheader:       ; preds = %Loop_3_body_start.lr.ph.split.us.split.split.us177.split
  br label %Loop_3_body_start.us.us153.us226

Loop_3_body_start.us.us153.us226:                 ; preds = %Loop_3_body_start.us.us153.us226.preheader, %Loop_3_body_start.us.us153.us226
  %.578.us.us154.us227 = phi i64 [ %.54.us.us173.us232, %Loop_3_body_start.us.us153.us226 ], [ 1, %Loop_3_body_start.us.us153.us226.preheader ]
  %.54.us.us173.us232 = add i64 %.578.us.us154.us227, 1
  %.59.us.us.us234.not = icmp sgt i64 %.54.us.us173.us232, %.58
  br i1 %.59.us.us.us234.not, label %Loop_3_header_start.Loop_3_follower_crit_edge.us, label %Loop_3_body_start.us.us153.us226

Loop_3_body_start.us.us74.us.us:                  ; preds = %Loop_3_body_start.us.us74.us.us.preheader, %Loop_3_body_start.us.us74.us.us
  %.578.us.us75.us.us = phi i64 [ %.54.us.us108.us.us, %Loop_3_body_start.us.us74.us.us ], [ 1, %Loop_3_body_start.us.us74.us.us.preheader ]
  %.54.us.us108.us.us = add i64 %.578.us.us75.us.us, 1
  %.59.us.us.us.us.not = icmp sgt i64 %.54.us.us108.us.us, %.58
  br i1 %.59.us.us.us.us.not, label %Loop_3_header_start.Loop_3_follower_crit_edge.us, label %Loop_3_body_start.us.us74.us.us

Loop_3_entry.lr.ph.split:                         ; preds = %Loop_3_entry.lr.ph
  br i1 %.29, label %Loop_3_entry.us193.outer.preheader, label %Loop_3_entry.preheader

Loop_3_entry.preheader:                           ; preds = %Loop_3_entry.lr.ph.split
  br label %Loop_3_entry

Loop_3_entry.us193.outer.preheader:               ; preds = %Loop_3_entry.lr.ph.split
  br label %Loop_3_entry.us193.outer

Loop_3_entry.us193.outer:                         ; preds = %arr_size_exceeds_allocated.us207, %Loop_3_entry.us193, %Loop_3_entry.us193.outer.preheader
  %.180115.us195.ph = phi { i1, { ptr, i32 } } [ %.195, %Loop_3_entry.us193.outer.preheader ], [ %.226.us213, %arr_size_exceeds_allocated.us207 ], [ { i1 true, { ptr, i32 } zeroinitializer }, %Loop_3_entry.us193 ]
  %allocated_size_red_1114.us196.ph = phi i32 [ %.186, %Loop_3_entry.us193.outer.preheader ], [ %.213.us208, %arr_size_exceeds_allocated.us207 ], [ undef, %Loop_3_entry.us193 ]
  br label %Loop_3_entry.us193

Loop_3_entry.us193:                               ; preds = %Loop_3_entry.us193.outer, %arr_size_exceeds_allocated_not.us204
  %.180115.us195 = phi { i1, { ptr, i32 } } [ %.233.us206, %arr_size_exceeds_allocated_not.us204 ], [ %.180115.us195.ph, %Loop_3_entry.us193.outer ]
  %.198.us197 = extractvalue { i1, { ptr, i32 } } %.180115.us195, 0
  br i1 %.198.us197, label %Loop_3_entry.us193.outer, label %Loop_2_reduction_1_cond_block.us198

Loop_2_reduction_1_cond_block.us198:              ; preds = %Loop_3_entry.us193
  %.207.us199 = extractvalue { i1, { ptr, i32 } } %.180115.us195, 1
  %.208.us200 = extractvalue { ptr, i32 } %.207.us199, 1
  %.209.us201 = add i32 %.208.us200, 1
  %.210.us202 = insertvalue { ptr, i32 } %.207.us199, i32 %.209.us201, 1
  %.211.us203 = icmp ugt i32 %.209.us201, %allocated_size_red_1114.us196.ph
  br i1 %.211.us203, label %arr_size_exceeds_allocated.us207, label %arr_size_exceeds_allocated_not.us204

arr_size_exceeds_allocated_not.us204:             ; preds = %Loop_2_reduction_1_cond_block.us198
  %14 = sext i32 %.208.us200 to i64
  %.228.us205 = getelementptr { i1, i64 }, ptr %.192, i64 %14
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %.228.us205, i8 0, i64 12, i1 false)
  %.233.us206 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.210.us202, 1
  br label %Loop_3_entry.us193

arr_size_exceeds_allocated.us207:                 ; preds = %Loop_2_reduction_1_cond_block.us198
  %.213.us208 = shl i32 %allocated_size_red_1114.us196.ph, 1
  %15 = sext i32 %.213.us208 to i64
  %.216.idx.us209 = mul nsw i64 %15, 12
  %.219.us210 = tail call ptr @realloc(ptr %.192, i64 %.216.idx.us209)
  %16 = sext i32 %.208.us200 to i64
  %.220.us211 = getelementptr { i1, i64 }, ptr %.219.us210, i64 %16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %.220.us211, i8 0, i64 12, i1 false)
  %.224.us212 = insertvalue { ptr, i32 } %.210.us202, ptr %.219.us210, 0
  %.226.us213 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.224.us212, 1
  br label %Loop_3_entry.us193.outer

Loop_2_follower:                                  ; preds = %Loop_2_reduction_0_init, %Loop_2_reduction_0_init.us, %Loop_2_entry
  %.180.lcssa = phi { i1, { ptr, i32 } } [ %.195, %Loop_2_entry ], [ %.181.us, %Loop_2_reduction_0_init.us ], [ %.181, %Loop_2_reduction_0_init ]
  %.259 = extractvalue { i1, { ptr, i32 } } %.241238, 0
  br i1 %.259, label %Loop_1_reduction_0_init, label %Loop_1_reduction_1_cond_block

Loop_3_entry:                                     ; preds = %Loop_3_entry.preheader, %Loop_2_reduction_0_init
  %.39117 = phi i64 [ %.36, %Loop_2_reduction_0_init ], [ 1, %Loop_3_entry.preheader ]
  %.180115 = phi { i1, { ptr, i32 } } [ %.181, %Loop_2_reduction_0_init ], [ %.195, %Loop_3_entry.preheader ]
  %allocated_size_red_1114 = phi i32 [ %.235, %Loop_2_reduction_0_init ], [ %.186, %Loop_3_entry.preheader ]
  %.198 = extractvalue { i1, { ptr, i32 } } %.180115, 0
  br i1 %.198, label %Loop_2_reduction_0_init, label %Loop_2_reduction_1_cond_block

Loop_3_body_start.us.us:                          ; preds = %Loop_3_body_start.us.us.preheader, %Loop_3_body_start.us.us
  br label %Loop_3_body_start.us.us

Loop_3_body_start.us9:                            ; preds = %Loop_3_body_start.us9.preheader, %Loop_3_body_start.us9
  br label %Loop_3_body_start.us9

Loop_2_reduction_0_init:                          ; preds = %Loop_3_entry, %arr_size_exceeds_allocated_not, %arr_size_exceeds_allocated
  %.181 = phi { i1, { ptr, i32 } } [ %.226, %arr_size_exceeds_allocated ], [ %.233, %arr_size_exceeds_allocated_not ], [ { i1 true, { ptr, i32 } zeroinitializer }, %Loop_3_entry ]
  %.235 = phi i32 [ %.213, %arr_size_exceeds_allocated ], [ %allocated_size_red_1114, %arr_size_exceeds_allocated_not ], [ undef, %Loop_3_entry ]
  %.36 = add i64 %.39117, 1
  %.41.not = icmp sgt i64 %.36, %.182
  br i1 %.41.not, label %Loop_2_follower, label %Loop_3_entry

Loop_2_reduction_1_cond_block:                    ; preds = %Loop_3_entry
  %.207 = extractvalue { i1, { ptr, i32 } } %.180115, 1
  %.208 = extractvalue { ptr, i32 } %.207, 1
  %.209 = add i32 %.208, 1
  %.210 = insertvalue { ptr, i32 } %.207, i32 %.209, 1
  %.211 = icmp ugt i32 %.209, %allocated_size_red_1114
  br i1 %.211, label %arr_size_exceeds_allocated, label %arr_size_exceeds_allocated_not

arr_size_exceeds_allocated:                       ; preds = %Loop_2_reduction_1_cond_block
  %.213 = shl i32 %allocated_size_red_1114, 1
  %17 = sext i32 %.213 to i64
  %.216.idx = mul nsw i64 %17, 12
  %.219 = tail call ptr @realloc(ptr %.192, i64 %.216.idx)
  %18 = sext i32 %.208 to i64
  %.220 = getelementptr { i1, i64 }, ptr %.219, i64 %18
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %.220, i8 0, i64 12, i1 false)
  %.224 = insertvalue { ptr, i32 } %.210, ptr %.219, 0
  %.226 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.224, 1
  br label %Loop_2_reduction_0_init

arr_size_exceeds_allocated_not:                   ; preds = %Loop_2_reduction_1_cond_block
  %19 = sext i32 %.208 to i64
  %.228 = getelementptr { i1, i64 }, ptr %.192, i64 %19
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %.228, i8 0, i64 12, i1 false)
  %.233 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.210, 1
  br label %Loop_2_reduction_0_init

Loop_1_reduction_0_init:                          ; preds = %Loop_2_follower, %arr_size_exceeds_allocated_not.1, %arr_size_exceeds_allocated.1
  %.242 = phi { i1, { ptr, i32 } } [ %.287, %arr_size_exceeds_allocated.1 ], [ %.294, %arr_size_exceeds_allocated_not.1 ], [ { i1 true, { ptr, i32 } zeroinitializer }, %Loop_2_follower ]
  %.296 = phi i32 [ %.274, %arr_size_exceeds_allocated.1 ], [ %allocated_size_red_1.1237, %arr_size_exceeds_allocated_not.1 ], [ undef, %Loop_2_follower ]
  %.18 = add i64 %.21240, 1
  %.20 = insertvalue { i1, i64 } zeroinitializer, i64 %.18, 1
  %.23 = icmp sle i64 %.18, %.243
  %or.cond = select i1 %.11, i1 true, i1 %.23
  br i1 %or.cond, label %Loop_2_entry, label %Loop_1_follower

Loop_1_reduction_1_cond_block:                    ; preds = %Loop_2_follower
  %.268 = extractvalue { i1, { ptr, i32 } } %.241238, 1
  %.269 = extractvalue { ptr, i32 } %.268, 1
  %.270 = add i32 %.269, 1
  %.271 = insertvalue { ptr, i32 } %.268, i32 %.270, 1
  %.272 = icmp ugt i32 %.270, %allocated_size_red_1.1237
  br i1 %.272, label %arr_size_exceeds_allocated.1, label %arr_size_exceeds_allocated_not.1

arr_size_exceeds_allocated.1:                     ; preds = %Loop_1_reduction_1_cond_block
  %.274 = shl i32 %allocated_size_red_1.1237, 1
  %20 = sext i32 %.274 to i64
  %.277.idx = mul nsw i64 %20, 24
  %.280 = tail call ptr @realloc(ptr %.253, i64 %.277.idx)
  %21 = sext i32 %.269 to i64
  %.281 = getelementptr { i1, { ptr, i32 } }, ptr %.280, i64 %21
  store { i1, { ptr, i32 } } %.180.lcssa, ptr %.281, align 8
  %.285 = insertvalue { ptr, i32 } %.271, ptr %.280, 0
  %.287 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.285, 1
  br label %Loop_1_reduction_0_init

arr_size_exceeds_allocated_not.1:                 ; preds = %Loop_1_reduction_1_cond_block
  %22 = sext i32 %.269 to i64
  %.289 = getelementptr { i1, { ptr, i32 } }, ptr %.253, i64 %22
  store { i1, { ptr, i32 } } %.180.lcssa, ptr %.289, align 8
  %.294 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.271, 1
  br label %Loop_1_reduction_0_init
}

; Function Attrs: nounwind
define noundef i32 @main({ ptr, i32 } %.1, { ptr, i32 } %.2, i64 %.3, i64 %.4, i64 %.5) local_unnamed_addr #4 {
.7:
  %.8 = extractvalue { ptr, i32 } %.1, 0
  %.9 = extractvalue { ptr, i32 } %.1, 1
  %0 = sext i32 %.9 to i64
  %.12.idx = mul nsw i64 %0, 24
  %.15 = tail call ptr @malloc(i64 %.12.idx)
  %.1828 = icmp sgt i32 %.9, 0
  br i1 %.1828, label %array_converter_loop_body_start.preheader, label %array_converter_loop_follower

array_converter_loop_body_start.preheader:        ; preds = %.7
  br label %array_converter_loop_body_start

array_converter_loop_body_start:                  ; preds = %array_converter_loop_body_start.preheader, %array_converter_loop_follower.1
  %.1729 = phi i32 [ %.50, %array_converter_loop_follower.1 ], [ 0, %array_converter_loop_body_start.preheader ]
  %1 = zext nneg i32 %.1729 to i64
  %.20 = getelementptr { ptr, i32 }, ptr %.8, i64 %1
  %.21 = load { ptr, i32 }, ptr %.20, align 8
  %.22 = extractvalue { ptr, i32 } %.21, 0
  %.23 = extractvalue { ptr, i32 } %.21, 1
  %2 = sext i32 %.23 to i64
  %.26.idx = mul nsw i64 %2, 12
  %.29 = tail call ptr @malloc(i64 %.26.idx)
  %.3226 = icmp sgt i32 %.23, 0
  br i1 %.3226, label %array_converter_loop_body_start.1.preheader, label %array_converter_loop_follower.1

array_converter_loop_body_start.1.preheader:      ; preds = %array_converter_loop_body_start
  br label %array_converter_loop_body_start.1

array_converter_loop_follower:                    ; preds = %array_converter_loop_follower.1, %.7
  %.52 = insertvalue { ptr, i32 } zeroinitializer, ptr %.15, 0
  %.53 = insertvalue { ptr, i32 } %.52, i32 %.9, 1
  %.55 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.53, 1
  %.56 = extractvalue { ptr, i32 } %.2, 0
  %.57 = extractvalue { ptr, i32 } %.2, 1
  %3 = sext i32 %.57 to i64
  %.60.idx = mul nsw i64 %3, 24
  %.63 = tail call ptr @malloc(i64 %.60.idx)
  %.6632 = icmp sgt i32 %.57, 0
  br i1 %.6632, label %array_converter_loop_body_start.2.preheader, label %array_converter_loop_follower.2

array_converter_loop_body_start.2.preheader:      ; preds = %array_converter_loop_follower
  br label %array_converter_loop_body_start.2

array_converter_loop_body_start.1:                ; preds = %array_converter_loop_body_start.1.preheader, %array_converter_loop_body_start.1
  %lsr.iv40 = phi ptr [ %.29, %array_converter_loop_body_start.1.preheader ], [ %scevgep41, %array_converter_loop_body_start.1 ]
  %lsr.iv36 = phi i64 [ 0, %array_converter_loop_body_start.1.preheader ], [ %lsr.iv.next37, %array_converter_loop_body_start.1 ]
  %4 = shl nuw nsw i64 %lsr.iv36, 3
  %scevgep39 = getelementptr i8, ptr %.22, i64 %4
  %.35 = load i64, ptr %scevgep39, align 4
  %.37 = insertvalue { i1, i64 } zeroinitializer, i64 %.35, 1
  store { i1, i64 } %.37, ptr %lsr.iv40, align 4
  %lsr.iv.next37 = add nuw nsw i64 %lsr.iv36, 1
  %tmp38 = trunc i64 %lsr.iv.next37 to i32
  %scevgep41 = getelementptr i8, ptr %lsr.iv40, i64 16
  %.32 = icmp slt i32 %tmp38, %.23
  br i1 %.32, label %array_converter_loop_body_start.1, label %array_converter_loop_follower.1

array_converter_loop_follower.1:                  ; preds = %array_converter_loop_body_start.1, %array_converter_loop_body_start
  %5 = trunc i64 %1 to i32
  %.43 = insertvalue { ptr, i32 } zeroinitializer, ptr %.29, 0
  %.44 = insertvalue { ptr, i32 } %.43, i32 %.23, 1
  %.46 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.44, 1
  %.47 = getelementptr { i1, { ptr, i32 } }, ptr %.15, i64 %1
  store { i1, { ptr, i32 } } %.46, ptr %.47, align 8
  %.50 = add nuw nsw i32 %5, 1
  %.18 = icmp slt i32 %.50, %.9
  br i1 %.18, label %array_converter_loop_body_start, label %array_converter_loop_follower

array_converter_loop_body_start.2:                ; preds = %array_converter_loop_body_start.2.preheader, %array_converter_loop_follower.3
  %.6533 = phi i32 [ %.98, %array_converter_loop_follower.3 ], [ 0, %array_converter_loop_body_start.2.preheader ]
  %6 = zext nneg i32 %.6533 to i64
  %.68 = getelementptr { ptr, i32 }, ptr %.56, i64 %6
  %.69 = load { ptr, i32 }, ptr %.68, align 8
  %.70 = extractvalue { ptr, i32 } %.69, 0
  %.71 = extractvalue { ptr, i32 } %.69, 1
  %7 = sext i32 %.71 to i64
  %.74.idx = mul nsw i64 %7, 12
  %.77 = tail call ptr @malloc(i64 %.74.idx)
  %.8030 = icmp sgt i32 %.71, 0
  br i1 %.8030, label %array_converter_loop_body_start.3.preheader, label %array_converter_loop_follower.3

array_converter_loop_body_start.3.preheader:      ; preds = %array_converter_loop_body_start.2
  br label %array_converter_loop_body_start.3

array_converter_loop_follower.2:                  ; preds = %array_converter_loop_follower.3, %array_converter_loop_follower
  %.100 = insertvalue { ptr, i32 } zeroinitializer, ptr %.63, 0
  %.101 = insertvalue { ptr, i32 } %.100, i32 %.57, 1
  %.103 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.101, 1
  %.105 = insertvalue { i1, i64 } zeroinitializer, i64 %.3, 1
  %.107 = insertvalue { i1, i64 } zeroinitializer, i64 %.4, 1
  %.109 = insertvalue { i1, i64 } zeroinitializer, i64 %.5, 1
  %.110 = tail call { i1, { ptr, i32 } } @sisal_main({ i1, { ptr, i32 } } %.55, { i1, { ptr, i32 } } %.103, { i1, i64 } %.105, { i1, i64 } %.107, { i1, i64 } %.109)
  %.111 = extractvalue { i1, { ptr, i32 } } %.110, 0
  br i1 %.111, label %val_errored, label %val_not_errored

array_converter_loop_body_start.3:                ; preds = %array_converter_loop_body_start.3.preheader, %array_converter_loop_body_start.3
  %lsr.iv34 = phi ptr [ %.77, %array_converter_loop_body_start.3.preheader ], [ %scevgep35, %array_converter_loop_body_start.3 ]
  %lsr.iv = phi i64 [ 0, %array_converter_loop_body_start.3.preheader ], [ %lsr.iv.next, %array_converter_loop_body_start.3 ]
  %8 = shl nuw nsw i64 %lsr.iv, 3
  %scevgep = getelementptr i8, ptr %.70, i64 %8
  %.83 = load i64, ptr %scevgep, align 4
  %.85 = insertvalue { i1, i64 } zeroinitializer, i64 %.83, 1
  store { i1, i64 } %.85, ptr %lsr.iv34, align 4
  %lsr.iv.next = add nuw nsw i64 %lsr.iv, 1
  %tmp = trunc i64 %lsr.iv.next to i32
  %scevgep35 = getelementptr i8, ptr %lsr.iv34, i64 16
  %.80 = icmp slt i32 %tmp, %.71
  br i1 %.80, label %array_converter_loop_body_start.3, label %array_converter_loop_follower.3

array_converter_loop_follower.3:                  ; preds = %array_converter_loop_body_start.3, %array_converter_loop_body_start.2
  %9 = trunc i64 %6 to i32
  %.91 = insertvalue { ptr, i32 } zeroinitializer, ptr %.77, 0
  %.92 = insertvalue { ptr, i32 } %.91, i32 %.71, 1
  %.94 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.92, 1
  %.95 = getelementptr { i1, { ptr, i32 } }, ptr %.63, i64 %6
  store { i1, { ptr, i32 } } %.94, ptr %.95, align 8
  %.98 = add nuw nsw i32 %9, 1
  %.66 = icmp slt i32 %.98, %.57
  br i1 %.66, label %array_converter_loop_body_start.2, label %array_converter_loop_follower.2

val_errored:                                      ; preds = %array_converter_loop_follower.2
  %.113 = alloca [15 x i8], align 8
  store <8 x i8> <i8 76, i8 97, i8 109, i8 98, i8 100, i8 97, i8 48, i8 58>, ptr %.113, align 8
  %.113.repack19 = getelementptr inbounds nuw i8, ptr %.113, i64 8
  store <4 x i8> <i8 32, i8 69, i8 82, i8 82>, ptr %.113.repack19, align 8
  %.113.repack23 = getelementptr inbounds nuw i8, ptr %.113, i64 12
  store i8 79, ptr %.113.repack23, align 4
  %.113.repack24 = getelementptr inbounds nuw i8, ptr %.113, i64 13
  store i8 82, ptr %.113.repack24, align 1
  %.113.repack25 = getelementptr inbounds nuw i8, ptr %.113, i64 14
  store i8 0, ptr %.113.repack25, align 2
  br label %end_printf

val_not_errored:                                  ; preds = %array_converter_loop_follower.2
  %.117 = extractvalue { i1, { ptr, i32 } } %.110, 1
  %.118 = alloca [11 x i8], align 8
  store <8 x i8> <i8 76, i8 97, i8 109, i8 98, i8 100, i8 97, i8 48, i8 58>, ptr %.118, align 8
  %.118.repack8 = getelementptr inbounds nuw i8, ptr %.118, i64 8
  store i8 32, ptr %.118.repack8, align 8
  %.118.repack9 = getelementptr inbounds nuw i8, ptr %.118, i64 9
  store i8 91, ptr %.118.repack9, align 1
  %.118.repack10 = getelementptr inbounds nuw i8, ptr %.118, i64 10
  store i8 0, ptr %.118.repack10, align 2
  %.120 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.118)
  %.121 = extractvalue { ptr, i32 } %.117, 0
  %.122 = extractvalue { ptr, i32 } %.117, 1
  tail call void @array_print_loop_0(ptr %.121, i32 %.122)
  %.124 = alloca [2 x i8], align 1
  store i8 93, ptr %.124, align 1
  %.124.repack11 = getelementptr inbounds nuw i8, ptr %.124, i64 1
  store i8 0, ptr %.124.repack11, align 1
  br label %end_printf

end_printf:                                       ; preds = %val_not_errored, %val_errored
  %.124.sink = phi ptr [ %.124, %val_not_errored ], [ %.113, %val_errored ]
  %.126 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.124.sink)
  ret i32 0
}

; Function Attrs: nofree nounwind
define void @array_print_loop_0(ptr nocapture readonly %.1, i32 %.2) local_unnamed_addr #0 {
entry:
  %.4 = alloca [3 x i8], align 1
  store i8 44, ptr %.4, align 1
  %.fca.1.gep = getelementptr inbounds nuw i8, ptr %.4, i64 1
  store i8 32, ptr %.fca.1.gep, align 1
  %.fca.2.gep = getelementptr inbounds nuw i8, ptr %.4, i64 2
  store i8 0, ptr %.fca.2.gep, align 1
  %.88 = icmp eq i32 %.2, 0
  br i1 %.88, label %array_loop_follower, label %array_print_loop.peel

array_print_loop.peel:                            ; preds = %entry
  %.16.peel.pre = load { i1, { ptr, i32 } }, ptr %.1, align 8
  %.17.peel = extractvalue { i1, { ptr, i32 } } %.16.peel.pre, 0
  br i1 %.17.peel, label %val_errored.peel, label %val_not_errored.peel

val_not_errored.peel:                             ; preds = %array_print_loop.peel
  %.23.peel = extractvalue { i1, { ptr, i32 } } %.16.peel.pre, 1
  %.24.peel = alloca [2 x i8], align 1
  store i8 91, ptr %.24.peel, align 1
  %.24.repack1.peel = getelementptr inbounds nuw i8, ptr %.24.peel, i64 1
  store i8 0, ptr %.24.repack1.peel, align 1
  %.26.peel = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.24.peel)
  %.27.peel = extractvalue { ptr, i32 } %.23.peel, 0
  %.28.peel = extractvalue { ptr, i32 } %.23.peel, 1
  tail call void @array_print_loop_1(ptr %.27.peel, i32 %.28.peel)
  %.30.peel = alloca [2 x i8], align 1
  store i8 93, ptr %.30.peel, align 1
  %.30.repack2.peel = getelementptr inbounds nuw i8, ptr %.30.peel, i64 1
  store i8 0, ptr %.30.repack2.peel, align 1
  br label %end_printf.peel

val_errored.peel:                                 ; preds = %array_print_loop.peel
  %.19.peel = alloca [6 x i8], align 4
  store <4 x i8> <i8 69, i8 82, i8 82, i8 79>, ptr %.19.peel, align 4
  %.19.repack6.peel = getelementptr inbounds nuw i8, ptr %.19.peel, i64 4
  store i8 82, ptr %.19.repack6.peel, align 4
  %.19.repack7.peel = getelementptr inbounds nuw i8, ptr %.19.peel, i64 5
  store i8 0, ptr %.19.repack7.peel, align 1
  br label %end_printf.peel

end_printf.peel:                                  ; preds = %val_errored.peel, %val_not_errored.peel
  %.19.peel.sink = phi ptr [ %.19.peel, %val_errored.peel ], [ %.30.peel, %val_not_errored.peel ]
  %.21.peel = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.19.peel.sink)
  %.8.peel = icmp eq i32 %.2, 1
  br i1 %.8.peel, label %array_loop_follower, label %array_print_loop.preheader

array_print_loop.preheader:                       ; preds = %end_printf.peel
  br label %array_print_loop

array_print_loop:                                 ; preds = %array_print_loop.preheader, %end_printf
  %.79 = phi i32 [ %.34, %end_printf ], [ 1, %array_print_loop.preheader ]
  %.12 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.4)
  %0 = sext i32 %.79 to i64
  %.15 = getelementptr { i1, { ptr, i32 } }, ptr %.1, i64 %0
  %.16 = load { i1, { ptr, i32 } }, ptr %.15, align 8
  %.17 = extractvalue { i1, { ptr, i32 } } %.16, 0
  br i1 %.17, label %val_errored, label %val_not_errored

array_loop_follower:                              ; preds = %end_printf, %end_printf.peel, %entry
  ret void

val_errored:                                      ; preds = %array_print_loop
  %.19 = alloca [6 x i8], align 4
  store <4 x i8> <i8 69, i8 82, i8 82, i8 79>, ptr %.19, align 4
  %.19.repack6 = getelementptr inbounds nuw i8, ptr %.19, i64 4
  store i8 82, ptr %.19.repack6, align 4
  %.19.repack7 = getelementptr inbounds nuw i8, ptr %.19, i64 5
  store i8 0, ptr %.19.repack7, align 1
  br label %end_printf

val_not_errored:                                  ; preds = %array_print_loop
  %.23 = extractvalue { i1, { ptr, i32 } } %.16, 1
  %.24 = alloca [2 x i8], align 1
  store i8 91, ptr %.24, align 1
  %.24.repack1 = getelementptr inbounds nuw i8, ptr %.24, i64 1
  store i8 0, ptr %.24.repack1, align 1
  %.26 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.24)
  %.27 = extractvalue { ptr, i32 } %.23, 0
  %.28 = extractvalue { ptr, i32 } %.23, 1
  tail call void @array_print_loop_1(ptr %.27, i32 %.28)
  %.30 = alloca [2 x i8], align 1
  store i8 93, ptr %.30, align 1
  %.30.repack2 = getelementptr inbounds nuw i8, ptr %.30, i64 1
  store i8 0, ptr %.30.repack2, align 1
  br label %end_printf

end_printf:                                       ; preds = %val_not_errored, %val_errored
  %.30.sink = phi ptr [ %.30, %val_not_errored ], [ %.19, %val_errored ]
  %.32 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.30.sink)
  %.34 = add i32 %.79, 1
  %.8 = icmp eq i32 %.2, %.34
  br i1 %.8, label %array_loop_follower, label %array_print_loop, !llvm.loop !0
}

; Function Attrs: nofree nounwind
define void @array_print_loop_1(ptr nocapture readonly %.1, i32 %.2) local_unnamed_addr #0 {
entry:
  %.4 = alloca [3 x i8], align 1
  store i8 44, ptr %.4, align 1
  %.fca.1.gep = getelementptr inbounds nuw i8, ptr %.4, i64 1
  store i8 32, ptr %.fca.1.gep, align 1
  %.fca.2.gep = getelementptr inbounds nuw i8, ptr %.4, i64 2
  store i8 0, ptr %.fca.2.gep, align 1
  %.89 = icmp eq i32 %.2, 0
  br i1 %.89, label %array_loop_follower, label %array_print_loop.peel

array_print_loop.peel:                            ; preds = %entry
  %.16.peel.pre = load { i1, i64 }, ptr %.1, align 4
  %.17.peel = extractvalue { i1, i64 } %.16.peel.pre, 0
  br i1 %.17.peel, label %val_errored.peel, label %val_not_errored.peel

val_not_errored.peel:                             ; preds = %array_print_loop.peel
  %.23.peel = extractvalue { i1, i64 } %.16.peel.pre, 1
  %.24.peel = alloca [4 x i8], align 4
  store <4 x i8> <i8 37, i8 108, i8 100, i8 0>, ptr %.24.peel, align 4
  %.26.peel = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.24.peel, i64 %.23.peel)
  br label %end_printf.peel

val_errored.peel:                                 ; preds = %array_print_loop.peel
  %.19.peel = alloca [6 x i8], align 4
  store <4 x i8> <i8 69, i8 82, i8 82, i8 79>, ptr %.19.peel, align 4
  %.19.repack7.peel = getelementptr inbounds nuw i8, ptr %.19.peel, i64 4
  store i8 82, ptr %.19.repack7.peel, align 4
  %.19.repack8.peel = getelementptr inbounds nuw i8, ptr %.19.peel, i64 5
  store i8 0, ptr %.19.repack8.peel, align 1
  %.21.peel = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.19.peel)
  br label %end_printf.peel

end_printf.peel:                                  ; preds = %val_errored.peel, %val_not_errored.peel
  %.8.peel = icmp eq i32 %.2, 1
  br i1 %.8.peel, label %array_loop_follower, label %array_print_loop.preheader

array_print_loop.preheader:                       ; preds = %end_printf.peel
  br label %array_print_loop

array_print_loop:                                 ; preds = %array_print_loop.preheader, %end_printf
  %.710 = phi i32 [ %.28, %end_printf ], [ 1, %array_print_loop.preheader ]
  %.12 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.4)
  %0 = sext i32 %.710 to i64
  %.15 = getelementptr { i1, i64 }, ptr %.1, i64 %0
  %.16 = load { i1, i64 }, ptr %.15, align 4
  %.17 = extractvalue { i1, i64 } %.16, 0
  br i1 %.17, label %val_errored, label %val_not_errored

array_loop_follower:                              ; preds = %end_printf, %end_printf.peel, %entry
  ret void

val_errored:                                      ; preds = %array_print_loop
  %.19 = alloca [6 x i8], align 4
  store <4 x i8> <i8 69, i8 82, i8 82, i8 79>, ptr %.19, align 4
  %.19.repack7 = getelementptr inbounds nuw i8, ptr %.19, i64 4
  store i8 82, ptr %.19.repack7, align 4
  %.19.repack8 = getelementptr inbounds nuw i8, ptr %.19, i64 5
  store i8 0, ptr %.19.repack8, align 1
  %.21 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.19)
  br label %end_printf

val_not_errored:                                  ; preds = %array_print_loop
  %.23 = extractvalue { i1, i64 } %.16, 1
  %.24 = alloca [4 x i8], align 4
  store <4 x i8> <i8 37, i8 108, i8 100, i8 0>, ptr %.24, align 4
  %.26 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.24, i64 %.23)
  br label %end_printf

end_printf:                                       ; preds = %val_not_errored, %val_errored
  %.28 = add i32 %.710, 1
  %.8 = icmp eq i32 %.2, %.28
  br i1 %.8, label %array_loop_follower, label %array_print_loop, !llvm.loop !2
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #5

attributes #0 = { nofree nounwind }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #3 = { nounwind memory(readwrite, argmem: read) }
attributes #4 = { nounwind }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.peeled.count", i32 1}
!2 = distinct !{!2, !1}
