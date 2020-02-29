$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

Describe 'ConvertTo-SVTTestCases tests' {
    Context 'Interface Tests' {
        It 'SVTResults array parameter cannot be null' {
            {ConvertTo-SVTTestCases -ArmResults $null} | should throw
        }

        It 'SVTResults array parameter cannot be empty' {
            {ConvertTo-SVTTestCases -ArmResults @()} | should throw
        }
    }

    Context 'Convert SVT Results as pipeline'{

        It 'Can process pipeline' {
            $SVTResults = @{FeatureName = 'ValidFeatureName';Description='ValidDescription';ResourceGroupName='ValidResourceGroupName';ControlSeverity='ValidControlSeverity';Status='ValidStatus'}

            $TestCases = @($SVTResults | ConvertTo-SVTTestCases)
            $TestCases.Count | should be 1

            $TestCaseFirst = $TestCases | Select-Object -First 1
            $TestCaseFirst.FeatureName | should be 'ValidFeatureName'
            $TestCaseFirst.ResourceGroupName | should be 'ValidResourceGroupName'
            $TestCaseFirst.Description | should be 'ValidDescription'
            $TestCaseFirst.Status | should be 'ValidStatus'
            $TestCaseFirst.ControlSeverity | should be 'ValidControlSeverity'
        }


        It 'Can process an array of SVT results' {
            $SVTResults = @(@{FeatureName = 'ValidFeatureName1';Description='ValidDescription1';ResourceGroupName='ValidResourceGroupName1';ControlSeverity='ValidControlSeverity1';Status='ValidStatus1'},
                            @{FeatureName = 'ValidFeatureName2';Description='ValidDescription2';ResourceGroupName='ValidResourceGroupName2';ControlSeverity='ValidControlSeverity2';Status='ValidStatus2'})

            $TestCases = @(ConvertTo-SVTTestCases -SVTResults $SVTResults)
            $TestCases.Count | should be 2

            $TestCaseFirst = $TestCases | Select-Object -First 1
            $TestCaseFirst.FeatureName | should be 'ValidFeatureName1'
            $TestCaseFirst.Description | should be 'ValidDescription1'
            $TestCaseFirst.ResourceGroupName | should be 'ValidResourceGroupName1'
            $TestCaseFirst.ControlSeverity | should be 'ValidControlSeverity1'
            $TestCaseFirst.Status | should be 'ValidStatus1'

            $TestCaseLast = $TestCases | Select-Object -Last 1
            $TestCaseLast.FeatureName | should be 'ValidFeatureName2'
            $TestCaseLast.Description | should be 'ValidDescription2'
            $TestCaseLast.ResourceGroupName | should be 'ValidResourceGroupName2'
            $TestCaseLast.ControlSeverity | should be 'ValidControlSeverity2'
            $TestCaseLast.Status | should be 'ValidStatus2'
        }
    }

    Context 'Convert SVT Results as parameter'{

        It 'Can process 1 SVT result' {
            $SVTResults = @(@{FeatureName = 'ValidFeatureName';Description='ValidDescription';ResourceGroupName='ValidResourceGroupName';ControlSeverity='ControlSeverity';Status='ValidStatus'})

            $TestCases = @(ConvertTo-SVTTestCases -SVTResults $SVTResults)
            $TestCases.Count | should be 1

            $TestCaseFirst = $TestCases | Select-Object -First 1
            $TestCaseFirst.FeatureName | should be 'ValidFeatureName'
            $TestCaseFirst.ResourceGroupName | should be 'ValidResourceGroupName'
            $TestCaseFirst.Description | should be 'ValidDescription'
            $TestCaseFirst.Status | should be 'ValidStatus'
            $TestCaseFirst.ControlSeverity | should be 'ControlSeverity'
        }


        It 'Can process an array of SVT results' {
            $SVTResults = @(@{FeatureName = 'ValidFeatureName1';Description='ValidDescription1';ResourceGroupName='ValidResourceGroupName1';ControlSeverity='ValidControlSeverity1';Status='ValidStatus1'},
                            @{FeatureName = 'ValidFeatureName2';Description='ValidDescription2';ResourceGroupName='ValidResourceGroupName2';ControlSeverity='ValidControlSeverity2';Status='ValidStatus2'})

            $TestCases = @(ConvertTo-SVTTestCases -SVTResults $SVTResults)
            $TestCases.Count | should be 2

            $TestCaseFirst = $TestCases | Select-Object -First 1
            $TestCaseFirst.FeatureName | should be 'ValidFeatureName1'
            $TestCaseFirst.Description | should be 'ValidDescription1'
            $TestCaseFirst.ResourceGroupName | should be 'ValidResourceGroupName1'
            $TestCaseFirst.ControlSeverity | should be 'ValidControlSeverity1'
            $TestCaseFirst.Status | should be 'ValidStatus1'

            $TestCaseLast = $TestCases | Select-Object -Last 1
            $TestCaseLast.FeatureName | should be 'ValidFeatureName2'
            $TestCaseLast.Description | should be 'ValidDescription2'
            $TestCaseLast.ResourceGroupName | should be 'ValidResourceGroupName2'
            $TestCaseLast.ControlSeverity | should be 'ValidControlSeverity2'
            $TestCaseLast.Status | should be 'ValidStatus2'
        }
    }
} 