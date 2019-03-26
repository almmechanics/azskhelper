$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

Describe 'Get-SkippedFilesList tests' {
    Context 'Interface Tests' {
        It 'Path array parameter cannot be null' {
            {Get-SkippedFilesList -Path $null} | should throw
        }

        It 'Path array parameter cannot be empty' {
            {Get-SkippedFilesList -Path [string]::empty} | should throw
        }

        It 'Path must be a valid path' {
            {Get-SkippedFilesList -Path 'invalid_path'} | should throw
        }
    }
}
