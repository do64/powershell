# Find apps installed in a per user context by querying the registry

class UserApps {
    [string]$Username
    [array]$InstalledApps
}

# Pull list of users with home folders
$Users = (Get-ChildItem $env:SYSTEMDRIVE\Users | Where-Object {$_.Name -ne "Public"})
# Get users SIDs
$UserSIDs = Get-CimInstance win32_useraccount | Select-Object name,sid
# Map user registry hives to PowerShell drive
New-PSDrive -Name GetUserApps -PSProvider Registry -Root HKEY_Users | Out-Null

function Get-InstalledUserApps($UserSID) {
    $64bitUserApps = @(Get-ChildItem GetUserApps:\$userSID\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue | Get-ItemProperty)
    $32bitUserApps = @(Get-ChildItem GetUserApps:\$userSID\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue | Get-ItemProperty)
    $AllApps = $64bitUserApps + $32bitUserApps
    return $AllApps
}

$UserList = @() # List to hold custom user objects
foreach ($User in $Users) {
    $UserSID = ($UserSIDs | Where-Object {$_.name -eq $User.Name}).sid
    $UserObject = [UserApps]::new()
    $UserObject.Username = $User.Name
    $UserObject.InstalledApps = Get-InstalledUserApps($UserSID)
    $UserList += $UserObject
}

Remove-PSDrive -Name GetUserApps

return $UserList