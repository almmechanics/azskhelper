Set-StrictMode -Version latest

function Expand-Logs {
    [CmdletBinding()] 
    param (
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateScript( { Test-Path $_ })]
        [ValidateNotNullOrEmpty()]
        $Path,

        [string]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('ARM', 'SVT')]
        $AnalysisType
    )
    
    # Find Singular AZSK archive
    $ArmTemplateCheckerLog = Search-AzskLogs -Path $Path -AnalysisType $AnalysisType
 
    $ExpandedPath = join-path ((New-TemporaryFile).DirectoryName) (get-date -Format 'a\z\sk-yyyyMMddHHmmss')
    New-Item $ExpandedPath -ItemType Directory -Force | out-null

    Expand-Archive -Path $ArmTemplateCheckerLog -DestinationPath $ExpandedPath -Verbose

    Write-Verbose ('Expanded "{0} into "{1}" folder' -f $ArmTemplateCheckerLog, $ExpandedPath)
    
    return $ExpandedPath
}   