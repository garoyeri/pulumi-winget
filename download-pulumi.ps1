param (
  [string]$version = "latest",
  [string]$arch = "x64",
  [bool]$clean = $false,
  [string]$pat
)

# Define the URL for the release of Pulumi from GitHub API
$url = "https://api.github.com/repos/pulumi/pulumi/releases/tags/$version"

# Create a header for the PAT if one was provided
$headers = @{
  'Accept' = 'application/vnd.github+json';
  'Authorization' = "Bearer $pat";
  'X-GitHub-Api-Version' = '2022-11-28'
}

# Use Invoke-RestMethod to send a GET request to the URL
$response = Invoke-RestMethod -Uri $url -Headers $headers
# $response.assets | Where-Object { $_.name -like "*-windows-$arch.zip" } | Select-Object -ExpandProperty name | Format-Table | Out-Host

# Extract the download URL for the zip file from the response
$zipUrl = $response.assets | Where-Object { $_.name -like "*-windows-$arch.zip" } | Select-Object -First 1 -ExpandProperty browser_download_url

# Define the path where the zip file will be saved
$zipFile = "./packages/pulumi-windows-$arch.zip"

# Check if file is already downloaded
if (Test-Path -Path $zipFile -PathType Leaf) {
  # skip downloading the file
  Write-Host "File was already downloaded: $zipFile"
} else {
  # Download the zip file
  Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -Headers $headers
}

# Define the path where the zip file will be extracted
$extractPath = "./packages/$arch"

# Create the directory if it doesn't exist
if (!(Test-Path -Path $extractPath)) {
  Write-Host "Setting up target path $extractPath"
  New-Item -ItemType Directory -Path $extractPath | Out-Null
}
elseif ($clean) {
  Write-Host "Cleaning up target path $extractPath"
  Remove-Item $extractPath -Recurse -Force
  New-Item -ItemType Directory -Path $extractPath | Out-Null
}

# Extract the zip file
Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force

Write-Host "Pulumi version $version has been downloaded and unzipped to $extractPath"
