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

    $SVTContent = @()
    foreach ($SVTFile in $candidateFiles)
    {
        Write-Verbose ('Processing file "{0}"' -f $SVTFile.FullName)
        $SVTContent += @(Get-Content $SVTFile.FullName | ConvertFrom-Csv)
    }

    if ($SVTContent.count -eq 0)
    {
        throw ('No Header/Content found.')
    }

    return @($SVTContent)
}