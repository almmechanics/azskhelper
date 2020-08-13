Set-StrictMode -Version latest
function ConvertTo-SVTNUnit {
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

    $OutputFile = Join-Path $OutputPath 'TEST-azsk-svt.nunit.xml'
    Write-Host ("##vso[task.setvariable variable={0}]{1}" -f $OutputVariable, $OutputFile)

    $TestsToRun = Get-ModulePath -Folder 'azsktests' -Filename 'Azsk.svt.tests.ps1' 
    $Global:AzSKPath = $OutputPath       
    
    return (Invoke-Pester -path $TestsToRun -OutputFile $OutputFile -OutputFormat NUnitXml -PassThru)
}