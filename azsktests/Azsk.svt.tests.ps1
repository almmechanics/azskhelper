Describe "azsk-svt" {
    context "SVT-NUnit" {
        BeforeAll {
            . $PSScriptRoot/../cmdlets/internal/Get-SVTResultList.ps1
            . $PSScriptRoot/../cmdlets/internal/ConvertTo-SVTTestCases.ps1
        }
        
        # Expand the AZSK result set
        $ExpandedAzskLogs = Expand-Logs -Path $Global:AzSKPath -AnalysisType 'SVT'
        
        # Generate testcases for the test run
        $TestCases = @(ConvertTo-SVTTestCases @(Get-SVTResultList -Path $ExpandedAzskLogs))
 
        It " '[<ControlSeverity> <FeatureName>] <Description>' with <ResourceName> in resource group <ResourceGroupName>'" -TestCases $TestCases {
            Param($Description, $FeatureName, $ResourceName, $ResourceGroupName, $Status, $ControlSeverity)
            
            if ($Status -eq 'Manual') {
                Set-ItResult -Inconclusive -Because 'Manual action required.'
            }
            elseif ($Status -eq 'Verify') {
                Set-ItResult -Pending -Because 'Manual verification required.'
            }

            $Status | should -be 'Passed'
        }
    } 
}