Set-StrictMode -Version latest

function Get-SkippedFilesList
{
    [CmdletBinding()] 
    param(
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $Path
    )
    $candidateFiles = @( Get-ChildItem -Path $Path -Recurse -filter 'SkippedFiles.Log')
    if ($candidateFiles.count -gt 0)
    {
        if ($candidateFiles.count -gt 1)
        {
            throw 'Multiple "SkippedFiles.Log" entries found.'
        }
        $SkippedFilesLog = ($candidateFiles | Select-Object -First 1).FullName
        return @(Get-Content ($SkippedFilesLog))
    }
    else
    {
        throw 'No "SkippedFiles.Log" entries found.'
    }
}