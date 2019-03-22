function Publish-AzskNUnit
{
    param(
        [string]
        $AzskOutputFolder,
        [switch]
        $EnableExit
    )

 <#'D:\azsk.zip'#>   

    
    
    $tmp = Expand-Logs $ArchivePath
    Get-SkippedFilesList -Path $tmp
    $ArmResults = @(Get-ARMCheckerResultList -Path $tmp)
    $TestCases = ConvertTo-TestCases -ArmResults $ArmResults

    $azskTest = Get-ModulePath -Folder 'cmdlets/interface' -Filename 'Azsk.tests.ps1'
    $OutputFile = ($ArchivePath |Split-Path) -Filename 'azsk.nunit.xml'

    $Scripts += (@{Path=$azskTest; parameters=@{TestCases=$TestCases}})
    write-host ("##vso[task.setvariable variable=NUnit.OutputPath]" -f $OutputFile)

    Invoke-Pester -Script $Scripts -OutputFile $OutputFile -OutputFormat NUnitXml -EnableExit:$EnableExit    
}