Set-StrictMode -Version latest
function ConvertTo-SVTTestCases {
    [CmdletBinding()] 
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Array]
        [ValidateNotNullOrEmpty()]
        $SVTResults
    )

    $TestCases = @()

    $SVTResults | ForEach-Object {
        # Allow optional ResourceGroupName parameter
        Write-Verbose $_
        if ($_ | Get-Member -Name 'ResourceGroupName') {
            $ResourceGroupName = ($_.ResourceGroupName)
        }
        else {
            $ResourceGroupName = [string]::Empty
        }

        $TestCases += @(
            @{
                FeatureName       = $_.FeatureName
                ResourceGroupName = $ResourceGroupName
                Description       = $_.Description
                Status            = $_.Status
                ControlSeverity   = $_.ControlSeverity
            }
        )
    }
    return $TestCases
} 
