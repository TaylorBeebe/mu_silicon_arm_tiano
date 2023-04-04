; ARM Assembly file for EDK2 and ARMASM64
;
; Save this file with a .s extension and add it to your EDK2 project.

  AREA |.text|, CODE, ALIGN=3

#include <AsmMacroIoLibV8.h>
#include <Library/ArmLib.h>

; ArmPlatformPeiBootAction
ArmPlatformPeiBootAction PROC
    ret
    ENDP

; ArmPlatformGetCorePosition
; With this function: CorePos = (ClusterId * 4) + CoreId
ArmPlatformGetCorePosition PROC
    and   x1, x0, #ARM_CORE_MASK
    and   x0, x0, #ARM_CLUSTER_MASK
    add   x0, x1, x0, LSR #6
    ret
    ENDP

; ArmPlatformGetPrimaryCoreMpId
ArmPlatformGetPrimaryCoreMpId PROC
    LDR   x1, =FixedPcdGet32(PcdArmPrimaryCore)
    mov   w0, w1
    ret
    ENDP

; ArmPlatformIsPrimaryCore
ArmPlatformIsPrimaryCore PROC
    LDR   x1, =FixedPcdGet32(PcdArmPrimaryCoreMask)
    and   x0, x0, x1
    LDR   x1, =FixedPcdGet32(PcdArmPrimaryCore)
    cmp   w0, w1
    mov   x0, #1
    mov   x1, #0
    csel  x0, x0, x1, eq
    ret
    ENDP

    END
