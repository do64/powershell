# PowerShell
This repo contains anything potentially useful I've written in PowerShell.


### Get-UserApps.ps1 ###
Some applications can be installed for a single user. Common examples are Spotify, Zoom, Webex. Usually these apps do not require admin permission to be installed. This script map all user registry hives to a PowerShell drive then find apps installed for a single user for each user who has logged on to the machine. The script returns an object with the username and an array of installed applications from the registry. If crappy crap ware is installed but does not list itself in the registry it will not be discovered by this script.

### which.ps1 ###
Written to add to my PowerShell $profile to roughly replicate something like the 'which' command on \*nix systems. This is essentially just a wrapper for the Get-Command cmdlet. Output is simplified compared to Get-Command.
