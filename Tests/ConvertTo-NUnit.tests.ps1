$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"
. "$here\..\cmdlets\internal\Get-ModulePath.ps1"


Describe 'ConvertTo-TestCases tests' {
    Context 'Interface Tests' {
        It 'OutputPath parameter cannot be null' {
            {ConvertTo-NUnit -OutputPath $null} | should throw
        }

        It 'OutputPath parameter cannot be empty' {
            {ConvertTo-NUnit -OutputPath @()} | should throw
        }

        It 'OutputPath parameter must be a valid path' {
            {ConvertTo-NUnit -OutputPath 'invalid_path'} | should throw
        }

        It 'TestCases array cannot be null' {
            {ConvertTo-NUnit -OutputPath 'TestDrive:' -TestCases $null} | should throw
        }

        It 'TestCases array cannot be an empty' {
            {ConvertTo-NUnit -OutputPath 'TestDrive:' -TestCases @()} | should throw
        }

        It 'OutputVariable parameter cannot be null' {
            {ConvertTo-NUnit -OutputPath 'TestDrive:' -TestCases @('valid') -OutputVariable $null} | should throw
        }

        It 'OutputVariable parameter cannot be empty' {
            {ConvertTo-NUnit -OutputPath 'TestDrive:' -TestCases @('valid') -OutputVariable ([string]::empty)} | should throw
        }
    }

    Context 'Usage' {
        It 'Can Invoke Pester directly' {

            Mock Join-Path{return 'valid_path'} -Verifiable
            Mock Write-host{} -Verifiable
            Mock Get-ModulePath{} -Verifiable
            Mock Invoke-Pester{} -Verifiable

            New-Item -ItemType Directory -path 'TestDrive:/source'

            {ConvertTo-NUnit -OutputPath 'TestDrive:/' -TestCases @('testcase') -OutputVariable 'valid' } | should not throw

            Assert-MockCalled Join-Path -Times 1 -Scope It
            Assert-MockCalled Write-Host -Times 1 -Scope It
            Assert-MockCalled Get-ModulePath -Times 1 -Scope It
            Assert-MockCalled Invoke-Pester -Times 1 -Scope It
        }

        It 'Can Invoke Pester directly to Exit on failure' {
            Mock Join-Path{return 'valid_path'} -Verifiable
            Mock Write-host{} -Verifiable
            Mock Get-ModulePath{} -Verifiable
            Mock Invoke-Pester{} -Verifiable

            New-Item -ItemType Directory -path 'TestDrive:/source2'

            {ConvertTo-NUnit -OutputPath 'TestDrive:/' -TestCases @('testcase2') -EnableExit -OutputVariable 'valid' } | should not throw

            Assert-MockCalled Join-Path -Times 1 -Scope It
            Assert-MockCalled Write-host -Times 1 -Scope It
            Assert-MockCalled Get-ModulePath -Times 1 -Scope It
            Assert-MockCalled Invoke-Pester -Times 1 -Scope It
        }
    }

}
