
function ConvertTo-TestCases
{
    param(
        [array]
        $ArmResults
    )

    $TestCases = @()
    $ArmResults | ForEach-Object{
        $TestCases += @{
        FeatureName = $_.FeatureName
        Description = $_.Description
        LineNumber = $_.LineNumber
        FilePath = $_.FilePath
        Status = $_.Status
        }
    }
    return $TestCases
}