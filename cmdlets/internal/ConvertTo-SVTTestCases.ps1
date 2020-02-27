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

            # Allow optional ResourceGroupName parameter
            $ResourceGroupName = [string]::empty            
            if ($_ | Get-Member ResourceGroupName)
            {
                $ResourceGroupName = ($_.ResourceGroupName)
            }

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
