param(
  [string]$version = '3.111.0'
)

$arm64installer = "./src/bin/ARM64/Release/pulumi-$version-windows-arm64.msi"
$arm64hash = "./src/bin/ARM64/Release/pulumi-$version-windows-arm64.sha256.txt"
$x64installer = "./src/bin/x64/Release/pulumi-$version-windows-x64.msi"
$x64hash = "./src/bin/x64/Release/pulumi-$version-windows-x64.sha256.txt"

if (Test-Path -Path $arm64installer -PathType Leaf) {
  Get-FileHash -Path $arm64installer SHA256 | Select-Object -ExpandProperty Hash | Out-File $arm64hash -Force
} else {
  Write-Error "arm64 installer not found: $arm64installer"
}

if (Test-Path -Path $x64installer -PathType Leaf) {
  Get-FileHash -Path $x64installer SHA256 | Select-Object -ExpandProperty Hash |Out-File $x64hash -Force
} else {
  Write-Error "x64 installer not found: $x64installer"
}
