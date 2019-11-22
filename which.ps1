#PowerShell function for a 'which' type command as used in UNIX systems 

#If the 'path' for a command is present the function returns the 'path'
#If there is no 'path' listed the function returns the standard output
#of the Get-Command which provides other useful information

#I add this to my PowerShell $profile

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





