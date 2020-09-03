Describe 'Expand-Logs tests' {
    BeforeAll {
        . $PSScriptRoot/../cmdlets/internal/Expand-Logs.ps1
        . $PSScriptRoot/../cmdlets/internal/Search-AzskLogs.ps1
    }

    BeforeEach {
        New-item -ItemType Directory -Path 'TestDrive:/Archive'
    }

    AfterEach {
        Remove-Item -Path 'TestDrive:/Archive' -Force -Recurse
    }

    Context 'Interface Tests' {
        It 'Path parameter cannot -be null' {
            { Expand-Logs -Path $null } | should -throw
        }

        It 'Path parameter cannot -be empty' {
            { Expand-Logs -Path [string]::empty } | should -throw
        }

        It 'Path must -be a valid path' {
            { Expand-Logs -Path 'invalid_path' } | should -throw
        }
    }

    Context 'Expand Archive' {
    
        It 'Returns the archive folder' {
            Mock Search-AzskLogs { return 'TestDrive:/archive' } -Verifiable
            Mock New-Item { return 'expanded_path' } -Verifiable
            Mock Expand-Archive { return 'expanded_path/azsk-123456' } -Verifiable

            (Expand-Logs -Path 'TestDrive:/Archive' -AnalysisType ARM) | should -Not -BeNullOrEmpty
            Should -Invoke New-Item -Exactly 1 -Scope It
            Should -Invoke Expand-Archive -Exactly 1 -Scope It
            Should -Invoke Search-AzskLogs -Exactly 1 -Scope It
        }

        It 'Creates a folder using the pattern "azsk-"' {
            Mock Search-AzskLogs { return 'TestDrive:/archive/azsk-123456.zip' } -Verifiable
            Mock New-Item { return 'expanded_path' } -Verifiable
            Mock Expand-Archive { return 'expanded_path/azsk-123456.zip' } -Verifiable

            (Expand-Logs -AnalysisType ARM -Path 'TestDrive:/Archive' | Split-Path -Leaf) | Should -BeLike 'azsk-*'
            Should -Invoke New-Item -Exactly 1 -Scope It
            Should -Invoke Expand-Archive -Exactly 1 -Scope It
        }
    }
}
