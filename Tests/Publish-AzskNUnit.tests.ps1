$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\interface\$sut"
. "$here\..\cmdlets\internal\Expand-Logs.ps1"
. "$here\..\cmdlets\internal\Get-ARMCheckerResultList.ps1"
. "$here\..\cmdlets\internal\ConvertTo-NUnit.ps1"
. "$here\..\cmdlets\internal\ConvertTo-TestCases.ps1"

Describe 'Publish-AzskNUnit tests' {
    Context 'Interface Tests' {
        It 'Path parameter cannot be null' {
            {Publish-AzskNUnit -Path $null} | should throw
        }

        It 'Path parameter cannot be empty' {
            {Publish-AzskNUnit -Path @()} | should throw
        }

        It 'Path parameter must be a valid path' {
            {Publish-AzskNUnit -Path 'TestDrive:/invalid_path'} | should throw
        }

         It 'Fails if logs canot be expanded' {

            New-Item -ItemType File -Path 'TestDrive:/Archive'
            Mock Expand-Logs {} -Verifiable
            Mock Write-Error{} -Verifiable 
            Mock Get-ARMCheckerResultList{} -Verifiable
            Mock ConvertTo-Nunit{} -Verifiable

            {Publish-AzskNUnit -Path 'TestDrive:/Archive'} | should not throw

            Assert-MockCalled Expand-Logs -Times 1 -Scope It
            Assert-MockCalled Write-Error -Times 1 -Scope It
            Assert-MockCalled Get-ARMCheckerResultList -Times 0 -Scope It
            Assert-MockCalled ConvertTo-NUnit -Times 0 -Scope It
        }

        It 'Fails if testcases are empty' {

            Mock Expand-Logs {return 'TestDrive:/'} -Verifiable
            Mock Write-Error{} -Verifiable 
            Mock Get-ARMCheckerResultList{return @()} -Verifiable
            Mock ConvertTo-Nunit{} -Verifiable

            {Publish-AzskNUnit -Path 'TestDrive:/Archive'} | should not throw

            Assert-MockCalled Expand-Logs -Times 1 -Scope It
            Assert-MockCalled Write-Error -Times 1 -Scope It
            Assert-MockCalled Get-ARMCheckerResultList -Times 1 -Scope It
            Assert-MockCalled ConvertTo-NUnit -Times 0 -Scope It
        }    

        It 'Passes testcases to Pester' {
            $ArmResults = @(@{FeatureName = 'ValidFeatureName1';Description='ValidDescription1';ResourceLineNumber='ValidLineNumber1';FilePath='ValidFilePath1';Status='ValidStatus1'},
                            @{FeatureName = 'ValidFeatureName2';Description='ValidDescription2';ResourceLineNumber='ValidLineNumber2';FilePath='ValidFilePath2';Status='ValidStatus2'})

            Mock Expand-Logs {return 'TestDrive:/'} -Verifiable
            Mock Write-Error{} -Verifiable 
            Mock Get-ARMCheckerResultList{return $ArmResults} -Verifiable
            Mock ConvertTo-NUnit{return @('valid')} -Verifiable
            Mock ConvertTo-TestCases{return @('testcase')} -Verifiable

            {Publish-AzskNUnit -Path 'TestDrive:/Archive'} | should not throw

            Assert-MockCalled Expand-Logs -Times 1 -Scope It
            Assert-MockCalled Get-ARMCheckerResultList -Times 1 -Scope It
            Assert-MockCalled ConvertTo-TestCases -Times 1 -Scope It
            Assert-MockCalled Write-Error -Times 0 -Scope It

            Assert-MockCalled ConvertTo-NUnit -Times 1 -Scope It
        }    
    }
}