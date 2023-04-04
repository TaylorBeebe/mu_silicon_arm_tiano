; Copyright (c) 2011-2021, Arm Limited. All rights reserved.<BR>
;
; SPDX-License-Identifier: BSD-2-Clause-Patent
;
;

;include <Chipset/AArch64.h>
;include <AsmMacroIoLibV8.h>
;include <Base.h>
;include <AutoGen.h>

AREA |.text|,ALIGN=3,CODE

;============================================================
;Default Exception Handlers
;============================================================

macro TO_HANDLER
   EL1_OR_EL2 x1
1: mrs  x1, elr_el1   ; EL1 Exception Link Register
   b    3f
2: mrs  x1, elr_el2   ; EL2 Exception Link Register
3: bl   PeiCommonExceptionEntry
endm

;
; Default Exception handlers: There is no plan to return from any of these exceptions.
; No context saving at all.
;

PeiVectorTable

VECTOR_ENTRY _DefaultSyncExceptHandler_t
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultIrq_t
  mov  x0, #EXCEPT_AARCH64_IRQ
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultFiq_t
  mov  x0, #EXCEPT_AARCH64_FIQ
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultSError_t
  mov  x0, #EXCEPT_AARCH64_SERROR
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultSyncExceptHandler_h
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultIrq_h
  mov  x0, #EXCEPT_AARCH64_IRQ
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultFiq_h
  mov  x0, #EXCEPT_AARCH64_FIQ
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultSError_h
  mov  x0, #EXCEPT_AARCH64_SERROR
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultSyncExceptHandler_LowerA64
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultIrq_LowerA64
  mov  x0, #EXCEPT_AARCH64_IRQ
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultFiq_LowerA64
  mov  x0, #EXCEPT_AARCH64_FIQ
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultSError_LowerA64
  mov  x0, #EXCEPT_AARCH64_SERROR
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultSyncExceptHandler_LowerA32
  mov  x0, #EXCEPT_AARCH64_SYNCHRONOUS_EXCEPTIONS
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultIrq_LowerA32
  mov  x0, #EXCEPT_AARCH64_IRQ
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultFiq_LowerA32
  mov  x0, #EXCEPT_AARCH64_FIQ
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

VECTOR_ENTRY _DefaultSError_LowerA32
  mov  x0, #EXCEPT_AARCH64_SERROR
  TO_HANDLER
  END_VECTOR_TABLE_ENTRY

END_VECTOR_TABLE PeiVectorTable