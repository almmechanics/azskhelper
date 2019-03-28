$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

Describe 'Get-SkippedFilesList tests' {
    Context 'Interface Tests' {
        It 'Path array parameter cannot be null' {
            {Get-SkippedFilesList -Path $null} | should throw
        }

        It 'Path array parameter cannot be empty' {
            {Get-SkippedFilesList -Path [string]::empty} | should throw
        }

        It 'Path must be a valid path' {
            {Get-SkippedFilesList -Path 'invalid_path'} | should throw
        }
    }

    Context 'Results processing' {

        New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles'

        It 'SkippedFiles not present' {
            {Get-SkippedFilesList -path 'TestDrive:/SkippedFiles'} | should throw
        }

        It 'SkippedFiles file empty' {
            New-Item  -ItemType File -Path 'TestDrive:/SkippedFiles/SkippedFiles.Log'
            Get-SkippedFilesList -path 'TestDrive:/SkippedFiles' | should be @()
        }

        It 'One SkippedFiles file found' {
            New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles/1'
            @('valid_file_1') | Out-File 'TestDrive:/SkippedFiles/1/SkippedFiles.Log'
            Get-SkippedFilesList -path 'TestDrive:/SkippedFiles/1' | should be 'valid_file_1'
        }

        It 'Multiple SkippedFiles file found' {

            New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles/2'
            New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles/2/1'
            New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles/2/2'

            @('valid_file_1') | Out-File 'TestDrive:/SkippedFiles/2/1/SkippedFiles.Log'
            @('valid_file_2') | Out-File 'TestDrive:/SkippedFiles/2/2/SkippedFiles.Log'

            {Get-SkippedFilesList -path 'TestDrive:/SkippedFiles/2'} | should throw
        }
    }
}
