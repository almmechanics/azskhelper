$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', '' 
. "$here\..\cmdlets\internal\$sut"

function Get-Module
{
    # SessionStateUnauthorizedAccessException: Cannot overwrite variable PSEdition because it is read-only or constant.
}
Describe 'Get-ModulePath tests' {
    Context 'Interface Tests' {
        It 'Filename parameter cannot be null' {
            {Get-ModulePath -Filename $null} | should throw
        }

        It 'Filename parameter cannot be empty' {
            {Get-ModulePath -Filename ([string]::Empty)} | should throw
        }

        It 'Folder parameter cannot be null' {
            {Get-ModulePath -Filename 'Valid' -Folder  $null} | should throw
        }

        It 'Folder parameter cannot be empty' {
            {Get-ModulePath -Filename 'Valid' -Folder ([string]::Empty)} | should throw
        }
    }

    Context 'Processes ModuleBase folder' {
        $testfolder =  Join-Path 'TestDrive:' 'ModuleBase'

        Mock Get-Module {return @{ModuleBase = $testfolder} } -Verifiable

        It 'Default folder name is processed on mac' {
            Get-ModulePath -Filename 'Valid.filename' | should be 'TestDrive:/ModuleBase/./Valid.filename'
            Assert-MockCalled Get-Module -Exactly 1 -Scope It
        }

        It 'custom folder name is processed on mac' {
            Get-ModulePath -Folder 'custom' -Filename 'Valid.filename' | should be 'TestDrive:/ModuleBase/custom/Valid.filename'
            Assert-MockCalled Get-Module -Exactly 1 -Scope It
        }
    }
} 