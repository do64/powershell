#If the 'path' for a command is present the function returns the 'path'
#If there is no 'path' listed the function returns the standard output
#of the Get-Command which provides other useful information

[CmdletBinding()]
param(
  [Alias("all")]  
  [switch]$a,
  [Parameter(Mandatory=$false)]
  [string]
  $filename
)

$ErrorActionPreference= 'silentlycontinue'

#Check if Path property exists and return value if so
if ((Get-Command $filename).Path){
    if ($a) {(Get-Command $filename -All).Path}
    else {(Get-Command $filename).Path}
}

#Check if DLL property exists and return value if so
elseif ((Get-Command $filename).DLL){
    if ($a) {(Get-Command $filename -All).DLL}
    else {(Get-Command $filename).DLL}
}

#Check if $filename is Alias and return DisplayName if so
elseif ((Get-Command $filename).CommandType -eq "Alias"){
    if ($a) {$alias = (Get-Command $filename -All).Definition}
    else {$alias = (Get-Command $filename).Definition}
    Write-Output "$filename -> $alias"
}
    
#If command is a function return the module it is from if the Module property exists
elseif ((Get-Command $filename).CommandType -eq "Function"){
    if ((Get-Command $filename).Module){
        if ($a) {
            $module = (Get-Command $filename -All).Module.Path
        } else {
            $module = (Get-Command $filename).Module.Path
        }
        Write-Output "Function from module: $module"
    }
    else {
        Write-Output "$filename is a function"
    }
}
else {
    break
}
