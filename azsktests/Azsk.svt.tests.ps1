param (
        [array]
        $TestCases 
)

Describe "azsk-svt" {
    It " '[<ControlSeverity> <FeatureName>] <Description>' with <ResourceName> in resource group <ResourceGroupName>'" -TestCases $TestCases {
        Param($Description, $FeatureName, $ResourceName, $ResourceGroupName, $Status, $ControlSeverity)
        
        if ($Status -eq 'Manual')
        {
            Set-ItResult -Inconclusive -Because 'Manual action required.'
        }
        elseif  ($Status -eq 'Verify')
        {
            Set-ItResult -Pending -Because 'Manual verification required.'
        }

        $Status | should be 'Passed'
    } 
}