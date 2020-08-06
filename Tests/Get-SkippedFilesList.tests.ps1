Describe 'Get-SkippedFilesList tests' {
    BeforeAll {
        . $PSScriptRoot/../cmdlets/internal/Get-SkippedFilesList.ps1
    }
    BeforeEach {
        New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles'
    }

    AfterEach {
        Remove-Item  -Path 'TestDrive:/SkippedFiles' -Force -Recurse
    }

    Context 'Interface Tests' {
        It 'Path array parameter cannot be null' {
            {Get-SkippedFilesList -Path $null} | should -throw
        }

        It 'Path array parameter cannot be empty' {
            {Get-SkippedFilesList -Path [string]::empty} | should -throw
        }

        It 'Path must -be a valid path' {
            {Get-SkippedFilesList -Path 'invalid_path'} | should -throw
        }
    }

    Context 'Results processing' {


        It 'SkippedFiles not present' {
            {Get-SkippedFilesList -path 'TestDrive:/SkippedFiles'} | should -throw
        }

        It 'SkippedFiles file empty' {
            New-Item -ItemType File -Path 'TestDrive:/SkippedFiles/SkippedFiles.Log' -force
            Get-SkippedFilesList -path 'TestDrive:/SkippedFiles' | should -be @()
        }

        It 'One SkippedFiles file found' {
            @('valid_file_1') | Out-File 'TestDrive:/SkippedFiles/SkippedFiles.Log'
            Get-SkippedFilesList -path 'TestDrive:/SkippedFiles' | should -be 'valid_file_1'
        }

        It 'Multiple SkippedFiles file found' {

            New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles/2' -force
            New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles/2/1' -force
            New-item -ItemType Directory -Path 'TestDrive:/SkippedFiles/2/2' -force

            @('valid_file_1') | Out-File 'TestDrive:/SkippedFiles/2/1/SkippedFiles.Log'
            @('valid_file_2') | Out-File 'TestDrive:/SkippedFiles/2/2/SkippedFiles.Log'

            {Get-SkippedFilesList -path 'TestDrive:/SkippedFiles/2'} | should -throw
        }
    }
}