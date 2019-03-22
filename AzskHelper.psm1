Set-StrictMode -Version Latest
$cmdletsPath = Join-Path $PSScriptRoot 'cmdlets'
$interfacePath = Join-Path $cmdletsPath 'interface'
. (Join-Path $interfacePath 'Publish-AzskNUnit.ps1')
$internalPath = Join-Path $cmdletsPath 'internal'
# <internal_sample>.ps1')
. (Join-Path $internalPath 'ConvertTo-TestCases.ps1')
. (Join-Path $internalPath 'Expand-Logs.ps1')
. (Join-Path $internalPath 'Get-ARMCheckerResultList.ps1')
. (Join-Path $internalPath 'Get-SkippedFilesList.ps1')
. (Join-Path $internalPath 'Get-SkippedFilesLog.ps1')
. (Join-Path $internalPath 'Get-ModulePath.ps1')

Write-Host 'azskhelper module loaded'
