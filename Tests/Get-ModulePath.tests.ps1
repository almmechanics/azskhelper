Describe 'Get-ModulePath tests' {
    BeforeAll {
        function Get-Module {
            # SessionStateUnauthorizedAccessException: Cannot overwrite variable PSEdition because it is read-only or constant.
        }

        . $PSScriptRoot/../cmdlets/internal/Get-ModulePath.ps1
    }

    Context 'Interface Tests' {
        It 'Filename parameter cannot -be null' {
            { Get-ModulePath -Filename $null } | should -throw
        }

        It 'Filename parameter cannot -be empty' {
            { Get-ModulePath -Filename ([string]::Empty) } | should -throw
        }

        It 'Folder parameter cannot -be null' {
            { Get-ModulePath -Filename 'Valid' -Folder  $null } | should -throw
        }

        It 'Folder parameter cannot -be empty' {
            { Get-ModulePath -Filename 'Valid' -Folder ([string]::Empty) } | should -throw
        }
    }

    Context 'Processes ModuleBase folder' {

        It 'Default folder name is processed' {
            Mock Get-Module { return @{ModuleBase = (Join-Path 'TestDrive:' 'ModuleBase') } } -Verifiable

            Get-ModulePath -Filename 'Valid.filename' | should -be 'TestDrive:/ModuleBase/./Valid.filename'
            Should -Invoke Get-Module -Exactly 1 -Scope It
        }

        It 'custom folder name is processed' {
            Mock Get-Module { return @{ModuleBase = (Join-Path 'TestDrive:' 'ModuleBase') } } -Verifiable

            Get-ModulePath -Folder 'custom' -Filename 'Valid.filename' | should -be 'TestDrive:/ModuleBase/custom/Valid.filename'
            Should -Invoke Get-Module -Exactly 1 -Scope It
        }
    }
} 