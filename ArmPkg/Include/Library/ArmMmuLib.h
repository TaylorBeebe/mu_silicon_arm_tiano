/** @file

  Copyright (c) 2015 - 2016, Linaro Ltd. All rights reserved.<BR>

  SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#ifndef ARM_MMU_LIB_H_
#define ARM_MMU_LIB_H_

#include <Uefi/UefiBaseType.h>

#include <Library/ArmLib.h>

typedef union {
  struct {
    UINT64    Valid                      : 1;
    UINT64    BlockOrTable               : 1;
    UINT64    AttributeIndex             : 3;
    UINT64    NonSecure                  : 1;
    UINT64    AccessPermissions          : 2;
    UINT64    Sharability                : 2;
    UINT64    AccessFlag                 : 1;
    UINT64    NonGlobal                  : 1;
    UINT64    Oa                         : 4;
    UINT64    Nt                         : 1;
    UINT64    OutputAddress              : 33;
    UINT64    Guarded                    : 1;
    UINT64    Dirty                      : 1;
    UINT64    Contiguous                 : 1;
    UINT64    PXn                        : 1;
    UINT64    Xn                         : 1;
    UINT64    Ignored                    : 4;
    UINT64    PageBasedHardwareAttribute : 4;
    UINT64    Reserved                   : 1;
  } Bits;
  UINT64    Uint64;
} TRANSLATION_TABLE_ATTRIBUTE;

typedef struct {
  UINT64                         LinearAddress;
  UINT64                         Length;
  TRANSLATION_TABLE_ATTRIBUTE    Attribute;
} TRANSLATION_TABLE_ENTRY;

EFI_STATUS
EFIAPI
ArmConfigureMmu (
  IN  ARM_MEMORY_REGION_DESCRIPTOR  *MemoryTable,
  OUT VOID                          **TranslationTableBase OPTIONAL,
  OUT UINTN                         *TranslationTableSize  OPTIONAL
  );

EFI_STATUS
EFIAPI
ArmSetMemoryRegionNoExec (
  IN  EFI_PHYSICAL_ADDRESS  BaseAddress,
  IN  UINT64                Length
  );

EFI_STATUS
EFIAPI
ArmClearMemoryRegionNoExec (
  IN  EFI_PHYSICAL_ADDRESS  BaseAddress,
  IN  UINT64                Length
  );

EFI_STATUS
EFIAPI
ArmSetMemoryRegionReadOnly (
  IN  EFI_PHYSICAL_ADDRESS  BaseAddress,
  IN  UINT64                Length
  );

EFI_STATUS
EFIAPI
ArmClearMemoryRegionReadOnly (
  IN  EFI_PHYSICAL_ADDRESS  BaseAddress,
  IN  UINT64                Length
  );

VOID
EFIAPI
ArmReplaceLiveTranslationEntry (
  IN  UINT64  *Entry,
  IN  UINT64  Value,
  IN  UINT64  RegionStart
  );

EFI_STATUS
ArmSetMemoryAttributes (
  IN EFI_PHYSICAL_ADDRESS  BaseAddress,
  IN UINT64                Length,
  IN UINT64                Attributes
  );

/**
  BEEBE TODO
**/
EFI_STATUS
EFIAPI
TranslationTableParse (
  IN     TRANSLATION_TABLE_ENTRY  *Map,
  IN OUT UINTN                    *MapCount
  );

#endif // ARM_MMU_LIB_H_
