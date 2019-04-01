Set-StrictMode -Version latest

function Publish-AzskNUnit
{
    [CmdletBinding()] 
    param(
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $Path,
        [switch]
        $EnableExit
    )
    try 
    {
        # Expand the AZSK result set
        $ExpandedAzskLogs = Expand-Logs -Path $Path

        # Generate parameters for the test run
        $TestCases = @((Get-ARMCheckerResultList -Path $ExpandedAzskLogs) | ConvertTo-TestCases)

        # Invoke pester to validate convert from AZSK to NUnit
        ConvertTo-Nunit -TestCases $TestCases -OutputPath ($Path | Split-Path) -EnableExit:$EnableExit  
    }
    catch
    {
        Write-Error $_
        return -1
    }
}