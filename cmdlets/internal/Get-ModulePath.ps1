Set-StrictMode -Version latest

function Get-ModulePath
{
    
    param(
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateNotNullOrEmpty()]
        $Filename,
        [string]
        [ValidateNotNullOrEmpty()]
        $Folder ='.'
    )

    $moduleBase = (Get-Module 'AzskHelper').ModuleBase

    return Join-Path $moduleBase (Join-Path $Folder $Filename)
}

