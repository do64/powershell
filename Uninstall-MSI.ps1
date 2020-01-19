#MSI Uninstaller. This is probably some sevrely overwraught code, but it works

#This script lists out installed software that can be uninstalled using MsiExec
#Script then prompts user to enter numbers corresponding to applications to uninstall
#First attempt learning how to use nested hastables/arrays
#key = number, value=(DisplayName,GUID)
#There is also some attempt at error handlign in here.

#Find all applications with "MsiExec.exe" in the uninstall string for 64 bit
$msi64 = @(Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall |
    Get-ItemProperty | Where-Object {$_.UninstallString -like "*MsiExec.exe*"})

#Find all applications with "MsiExec.exe" in the uninstall string for 32 bit
$msi32 = @(Get-ChildItem HKLM:\SOFTWARE\WOW6432NODE\Microsoft\Windows\CurrentVersion\Uninstall |
    Get-ItemProperty | Where-Object {$_.UninstallString -like "*MsiExec.exe*"})

#Combine the arrays
$msiAll = $msi64 + $msi32
#Sort the new array
$msiAll = $msiAll | Sort-Object -Property DisplayName
#Create an empty ordered hashtable
$msiHash = [ordered]@{}
#Create an empty array for user input
$uninstall = @()
#Set counter to one
$counter = 1
#Create an array that will contain all valid values for user selection
$validSelections = @("done")
#Clear value for $selection
$selection = $null

#Create a hashtable, with the value being an array contain the MSI name and GUID
foreach ($msi in $msiAll) {
    #Regex to extract only the GUID from the uninstall string
    $guidPattern = [Regex]::new('\{.*?\}')
    $guid = $guidPattern.Matches($msi.UninstallString)
    $msiHash.add($counter,@($msi.DisplayName,$guid))
    #Counter for valid range selection
    $validSelections += $counter
    $counter += 1
}

#Prints list of uninstallable applications to the console
Write-Host "Uninstallable Applications:`n"
$msiHash.Keys.ForEach({"$_`. $($msiHash.$_[0])"}) -join "`n"

#Instructions for input
Write-Host "`nEnter the number which corresponds to the application you would like to uninstall.`nEnter one number per 'Input' and press ENTER, you will then be prompted to enter another number.`nWhen you have entered the numbers of all the applications you would like to uninstall type DONE and press ENTER, you will then be asked to confirm the uninstall."

While ($selection -ne "done") {
    #Resets $selection for evaluation on if loop below
    $selection = $null
    $selection = (Read-Host "Input").ToLower()
    if ($selection) {
        if ($validSelections -contains $selection) {
            if ($selection -ne "done") {$uninstall += [int]$selection}
        }
        else {
            Write-Host "Invalid selection." -ForegroundColor Red
        }
    }
    else {
        Write-Host "Invalid selection." -ForegroundColor Red
    }
}

Write-Host "The following applications will be uninstalled:"
foreach ($a in $uninstall) {
    (($msiHash.$a)[0]) 
}

#This is super clunked out but works
Write-Host "Press ENTER to confirm or Ctrl + C to cancel..."
Read-Host

foreach ($app in $uninstall) {
    $msiDisplayName = ($msiHash.$app)[0]
    $msiGuid = ($msiHash.$app)[1]
    Start-Process "MsiExec.exe" -ArgumentList "/X $msiGuid /quiet" -Wait
    if (!$?) {
        Write-Host "Error uninstalling $msiDisplayName" -ForegroundColor Red
    }
    else {
        Write-Host "Successfully uninstalled $msiDisplayName" -ForegroundColor Green
    }  
}
