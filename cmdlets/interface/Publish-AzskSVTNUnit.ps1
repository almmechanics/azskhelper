Set-StrictMode -Version latest

function Publish-AzskSVTNUnit {
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
        $summary = ConvertTo-SVTNUnit -OutputPath $Path -OutputVariable $OutputVariable

        if ($summary.FailedCount -gt 0) {
            if ($EnableExit) {
                Write-Error 'Not all AzSK SVT tests completed successfully'
            }
            else {
                Write-Warning 'Not all AzSK SVT tests completed successfully'
            }
        }
    }
    catch {
        Write-Error $_
        return -1
    }
} 