
Set-StrictMode -Version latest
function ConvertTo-NUnit
{
    [CmdletBinding()] 
    param(
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateScript({Test-Path $_})]
        $OutputPath,
        [Parameter(Mandatory=$true)]
        [array]
        [ValidateNotNullOrEmpty()]
        $TestCases,
        [switch]
        $EnableExit
    )

    $OutputFile = Join-Path $OutputPath 'TEST-azsk.nunit.xml'
    Write-host ("##vso[task.setvariable variable=AZSK.NUnit.OutputPath]" -f $OutputFile)

    $TestsToRun = Get-ModulePath -Folder 'azsktests' -Filename 'Azsk.tests.ps1'

    Invoke-Pester -Script (@{Path=$TestsToRun; parameters=@{TestCases=$TestCases}}) -OutputFile $OutputFile -OutputFormat NUnitXml -EnableExit:$EnableExit    
}