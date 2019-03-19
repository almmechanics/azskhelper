function Get-SkippedFilesLog
{
    param(
        [string]
        $Path
    )
    $SkippedFilesLog = ( Get-ChildItem -Path $Path -Recurse -filter 'SkippedFiles.Log')
    return ($SkippedFilesLog).FullName
}