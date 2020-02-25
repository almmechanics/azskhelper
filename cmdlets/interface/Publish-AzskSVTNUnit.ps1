Set-StrictMode -Version latest

function Publish-AzskSVTNUnit
{
    [CmdletBinding()] 
    param(
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $Path,
        [string]
        [ValidateNotNullOrEmpty()]
        $OutputVariable = 'AZSK.NUnit.OutputPath',
        [switch]
        $EnableExit
    )
    try 
    {
        # Expand the AZSK result set
        $ExpandedAzskLogs = Expand-Logs -Path $Path -AnalysisType 'SVT'

        # Generate parameters for the test run
        $TestCases = @(ConvertTo-SVTTestCases @(Get-SVTResultList -Path $ExpandedAzskLogs))

        # Invoke pester to validate convert from AZSK to NUnit
        $summary = ConvertTo-SVTNunit -TestCases $TestCases -OutputPath $Path -OutputVariable $OutputVariable

        if ($summary.FailedCount -gt 0)
        {
            if($EnableExit)
            {
                Write-Error 'Not all AzSK SVT tests completed successfully'
            }
            else 
            {
                Write-Warning 'Not all AzSK SVT tests completed successfully'
            }
        }
    }
    catch
    {
        Write-Error $_
        return -1
    }
} 