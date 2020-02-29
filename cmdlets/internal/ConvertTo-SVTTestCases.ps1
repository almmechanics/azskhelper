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

    $SVTResults | ForEach-Object {
        # Allow optional ResourceGroupName parameter
        if ($_.ContainsKey('ResourceGroupName'))
        {
            $ResourceGroupName = ($_.ResourceGroupName)
        }
        else {
            $ResourceGroupName = [string]::empty
        }

        $TestCases += @(
            @{
                FeatureName = $_.FeatureName
                ResourceGroupName = $ResourceGroupName
                Description = $_.Description
                Status = $_.Status
                ControlSeverity = $_.ControlSeverity
            }
        )
    }
    return $TestCases
} 
