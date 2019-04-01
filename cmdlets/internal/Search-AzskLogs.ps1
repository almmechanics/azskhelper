Set-StrictMode -Version latest

function Search-AzskLogs  {
    [CmdletBinding()] 
    param (
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $Path
    )
    
    # Find Singular AZSK archive
    $candidateFiles = @(Get-ChildItem -Path $Path -Include 'ArmTemplateChecker_Logs*.zip' -Recurse)
    if ($candidateFiles.count -eq 0)
    {
        throw 'No "ArmTemplateChecker_Logs.zip" entries found.'
    }

    if ($candidateFiles.count -gt 1)
    {
        throw 'Multiple "ArmTemplateChecker_Logs.*.zip" entries found.'
    }
    
    return ($candidateFiles | Select-Object -First 1).FullName
}