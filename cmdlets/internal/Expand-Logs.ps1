Set-StrictMode -Version latest

function Expand-Logs  {
    [CmdletBinding()] 
    param (
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $Path
    )
    
    # Find Singular AZSK archive
    $ArmTemplateCheckerLog = Search-AzskLogs -Path $Path
 
    $ExpandedPath= join-path ((New-TemporaryFile).DirectoryName) (get-date -Format 'a\z\sk-yyyyMMddHHmmss')
    New-Item $ExpandedPath -ItemType Directory -Force | out-null

    Expand-Archive -Path $ArmTemplateCheckerLog -DestinationPath $ExpandedPath -Verbose

    Write-Verbose ('Expanded "{0} into "{1}" folder' -f $ArmTemplateCheckerLog, $ExpandedPath)
    
    return $ExpandedPath
}   