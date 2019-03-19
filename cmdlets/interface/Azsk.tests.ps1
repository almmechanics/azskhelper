param (
        [array]
        $TestCases 
)

Describe "azsk" {


        It " '[<FeatureName>] <Description>' set at <LineNumber> in '<FilePath>'" -TestCases $TestCases {
            Param($Description, $FilePath,$FeatureName,$LineNumber,$Status)
                $Status | should be 'Passed'
        } 
}