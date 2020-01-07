<#
    .Synopsis
        which [-a] filename
    .Description
        An attempt to emulate the UNIX which command in PowerShell. which returns the pathnames of the files, alias, or functions that would be executed in the current environment.
        It does this by using the 'Get-Command' PowerShell function to search for the Path, DLL, or CommandType of the argument.
        
        The argument is first checked for the 'Path' property, if this is not found the agument is then checked for the 'DLL' property. If neither of these are found the 'which'
        cmdlet then checks for the 'CommandType' property and returns applicable information.
    .Example 
        which notepad.exe 
        #>

Function which ($command){

    $ErrorActionPreference= 'silentlycontinue'

    #Check if Path property exists and return value if so
    if ((Get-Command $command).Path){
        (Get-Command $command).Path
    }

    #Check if DLL property exists and return value if so
    elseif ((Get-Command $command).DLL){
        (Get-Command $command).DLL
    }

    #Check if $command is Alias and return DisplayName if so
    elseif ((Get-Command $command).CommandType -eq "Alias"){
        $alias = (Get-Command $command).DisplayName
        Write-Output "$alias"
    }
    
    #If command is a function return the module it is from if the Module property exists
    elseif ((Get-Command $command).CommandType -eq "Function"){
        if ((Get-Command $command).Module){
            $module = (Get-Command $command).Module
            $module_path = (Get-Module $module).Path
            Write-Output "Function from module: $module_path"
        }
        else {
            Write-Output "$command is a function"
        }
    }
    else {
        break
    }
}





