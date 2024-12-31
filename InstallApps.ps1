# You can get and run the entire script on a new machine by invoking the following command.
# Invoke-Expression (Invoke-WebRequest https://raw.githubusercontent.com/0ut1awStar/InstallApps/InstallApps.ps1).content

# When running WinGet without administrator privileges, some applications may require elevation to install. 
# When the installer runs, Windows will prompt you to elevate. If you choose not to elevate, the application 
# will fail to install.

# application list (https://winget.run/)
$WinGet = @(
    "Audacity.Audacity",
    "Betaflight.Betaflight-Configurator",
    "ScooterSoftware.BeyondCompare4",
    "TGRMNSoftware.BulkRenameUtility",
    "Brave.Brave",
    "Google.Chrome",
    "Corsair.iCUE.4", # hardware specific
    "Jabra.Direct", # hardware specific
    "SteelSeries.GG", # hardware specific
    "Logitech.GHUB", # hardware specific
    "EaseUS.PartitionMaster",
    "Mozilla.Firefox.ESR",
    "BlenderFoundation.Blender",
    "Ultimaker.Cura",
    "CrystalDewWorld.CrystalDiskMark",
    "Almico.SpeedFan",
    "CPUID.HWMonitor",
    "CPUID.CPU-Z",
    "TechPowerUp.GPU-Z",
    "Discord.Discord",
    "PointPlanck.FileBot",
    "GitHub.GitHubDesktop",
    "Greenshot.Greenshot",
    "Amazon.Games",
    "EpicGames.EpicGamesLauncher",
    "GOG.Galaxy",
    "Valve.Steam",
    "HandBrake.HandBrake",
    "LIGHTNINGUK.ImgBurn",
    "DuongDieuPhap.ImageGlass",
    "Malwarebytes.Malwarebytes",
    "MediaArea.MediaInfo",
    "MediaArea.MediaInfo.GUI",
    "Meld.Meld",
    "Microsoft.VisualStudioCode",
    "Mobatek.MobaXterm",
    "MusicBrainz.Picard",
    "Nvidia.Broadcast",
    "Nvidia.GeForceExperience",
    "OBSProject.OBSStudio",
    "Ocenaudio.Ocenaudio",
    "OpenMPT.OpenMPT",
    "Plex.Plex",
    "Plex.Plexamp",
    "yt-dlp.yt-dlp",
    "Gyan.FFmpeg"
)

# manual install
#filezilla
#adobe
#solidworks
#brother
#powerchute
#lychee
#S3D
#questlink
#syncthing

function Install-WinGetApp {
    param (
        [string]$PackageID
    )
    Write-Verbose -Message "Installing $Package"
    winget install --id "$PackageID" --silent --accept-source-agreements --accept-package-agreements --source winget
}


## RUN SCRIPT ##

# Install WinGet, if not already installed
if (!(Get-AppPackage -name "Microsoft.DesktopAppInstaller")) {
    Write-Verbose -Message "Installing WinGet..."
@'
# Enable TLSv12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Set latest WinGet Github URL
$releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

# Install Nuget as Package Source Provider
Register-PackageSource -Name Nuget -Location "http://www.nuget.org/api/v2" -ProviderName Nuget -Trusted

# Get Win-Get release package
$releases = Invoke-RestMethod -uri $releases_url
$latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith('msixbundle') } | Select -First 1

# Install Microsoft.DesktopAppInstaller Package
Add-AppxPackage -Path $latestRelease.browser_download_url
'@ > $Env:Temp\winget.ps1
    Start-Process -FilePath "PowerShell" -ArgumentList "$Env:Temp\winget.ps1" -Verb RunAs -Wait
    Remove-Item -Path $Env:Temp\winget.ps1 -Force
}

foreach ($app in $WinGet) {
    Install-WinGetApp -PackageID "$app"
}
