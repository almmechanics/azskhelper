function Get-ModulePath
{
    param(
    [string]
    $Folder ='.',
    [string]
    $Filename)

    $root = (Get-Module 'AzskHelper').ModuleBase

    return Join-Path $root (Join-Path $Folder $Filename)
}

