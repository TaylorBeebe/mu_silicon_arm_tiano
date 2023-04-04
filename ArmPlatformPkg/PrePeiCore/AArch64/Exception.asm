//
//  Copyright (c) 2011-2021, Arm Limited. All rights reserved.<BR>
//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//
//

#include <Chipset/AArch64.h>
#include <AsmMacroIoLibV8.h>
#include <Base.h>
#include <AutoGen.h>

//============================================================
//Default Exception Handlers
//============================================================

// #define TO_HANDLER                                              \
//   EL1_OR_EL2(x1)                                               \
// 1: mrs  x1, elr_el1    /* EL1 Exception Link Register */       ;\
//    b    %3F                                                     ;\
// 2: mrs  x1, elr_el2    /* EL2 Exception Link Register */       ;\
// 3: bl   PeiCommonExceptionEntry                                ;
// 
//   EL1_OR_EL2(x1)
// 1: mrs  x1, elr_el1
//    b    %F3
// 2: mrs  x1, elr_el2
// 3: bl   PeiCommonExceptionEntry

//
// Default Exception handlers: There is no plan to return from any of these exceptions.
// No context saving at all.
//
  AREA    |.text|,ALIGN=11,CODE,READONLY
  EXPORT  PeiVectorTable
PeiVectorTable PROC

  ALIGN 128
DefaultSyncExceptHandler_t
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultIrq_t
  mov  x0, #EXCEPT_AARCH64_IRQ
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultFiq_t
  mov  x0, #EXCEPT_AARCH64_FIQ
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultSError_t
  mov  x0, #EXCEPT_AARCH64_SERROR
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultSyncExceptHandler_h
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultIrq_h
  mov  x0, #EXCEPT_AARCH64_IRQ
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultFiq_h
  mov  x0, #EXCEPT_AARCH64_FIQ
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultSError_h
  mov  x0, #EXCEPT_AARCH64_SERROR
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultSyncExceptHandler_LowerA64
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultIrq_LowerA64
  mov  x0, #EXCEPT_AARCH64_IRQ
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultFiq_LowerA64
  mov  x0, #EXCEPT_AARCH64_FIQ
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultSError_LowerA64
  mov  x0, #EXCEPT_AARCH64_SERROR
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultSyncExceptHandler_LowerA32
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultIrq_LowerA32
  mov  x0, #EXCEPT_AARCH64_IRQ
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultFiq_LowerA32
  mov  x0, #EXCEPT_AARCH64_FIQ
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

  ALIGN 128
DefaultSError_LowerA32
  mov  x0, #EXCEPT_AARCH64_SERROR
    EL1_OR_EL2(x1)
1: mrs  x1, elr_el1
   b    %F3
2: mrs  x1, elr_el2
3: bl   PeiCommonExceptionEntry

PeiVectorTable ENDP
  ALIGN   0x800
  AREA    |.text|,ALIGN=3,CODE,READONLY
  
  END