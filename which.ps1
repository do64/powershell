#PowerShell function for a 'which' type command as used in UNIX systems 

#If the 'path' for a command is present the function returns the 'path'
#If there is no 'path' listed the function returns the standard output
#of the Get-Command which provides other useful information

#I add this to my PowerShell $profile

Function which ($command){
    $command_path = (Get-Command $command).Path

    if ($command_path){
        (Get-Command $command).Path
    }

    else {
        Get-Command $command
    }
}
