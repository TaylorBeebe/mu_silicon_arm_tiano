;===============================================================================
;  Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
;
;  SPDX-License-Identifier: BSD-2-Clause-Patent
;===============================================================================

AREA    |.text|, CODE, ALIGN=3

IMPORT  gApStacksBase
IMPORT  gProcessorIDs
IMPORT  ApProcedure
IMPORT  gApStackSize

EXPORT  ApEntryPoint

; Entry-point for the AP
; VOID
; ApEntryPoint (
;   VOID
;   );
ApEntryPoint PROC
  mrs x0, mpidr_el1
  ; Mask the non-affinity bits
  bic x0, x0, 0x00ff000000
  and x0, x0, 0xffffffffff
  ldr x1, =gProcessorIDs
  mov x2, 0                   ; x2 = processor index

; Find index in gProcessorIDs for current processor
1
  ldr x3, [x1, x2, lsl #3]    ; x4 = gProcessorIDs + x2 * 8
  cmp x3, #-1                 ; check if we've reached the end of gProcessorIDs
  beq ProcessorNotFound
  add x2, x2, 1               ; x2++
  cmp x0, x3                  ; if mpidr_el1 != gProcessorIDs[x] then loop
  bne %B1

; Calculate stack address
  ; x2 contains the index for the current processor plus 1
  ldr x0, =gApStacksBase
  ldr x1, =gApStackSize
  mul x3, x2, x1              ; x3 = (ProcessorIndex + 1) * gApStackSize
  add sp, x0, x3              ; sp = gApStacksBase + x3
  mov x29, xzr
  bl ApProcedure             ; doesn't return

ProcessorNotFound
; Turn off the processor
  mov w0, #0xc4000003         ; ARM_SMC_ID_PSCI_CPU_OFF
  .inst 0xd4000001 ; smc #0
  b %BProcessorNotFound
  ENDP
END