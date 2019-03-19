function Publish-AzskNUnit
{
    param(
        [string]
        $path
    )

 <#'D:\azsk.zip'#>   

$tmp = Expand-Logs $path
Get-SkippedFilesList -Path $tmp
$ArmResults = @(Get-ARMCheckerResultList -Path $tmp)
$TestCases = ConvertTo-TestCases -ArmResults $ArmResults

$azskTest = Get-ModulePath -Folder 'cmdlets/interface' -Filename 'Azsk.tests.ps1'
$OutputFile = Get-ModulePath -Filename 'azsk.nunit.xml'

$Scripts += (@{Path=$azskTest; parameters=@{TestCases=$TestCases}})

Invoke-Pester -Script $Scripts -OutputFile $OutputFile -OutputFormat NUnitXml
}