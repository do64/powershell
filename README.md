# PowerShell
Public PowerShell stuff I've written.

### Set-LightOrDarkTheme.ps1 ###
Toggle the system theme to a default dark or light theme with optional Windows Terminal color scheme support. 

Modify the $SystemDefaultDark and $SystemDefaultLight variables to point to the path of custom dark and light themes if desired. Modify the $TerminalDefaultDark and $TerminalDefaultLight variables for Windows Terminal color schemes. Just reference the name of the scheme as defined in your Windows Terminal settings json file.

The mandatory -Mode parameter is used to set theme to Dark or Light. Use the -Terminal switch to also set the color scheme of Windows Terminal for all terminal profiles.

### Set-TaskbarVisibility.ps1 ###
Toggles taskbar visibility if no argument is provided. Parameter 'Visibility' can be added to explictly set the taskbar as either 'Visible' or 'Autohide'.

### which.ps1 ###
Written to add to my PowerShell $profile to roughly replicate something like the 'which' command on \*nix systems. This is essentially just a wrapper for the Get-Command cmdlet. Output is simplified compared to Get-Command.
