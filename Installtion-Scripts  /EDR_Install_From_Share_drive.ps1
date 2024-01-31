# Ensure that ***all files*** in this zip are extracted to the shared folder.
# Ensure that the share is accessible to domain computers.
# Ensure share permissions allow 'Domain Computers' read access.
# Ensure security permissions allow 'Domain Computers' Read/Execute access.

# Location of the Carbon Black *folder* you want to use to install
$SensorShare = '\\Path-To-Carbon-Black-Installer\CarbonBlackClientSetupFolder'

# The folder is copied to the following *local* directory
$SensorLocal = 'C:\windows\Temp\Carbon\CarbonBlackClientSetupFolder'

# Check if the CarbonBlack service is already installed
$serviceInstalled = Get-Service -Name 'CarbonBlack' -ErrorAction SilentlyContinue

if (-not $serviceInstalled) {
    # Create a Carbon TEMP directory if it doesn't already exist
    $tempDirectory = 'C:\windows\Temp\Carbon'
    if (-not (Test-Path -Path $tempDirectory)) {
        New-Item -ItemType Directory -Path $tempDirectory -Force | Out-Null
    }

    # Copy the sensor folder if the share is available
    if (Test-Path -Path $SensorShare -Directory) {
        Copy-Item -Path $SensorShare -Destination $SensorLocal -Recurse -Force

        # Run the MSI installer silently
        $msiExecArgs = "/qn /i '$SensorLocal\cbsetup.msi' /L*V 'C:\windows\Temp\Carbon\msi.log'"
        Start-Process -FilePath 'msiexec.exe' -ArgumentList $msiExecArgs -Wait
    }
}

if ($serviceInstalled) {
    Write-Host "Carbon Black is already installed."
} else {
    Write-Host "Carbon Black has been installed."
}
