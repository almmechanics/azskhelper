$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

Describe 'Get-SVTResultList tests' {
    Context 'Interface Tests' {
        It 'Path array parameter cannot be null' {
            {Get-SVTResultList -Path $null} | should throw
        }

        It 'Path array parameter cannot be empty' {
            {Get-SVTResultList -Path [string]::empty} | should throw
        }

        It 'Path must be a valid path' {
            {Get-SVTResultList -Path 'invalid_path'} | should throw
        }
    }

    Context 'Results processing' {

        New-item -ItemType Directory -Path 'TestDrive:/SecurityReport'

        It 'SecurityReport not present' {
            {Get-SVTResultList -path 'TestDrive:/SecurityReport'} | should throw
        }

        It 'SecurityReport file empty' {
            New-Item  -ItemType File -Path 'TestDrive:/SecurityReport/SecurityReport_empty.csv'
           { Get-SVTResultList -path 'TestDrive:/SecurityReport'} | should throw
        }

        It 'One SecurityReport file found with no header' {
            New-item -ItemType Directory -Path 'TestDrive:/SecurityReport/1'
            @('"value"') | Out-File 'TestDrive:/SecurityReport/1/SecurityReport_1.csv'
            {Get-SVTResultList -path 'TestDrive:/SecurityReport/1'} | should throw
        }

        It 'One SecurityReport file found with a header' {
            New-item -ItemType Directory -Path 'TestDrive:/SecurityReport/2'
            @('"header"','"value"') | Out-File 'TestDrive:/SecurityReport/2/SecurityReport_1.csv'
            Get-SVTResultList -path 'TestDrive:/SecurityReport/2' | should be '@{header=value}'
        }

        It 'Multiple SecurityReport file found' {

            New-item -ItemType Directory -Path 'TestDrive:/SecurityReport/3'

            @('valid_file_1') | Out-File 'TestDrive:/SecurityReport/3/SecurityReport_1.csv'
            @('valid_file_2') | Out-File 'TestDrive:/SecurityReport/3/SecurityReport_2.csv'

            {Get-SVTResultList -path 'TestDrive:/SecurityReport/3'} | should throw
        }
    }
}
