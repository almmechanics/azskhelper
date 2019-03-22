function Expand-Logs  {
    param (
        [string]
        $ArchivePath
    )
    
    $tmpPath= join-path ((New-TemporaryFile).DirectoryName) (get-date -Format 'a\z\sk-yyyyMMddHHmmss')
    New-Item $tmpPath -ItemType Directory -Force | out-null
    Write-warning $tmpPath   
    Expand-Archive -Path $ArchivePath -DestinationPath $tmpPath -Verbose
    return $tmpPath
}   