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

    $Global:AzSKPath = $OutputPath       

    $TestsToRun = Get-ModulePath -Folder 'azsktests' -Filename 'Azsk.arm.tests.ps1'

    $configuration = [PesterConfiguration]::Default
    $configuration.Run.Exit = $True
    $Configuration.TestResult.Enabled = $True
    $configuration.TestResult.OutputPath = $OutputFile
    $configuration.TestResult.OutputFormat = 'NUnitXml'
    $configuration.Run.Path = $TestsToRun
    $configuration.Run.PassThru = $True

    return (Invoke-Pester -Configuration $configuration)
}