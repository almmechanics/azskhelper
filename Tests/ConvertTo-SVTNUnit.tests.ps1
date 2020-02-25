$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"
. "$here\..\cmdlets\internal\Get-ModulePath.ps1"

Describe 'ConvertTo-SVTNUnit tests' {
    Context 'Interface Tests' {
        It 'OutputPath parameter cannot be null' {
            {ConvertTo-SVTNUnit -OutputPath $null} | should throw
        }

        It 'OutputPath parameter cannot be empty' {
            {ConvertTo-SVTNUnit -OutputPath @()} | should throw
        }

        It 'OutputPath parameter must be a valid path' {
            {ConvertTo-SVTNUnit -OutputPath 'invalid_path'} | should throw
        }

        It 'TestCases array cannot be null' {
            {ConvertTo-SVTNUnit -OutputPath 'TestDrive:' -TestCases $null} | should throw
        }

        It 'TestCases array cannot be an empty' {
            {ConvertTo-SVTNUnit-NUnit -OutputPath 'TestDrive:' -TestCases @()} | should throw
        }

        It 'OutputVariable parameter cannot be null' {
            {ConvertTo-SVTNUnit-NUnit -OutputPath 'TestDrive:' -TestCases @('valid') -OutputVariable $null} | should throw
        }

        It 'OutputVariable parameter cannot be empty' {
            {ConvertTo-SVTNUnit -OutputPath 'TestDrive:' -TestCases @('valid') -OutputVariable ([string]::empty)} | should throw
        }
    }

    Context 'Usage' {
        It 'Can Invoke Pester directly' {

            Mock Join-Path{return 'valid_path'} -Verifiable
            Mock Write-host{} -Verifiable
            Mock Get-ModulePath{} -Verifiable
            Mock Invoke-Pester{} -Verifiable

            New-Item -ItemType Directory -path 'TestDrive:/source'

            {ConvertTo-SVTNUnit -OutputPath 'TestDrive:/' -TestCases @('testcase') -OutputVariable 'valid' } | should not throw

            Assert-MockCalled Join-Path -Times 1 -Scope It
            Assert-MockCalled Write-Host -Times 1 -Scope It
            Assert-MockCalled Get-ModulePath -Times 1 -Scope It
            Assert-MockCalled Invoke-Pester -Times 1 -Scope It
        }
    }
}