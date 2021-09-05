# PowerShell
This repo contains anything potentially useful I've written in PowerShell.


### Get-UserApps.ps1 ###
Some applications can be installed for a single user. Common examples are Spotify, Zoom, Webex. Usually these apps do not require administrative privileges to be installed. This script maps all user registry hives to a PowerShell drive and then finds the apps that are installed in a single user context for each user who has logged on to the machine. The script returns an array of objects, each object includes the user's username and details about the user's applications installed in a single user context. If crappy crapware is installed but does not list itself in the registry it will not be discovered by this script.

### which.ps1 ###
Written to add to my PowerShell $profile to roughly replicate something like the 'which' command on \*nix systems. This is essentially just a wrapper for the Get-Command cmdlet. Output is simplified compared to Get-Command.
