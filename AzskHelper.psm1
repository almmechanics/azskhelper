Set-StrictMode -Version Latest

$cmdletsPath = Join-Path $PSScriptRoot 'cmdlets'

$interfacePath = Join-Path $cmdletsPath 'interface'
. (Join-Path $interfacePath 'Publish-AzskNUnit.ps1')
. (Join-Path $interfacePath 'Publish-AzskSVTNUnit.ps1')


$internalPath = Join-Path $cmdletsPath 'internal'
. (Join-Path $internalPath 'ConvertTo-NUnit.ps1')
. (Join-Path $internalPath 'ConvertTo-SVTNUnit.PS1')
. (Join-Path $internalPath 'ConvertTo-TestCases.ps1')
. (Join-Path $internalPath 'ConvertTo-SVTTestCases.ps1')
. (Join-Path $internalPath 'Expand-Logs.ps1')
. (Join-Path $internalPath 'Get-ARMCheckerResultList.ps1')
. (Join-Path $internalPath 'Get-SVTResultList.ps1')
. (Join-Path $internalPath 'Get-SkippedFilesList.ps1')
. (Join-Path $internalPath 'Get-ModulePath.ps1')
. (Join-Path $internalPath 'Search-AzskLogs.ps1')

Write-Verbose 'azskhelper module loaded'
