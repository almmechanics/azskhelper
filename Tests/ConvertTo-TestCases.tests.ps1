$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

Describe 'ConvertTo-TestCases tests' {
    Context 'Interface Tests' {
        It 'ArmResults array parameter cannot be null' {
            {ConvertTo-TestCases -ArmResults $null} | should throw
        }

        It 'ArmResults array parameter cannot be empty' {
            {ConvertTo-TestCases -ArmResults @()} | should throw
        }
    }

    Context 'Convert ARM Results as pipeline'{

        It 'Can process pipeline' {
            $ArmResults = @(@{FeatureName = 'ValidFeatureName';Description='ValidDescription';ResourceLineNumber='ValidLineNumber';FilePath='ValidFilePath';Status='ValidStatus'})

            $TestCases = @($ArmResults | ConvertTo-TestCases)
            $TestCases.Count | should be 1

            $TestCaseFirst = $TestCases | Select-Object -First 1
            $TestCaseFirst.FeatureName | should be 'ValidFeatureName'
            $TestCaseFirst.Description | should be 'ValidDescription'
            $TestCaseFirst.ResourceLineNumber | should be 'ValidLineNumber'
            $TestCaseFirst.FilePath | should be 'ValidFilePath'
            $TestCaseFirst.Status | should be 'ValidStatus'
        }


        It 'Can process an array of ARM results' {
            $ArmResults = @(@{FeatureName = 'ValidFeatureName1';Description='ValidDescription1';ResourceLineNumber='ValidLineNumber1';FilePath='ValidFilePath1';Status='ValidStatus1'},
                            @{FeatureName = 'ValidFeatureName2';Description='ValidDescription2';ResourceLineNumber='ValidLineNumber2';FilePath='ValidFilePath2';Status='ValidStatus2'})

            $TestCases = @(ConvertTo-TestCases -ArmResults $ArmResults)
            $TestCases.Count | should be 2

            $TestCaseFirst = $TestCases | Select-Object -First 1
            $TestCaseFirst.FeatureName | should be 'ValidFeatureName1'
            $TestCaseFirst.Description | should be 'ValidDescription1'
            $TestCaseFirst.ResourceLineNumber | should be 'ValidLineNumber1'
            $TestCaseFirst.FilePath | should be 'ValidFilePath1'
            $TestCaseFirst.Status | should be 'ValidStatus1'

            $TestCaseLast = $TestCases | Select-Object -Last 1
            $TestCaseLast.FeatureName | should be 'ValidFeatureName2'
            $TestCaseLast.Description | should be 'ValidDescription2'
            $TestCaseLast.ResourceLineNumber | should be 'ValidLineNumber2'
            $TestCaseLast.FilePath | should be 'ValidFilePath2'
            $TestCaseLast.Status | should be 'ValidStatus2'
        }
    }

    Context 'Convert ARM Results as parameter'{

        It 'Can process 1 ARM result' {
            $ArmResults = @(@{FeatureName = 'ValidFeatureName';Description='ValidDescription';ResourceLineNumber='ValidLineNumber';FilePath='ValidFilePath';Status='ValidStatus'})

            $TestCases = @(ConvertTo-TestCases -ArmResults $ArmResults)
            $TestCases.Count | should be 1

            $TestCaseFirst = $TestCases | Select-Object -First 1
            $TestCaseFirst.FeatureName | should be 'ValidFeatureName'
            $TestCaseFirst.Description | should be 'ValidDescription'
            $TestCaseFirst.ResourceLineNumber | should be 'ValidLineNumber'
            $TestCaseFirst.FilePath | should be 'ValidFilePath'
            $TestCaseFirst.Status | should be 'ValidStatus'
        }


        It 'Can process an array of ARM results' {
            $ArmResults = @(@{FeatureName = 'ValidFeatureName1';Description='ValidDescription1';ResourceLineNumber='ValidLineNumber1';FilePath='ValidFilePath1';Status='ValidStatus1'},
                            @{FeatureName = 'ValidFeatureName2';Description='ValidDescription2';ResourceLineNumber='ValidLineNumber2';FilePath='ValidFilePath2';Status='ValidStatus2'})

            $TestCases = @(ConvertTo-TestCases -ArmResults $ArmResults)
            $TestCases.Count | should be 2

            $TestCaseFirst = $TestCases | Select-Object -First 1
            $TestCaseFirst.FeatureName | should be 'ValidFeatureName1'
            $TestCaseFirst.Description | should be 'ValidDescription1'
            $TestCaseFirst.ResourceLineNumber | should be 'ValidLineNumber1'
            $TestCaseFirst.FilePath | should be 'ValidFilePath1'
            $TestCaseFirst.Status | should be 'ValidStatus1'

            $TestCaseLast = $TestCases | Select-Object -Last 1
            $TestCaseLast.FeatureName | should be 'ValidFeatureName2'
            $TestCaseLast.Description | should be 'ValidDescription2'
            $TestCaseLast.ResourceLineNumber | should be 'ValidLineNumber2'
            $TestCaseLast.FilePath | should be 'ValidFilePath2'
            $TestCaseLast.Status | should be 'ValidStatus2'
        }
    }
} 