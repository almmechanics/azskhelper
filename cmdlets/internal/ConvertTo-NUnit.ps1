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
        [string]
        [ValidateNotNullOrEmpty()]
        $OutputVariable,
        [Parameter(Mandatory=$true)]
        [array]
        [ValidateNotNullOrEmpty()]
        $TestCases
    )

    $OutputFile = Join-Path $OutputPath 'TEST-azsk.nunit.xml'
    Write-Host ("##vso[task.setvariable variable={0}]{1}" -f $OutputVariable, $OutputFile)

    $TestsToRun = Get-ModulePath -Folder 'azsktests' -Filename 'Azsk.tests.ps1'

    return (Invoke-Pester -Script (@{Path=$TestsToRun; parameters=@{TestCases=$TestCases}}) -OutputFile $OutputFile -OutputFormat NUnitXml -PassThru)
}