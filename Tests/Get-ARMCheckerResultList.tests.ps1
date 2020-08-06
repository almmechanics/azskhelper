Describe 'Expand-Logs tests' {
    BeforeAll {
        . $PSScriptRoot/../cmdlets/internal/Get-ARMCheckerResultList.ps1
    }
    BeforeEach {
        New-item -ItemType Directory -Path 'TestDrive:/ARMCheckerResults'
    }

    AfterEach {
        Remove-Item  -Path 'TestDrive:/ARMCheckerResults' -Force -Recurse
    }

    Context 'Interface Tests' {
        It 'Path array parameter cannot -be null' {
            {Get-ARMCheckerResultList -Path $null} | should -throw
        }

        It 'Path array parameter cannot -be empty' {
            {Get-ARMCheckerResultList -Path [string]::empty} | should -throw
        }

        It 'Path must -be a valid path' {
            {Get-ARMCheckerResultList -Path 'invalid_path'} | should -throw
        }
    }

    Context 'Results processing' {

        It 'ARMCheckerResults_ not present' {
            {Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults'} | should -throw
        }

        It 'ARMCheckerResults file empty' {
            New-Item  -ItemType File -Path 'TestDrive:/ARMCheckerResults/ARMCheckerResults_empty.csv'
           { Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults'} | should -throw
        }

        It 'One ARMCheckerResults file found with no header' {
            @('"value"') | Out-File 'TestDrive:/ARMCheckerResults/ARMCheckerResults_1.csv'
            {Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults'} | should -throw
        }

        It 'One ARMCheckerResults file found with a header' {
            @('"header"','"value"') | Out-File 'TestDrive:/ARMCheckerResults/ARMCheckerResults_1.csv'
            Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults' | should -be '@{header=value}'
        }

        It 'Multiple ARMCheckerResults file found' {

            @('valid_file_1') | Out-File 'TestDrive:/ARMCheckerResults/ARMCheckerResults_1.csv'
            @('valid_file_2') | Out-File 'TestDrive:/ARMCheckerResults/ARMCheckerResults_2.csv'

            {Get-ARMCheckerResultList -path 'TestDrive:/ARMCheckerResults'} | should -throw
        }
    }
}
