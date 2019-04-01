# Publish AZSK output as NUNIT

Converts AZSK zip archive output into NUnit Test results via the pester module (Default on Win 10/2016+).

The Module has a simple interface:

      Publish-AzskNUnit [-Path <Path>] [-EnableExit] 

The [-EnableExit] option allows this code to be called within a CI pipeline, making the failure of AZSK to be part of the PR/Build process.