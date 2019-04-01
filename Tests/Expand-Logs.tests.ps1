$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"
. "$here\..\cmdlets\internal\Search-AzskLogs.ps1"

Describe 'Expand-Logs tests' {
    Context 'Interface Tests' {
        It 'Path parameter cannot be null' {
            {Expand-Logs -Path $null} | should throw
        }

        It 'Path parameter cannot be empty' {
            {Expand-Logs -Path [string]::empty} | should throw
        }

        It 'Path must be a valid path' {
            {Expand-Logs -Path 'invalid_path'} | should throw
        }
    }

    Context 'Expand Archive' {
    
        New-item -Path 'TestDrive:/Archive'
        It 'Returns the archive folder' {

            Mock Search-AzskLogs {return 'TestDrive:/archive'} -Verifiable
            Mock New-Item {return 'expanded_path'} -Verifiable
            Mock Expand-Archive {return 'expanded_path/azsk-123456'} -Verifiable

            Expand-Logs -Path  'TestDrive:/Archive' | should not benullorempty
            Assert-MockCalled New-Item -Times 1 -Scope It
            Assert-MockCalled Expand-Archive -Times 1 -Scope It
            Assert-MockCalled Search-AzskLogs -Times 1 -Scope It
        }

        It 'Creates a folder using the pattern "azsk-"' {

            Mock New-Item {return 'expanded_path'} -Verifiable
            Mock Expand-Archive {return 'expanded_path/azsk-123456'} -Verifiable

            (Expand-Logs -Path  'TestDrive:/Archive'| Split-Path -Leaf) | Should -BeLikeExactly 'azsk-*'
            Assert-MockCalled New-Item -Times 1 -Scope It
            Assert-MockCalled Expand-Archive -Times 1 -Scope It
        }
    }
}
