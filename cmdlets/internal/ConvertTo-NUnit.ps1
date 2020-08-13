Set-StrictMode -Version latest
function ConvertTo-NUnit {
    [CmdletBinding()] 
    param(
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateScript( { Test-Path $_ })]
        $OutputPath,
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateNotNullOrEmpty()]
        $OutputVariable
        )

    $OutputFile = Join-Path $OutputPath 'TEST-azsk.nunit.xml'
    Write-Host ("##vso[task.setvariable variable={0}]{1}" -f $OutputVariable, $OutputFile)

    $TestsToRun = Get-ModulePath -Folder 'azsktests' -Filename 'Azsk.arm.tests.ps1'
    $Global:AzSKPath = $OutputPath

    return (Invoke-Pester -path $TestsToRun -OutputFile $OutputFile -OutputFormat NUnitXml -PassThru)
}