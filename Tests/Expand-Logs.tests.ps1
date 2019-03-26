$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

Describe 'Expand-Logs tests' {
    Context 'Interface Tests' {
        It 'ArchivePath array parameter cannot be null' {
            {Expand-Logs -ArchivePath $null} | should throw
        }

        It 'ArchivePath array parameter cannot be empty' {
            {Expand-Logs -ArchivePath [string]::empty} | should throw
        }

        It 'ArchivePath must be a valid path' {
            {Expand-Logs -ArchivePath 'invalid_path'} | should throw
        }
    }

    Context 'Expand Archive' {
    
        New-item -Path 'TestDrive:/Archive'
        It 'Returns the archive folder' {

            Mock New-Item {return 'expanded_path'} -Verifiable
            Mock Expand-Archive {return 'expanded_path/azsk-123456'} -Verifiable

            Expand-Logs -ArchivePath  'TestDrive:/Archive' | should not benullorempty
            Assert-MockCalled New-Item -Times 1 -Scope It
            Assert-MockCalled Expand-Archive -Times 1 -Scope It
        }

        It 'Creates a folder using the pattern "azsk-"' {

            Mock New-Item {return 'expanded_path'} -Verifiable
            Mock Expand-Archive {return 'expanded_path/azsk-123456'} -Verifiable

            (Expand-Logs -ArchivePath  'TestDrive:/Archive'| Split-Path -Leaf) | Should -BeLikeExactly 'azsk-*'
            Assert-MockCalled New-Item -Times 1 -Scope It
            Assert-MockCalled Expand-Archive -Times 1 -Scope It
        }
    }
}
