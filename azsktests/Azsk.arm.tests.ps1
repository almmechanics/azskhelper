Describe "azsk" {
        BeforeAll {
                . $PSScriptRoot/../cmdlets/internal/Get-ARMCheckerResultList.ps1
                . $PSScriptRoot/../cmdlets/internal/ConvertTo-TestCases.ps1
        }
        
        
        # Expand the AZSK result set
        $ExpandedAzskLogs = Expand-Logs -Path $Global:AzSKPath -AnalysisType 'ARM'

        # Generate testcases for the test run
        $TestCases = @(ConvertTo-TestCases @(Get-ARMCheckerResultList -Path $ExpandedAzskLogs))

        Context "ARM-NUnit" {
                It " '[<FeatureName>] <Description>' set at <ResourceLineNumber> in '<FilePath>'" -TestCases $TestCases {
                        Param($Description, $FilePath, $FeatureName, $ResourceLineNumber, $Status)
                        $Status | should -be 'Passed'
                }
        } 
}