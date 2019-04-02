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
        ConvertTo-Nunit -TestCases $TestCases -OutputPath $Path -EnableExit:$EnableExit -OutputVariable $OutputVariable
    }
    catch
    {
        Write-Error $_
        return -1
    }
}