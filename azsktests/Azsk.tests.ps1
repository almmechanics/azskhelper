param (
        [array]
        $TestCases 
)
Describe "azsk" {
        It " '[<FeatureName>] <Description>' set at <ResourceLineNumber> in '<FilePath>'" -TestCases $TestCases {
            Param($Description, $FilePath,$FeatureName,$ResourceLineNumber,$Status)
                $Status | should be 'Passed'
        } 
}