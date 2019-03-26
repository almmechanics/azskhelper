Set-StrictMode -Version latest

function Expand-Logs  {
    [CmdletBinding()] 
    param (
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $ArchivePath
    )
    
    $ExpandedPath= join-path ((New-TemporaryFile).DirectoryName) (get-date -Format 'a\z\sk-yyyyMMddHHmmss')
    New-Item $ExpandedPath -ItemType Directory -Force | out-null
    Expand-Archive -Path $ArchivePath -DestinationPath $expandedPath -Verbose
    return $ExpandedPath
}   