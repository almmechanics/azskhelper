Set-StrictMode -Version latest

function Publish-AzskNUnit
{
    [CmdletBinding()] 
    param(
        [string]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        $AzskOutputFolder,
        [switch]
        $EnableExit
    )
    try 
    {
        
        # Expand the AZSK result set
        $ExpandedAzskLogs = Expand-Logs $AzskOutputFolder

        # Generate parameters for the test run
        $TestsToRun = Get-ModulePath -Folder 'cmdlets/interface' -Filename 'Azsk.tests.ps1'
        $TestCases = @((Get-ARMCheckerResultList -Path $ExpandedAzskLogs) | ConvertTo-TestCases)
        $OutputFile = join-path ($ArchivePath | Split-Path) 'azsk.nunit.xml'
        Write-host ("##vso[task.setvariable variable=NUnit.OutputPath]" -f $OutputFile)
      
        # invoke pester to validate convert from AZSK to NUnit
        Invoke-Pester -Script (@{Path=$TestsToRun; parameters=@{TestCases=$TestCases}}) -OutputFile $OutputFile -OutputFormat NUnitXml -EnableExit:$EnableExit    
    }
    catch
    {
        Write-Error $_
        return -1
    }
}