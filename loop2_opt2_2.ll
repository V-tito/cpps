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
  %.29 = extractvalue { i1, i64 } %.4, 0
  %.182 = extractvalue { i1, i64 } %.4, 1
  %.186 = trunc i64 %.182 to i32
  %1 = sext i32 %.186 to i64
  %.189.idx = mul nsw i64 %1, 12
  %.47 = extractvalue { i1, i64 } %.5, 0
  %.58 = extractvalue { i1, i64 } %.5, 1
  %.61 = extractvalue { i1, { ptr, i32 } } %.1, 0
  %.67 = extractvalue { i1, { ptr, i32 } } %.1, 1
  %.68 = extractvalue { ptr, i32 } %.67, 1
  %.75 = extractvalue { ptr, i32 } %.67, 0
  %.101 = extractvalue { i1, { ptr, i32 } } %.2, 0
  %.107 = extractvalue { i1, { ptr, i32 } } %.2, 1
  %.108 = extractvalue { ptr, i32 } %.107, 1
  %.115 = extractvalue { ptr, i32 } %.107, 0
  br label %Loop_1_header_start

Loop_1_header_start:                              ; preds = %Loop_1_reduction_0_init, %entry
  %allocated_size_red_1.1 = phi i32 [ %.247, %entry ], [ %.296, %Loop_1_reduction_0_init ]
  %.241 = phi { i1, { ptr, i32 } } [ %.256, %entry ], [ %.242, %Loop_1_reduction_0_init ]
  %i = phi { i1, i64 } [ { i1 false, i64 1 }, %entry ], [ %.20, %Loop_1_reduction_0_init ]
  %.21 = extractvalue { i1, i64 } %i, 1
  %.23 = icmp sle i64 %.21, %.243
  %or.cond = select i1 %.11, i1 true, i1 %.23
  br i1 %or.cond, label %Loop_2_entry, label %Loop_1_follower

Loop_1_follower:                                  ; preds = %Loop_1_header_start
  ret { i1, { ptr, i32 } } %.241

Loop_2_entry:                                     ; preds = %Loop_1_header_start
  %.192 = tail call ptr @malloc(i64 %.189.idx)
  %.193 = insertvalue { ptr, i32 } zeroinitializer, ptr %.192, 0
  %reduction_array = insertvalue { ptr, i32 } %.193, i32 0, 1
  %.195 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %reduction_array, 1
  %.63 = extractvalue { i1, i64 } %i, 0
  %.64 = or i1 %.61, %.63
  %.69 = trunc i64 %.21 to i32
  %.70 = add i32 %.69, -1
  %.71 = icmp slt i32 %.70, 0
  %.72 = icmp slt i32 %.68, %.70
  %.73 = or i1 %.71, %.72
  %2 = zext nneg i32 %.70 to i64
  %.76 = getelementptr { i1, { ptr, i32 } }, ptr %.75, i64 %2
  %brmerge = select i1 %.64, i1 true, i1 %.73
  br label %Loop_2_header_start

Loop_2_header_start:                              ; preds = %Loop_2_reduction_0_init, %Loop_2_entry
  %allocated_size_red_1 = phi i32 [ %.186, %Loop_2_entry ], [ %.235, %Loop_2_reduction_0_init ]
  %.180 = phi { i1, { ptr, i32 } } [ %.195, %Loop_2_entry ], [ %.181, %Loop_2_reduction_0_init ]
  %j = phi { i1, i64 } [ { i1 false, i64 1 }, %Loop_2_entry ], [ %.38, %Loop_2_reduction_0_init ]
  %.39 = extractvalue { i1, i64 } %j, 1
  %.41 = icmp sle i64 %.39, %.182
  %or.cond1 = select i1 %.29, i1 true, i1 %.41
  br i1 %or.cond1, label %Loop_3_entry, label %Loop_2_follower

Loop_2_follower:                                  ; preds = %Loop_2_header_start
  %.259 = extractvalue { i1, { ptr, i32 } } %.241, 0
  br i1 %.259, label %Loop_1_reduction_0_init, label %Loop_1_reduction_1_cond_block

Loop_3_entry:                                     ; preds = %Loop_2_header_start
  %.123 = extractvalue { i1, i64 } %j, 0
  %.129 = trunc i64 %.39 to i32
  %.130 = add i32 %.129, -1
  %3 = zext nneg i32 %.130 to i64
  br label %Loop_3_header_start

Loop_3_header_start:                              ; preds = %ArrayAccess_phi_block.3, %Loop_3_entry
  %.153 = phi { i1, i64 } [ zeroinitializer, %Loop_3_entry ], [ %.154, %ArrayAccess_phi_block.3 ]
  %k = phi { i1, i64 } [ { i1 false, i64 1 }, %Loop_3_entry ], [ %.56, %ArrayAccess_phi_block.3 ]
  %.57 = extractvalue { i1, i64 } %k, 1
  %.59 = icmp sle i64 %.57, %.58
  %or.cond2 = select i1 %.47, i1 true, i1 %.59
  br i1 %or.cond2, label %Loop_3_body_start, label %Loop_3_follower

Loop_3_body_start:                                ; preds = %Loop_3_header_start
  br i1 %brmerge, label %ArrayAccess_phi_block, label %ArrayAccess_correct_exec_block

Loop_3_follower:                                  ; preds = %Loop_3_header_start
  %.198 = extractvalue { i1, { ptr, i32 } } %.180, 0
  br i1 %.198, label %Loop_2_reduction_0_init, label %Loop_2_reduction_1_cond_block

ArrayAccess_correct_exec_block:                   ; preds = %Loop_3_body_start
  %.77 = load { i1, { ptr, i32 } }, ptr %.76, align 8
  br label %ArrayAccess_phi_block

ArrayAccess_phi_block:                            ; preds = %Loop_3_body_start, %ArrayAccess_correct_exec_block
  %.80 = phi { i1, { ptr, i32 } } [ %.77, %ArrayAccess_correct_exec_block ], [ { i1 true, { ptr, i32 } zeroinitializer }, %Loop_3_body_start ]
  %.81 = extractvalue { i1, { ptr, i32 } } %.80, 0
  %.83 = extractvalue { i1, i64 } %k, 0
  %.84 = or i1 %.83, %.81
  br i1 %.84, label %ArrayAccess_phi_block.1, label %array_access_out_of_bounds_check.1

ArrayAccess_correct_exec_block.1:                 ; preds = %array_access_out_of_bounds_check.1
  %.95 = extractvalue { ptr, i32 } %.87, 0
  %4 = zext nneg i32 %.90 to i64
  %.96 = getelementptr { i1, i64 }, ptr %.95, i64 %4
  %.97 = load { i1, i64 }, ptr %.96, align 4
  br label %ArrayAccess_phi_block.1

ArrayAccess_phi_block.1:                          ; preds = %ArrayAccess_phi_block, %array_access_out_of_bounds_check.1, %ArrayAccess_correct_exec_block.1
  %.100 = phi { i1, i64 } [ %.97, %ArrayAccess_correct_exec_block.1 ], [ { i1 true, i64 0 }, %array_access_out_of_bounds_check.1 ], [ { i1 true, i64 0 }, %ArrayAccess_phi_block ]
  %.104 = or i1 %.101, %.83
  br i1 %.104, label %ArrayAccess_phi_block.2, label %array_access_out_of_bounds_check.2

array_access_out_of_bounds_check.1:               ; preds = %ArrayAccess_phi_block
  %.87 = extractvalue { i1, { ptr, i32 } } %.80, 1
  %.88 = extractvalue { ptr, i32 } %.87, 1
  %.89 = trunc i64 %.57 to i32
  %.90 = add i32 %.89, -1
  %.91 = icmp slt i32 %.90, 0
  %.92 = icmp slt i32 %.88, %.90
  %.93 = or i1 %.91, %.92
  br i1 %.93, label %ArrayAccess_phi_block.1, label %ArrayAccess_correct_exec_block.1

ArrayAccess_correct_exec_block.2:                 ; preds = %array_access_out_of_bounds_check.2
  %5 = zext nneg i32 %.110 to i64
  %.116 = getelementptr { i1, { ptr, i32 } }, ptr %.115, i64 %5
  %.117 = load { i1, { ptr, i32 } }, ptr %.116, align 8
  br label %ArrayAccess_phi_block.2

ArrayAccess_phi_block.2:                          ; preds = %ArrayAccess_phi_block.1, %array_access_out_of_bounds_check.2, %ArrayAccess_correct_exec_block.2
  %.120 = phi { i1, { ptr, i32 } } [ %.117, %ArrayAccess_correct_exec_block.2 ], [ { i1 true, { ptr, i32 } zeroinitializer }, %array_access_out_of_bounds_check.2 ], [ { i1 true, { ptr, i32 } zeroinitializer }, %ArrayAccess_phi_block.1 ]
  %.121 = extractvalue { i1, { ptr, i32 } } %.120, 0
  %.124 = or i1 %.123, %.121
  br i1 %.124, label %ArrayAccess_phi_block.3, label %array_access_out_of_bounds_check.3

array_access_out_of_bounds_check.2:               ; preds = %ArrayAccess_phi_block.1
  %.109 = trunc i64 %.57 to i32
  %.110 = add i32 %.109, -1
  %.111 = icmp slt i32 %.110, 0
  %.112 = icmp slt i32 %.108, %.110
  %.113 = or i1 %.111, %.112
  br i1 %.113, label %ArrayAccess_phi_block.2, label %ArrayAccess_correct_exec_block.2

ArrayAccess_correct_exec_block.3:                 ; preds = %array_access_out_of_bounds_check.3
  %.135 = extractvalue { ptr, i32 } %.127, 0
  %.136 = getelementptr { i1, i64 }, ptr %.135, i64 %3
  %.137 = load { i1, i64 }, ptr %.136, align 4
  br label %ArrayAccess_phi_block.3

ArrayAccess_phi_block.3:                          ; preds = %ArrayAccess_phi_block.2, %array_access_out_of_bounds_check.3, %ArrayAccess_correct_exec_block.3
  %.140 = phi { i1, i64 } [ %.137, %ArrayAccess_correct_exec_block.3 ], [ { i1 true, i64 0 }, %array_access_out_of_bounds_check.3 ], [ { i1 true, i64 0 }, %ArrayAccess_phi_block.2 ]
  %.141 = extractvalue { i1, i64 } %.100, 0
  %.142 = extractvalue { i1, i64 } %.100, 1
  %.143 = extractvalue { i1, i64 } %.140, 0
  %.144 = extractvalue { i1, i64 } %.140, 1
  %.146 = or i1 %.141, %.143
  %Sij = mul i64 %.144, %.142
  %.149 = select i1 %.146, i64 undef, i64 %Sij
  %.159 = extractvalue { i1, i64 } %.153, 0
  %.163 = or i1 %.159, %.146
  %.169 = extractvalue { i1, i64 } %.153, 1
  %.171 = add i64 %.149, %.169
  %.173 = insertvalue { i1, i64 } zeroinitializer, i64 %.171, 1
  %.154 = select i1 %.163, { i1, i64 } { i1 true, i64 0 }, { i1, i64 } %.173
  %.54 = add i64 %.57, 1
  %.56 = insertvalue { i1, i64 } zeroinitializer, i64 %.54, 1
  br label %Loop_3_header_start

array_access_out_of_bounds_check.3:               ; preds = %ArrayAccess_phi_block.2
  %6 = trunc i64 %3 to i32
  %7 = trunc i64 %3 to i32
  %8 = icmp slt i32 %7, 0
  %.127 = extractvalue { i1, { ptr, i32 } } %.120, 1
  %.128 = extractvalue { ptr, i32 } %.127, 1
  %.132 = icmp slt i32 %.128, %6
  %.133 = or i1 %8, %.132
  br i1 %.133, label %ArrayAccess_phi_block.3, label %ArrayAccess_correct_exec_block.3

Loop_2_reduction_0_init:                          ; preds = %Loop_3_follower, %arr_size_exceeds_allocated_not, %arr_size_exceeds_allocated
  %.181 = phi { i1, { ptr, i32 } } [ %.226, %arr_size_exceeds_allocated ], [ %.233, %arr_size_exceeds_allocated_not ], [ { i1 true, { ptr, i32 } zeroinitializer }, %Loop_3_follower ]
  %.235 = phi i32 [ %.213, %arr_size_exceeds_allocated ], [ %allocated_size_red_1, %arr_size_exceeds_allocated_not ], [ undef, %Loop_3_follower ]
  %.36 = add i64 %.39, 1
  %.38 = insertvalue { i1, i64 } zeroinitializer, i64 %.36, 1
  br label %Loop_2_header_start

Loop_2_reduction_1_cond_block:                    ; preds = %Loop_3_follower
  %.207 = extractvalue { i1, { ptr, i32 } } %.180, 1
  %.208 = extractvalue { ptr, i32 } %.207, 1
  %.209 = add i32 %.208, 1
  %.210 = insertvalue { ptr, i32 } %.207, i32 %.209, 1
  %.211 = icmp ugt i32 %.209, %allocated_size_red_1
  br i1 %.211, label %arr_size_exceeds_allocated, label %arr_size_exceeds_allocated_not

arr_size_exceeds_allocated:                       ; preds = %Loop_2_reduction_1_cond_block
  %.213 = shl i32 %allocated_size_red_1, 1
  %9 = sext i32 %.213 to i64
  %.216.idx = mul nsw i64 %9, 12
  %.219 = tail call ptr @realloc(ptr %.192, i64 %.216.idx)
  %10 = sext i32 %.208 to i64
  %.220 = getelementptr { i1, i64 }, ptr %.219, i64 %10
  store { i1, i64 } %.153, ptr %.220, align 4
  %.224 = insertvalue { ptr, i32 } %.210, ptr %.219, 0
  %.226 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.224, 1
  br label %Loop_2_reduction_0_init

arr_size_exceeds_allocated_not:                   ; preds = %Loop_2_reduction_1_cond_block
  %11 = sext i32 %.208 to i64
  %.228 = getelementptr { i1, i64 }, ptr %.192, i64 %11
  store { i1, i64 } %.153, ptr %.228, align 4
  %.233 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.210, 1
  br label %Loop_2_reduction_0_init

Loop_1_reduction_0_init:                          ; preds = %Loop_2_follower, %arr_size_exceeds_allocated_not.1, %arr_size_exceeds_allocated.1
  %.242 = phi { i1, { ptr, i32 } } [ %.287, %arr_size_exceeds_allocated.1 ], [ %.294, %arr_size_exceeds_allocated_not.1 ], [ { i1 true, { ptr, i32 } zeroinitializer }, %Loop_2_follower ]
  %.296 = phi i32 [ %.274, %arr_size_exceeds_allocated.1 ], [ %allocated_size_red_1.1, %arr_size_exceeds_allocated_not.1 ], [ undef, %Loop_2_follower ]
  %.18 = add i64 %.21, 1
  %.20 = insertvalue { i1, i64 } zeroinitializer, i64 %.18, 1
  br label %Loop_1_header_start

Loop_1_reduction_1_cond_block:                    ; preds = %Loop_2_follower
  %.268 = extractvalue { i1, { ptr, i32 } } %.241, 1
  %.269 = extractvalue { ptr, i32 } %.268, 1
  %.270 = add i32 %.269, 1
  %.271 = insertvalue { ptr, i32 } %.268, i32 %.270, 1
  %.272 = icmp ugt i32 %.270, %allocated_size_red_1.1
  br i1 %.272, label %arr_size_exceeds_allocated.1, label %arr_size_exceeds_allocated_not.1

arr_size_exceeds_allocated.1:                     ; preds = %Loop_1_reduction_1_cond_block
  %.274 = shl i32 %allocated_size_red_1.1, 1
  %12 = sext i32 %.274 to i64
  %.277.idx = mul nsw i64 %12, 24
  %.280 = tail call ptr @realloc(ptr %.253, i64 %.277.idx)
  %13 = sext i32 %.269 to i64
  %.281 = getelementptr { i1, { ptr, i32 } }, ptr %.280, i64 %13
  store { i1, { ptr, i32 } } %.180, ptr %.281, align 8
  %.285 = insertvalue { ptr, i32 } %.271, ptr %.280, 0
  %.287 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.285, 1
  br label %Loop_1_reduction_0_init

arr_size_exceeds_allocated_not.1:                 ; preds = %Loop_1_reduction_1_cond_block
  %14 = sext i32 %.269 to i64
  %.289 = getelementptr { i1, { ptr, i32 } }, ptr %.253, i64 %14
  store { i1, { ptr, i32 } } %.180, ptr %.289, align 8
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
  br label %array_converter_loop_header

array_converter_loop_header:                      ; preds = %array_converter_loop_follower.1, %.7
  %.17 = phi i32 [ 0, %.7 ], [ %.50, %array_converter_loop_follower.1 ]
  %.18 = icmp slt i32 %.17, %.9
  br i1 %.18, label %array_converter_loop_body_start, label %array_converter_loop_follower

array_converter_loop_body_start:                  ; preds = %array_converter_loop_header
  %1 = zext nneg i32 %.17 to i64
  %.20 = getelementptr { ptr, i32 }, ptr %.8, i64 %1
  %.21 = load { ptr, i32 }, ptr %.20, align 8
  %.22 = extractvalue { ptr, i32 } %.21, 0
  %.23 = extractvalue { ptr, i32 } %.21, 1
  %2 = sext i32 %.23 to i64
  %.26.idx = mul nsw i64 %2, 12
  %.29 = tail call ptr @malloc(i64 %.26.idx)
  br label %array_converter_loop_header.1

array_converter_loop_follower:                    ; preds = %array_converter_loop_header
  %.52 = insertvalue { ptr, i32 } zeroinitializer, ptr %.15, 0
  %.53 = insertvalue { ptr, i32 } %.52, i32 %.9, 1
  %.56 = extractvalue { ptr, i32 } %.2, 0
  %.57 = extractvalue { ptr, i32 } %.2, 1
  %3 = sext i32 %.57 to i64
  %.60.idx = mul nsw i64 %3, 24
  %.63 = tail call ptr @malloc(i64 %.60.idx)
  br label %array_converter_loop_header.2

array_converter_loop_header.1:                    ; preds = %array_converter_loop_body_start.1, %array_converter_loop_body_start
  %lsr.iv31 = phi ptr [ %scevgep32, %array_converter_loop_body_start.1 ], [ %.29, %array_converter_loop_body_start ]
  %lsr.iv28 = phi i64 [ %lsr.iv.next29, %array_converter_loop_body_start.1 ], [ 0, %array_converter_loop_body_start ]
  %tmp33 = trunc i64 %lsr.iv28 to i32
  %.32 = icmp slt i32 %tmp33, %.23
  br i1 %.32, label %array_converter_loop_body_start.1, label %array_converter_loop_follower.1

array_converter_loop_body_start.1:                ; preds = %array_converter_loop_header.1
  %4 = shl nuw nsw i64 %lsr.iv28, 3
  %scevgep30 = getelementptr i8, ptr %.22, i64 %4
  %.35 = load i64, ptr %scevgep30, align 4
  %.37 = insertvalue { i1, i64 } zeroinitializer, i64 %.35, 1
  store { i1, i64 } %.37, ptr %lsr.iv31, align 4
  %lsr.iv.next29 = add nuw nsw i64 %lsr.iv28, 1
  %scevgep32 = getelementptr i8, ptr %lsr.iv31, i64 16
  br label %array_converter_loop_header.1

array_converter_loop_follower.1:                  ; preds = %array_converter_loop_header.1
  %.43 = insertvalue { ptr, i32 } zeroinitializer, ptr %.29, 0
  %.44 = insertvalue { ptr, i32 } %.43, i32 %.23, 1
  %.46 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.44, 1
  %.47 = getelementptr { i1, { ptr, i32 } }, ptr %.15, i64 %1
  store { i1, { ptr, i32 } } %.46, ptr %.47, align 8
  %.50 = add nuw nsw i32 %.17, 1
  br label %array_converter_loop_header

array_converter_loop_header.2:                    ; preds = %array_converter_loop_follower.3, %array_converter_loop_follower
  %.65 = phi i32 [ 0, %array_converter_loop_follower ], [ %.98, %array_converter_loop_follower.3 ]
  %.66 = icmp slt i32 %.65, %.57
  br i1 %.66, label %array_converter_loop_body_start.2, label %array_converter_loop_follower.2

array_converter_loop_body_start.2:                ; preds = %array_converter_loop_header.2
  %5 = zext nneg i32 %.65 to i64
  %.68 = getelementptr { ptr, i32 }, ptr %.56, i64 %5
  %.69 = load { ptr, i32 }, ptr %.68, align 8
  %.70 = extractvalue { ptr, i32 } %.69, 0
  %.71 = extractvalue { ptr, i32 } %.69, 1
  %6 = sext i32 %.71 to i64
  %.74.idx = mul nsw i64 %6, 12
  %.77 = tail call ptr @malloc(i64 %.74.idx)
  br label %array_converter_loop_header.3

array_converter_loop_follower.2:                  ; preds = %array_converter_loop_header.2
  %.55 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.53, 1
  %.100 = insertvalue { ptr, i32 } zeroinitializer, ptr %.63, 0
  %.101 = insertvalue { ptr, i32 } %.100, i32 %.57, 1
  %.103 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.101, 1
  %.105 = insertvalue { i1, i64 } zeroinitializer, i64 %.3, 1
  %.107 = insertvalue { i1, i64 } zeroinitializer, i64 %.4, 1
  %.109 = insertvalue { i1, i64 } zeroinitializer, i64 %.5, 1
  %.110 = tail call { i1, { ptr, i32 } } @sisal_main({ i1, { ptr, i32 } } %.55, { i1, { ptr, i32 } } %.103, { i1, i64 } %.105, { i1, i64 } %.107, { i1, i64 } %.109)
  %.111 = extractvalue { i1, { ptr, i32 } } %.110, 0
  br i1 %.111, label %val_errored, label %val_not_errored

array_converter_loop_header.3:                    ; preds = %array_converter_loop_body_start.3, %array_converter_loop_body_start.2
  %lsr.iv26 = phi ptr [ %scevgep27, %array_converter_loop_body_start.3 ], [ %.77, %array_converter_loop_body_start.2 ]
  %lsr.iv = phi i64 [ %lsr.iv.next, %array_converter_loop_body_start.3 ], [ 0, %array_converter_loop_body_start.2 ]
  %tmp = trunc i64 %lsr.iv to i32
  %.80 = icmp slt i32 %tmp, %.71
  br i1 %.80, label %array_converter_loop_body_start.3, label %array_converter_loop_follower.3

array_converter_loop_body_start.3:                ; preds = %array_converter_loop_header.3
  %7 = shl nuw nsw i64 %lsr.iv, 3
  %scevgep = getelementptr i8, ptr %.70, i64 %7
  %.83 = load i64, ptr %scevgep, align 4
  %.85 = insertvalue { i1, i64 } zeroinitializer, i64 %.83, 1
  store { i1, i64 } %.85, ptr %lsr.iv26, align 4
  %lsr.iv.next = add nuw nsw i64 %lsr.iv, 1
  %scevgep27 = getelementptr i8, ptr %lsr.iv26, i64 16
  br label %array_converter_loop_header.3

array_converter_loop_follower.3:                  ; preds = %array_converter_loop_header.3
  %.91 = insertvalue { ptr, i32 } zeroinitializer, ptr %.77, 0
  %.92 = insertvalue { ptr, i32 } %.91, i32 %.71, 1
  %.94 = insertvalue { i1, { ptr, i32 } } zeroinitializer, { ptr, i32 } %.92, 1
  %.95 = getelementptr { i1, { ptr, i32 } }, ptr %.63, i64 %5
  store { i1, { ptr, i32 } } %.94, ptr %.95, align 8
  %.98 = add nuw nsw i32 %.65, 1
  br label %array_converter_loop_header.2

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
  %.8.peel = icmp eq i32 %.2, 0
  br i1 %.8.peel, label %array_loop_follower, label %array_print_loop.peel

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
  br label %array_loop_header

array_loop_header:                                ; preds = %end_printf, %end_printf.peel
  %.7 = phi i32 [ 1, %end_printf.peel ], [ %.34, %end_printf ]
  %.8 = icmp eq i32 %.2, %.7
  br i1 %.8, label %array_loop_follower, label %array_loop_comma

array_loop_comma:                                 ; preds = %array_loop_header
  %.10.not = icmp eq i32 %.7, 0
  br i1 %.10.not, label %array_print_loop, label %print_comma

print_comma:                                      ; preds = %array_loop_comma
  %.12 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.4)
  br label %array_print_loop

array_print_loop:                                 ; preds = %array_loop_comma, %print_comma
  %0 = sext i32 %.7 to i64
  %.15 = getelementptr { i1, { ptr, i32 } }, ptr %.1, i64 %0
  %.16 = load { i1, { ptr, i32 } }, ptr %.15, align 8
  %.17 = extractvalue { i1, { ptr, i32 } } %.16, 0
  br i1 %.17, label %val_errored, label %val_not_errored

array_loop_follower:                              ; preds = %array_loop_header, %entry
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
  %.34 = add i32 %.7, 1
  br label %array_loop_header, !llvm.loop !0
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
  %.8.peel = icmp eq i32 %.2, 0
  br i1 %.8.peel, label %array_loop_follower, label %array_print_loop.peel

array_print_loop.peel:                            ; preds = %entry
  %.16.peel.pre = load { i1, i64 }, ptr %.1, align 4
  %.17.peel = extractvalue { i1, i64 } %.16.peel.pre, 0
  br i1 %.17.peel, label %val_errored.peel, label %val_not_errored.peel

val_not_errored.peel:                             ; preds = %array_print_loop.peel
  %.23.peel = extractvalue { i1, i64 } %.16.peel.pre, 1
  %.24.peel = alloca [4 x i8], align 4
  store <4 x i8> <i8 37, i8 108, i8 100, i8 0>, ptr %.24.peel, align 4
  %.26.peel = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.24.peel, i64 %.23.peel)
  br label %array_loop_header.preheader

val_errored.peel:                                 ; preds = %array_print_loop.peel
  %.19.peel = alloca [6 x i8], align 4
  store <4 x i8> <i8 69, i8 82, i8 82, i8 79>, ptr %.19.peel, align 4
  %.19.repack7.peel = getelementptr inbounds nuw i8, ptr %.19.peel, i64 4
  store i8 82, ptr %.19.repack7.peel, align 4
  %.19.repack8.peel = getelementptr inbounds nuw i8, ptr %.19.peel, i64 5
  store i8 0, ptr %.19.repack8.peel, align 1
  %.21.peel = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.19.peel)
  br label %array_loop_header.preheader

array_loop_header.preheader:                      ; preds = %val_errored.peel, %val_not_errored.peel
  br label %array_loop_header

array_loop_header:                                ; preds = %array_loop_header.preheader, %end_printf
  %.7 = phi i32 [ %.28, %end_printf ], [ 1, %array_loop_header.preheader ]
  %.8 = icmp eq i32 %.2, %.7
  br i1 %.8, label %array_loop_follower, label %array_loop_comma

array_loop_comma:                                 ; preds = %array_loop_header
  %.10.not = icmp eq i32 %.7, 0
  br i1 %.10.not, label %array_print_loop, label %print_comma

print_comma:                                      ; preds = %array_loop_comma
  %.12 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) %.4)
  br label %array_print_loop

array_print_loop:                                 ; preds = %array_loop_comma, %print_comma
  %0 = sext i32 %.7 to i64
  %.15 = getelementptr { i1, i64 }, ptr %.1, i64 %0
  %.16 = load { i1, i64 }, ptr %.15, align 4
  %.17 = extractvalue { i1, i64 } %.16, 0
  br i1 %.17, label %val_errored, label %val_not_errored

array_loop_follower:                              ; preds = %array_loop_header, %entry
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
  %.28 = add i32 %.7, 1
  br label %array_loop_header, !llvm.loop !2
}

attributes #0 = { nofree nounwind }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #3 = { nounwind memory(readwrite, argmem: read) }
attributes #4 = { nounwind }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.peeled.count", i32 1}
!2 = distinct !{!2, !1}
