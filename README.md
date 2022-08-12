# CFC Auto Clean
CFC's automatic server cleaning system!

## Overview
This addon runs cleanup commands on your server periodically.

### How it works:
The server triggers cleanup commands at a regular interval.
Cleanup commands include:
- Removing unowned weapons
- Clearing decals

### Configuration:
- `cfc_autoclean_enabled (0 or 1)` - Enables/disables the autoclean commands. default: 1
- `cfc_autoclean_interval (number in seconds)` - Sets how regularly the commands are called. default: 500
- `cfc_autoclean_notification_enabled (0 or 1)` - Enables/disables the client-side prints. default: 1
- `cfc_autoclean_prefix (any string)` - Sets the prefix for the client-side prints. default: "CFC AutoClean"
