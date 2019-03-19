function Get-ARMCheckerResultList
{
    param(
        [string]
        $Path
    )

    $ARMCheckerResults = Get-ChildItem -Path $Path -Recurse  -include 'ARMCheckerResults_*.csv'
    return @(Get-Content $ARMCheckerResults | ConvertFrom-CSV)
}