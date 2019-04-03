Set-StrictMode -Version latest

function Publish-AzskNUnit
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
        $ExpandedAzskLogs = Expand-Logs -Path $Path

        # Generate parameters for the test run
        $TestCases = @(ConvertTo-TestCases -ArmResults @(Get-ARMCheckerResultList -Path $ExpandedAzskLogs))

        # Invoke pester to validate convert from AZSK to NUnit
        $summary = ConvertTo-Nunit -TestCases $TestCases -OutputPath $Path -OutputVariable $OutputVariable

        if ($summary.FailedCount -gt 0)
        {
            Write-Warning 'Not all AzSK tests completed successfully'

            if($EnableExit)
            {
                $host.SetShouldExit($summary.FailedCount)
            }
        }
    }
    catch
    {
        Write-Error $_
        return -1
    }
}