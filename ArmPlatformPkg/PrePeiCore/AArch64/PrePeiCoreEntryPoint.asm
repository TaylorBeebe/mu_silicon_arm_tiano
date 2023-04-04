//
//  Copyright (c) 2011-2014, ARM Limited. All rights reserved.
//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//
//

#include <AsmMacroIoLibV8.h>

ModuleEntryPoint PROC
  // Do early platform specific actions
  bl    ArmPlatformPeiBootAction

// NOTE: We could be booting from EL3, EL2 or EL1. Need to correctly detect
//       and configure the system accordingly. EL2 is default if possible.
// If we started in EL3 we need to switch and run at EL2.
// If we are running at EL2 stay in EL2
// If we are starting at EL1 stay in EL1.

// If started at EL3 Sec is run and switches to EL2 before jumping to PEI.
// If started at EL1 or EL2 Sec jumps directly to PEI without making any
// changes.

// Which EL are we running at? Every EL needs some level of setup...
// We should not run this code in EL3
  EL1_OR_EL2(x0)
1
  bl    SetupExceptionLevel1
  b     MainEntryPoint
2
  bl    SetupExceptionLevel2
  b     MainEntryPoint
ModuleEntryPoint ENDP

MainEntryPoint PROC
  // Identify CPU ID
  bl    ArmReadMpidr
  // Keep a copy of the MpId register value
  mov   x5, x0

  // Is it the Primary Core ?
  bl    ArmPlatformIsPrimaryCore

  // Get the top of the primary stacks (and the base of the secondary stacks)
  mov x1, FixedPcdGet64(PcdCPUCoresStackBase) + FixedPcdGet32(PcdCPUCorePrimaryStackSize)

  // x0 is equal to 1 if I am the primary core
  cmp   x0, #1
  b.eq   SetupPrimaryCoreStack
MainEntryPoint ENDP

SetupSecondaryCoreStack PROC
  // x1 contains the base of the secondary stacks

  // Get the Core Position
  mov   x6, x1      // Save base of the secondary stacks
  mov   x0, x5
  bl    ArmPlatformGetCorePosition
  // The stack starts at the top of the stack region. Add '1' to the Core Position to get the top of the stack
  add   x0, x0, #1

  // StackOffset = CorePos * StackSize
  movz  x2, (FixedPcdGet32(PcdCPUCoreSecondaryStackSize)) >> 16, lsl #16
  movk  x2, (FixedPcdGet32(PcdCPUCoreSecondaryStackSize)) & 0xffff
  mul   x0, x0, x2
  // SP = StackBase + StackOffset
  add   sp, x6, x0
SetupSecondaryCoreStack ENDP

PrepareArguments PROC
  // The PEI Core Entry Point has been computed by GenFV and stored in the second entry of the Reset Vector
  MOV64 (x2, FixedPcdGet64(PcdFvBaseAddress))
  ldr   x1, [x2, #8]

  // Move sec startup address into a data register
  // Ensure we're jumping to FV version of the code (not boot remapped alias)
  ldr   x3, =CEntryPoint

  // Set the frame pointer to NULL so any backtraces terminate here
  mov   x29, xzr

  // Jump to PrePeiCore C code
  //    x0 = mp_id
  //    x1 = pei_core_address
  mov   x0, x5
  blr   x3
PrepareArguments ENDP

SetupPrimaryCoreStack PROC
  mov   sp, x1
  mov   x8, FixedPcdGet64 (PcdCPUCoresStackBase)

  LDR x10, FixedPcdGet64 (PcdCPUCoresStackBase)
  LDR x9, FixedPcdGet64 (PcdCPUCoresStackBase)
  LSL x9, x9, 32
  ORR x10, x10, x9
  mov x9, x10
0:
  stp   x9, x9, [x8], #16
  cmp   x8, x1
  b.lt  %B0
  b     PrepareArguments
SetupPrimaryCoreStack ENDP

  END