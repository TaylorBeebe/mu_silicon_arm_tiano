; Copyright (c) 2012-2014, ARM Limited. All rights reserved.
; Copyright (c) 2014-2016, Linaro Limited. All rights reserved.
;
; SPDX-License-Identifier: BSD-2-Clause-Patent
;

; This example assumes the file is saved as "AsmMacroIoLibV8.h"
INCLUDE |AsmMacroIoLibV8.h|

; ARM_CALL_HVC PROC
; Function to perform a HVC call with the HVC parameter block
; using Visual Studio ARM toolchain compatible assembly language
ArmCallHvc PROC

    ; Push x0 on the stack - The stack must always be quad-word aligned
    STR x0, [SP, #-16]!

    ; Load the HVC arguments values into the appropriate registers
    LDP x6, x7, [x0, #48]
    LDP x4, x5, [x0, #32]
    LDP x2, x3, [x0, #16]
    LDP x0, x1, [x0, #0]

    ; Issue the hypervisor call
    HVC #0

    ; Pop the ARM_HVC_ARGS structure address from the stack into x9
    LDR x9, [SP], #16

    ; Store the HVC returned values into the ARM_HVC_ARGS structure.
    ; A HVC call can return up to 4 values
    STP x2, x3, [x9, #16]
    STP x0, x1, [x9, #0]

    ; Return the structure address in x0
    MOV x0, x9

    ; Return from the function
    RET

ArmCallHvc ENDP