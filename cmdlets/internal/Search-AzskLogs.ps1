Set-StrictMode -Version latest

function Search-AzskLogs {
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
    $LogPattern = 'ArmTemplateChecker_Logs'
    if ($AnalysisType -eq 'SVT') {
        $LogPattern = 'AzSK_'
    }

    $candidateFiles = @(Get-ChildItem -Path $Path -Include ('{0}*.zip' -f $LogPattern) -Recurse)
    if ($candidateFiles.count -eq 0) {
        throw ('No "{0}.zip" entries found.' -f $LogPattern)
    }

    if ($candidateFiles.count -gt 1) {
        throw ('Multiple "{0}.zip" entries found.' -f $LogPattern)
    }
    
    return ($candidateFiles | Select-Object -First 1).FullName
}