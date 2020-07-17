# CFC Auto Clean
CFC's automatic server cleaning system!

## Overview
This addon runs cleanup commands on your server periodically.

### How it works:
The server triggers cleanup commands at an interval in seconds set by the `cfc_autoclean` console variable.  
Cleanup commands include:
- Removing unowned weapons
- Clearing decals

### Anti Prop Grief
If APG is installed, the cleanup commands will also be triggered by APG's `APG_lagDetected` hook.
