<a href="https://www.pulumi.com" title="Pulumi - Modern Infrastructure as Code - AWS Azure Kubernetes Containers Serverless">
    <img src="https://www.pulumi.com/images/logo/logo.svg" width="350">
</a>

This repository contains the scripts required to update the Pulumi package on [Windows Package Manager](https://github.com/microsoft/winget-cli).

Written using WiX Toolset v4 and PowerShell scripts.

## Running locally

```powershell
# Download latest pulumi binaries (or specify a version)
# NOTE: v3.111.1 doesn't have windows binaries, so you should pick one that does
./download-pulumi.ps1 -pat 'YOUR-GITHUB-PAT-TOKEN' -arch x64 -version v3.111.0
./download-pulumi.ps1 -pat 'YOUR-GITHUB-PAT-TOKEN' -arch arm64 -version v3.111.0

# restore the wix toolset locally, allows you to build wix projects
dotnet tool restore

# build the installers
dotnet build src -c Release -p:Platform=x64 -p:Version=3.111.0
dotnet build src -c Release -p:Platform=arm64 -p:Version=3.111.0
```

This generates a MSI file (windows installer) and a winget manifest file

> NOTE: To actually get an MSI, you need candle.exe/light.exe from WiX tools in your path. These are available in the CI.
