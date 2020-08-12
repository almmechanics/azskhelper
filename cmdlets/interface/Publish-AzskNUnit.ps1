Set-StrictMode -Version latest

function Publish-AzskNUnit {
    [CmdletBinding()] 
    param(
        [string]
        [ValidateScript( { Test-Path $_ })]
        [ValidateNotNullOrEmpty()]
        $Path,
        [string]
        [ValidateNotNullOrEmpty()]
        $OutputVariable = 'AZSK.NUnit.OutputPath',
        [switch]
        $EnableExit
    )
    try {
        # Invoke pester to validate convert from AZSK to NUnit
        $summary = ConvertTo-Nunit -OutputPath $Path -OutputVariable $OutputVariable

        if ($summary.FailedCount -gt 0) {
            if ($EnableExit) {
                Write-Error 'Not all AzSK tests completed successfully'
            }
            else {
                Write-Warning 'Not all AzSK tests completed successfully'
            }
        }
    }
    catch {
        Write-Error $_
        return -1
    }
}