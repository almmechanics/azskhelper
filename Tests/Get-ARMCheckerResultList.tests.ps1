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
}
