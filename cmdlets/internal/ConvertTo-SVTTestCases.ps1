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
            $ResourceGroupName = [string]::empty
            if ($_ | Get-Member -Name 'ResourceGroupsName') {$ResourceGroupName = $_.ResourceGroupName}

            @{
                FeatureName = $_.FeatureName
                ResourceName = $ResourceGroupName
                Description = $_.Description
                Status = $_.Status
                ControlSeverity = $_.ControlSeverity
            }
        )
    }
    return $TestCases
} 
