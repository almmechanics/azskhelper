Describe 'Get-SVTResultList tests' {

    BeforeAll {
        . $PSScriptRoot/../cmdlets/internal/Get-SVTResultList.ps1
    }
    BeforeEach {
        New-item -ItemType Directory -Path 'TestDrive:/SecurityReport'
    }

    AfterEach {
        Remove-Item  -Path 'TestDrive:/SecurityReport' -Force -Recurse
    }
    
    Context 'Interface Tests' {
        It 'Path array parameter cannot -be null' {
            {Get-SVTResultList -Path $null} | should -throw
        }

        It 'Path array parameter cannot -be empty' {
            {Get-SVTResultList -Path [string]::empty} | should -throw
        }

        It 'Path must -be a valid path' {
            {Get-SVTResultList -Path 'invalid_path'} | should -throw
        }
    }

    Context 'Results processing' {


        It 'SecurityReport not present' {
            {Get-SVTResultList -path 'TestDrive:/SecurityReport'} | should -throw
        }

        It 'SecurityReport file empty' {
            New-Item  -ItemType File -Path 'TestDrive:/SecurityReport/SecurityReport_empty.csv' -force
           { Get-SVTResultList -path 'TestDrive:/SecurityReport'} | should -throw
        }

        It 'One SecurityReport file found with no header' {
            @('"value"') | Out-File 'TestDrive:/SecurityReport/SecurityReport_1.csv'
            {Get-SVTResultList -path 'TestDrive:/SecurityReport'} | should -throw
        }

        It 'One SecurityReport file found with a header' {
            @('"header"','"value"') | Out-File 'TestDrive:/SecurityReport/SecurityReport_1.csv'
            Get-SVTResultList -path 'TestDrive:/SecurityReport' | should -be '@{header=value}'
        }

        It 'Multiple SecurityReport file found' {


            @('valid_file_1') | Out-File 'TestDrive:/SecurityReport/SecurityReport_1.csv'
            @('valid_file_2') | Out-File 'TestDrive:/SecurityReport/SecurityReport_2.csv'

            {Get-SVTResultList -path 'TestDrive:/SecurityReport'} | should -throw
        }
    }
}
