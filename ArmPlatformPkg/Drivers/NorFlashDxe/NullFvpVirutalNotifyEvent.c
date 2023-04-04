#include "NorFlash.h"

VOID
EFIAPI
FvbVirtualNotifyEvent (
  IN EFI_EVENT  Event,
  IN VOID       *Context
  )

{
  return;
}


/**
  Fixup internal data so that EFI can be call in virtual mode.
  Call the passed in Child Notify event and convert any pointers in
  lib to virtual mode.

  @param[in]    Event   The Event that is being processed
  @param[in]    Context Event Context
**/
VOID
EFIAPI
NorFlashVirtualNotifyEvent (
  IN EFI_EVENT  Event,
  IN VOID       *Context
  )
{
  return;
}