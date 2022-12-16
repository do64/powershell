# Version 1.0
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Dark","Light")]
    [string]
    $Mode,
    [Switch]
    $Terminal
)

# provide the full path of the theme files to be used by default
$SystemDefaultDark = "C:\Windows\Resources\Themes\dark.theme"
$SystemDefaultLight = "C:\Windows\Resources\Themes\aero.theme"

# WINDOWS TERMINAL: provide the name of the Windows Terminal color scheme to be used by default
$TerminalDefaultDark = "One Half Dark"
$TerminalDefaultLight = "One Half Light"

# Default should be fine but can be modified if needed
$TerminalSettingsJsonPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

function SetTerminal($TM) {
    if ($TM -eq "Dark") {$TerminalMode = $TerminalDefaultDark}
    if ($TM -eq "Light") {$TerminalMode = $TerminalDefaultLight}

    $SettingsJson = Get-Content -Raw -Path $TerminalSettingsJsonPath | ConvertFrom-Json
    $Profiles = $SettingsJson.profiles.list
    foreach ($P in $Profiles) {
        Write-Host $P.guid
        if (($SettingsJson.profiles.list | Where-Object {$_.guid -eq $P.guid}).colorScheme) {
            ($SettingsJson.profiles.list | Where-Object {$_.guid -eq $P.guid}).colorScheme = $TerminalMode
        } else {
            ($SettingsJson.profiles.list | Where-Object {$_.guid -eq $P.guid}) | Add-Member -Name "colorScheme" -Value $TerminalMode -MemberType NoteProperty
        }
    }
    $SettingsJson | ConvertTo-Json -Depth 100 | Out-File $TerminalSettingsJsonPath -Force
}
function SetMode($M) {
    if ($M -eq "Dark") {$Theme = $SystemDefaultDark}
    if ($M -eq "Light") {$Theme = $SystemDefaultLight}

    Stop-Process -Name SystemSettings -ErrorAction SilentlyContinue
    Start-Process $Theme -Wait
    Stop-Process -Name SystemSettings
    if ($Terminal) {
        SetTerminal $M
    }
}

SetMode $Mode