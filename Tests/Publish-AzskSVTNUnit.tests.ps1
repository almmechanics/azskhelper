Describe 'Publish-AzskSVTNUnit tests' {
    BeforeAll {
        . $PSScriptRoot/../cmdlets/interface/Publish-AzskSVTNUnit.ps1
        . $PSScriptRoot/../cmdlets/internal/Expand-Logs.ps1
        . $PSScriptRoot/../cmdlets/internal/Get-SVTResultList.ps1
        . $PSScriptRoot/../cmdlets/internal/ConvertTo-SVTNUnit.ps1
        . $PSScriptRoot/../cmdlets/internal/ConvertTo-SVTTestCases.ps1
    }

    Context 'Interface Tests' {
        It 'Path parameter cannot be null' {
            { Publish-AzskSVTNUnit Path $null } | should -throw
        }

        It 'Path parameter cannot be empty' {
            { Publish-AzskSVTNUnit -Path @() } | should -throw
        }

        It 'Path parameter must be a valid path' {
            { Publish-AzskSVTNUnit -Path 'TestDrive:/invalid_path' } | should -throw
        }

        It 'Fails if logs cannot be expanded' {
            Set-ItResult -Inconclusive 

            New-item -ItemType Directory -Path 'TestDrive:/Archive'
            Mock Expand-Logs {} -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-SVTResultList {} -Verifiable
            Mock ConvertTo-SVTNUnit {} -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 1 -Scope It
            Should -Invoke Get-SVTResultList -Exactly 0 -Scope It
            Should -Invoke ConvertTo-SVTNUnit -Exactly 0 -Scope It
        }

        It 'Fails if testcases are empty' {
            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-SVTResultList { return @() } -Verifiable
            Mock ConvertTo-SVTNUnit {} -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 1 -Scope It
            Should -Invoke Get-SVTResultList -Exactly 1 -Scope It
            Should -Invoke ConvertTo-SVTNUnit -Exactly 0 -Scope It
        }    

        It 'Passes testcases to Pester' {
            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'

            New-item -ItemType Directory -Path 'TestDrive:/Archive'

            $SVTResults = @(@{FeatureName = 'ValidFeatureName1'; Description = 'ValidDescription1'; ResourceName = 'ValidResourceName1'; ControlSeverity = 'ValidControlSeverity1'; Status = 'ValidStatus1'; ResourceGroupName = 'ValidResourceGroupName1' },
                @{FeatureName = 'ValidFeatureName2'; Description = 'ValidDescription2'; ResourceName = 'ValidResourceName2'; ControlSeverity = 'ValidControlSeverity2'; Status = 'ValidStatus2'; ResourceGroupName = 'ValidResourceGroupName2' })

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-SVTResultList { return $SVTResults } -Verifiable
            Mock ConvertTo-SVTNUnit { return @{'FailedCount' = '0' } } -Verifiable
            Mock ConvertTo-SVTTestCases { return @('testcase') } -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Get-SVTResultList -Exactly 1 -Scope It
            Should -Invoke ConvertTo-SVTTestCases -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 0 -Scope It

            Should -Invoke ConvertTo-SVTNUnit -Exactly 1 -Scope It
        }    

        It 'Generates Errors if Enable Exit enabled' {
            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'
            
            $SVTResults = @(@{})

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable
            Mock Write-Warning {} -Verifiable            
            Mock Get-SVTResultList { return $SVTResults } -Verifiable
            Mock ConvertTo-SVTNUnit { return @{'FailedCount' = '1' } } -Verifiable
            Mock ConvertTo-SVTTestCases { return @('testcase') } -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' -EnableExit } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Get-SVTResultList -Exactly 1 -Scope It
            Should -Invoke ConvertTo-SVTTestCases -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 1 -Scope It
            Should -Invoke Write-Warning -Exactly 0 -Scope It
            Should -Invoke ConvertTo-SVTNUnit -Exactly 1 -Scope It
        }    

        It 'Generated Warning if Enable Exit not enabled' {
            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'

            $SVTResults = @(@{})
            New-item -ItemType Directory -Path 'TestDrive:/Archive'

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Write-Warning {} -Verifiable

            Mock Get-SVTResultList { return $SVTResults } -Verifiable
            Mock ConvertTo-SVTNUnit { return @{'FailedCount' = '1' } } -Verifiable
            Mock ConvertTo-SVTTestCases { return @('testcase') } -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Get-SVTResultList -Exactly 1 -Scope It
            Should -Invoke ConvertTo-SVTTestCases -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 0 -Scope It
            Should -Invoke Write-Warning -Exactly 1 -Scope It
            Should -Invoke ConvertTo-SVTNUnit -Exactly 1 -Scope It
        }   
    }
}