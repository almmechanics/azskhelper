Set-StrictMode -Version latest
function ConvertTo-TestCases {
    [CmdletBinding()] 
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Array]
        [ValidateNotNullOrEmpty()]
        $ArmResults
    )

    $TestCases = @()
    $ArmResults | ForEach-Object {
        $TestCases += @(
            @{
                FeatureName        = $_.FeatureName
                Description        = $_.Description
                ResourceLineNumber = $_.ResourceLineNumber
                FilePath           = $_.FilePath
                Status             = $_.Status
            }
        )
    }
    return $TestCases
}