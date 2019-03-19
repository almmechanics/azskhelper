function Get-SkippedFilesList
{
    param(
        [string]
        $Path
    )
    return @(Get-Content (Get-SkippedFilesLog -Path $Path))
}