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
    }

    Context 'Results processing' {

        New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs'

        It 'ArmTemplateChecker_Logs not present' {
            {Search-AzskLogs -path 'TestDrive:/ArmTemplateChecker_Logs'} | should throw
        }

        It 'One ArmTemplateChecker_Logs file found' {
            New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs/1'
            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/1/ArmTemplateChecker_Logs_1.zip'
            (Search-AzskLogs -path 'TestDrive:/ArmTemplateChecker_Logs/1' | Split-Path -leaf)  | should  be 'ArmTemplateChecker_Logs_1.zip'
        }

        It 'Multiple ArmTemplateChecker_Logs file found' {

            New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs/2'
            New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs/2/1'
            New-item -ItemType Directory -Path 'TestDrive:/ArmTemplateChecker_Logs/2/2'

            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/2/1/ArmTemplateChecker_Logs_2_1.zip'
            New-Item -ItemType File 'TestDrive:/ArmTemplateChecker_Logs/2/2/ArmTemplateChecker_Logs_2_2.zip'

            {Search-AzskLogs -Path 'TestDrive:/ArmTemplateChecker_Logs/2'} | should throw
        }
    }
}
