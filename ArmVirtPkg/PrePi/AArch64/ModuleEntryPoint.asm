//
//  Copyright (c) 2011-2013, ARM Limited. All rights reserved.
//  Copyright (c) 2015-2016, Linaro Limited. All rights reserved.
//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//
//

#include <AsmMacroIoLibV8.h>

AREA _ModuleEntryPoint, CODE
ALIGN
_Module_Entry_Point PROC
  bl    _DiscoverDramFromDt

  // Get ID of this CPU in Multicore system
  bl    _ArmReadMpidr
  // Keep a copy of the MpId register value
  MOV   x20, X0

_SetupStackPosition
  // Compute Top of System Memory
  LDR   X1, =_PcdSystemMemoryBase
  LDR   X2, =_PcdSystemMemorySize
  SUB   X2, X2, #1
  ADD   X1, X1, X2      // X1 = SystemMemoryTop = PcdSystemMemoryBase + PcdSystemMemorySize

  // Calculate Top of the Firmware Device
  LDR   X2, =_PcdFdBaseAddress
  MOV32(X3, _FixedPcdGet32(PcdFdSize) - 1)
  ADD   X3, X3, X2      // X3 = FdTop = PcdFdBaseAddress + PcdFdSize

  // UEFI Memory Size (stacks are allocated in this region)
  MOV32(X4, _FixedPcdGet32(PcdSystemMemoryUefiRegionSize))

  //
  // Reserve the memory for the UEFI region (contain stacks on its top)
  //

  // Calculate how much space there is between the top of the Firmware and the Top of the System Memory
  SUBS  X0, X1, X3   // X0 = SystemMemoryTop - FdTop
  BMI   _SetupStack  // Jump if negative (FdTop > SystemMemoryTop). Case when the PrePi is in XIP memory outside of the DRAM
  CMP   X0, X4
  BGE   _SetupStack

  // Case the top of stacks is the FdBaseAddress
  MOV   X1, X2

_SetupStack
  // X1 contains the top of the stack (and the UEFI Memory)

  // Because the 'push' instruction is equivalent to 'stmdb' (decrement before), we need to increment
  // one to the top of the stack. We check if incrementing one does not overflow (case of DRAM at the
  // top of the memory space)
  ADDS  X21, X1, #1
  BCS   _SetupOverflowStack

_SetupAlignedStack
  MOV   X1, X21
  B     _GetBaseUefiMemory

_SetupOverflowStack
  // Case memory at the top of the address space. Ensure the top of the stack is EFI_PAGE_SIZE
  // aligned (4KB)
  AND   X1, X1, ~EFI_PAGE_MASK

_GetBaseUefiMemory
  // Calculate the Base of the UEFI Memory
  SUB   X21, X1, X4

_GetStackBase
  // X1 = The top of the MpCore Stacks
  MOV   SP, X1

  // Stack for the primary core = PrimaryCoreStack
  MOV32(X2, _FixedPcdGet32(PcdCPUCorePrimaryStackSize))
  SUB   X22, X1, X2

  MOV   X0, X20
  MOV   X1, X21
  MOV   X2, X22

  // Set the frame pointer to NULL so any backtraces terminate here
  MOV   X29, XZR

  // Jump to PrePiCore C code
  //    X0 = MpId
  //    X1 = UefiMemoryBase
  //    X2 = StacksBase
  BL    _C_Entry_Point

_NeverReturn
  B _NeverReturn
  ENDPROC

AREA _DiscoverDramFromDt, CODE
ALIGN
_Discover_Dram_From_Dt PROC
  //
  // If we are booting from RAM using the Linux kernel boot protocol, X0 will
  // point to the DTB image in memory. Otherwise, use the default value defined
  // by the platform.
  //
  CBNZ  X0, 0f
  LDR   X0, =_PcdDeviceTreeInitialBaseAddress

0:MOV   X29, X30            // preserve LR
  MOV   X28, X0             // preserve DTB pointer
  MOV   X27, X1             // preserve base of image pointer

  //
  // The base of the runtime image has been preserved in X1. Check whether
  // the expected magic number can be found in the header.
  //
  LDR   W8, .LArm64LinuxMagic
  LDR   W9, [X1, #0x38]
  CMP   W8, W9
  BNE   .Lout

  //
  //
  // OK, so far so good. We have confirmed that we likely have a DTB and are
  // booting via the arm64 Linux boot protocol. Update the base-of-img PCD
  // to the actual relocated value and add the shift of PcdFdBaseAddress to
  // PcdFvBaseAddress as well
  //
  ADR   X8, _PcdFdBaseAddress
  ADR   X9, _PcdFvBaseAddress
  LDR   X6, [X8]
  LDR   X7, [X9]
  SUB   X7, X7, X6
  ADD   X7, X7, X1
  STR   X1, [X8]
  STR   X7, [X9]

  //
  // The runtime address may be different from the link time address so fix
  // up the PE/COFF relocations. Since we are calling a C function, use the
  // window at the beginning of the FD image as a temp stack.
  //
  MOV   X0, X7
  ADR   X1, _PeCoffLoaderImageReadFromMemory
  MOV   SP, X7
  BL    _RelocatePeCoffImage

  //
  // Discover the memory size and offset from the DTB, and record in the
  // respective PCDs. This will also return false if a corrupt DTB is
  // encountered.
  //
  MOV   X0, X28
  ADR   X1, _PcdSystemMemoryBase
  ADR   X2, _PcdSystemMemorySize
  BL    _FindMemnode
  CBZ   X0, .Lout

  //
  // Copy the DTB to the slack space right after the 64 byte arm64/Linux style
  // image header at the base of this image (defined in the FDF), and record the
  // pointer in PcdDeviceTreeInitialBaseAddress.
  //
  ADR   X8, _PcdDeviceTreeInitialBaseAddress
  ADD   X27, X27, #0x40
  STR   X27, [X8]

  MOV   X0, X27
  MOV   X1, X28
  BL    _CopyFdt

.Lout
  RET    X29

.LArm64LinuxMagic
  DCB   0x41, 0x52, 0x4d, 0x64
  ENDPROC
