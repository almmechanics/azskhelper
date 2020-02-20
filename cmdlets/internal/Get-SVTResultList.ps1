Set-StrictMode -Version latest

function Get-SVTResultList
{
    [CmdletBinding()] 
    param(
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $Path
    )

    $candidateFiles = @( Get-ChildItem -Path $Path -filter '*SecurityReport*.csv' -recurse)
    if ($candidateFiles.count -eq 0)
    {
        throw 'No "SecurityReport.csv" entries found.'
    }

    if ($candidateFiles.count -gt 1)
    {
        throw 'Multiple "SecurityReport.csv" entries found.'
    }

    $ARMCheckerResults = ($candidateFiles | Select-Object -First 1).FullName
    Write-Verbose ('Processing file "{0}"' -f $ARMCheckerResults)

    $content = @((Get-Content $ARMCheckerResults) | ConvertFrom-CSV)
    if ($content.count -eq 0)
    {
        throw ('No Header/Content found in "{0}"' -f $ARMCheckerResults)
    }

    return  $content
}