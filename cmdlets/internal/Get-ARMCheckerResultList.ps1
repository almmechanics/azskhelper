Set-StrictMode -Version latest

function Get-ARMCheckerResultList
{
    [CmdletBinding()] 
    param(
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $Path
    )

    $ARMCheckerResults = Get-ChildItem -Path $Path -Recurse  -include 'ARMCheckerResults_*.csv'
    return @(Get-Content $ARMCheckerResults | ConvertFrom-CSV)
}