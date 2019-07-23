[![Board Status](https://almmechanics.visualstudio.com/76672c97-594f-4ebd-8422-baf477008983/f653f92c-c5bd-4c3a-b053-9eac745571d7/_apis/work/boardbadge/da8b9534-0039-4793-b402-a3da02414273)](https://almmechanics.visualstudio.com/76672c97-594f-4ebd-8422-baf477008983/_boards/board/t/f653f92c-c5bd-4c3a-b053-9eac745571d7/Microsoft.RequirementCategory)
# Publish AZSK output as NUNIT

Converts AZSK zip archive output into NUnit Test results via the pester module (Default on Win 10/2016+).

The Module has a simple interface:

      Publish-AzskNUnit [-Path <Path>] [-EnableExit] 

The [-EnableExit] option allows this code to be called within a CI pipeline, making the failure of AZSK to be part of the PR/Build process.