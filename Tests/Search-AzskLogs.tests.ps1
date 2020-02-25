$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

Describe 'Search-AzskLogs tests' {
    Context 'Interface Tests' {
        It 'Path array parameter cannot be null' {
            {Search-AzskLogs -Path $null} | should throw
        }

        It 'Path array parameter cannot be empty' {
            {Search-AzskLogs -Path [string]::empty} | should throw
        }

        It 'Path must be a valid path' {
            {Search-AzskLogs -Path 'invalid_path'} | should throw
        }

        It 'Analysis tupe must be a valid' {
            {Search-AzskLogs -Path 'TestDrive:/' -AnalysisType 'invalid'} | should throw
        }

    }

    Context 'ARM Results processing' {

        New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs'

        It 'ArmTemplateChecker_Logs not present' {
            {Search-AzskLogs -path 'TestDrive:/ArmTemplateChecker_Logs' -AnalysisType ARM} | should throw
        }

        It 'One ArmTemplateChecker_Logs file found' {
            New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs/1'
            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/1/ArmTemplateChecker_Logs_1.zip'
            (Search-AzskLogs -AnalysisType ARM -path 'TestDrive:/ArmTemplateChecker_Logs/1' | Split-Path -leaf)  | should  be 'ArmTemplateChecker_Logs_1.zip'
        }

        It 'Multiple ArmTemplateChecker_Logs file found' {

            New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs/2'
            New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs/2/1'
            New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs/2/2'

            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/2/1/ArmTemplateChecker_Logs_2_1.zip'
            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/2/2/ArmTemplateChecker_Logs_2_2.zip'

            {Search-AzskLogs -AnalysisType ARM -Path 'TestDrive:/ArmTemplateChecker_Logs/2'} | should throw
        }
    }

    Context 'SVT Results processing' {

        New-item -ItemType Directory -Path 'TestDrive:/AzSK_Data'

        It 'AzSK_ not present' {
            {Search-AzskLogs -path 'TestDrive:/AzSK_Data' -AnalysisType SVT} | should throw
        }

        It 'One AzSK_ file found' {
            New-item -ItemType Directory -Path 'TestDrive:/AzSK_Valid/1'
            New-Item -ItemType File 'TestDrive:/AzSK_Valid/1/AzSK_Valid.zip'
            (Search-AzskLogs -AnalysisType SVT -path 'TestDrive:/AzSK_Valid/1' | Split-Path -leaf)  | should  be 'AzSK_Valid.zip'
        }

        It 'Multiple AzSK_ file found' {

            New-item -ItemType Directory -Path 'TestDrive:/AzSK_Valid/2'
            New-item -ItemType Directory -Path 'TestDrive:/AzSK_Valid/2/1'
            New-item -ItemType Directory -Path 'TestDrive:/AzSK_Valid/2/2'

            New-Item -ItemType File 'TestDrive:/AzSK_Valid/2/1/AzSK_21.zip'
            New-Item -ItemType File 'TestDrive:/AzSK_Valid/2/2/AzSK_22.zip'

            {Search-AzskLogs -AnalysisType SVT -Path 'TestDrive:/AzSK_Valid/2'} | should throw
        }
    }
}
