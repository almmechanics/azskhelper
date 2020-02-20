Set-StrictMode -Version latest
function ConvertTo-SVTTestCases
{
    [CmdletBinding()] 
    param(
        [parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [Array]
        [ValidateNotNullOrEmpty()]
        $SVTResults
    )

    $TestCases = @()

    $SVTResults | ForEach-Object{
        $TestCases += @(
            @{
                FeatureName = $_.FeatureName
                ResourceGroupName = $_.ResourceGroupName
                ResourceName = $_.ResourceName
                Description = $_.Description
                Status = $_.Status
                ControlSeverity = $_.ControlSeverity
            }
        )
    }
    return $TestCases
}