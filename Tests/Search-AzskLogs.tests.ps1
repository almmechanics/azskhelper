Describe 'Search-AzskLogs tests' {
    BeforeAll {
        . $PSScriptRoot/../cmdlets/internal/Search-AzskLogs.ps1
    }

    BeforeEach {
        New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs'
        New-item -ItemType Directory -Path 'TestDrive:/AzSK_Valid'
        New-item -ItemType Directory -Path 'TestDrive:/AzSK_Data'
    }

    AfterEach {
        Remove-Item -Path 'TestDrive:/ArmTemplateChecker_Logs' -Force -Recurse
        Remove-Item -Path 'TestDrive:/AzSK_Valid' -Force -Recurse
        Remove-Item -Path 'TestDrive:/AzSK_Data' -Force -Recurse
    }

    Context 'Interface Tests' {
        It 'Path array parameter cannot -be null' {
            { Search-AzskLogs -Path $null } | should -throw
        }

        It 'Path array parameter cannot -be empty' {
            { Search-AzskLogs -Path [string]::empty } | should -throw
        }

        It 'Path must -be a valid path' {
            { Search-AzskLogs -Path 'invalid_path' } | should -throw
        }

        It 'Analysis tupe must -be a valid' {
            { Search-AzskLogs -Path 'TestDrive:' -AnalysisType 'invalid' } | should -throw
        }
    }

    Context 'ARM Results processing' {


        It 'ArmTemplateChecker_Logs not present' {
            { Search-AzskLogs -path 'TestDrive:/ArmTemplateChecker_Logs' -AnalysisType ARM } | should -throw
        }

        It 'One ArmTemplateChecker_Logs file found' {
            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/ArmTemplateChecker_Logs_1.zip'
            (Search-AzskLogs -AnalysisType ARM -path 'TestDrive:/ArmTemplateChecker_Logs' | Split-Path -leaf)  | should  -be 'ArmTemplateChecker_Logs_1.zip'
        }

        It 'Multiple ArmTemplateChecker_Logs file found' {

            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/ArmTemplateChecker_Logs_2_1.zip'
            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/ArmTemplateChecker_Logs_2_2.zip'

            { Search-AzskLogs -AnalysisType ARM -Path 'TestDrive:/ArmTemplateChecker_Logs' } | should -throw
        }
    }

    Context 'SVT Results processing' {

        It 'AzSK_ not present' {
            { Search-AzskLogs -path 'TestDrive:/invalid' -AnalysisType SVT } | should -throw
        }

        It 'One AzSK_ file found' {
            New-Item -ItemType File 'TestDrive:/AzSK_Valid/AzSK_Valid.zip' -Force
            (Search-AzskLogs -AnalysisType SVT -path 'TestDrive:/AzSK_Valid' | Split-Path -leaf)  | should  -be 'AzSK_Valid.zip'
        }

        It 'Multiple AzSK_ file found' {

            New-Item -ItemType File 'TestDrive:/AzSK_Valid/AzSK_21.zip' -Force
            New-Item -ItemType File 'TestDrive:/AzSK_Valid/AzSK_22.zip' -Force

            { Search-AzskLogs -AnalysisType SVT -Path 'TestDrive:/AzSK_Valid/2' } | should -throw
        }
    }
}
