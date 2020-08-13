Describe 'ConvertTo-NUnit tests' {
    BeforeAll {
        . $PSScriptRoot/../cmdlets/internal/ConvertTo-NUnit.ps1
        . $PSScriptRoot/../cmdlets/internal/Get-ModulePath.ps1
        . $PSScriptRoot/../cmdlets/internal/Use-Pester.ps1
    }

    BeforeEach {
        New-item -ItemType Directory -Path 'TestDrive:/convert'
    }

    AfterEach {
        Remove-Item -Path 'TestDrive:/convert' -Force -Recurse
    }

    Context 'Interface Tests' {
        It 'OutputPath parameter cannot be null' {
            { ConvertTo-NUnit -OutputPath $null } | should -throw
        }

        It 'OutputPath parameter cannot be empty' {
            { ConvertTo-NUnit -OutputPath @() } | should -throw
        }

        It 'OutputPath parameter must be a valid path' {
            { ConvertTo-NUnit -OutputPath 'invalid_path' } | should -throw
        }

        It 'TestCases array cannot be null' {
            { ConvertTo-NUnit -OutputPath 'TestDrive:' -TestCases $null } | should -throw
        }

        It 'TestCases array cannot be an empty' {
            { ConvertTo-NUnit -OutputPath 'TestDrive:/' -TestCases @() } | should -throw
        }

        It 'OutputVariable parameter cannot be null' {
            { ConvertTo-NUnit -OutputPath 'TestDrive:/' -TestCases @('valid') -OutputVariable $null } | should -throw
        }

        It 'OutputVariable parameter cannot be empty' {
            { ConvertTo-NUnit -OutputPath 'TestDrive:/' -TestCases @('valid') -OutputVariable ([string]::empty) } | should -throw
        }
    }

    Context 'Usage' {
        It 'Can Invoke Pester directly' {

            Mock Join-Path { return 'valid_path' } -Verifiable
            Mock Write-host {} -Verifiable
            Mock Get-ModulePath { return 'TestDrive:/convert' } -Verifiable
            Mock Invoke-Pester {} -Verifiable

            { ConvertTo-NUnit -OutputPath 'TestDrive:/convert' -TestCases @('testcase') -OutputVariable 'valid' } | should -not -throw

            Should -Invoke Join-Path -Exactly 1 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It
            Should -Invoke Get-ModulePath -Exactly 1 -Scope It
            Should -Invoke Invoke-Pester -Exactly 1 -Scope It
        }
    }
}