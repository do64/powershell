# PowerShell
This repo contains various PowerShell scripts I've written. Below are general descriptions of what each script does.

# Send-MagicPacket.ps1 #
Send a wake on LAN magic packet. Description of parameters is below.

**MacAddress**
> MAC address of the host you want to wake.

**BroadcastAddress**
> Define a broadcast address to send the magic packet to. Defaults to 255.255.255.255

**Port**
> Port to send magic packet to. Defaults to 7.

**ConfirmAwake**
> Define a hostname or IP address of the device to be woken up. If this parameter is used the script will immediatley start pinging the target device after sending the magic packet.

**Beep**
> Switch. If used with **ConfirmAwake** one console beep will be played when the target device responds to a ping.


# Set-DarkOrLightTheme.ps1 #
Toggle the system theme to a default dark or light theme with optional Windows Terminal color scheme support. 

Modify the **$SystemDefaultDark** and **$SystemDefaultLight** variables at the top of the script to point to the path of custom dark and light themes if desired. Modify the **$TerminalDefaultDark** and **$TerminalDefaultLight** variables for Windows Terminal color schemes. Just reference the name of the scheme as defined in your Windows Terminal settings json file.

The mandatory **-Mode** parameter is used to set theme to Dark or Light. Use the **-Terminal** switch to also set the color scheme of Windows Terminal for all terminal profiles.

In the example below the system and Windows Terminal will both be set to dark mode.
```powershell
Set-DarkOrLightTheme -Mode Dark -Terminal
```

# Set-TaskbarVisibility.ps1 #
Toggles taskbar visibility if no argument is provided. Parameter **-Visibility** can be added to explictly set the taskbar as either **Visible** or **Autohide**.

# which.ps1 #
Written to add to my PowerShell $profile to roughly replicate something like the 'which' command on \*nix systems. This is essentially just a wrapper for the Get-Command cmdlet. Output is simplified compared to Get-Command.

The **-a** switch can be used to find all matches. Example below.
```powershell
which notepad -a
C:\Windows\system32\notepad.exe
C:\Windows\notepad.exe
C:\Users\Bort\AppData\Local\Microsoft\WindowsApps\notepad.exe
```
