# Find apps installed in a per user context by querying the registry

function Get-Exe($App) {
    $File = $App.DisplayIcon.Split(',')[0]
    if ((Get-ItemProperty $File -ErroAction -SilentlyContinue).Extension -eq '.exe') {
            return $File
    }
    else {
        return (Get-ChildItem (Split-Path $File) | Where-Object {$_.Extension -eq '.exe'}).VersionInfo.FileName
    }
}

# Pull list of users with home folders
$Users = (Get-ChildItem $env:SYSTEMDRIVE\Users | Where-Object {$_.Name -ne "Public"})
foreach ($User in $Users) {
    Add-Member -InputObject $User -NotePropertyName 'SID' -NotePropertyValue (Get-CimInstance win32_useraccount | `
    Where-Object {$_.name -eq $User.Name} | Select-Object sid).sid
}

$PatternSID = 'S-1-5-21-\d+-\d+\-\d+\-\d+$'
$LoadedHives = Get-ChildItem Registry::HKEY_USERS | Where-Object {$_.PSChildname -match $PatternSID}
$UnloadedHives = (Compare-Object $Users.SID $LoadedHives.PSChildname).InputObject

$AppList = @() # List to hold customized application objects
foreach ($User in $Users) {
    if ($User.SID -in $UnloadedHives) {reg load HKU\$($User.SID) C:\Users\$($User.Name)\NTUSER.DAT}
    $64bitUserApps = @(Get-ChildItem registry::HKEY_USERS\$($User.SID)\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue | Get-ItemProperty)
    $32bitUserApps = @(Get-ChildItem registry::HKEY_USERS\$($User.SID)\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue | Get-ItemProperty)
    $InstalledUserApps = $64bitUserApps + $32bitUserApps
    foreach ($App in $InstalledUserApps) {
        $App | Add-Member -NotePropertyName 'User' -NotePropertyValue $User.Name
        try {
            $App | Add-Member -NotePropertyName 'PossibleExe' -NotePropertyValue (Get-Exe($App)) 
        } catch {}
        $AppList += $App
    }
    if ($User.SID -in $UnloadedHives) {
        [gc]::Collect()
        reg unload HKU\$($User.SID) | Out-Null
    }
}

$AppList | Select-Object -Property User, DisplayName, Publisher, `
            DisplayVersion, PossibleExe, UninstallString, QuietUninstallString, `
            EstimatedSize | Out-GridView -Title 'Installed Single User Applications' -PassThru

return $AppList