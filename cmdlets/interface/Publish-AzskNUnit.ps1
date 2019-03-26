Set-StrictMode -Version latest

function Publish-AzskNUnit
{
    [CmdletBinding()] 
    param(
        [string]
        $AzskOutputFolder,
        [switch]
        $EnableExit
    )

    $expandedLogs = Expand-Logs $ArchivePath
    Get-SkippedFilesList -Path $expandedLogs

    $armResults = @(Get-ARMCheckerResultList -Path $expandedLogs)
    $TestCases = ConvertTo-TestCases -ArmResults $armResults

    $azskTest = Get-ModulePath -Folder 'cmdlets/interface' -Filename 'Azsk.tests.ps1'

    $OutputFile = join-path ($ArchivePath | Split-Path) 'azsk.nunit.xml'
    write-host ("##vso[task.setvariable variable=NUnit.OutputPath]" -f $OutputFile)

    $Scripts += (@{Path=$azskTest; parameters=@{TestCases=$TestCases}})
    Invoke-Pester -Script $Scripts -OutputFile $OutputFile -OutputFormat NUnitXml -EnableExit:$EnableExit    
}