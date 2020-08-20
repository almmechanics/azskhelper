Describe 'Publish-AzskNUnit tests' {
    BeforeAll {
        . $PSScriptRoot/../cmdlets/interface/Publish-AzskNUnit.ps1
        . $PSScriptRoot/../cmdlets/internal/ConvertTo-NUnit.ps1
        . $PSScriptRoot/../cmdlets/internal/Get-ModulePath.ps1
        . $PSScriptRoot/../cmdlets/internal/Expand-Logs.ps1
        . $PSScriptRoot/../cmdlets/internal/Get-ARMCheckerResultList.ps1
        . $PSScriptRoot/../cmdlets/internal/ConvertTo-NUnit.ps1
        . $PSScriptRoot/../cmdlets/internal/ConvertTo-TestCases.ps1


    }
    
    Context 'Interface Tests' {
        It 'Path parameter cannot be null' {
            { Publish-AzskNUnit -Path $null } | should -throw
        }

        It 'Path parameter cannot be empty' {
            { Publish-AzskNUnit -Path @() } | should -throw
        }

        It 'Path parameter must be a valid path' {
            { Publish-AzskNUnit -Path 'TestDrive:/invalid_path' } | should -throw
        }

        It 'Fails if logs cannot be expanded' {
            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'

            New-Item -ItemType File -Path 'TestDrive:/Archive'
            Mock Expand-Logs {} -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-ARMCheckerResultList {} -Verifiable
            Mock ConvertTo-Nunit {} -Verifiable

            { Publish-AzskNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 1 -Scope It
            Should -Invoke Get-ARMCheckerResultList -Exactly 0 -Scope It
            Should -Invoke ConvertTo-NUnit -Exactly 0 -Scope It
        }

        It 'Fails if testcases are empty' {

            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-ARMCheckerResultList { return @() } -Verifiable
            Mock ConvertTo-Nunit {} -Verifiable

            { Publish-AzskNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 1 -Scope It
            Should -Invoke Get-ARMCheckerResultList -Exactly 1 -Scope It
            Should -Invoke ConvertTo-NUnit -Exactly 0 -Scope It
        }    

        It 'Passes testcases to Pester' {
            
            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'
  
            $ArmResults = @(@{FeatureName = 'ValidFeatureName1'; Description = 'ValidDescription1'; ResourceLineNumber = 'ValidLineNumber1'; FilePath = 'ValidFilePath1'; Status = 'ValidStatus1' },
                @{FeatureName = 'ValidFeatureName2'; Description = 'ValidDescription2'; ResourceLineNumber = 'ValidLineNumber2'; FilePath = 'ValidFilePath2'; Status = 'ValidStatus2' })

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-ARMCheckerResultList { return $ArmResults } -Verifiable
            Mock ConvertTo-NUnit { return @{'FailedCount' = '0' } } -Verifiable
            Mock ConvertTo-TestCases { return @('testcase') } -Verifiable

            { Publish-AzskNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Get-ARMCheckerResultList -Exactly 1 -Scope It
            Should -Invoke ConvertTo-TestCases -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 0 -Scope It

            Should -Invoke ConvertTo-NUnit -Exactly 1 -Scope It
        }    

        It 'Generates Errors if Enable Exit enabled' {
            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'
            
            $ArmResults = @(@{})

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Write-Warning {} -Verifiable 
            Mock Get-ARMCheckerResultList { return $ArmResults } -Verifiable
            Mock ConvertTo-NUnit { return @{'FailedCount' = '1' } } -Verifiable
            Mock ConvertTo-TestCases { return @('testcase') } -Verifiable

            { Publish-AzskNUnit -Path 'TestDrive:/Archive' -EnableExit } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Get-ARMCheckerResultList -Exactly 1 -Scope It
            Should -Invoke ConvertTo-TestCases -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 1 -Scope It
            Should -Invoke Write-Warning -Exactly 0 -Scope It

            Should -Invoke ConvertTo-NUnit -Exactly 1 -Scope It
        }    

        It 'Generated Warning if Enable Exit not enabled' {
            Set-ItResult -Inconclusive -Because 'Invocation of Invoke-Pester from a Pester test run does not propograte mocks'

            $ArmResults = @(@{})

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Write-Warning {} -Verifiable 

            Mock Get-ARMCheckerResultList { return $ArmResults } -Verifiable
            Mock ConvertTo-NUnit { return @{'FailedCount' = '1' } } -Verifiable
            Mock ConvertTo-TestCases { return @('testcase') } -Verifiable

            { Publish-AzskNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Should -Invoke Expand-Logs -Exactly 1 -Scope It
            Should -Invoke Get-ARMCheckerResultList -Exactly 1 -Scope It
            Should -Invoke ConvertTo-TestCases -Exactly 1 -Scope It
            Should -Invoke Write-Error -Exactly 0 -Scope It
            Should -Invoke Write-Warning -Exactly 1 -Scope It

            Should -Invoke ConvertTo-NUnit -Exactly 1 -Scope It
        }   
    }
}