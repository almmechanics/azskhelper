function Expand-Logs  {
    param (
        [string]
        $archivename
    )
    
    $tmpPath= join-path ((New-TemporaryFile).DirectoryName) (get-date -Format 'a\z\sk-yyyyMMddHHmmss')
    New-Item $tmpPath -ItemType Directory -Force | out-null
    Write-warning $tmpPath   
    Expand-Archive -Path $archivename -DestinationPath $tmpPath -Verbose
    return $tmpPath
}   