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

    $SkippedFilesLog = ( Get-ChildItem -Path $Path -Recurse -filter 'SkippedFiles.Log').FullName

    return @(Get-Content ($SkippedFilesLog))
}