; ------------------------------------------------------------------------------
;
; Copyright (c) 2008 - 2010, Apple Inc. All rights reserved.<BR>
; Copyright (c) 2011 - 2013, ARM Ltd. All rights reserved.<BR>
;
; SPDX-License-Identifier: BSD-2-Clause-Patent
;
; ------------------------------------------------------------------------------

INCLUDE AsmMacroIoLibV8.inc

AREA ||.text||, CODE
EXPORT GccSemihostCall


GccSemihostCall
    HLT     0xF000
    BX      LR
END