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

        It 'Fails if logs canot be expanded' {
            New-item -ItemType Directory -Path 'TestDrive:/Archive'
            Mock Expand-Logs {} -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-SVTResultList {} -Verifiable
            Mock ConvertTo-SVTNUnit {} -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Assert-MockCalled Expand-Logs -Times 1 -Scope It
            Assert-MockCalled Write-Error -Times 1 -Scope It
            Assert-MockCalled Get-SVTResultList -Times 0 -Scope It
            Assert-MockCalled ConvertTo-SVTNUnit -Times 0 -Scope It
        }

        It 'Fails if testcases are empty' {
            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-SVTResultList { return @() } -Verifiable
            Mock ConvertTo-SVTNUnit {} -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Assert-MockCalled Expand-Logs -Times 1 -Scope It
            Assert-MockCalled Write-Error -Times 1 -Scope It
            Assert-MockCalled Get-SVTResultList -Times 1 -Scope It
            Assert-MockCalled ConvertTo-SVTNUnit -Times 0 -Scope It
        }    

        It 'Passes testcases to Pester' {
            $SVTResults = @(@{FeatureName = 'ValidFeatureName1'; Description = 'ValidDescription1'; ResourceName = 'ValidResourceName1'; ControlSeverity = 'ValidControlSeverity1'; Status = 'ValidStatus1'; ResourceGroupName = 'ValidResourceGroupName1' },
                @{FeatureName = 'ValidFeatureName2'; Description = 'ValidDescription2'; ResourceName = 'ValidResourceName2'; ControlSeverity = 'ValidControlSeverity2'; Status = 'ValidStatus2'; ResourceGroupName = 'ValidResourceGroupName2' })

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Get-SVTResultList { return $SVTResults } -Verifiable
            Mock ConvertTo-SVTNUnit { return @{'FailedCount' = '0' } } -Verifiable
            Mock ConvertTo-SVTTestCases { return @('testcase') } -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Assert-MockCalled Expand-Logs -Times 1 -Scope It
            Assert-MockCalled Get-SVTResultList -Times 1 -Scope It
            Assert-MockCalled ConvertTo-SVTTestCases -Times 1 -Scope It
            Assert-MockCalled Write-Error -Times 0 -Scope It

            Assert-MockCalled ConvertTo-SVTNUnit -Times 1 -Scope It
        }    

        It 'Generates Errors if Enable Exit enabled' {
            $SVTResults = @(@{})

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable
            Mock Write-Warning {} -Verifiable            
            Mock Get-SVTResultList { return $SVTResults } -Verifiable
            Mock ConvertTo-SVTNUnit { return @{'FailedCount' = '1' } } -Verifiable
            Mock ConvertTo-SVTTestCases { return @('testcase') } -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' -EnableExit } | should -not -throw

            Assert-MockCalled Expand-Logs -Times 1 -Scope It
            Assert-MockCalled Get-SVTResultList -Times 1 -Scope It
            Assert-MockCalled ConvertTo-SVTTestCases -Times 1 -Scope It
            Assert-MockCalled Write-Error -Times 1 -Scope It
            Assert-MockCalled Write-Warning -Times 0 -Scope It
            Assert-MockCalled ConvertTo-SVTNUnit -Times 1 -Scope It
        }    

        It 'Generated Warning if Enable Exit not enabled' {
            $SVTResults = @(@{})

            Mock Expand-Logs { return 'TestDrive:/' } -Verifiable
            Mock Write-Error {} -Verifiable 
            Mock Write-Warning {} -Verifiable

            Mock Get-SVTResultList { return $SVTResults } -Verifiable
            Mock ConvertTo-SVTNUnit { return @{'FailedCount' = '1' } } -Verifiable
            Mock ConvertTo-SVTTestCases { return @('testcase') } -Verifiable

            { Publish-AzskSVTNUnit -Path 'TestDrive:/Archive' } | should -not -throw

            Assert-MockCalled Expand-Logs -Times 1 -Scope It
            Assert-MockCalled Get-SVTResultList -Times 1 -Scope It
            Assert-MockCalled ConvertTo-SVTTestCases -Times 1 -Scope It
            Assert-MockCalled Write-Error -Times 0 -Scope It
            Assert-MockCalled Write-Warning -Times 1 -Scope It
            Assert-MockCalled ConvertTo-SVTNUnit -Times 1 -Scope It
        }   
    }
}