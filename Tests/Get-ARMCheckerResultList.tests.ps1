$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

Describe 'Expand-Logs tests' {
    Context 'Interface Tests' {
        It 'Path array parameter cannot be null' {
            {Get-ARMCheckerResultList -Path $null} | should throw
        }

        It 'Path array parameter cannot be empty' {
            {Get-ARMCheckerResultList -Path [string]::empty} | should throw
        }

        It 'Path must be a valid path' {
            {Get-ARMCheckerResultList -Path 'invalid_path'} | should throw
        }
    }

    Context 'Results processing' {

        New-item -ItemType Directory -Path 'TestDrive:/ARMCheckerResults'

        It 'ARMCheckerResults_ not present' {
            {Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults'} | should throw
        }

        It 'ARMCheckerResults file empty' {
            New-Item  -ItemType File -Path 'TestDrive:/ARMCheckerResults/ARMCheckerResults_empty.csv'
           { Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults'} | should throw
        }

        It 'One ARMCheckerResults file found with no header' {
            New-item -ItemType Directory -Path 'TestDrive:/ARMCheckerResults/1'
            @('"value"') | Out-File 'TestDrive:/ARMCheckerResults/1/ARMCheckerResults_1.csv'
            {Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults/1'} | should throw
        }

        It 'One ARMCheckerResults file found with a header' {
            New-item -ItemType Directory -Path 'TestDrive:/ARMCheckerResults/2'
            @('"header"','"value"') | Out-File 'TestDrive:/ARMCheckerResults/2/ARMCheckerResults_1.csv'
            Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults/2' | should be '@{header=value}'
        }

        It 'Multiple ARMCheckerResults file found' {

            New-item -ItemType Directory -Path 'TestDrive:/ARMCheckerResults/3'

            @('valid_file_1') | Out-File 'TestDrive:/ARMCheckerResults/3/ARMCheckerResults_1.csv'
            @('valid_file_2') | Out-File 'TestDrive:/ARMCheckerResults/3/ARMCheckerResults_2.csv'

            {Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults/3'} | should throw
        }
    }
}
