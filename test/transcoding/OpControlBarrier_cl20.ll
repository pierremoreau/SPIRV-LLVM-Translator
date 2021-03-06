; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv %t.bc -spirv-text -o %t.txt
; RUN: FileCheck < %t.txt %s --check-prefix=CHECK-SPIRV
; RUN: llvm-spirv %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis < %t.rev.bc | FileCheck %s --check-prefix=CHECK-LLVM

; work_group_barrier with the default scope (memory_scope_work_group)
; CHECK-LLVM: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 1) [[attr:#[0-9]+]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 1) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 1) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 3, i32 1) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 5, i32 1) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 7, i32 1) [[attr]]

; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 0) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 1) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 2) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 3) [[attr]]

; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 0) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 1) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 2) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 3) [[attr]]

; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 0) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 1) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 2) [[attr]]
; CHECK-LLVM-NEXT: call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 3) [[attr]]

; CHECK-LLVM: attributes [[attr]] = { convergent nounwind }

; Both 'CrossDevice' memory scope and 'None' memory order enums have value equal to 0.
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[Null:[0-9]+]] 0
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema1:[0-9]+]] 528
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema2:[0-9]+]] 272
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema3:[0-9]+]] 2064
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema4:[0-9]+]] 784
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema5:[0-9]+]] 2320
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[MemSema6:[0-9]+]] 2832

; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[ScopeWorkItem:[0-9]+]] 4
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[ScopeWorkGroup:[0-9]+]] 2
; CHECK-SPIRV-DAG: 4 Constant {{[0-9]+}} [[ScopeDevice:[0-9]+]] 1

; CHECK-SPIRV: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[Null]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema1]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema2]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema3]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema4]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema5]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema6]]

; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkItem]] [[MemSema1]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema1]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeDevice]] [[MemSema1]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[Null]] [[MemSema1]]

; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkItem]] [[MemSema2]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema2]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeDevice]] [[MemSema2]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[Null]] [[MemSema2]]

; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkItem]] [[MemSema3]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeWorkGroup]] [[MemSema3]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[ScopeDevice]] [[MemSema3]]
; CHECK-SPIRV-NEXT: 4 ControlBarrier [[ScopeWorkGroup]] [[Null]] [[MemSema3]]


; ModuleID = 'work_group_barrier.cl'
target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

; Function Attrs: nounwind
define spir_kernel void @test() #0 !kernel_arg_addr_space !1 !kernel_arg_access_qual !1 !kernel_arg_type !1 !kernel_arg_base_type !1 !kernel_arg_type_qual !1 {
entry:
  call spir_func void @_Z18work_group_barrierj(i32 0) ; no mem fence
  call spir_func void @_Z18work_group_barrierj(i32 2) ; global mem fence
  call spir_func void @_Z18work_group_barrierj(i32 1) ; local mem fence
  call spir_func void @_Z18work_group_barrierj(i32 4) ; image mem fence

  call spir_func void @_Z18work_group_barrierj(i32 3) ; global | local
  call spir_func void @_Z18work_group_barrierj(i32 5) ; local | image
  call spir_func void @_Z18work_group_barrierj(i32 7) ; global | local | image

  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 0) ; global mem fence + memory_scope_work_item
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 1) ; global mem fence + memory_scope_work_group
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 2) ; global mem fence + memory_scope_device
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 2, i32 3) ; global mem fence + memory_scope_all_svm_devices

  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 0) ; local mem fence + memory_scope_work_item
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 1) ; local mem fence + memory_scope_work_group
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 2) ; local mem fence + memory_scope_device
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 1, i32 3) ; local mem fence + memory_scope_all_svm_devices

  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 0) ; image mem fence + memory_scope_work_item
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 1) ; image mem fence + memory_scope_work_group
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 2) ; image mem fence + memory_scope_device
  call spir_func void @_Z18work_group_barrierj12memory_scope(i32 4, i32 3) ; image mem fence + memory_scope_all_svm_devices

  ret void
}

declare spir_func void @_Z18work_group_barrierj(i32) #1
declare spir_func void @_Z18work_group_barrierj12memory_scope(i32, i32) #1

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!opencl.enable.FP_CONTRACT = !{}
!opencl.spir.version = !{!2}
!opencl.ocl.version = !{!3}
!opencl.used.extensions = !{!1}
!opencl.used.optional.core.features = !{!1}
!opencl.compiler.options = !{!1}

!1 = !{}
!2 = !{i32 1, i32 2}
!3 = !{i32 2, i32 0}
