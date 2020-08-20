Describe 'ConvertTo-SVTNUnit tests' {

    BeforeAll {
        . $PSScriptRoot/../cmdlets/internal/ConvertTo-SVTNUnit.ps1
        . $PSScriptRoot/../cmdlets/internal/Get-ModulePath.ps1
    }


    BeforeEach {
        New-item -ItemType Directory -Path 'TestDrive:/svt'
    }

    AfterEach {
        Remove-Item -Path 'TestDrive:/svt' -Force -Recurse
    }


    Context 'Interface Tests' {
        It 'OutputPath parameter cannot -be null' {
            { ConvertTo-SVTNUnit -OutputPath $null } | should -throw
        }

        It 'OutputPath parameter cannot -be empty' {
            { ConvertTo-SVTNUnit -OutputPath @() } | should -throw
        }

        It 'OutputPath parameter must -be a valid path' {
            { ConvertTo-SVTNUnit -OutputPath 'invalid_path' } | should -throw
        }

        It 'OutputVariable parameter cannot -be null' {
            { ConvertTo-SVTNUnit-NUnit -OutputPath 'TestDrive:' -OutputVariable $null } | should -throw
        }

        It 'OutputVariable parameter cannot -be empty' {
            { ConvertTo-SVTNUnit -OutputPath 'TestDrive:'  -OutputVariable ([string]::empty) } | should -throw
        }
    }

    Context 'Usage' {
        It 'Can Invoke Pester directly' {

            Mock Join-Path { return 'valid_path' } -Verifiable
            Mock Write-host {} -Verifiable
            Mock Get-ModulePath { return 'TestDrive:/svt' } -Verifiable
            Mock Invoke-Pester {} -Verifiable

            { ConvertTo-SVTNUnit -OutputPath 'TestDrive:/' -OutputVariable 'valid' } | should -not -throw

            Should -Invoke Join-Path -Exactly 1 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It
            Should -Invoke Get-ModulePath -Exactly 1 -Scope It
            Should -Invoke Invoke-Pester -Exactly 1 -Scope It
        }
    }
}