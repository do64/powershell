[CmdletBinding()]
param(
    # Accepts AutoHide or Visible
    [Parameter()]
    [string]
    $Visibility
)

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3"
$RegValues = (Get-ItemProperty -Path $RegPath).Settings
$RegValues[8]

if ($Visibility -eq "") {
    if ($RegValues[8] -eq 122) {
        $RegValues[8] = 123
        Set-ItemProperty -Path $RegPath -Name Settings -Value $RegValues
        Stop-Process -Name explorer
        exit
    } elseif ($RegValues[8] -eq 123) {
        $RegValues[8] = 122
        Set-ItemProperty -Path $RegPath -Name Settings -Value $RegValues
        Stop-Process -Name explorer
        exit
    }
} else {
    if ($Visibility -eq "Visible") {
        $RegValues[8] = 122
        Set-ItemProperty -Path $RegPath -Name Settings -Value $RegValues
        Stop-Process -Name explorer
        exit
    } elseif ($Visibility -eq "AutoHide") {
        $RegValues[8] = 123
        Set-ItemProperty -Path $RegPath -Name Settings -Value $RegValues
        Stop-Process -Name explorer
        exit
    }
}