# You can get and run the entire script on a new machine by invoking the following command.
# irm https://raw.githubusercontent.com/0ut1awStar/InstallApps/refs/heads/main/InstallApps.ps1 | iex

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
    "UnifiedIntents.UnifiedRemote",
    "yt-dlp.yt-dlp",
    "Gyan.FFmpeg"
)

# manual install
#Office (massgrave.dev)
#filezilla
#adobe p
#solidworks
#brother
#powerchute
#lychee
#S3D
#questlink
#syncthing


function CheckAdminPrivileges {
    if (!([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544')) {
        Write-Host "You are not running this script with administrator privileges. Please run as Administrator. Ending Script." -ForegroundColor Red
        exit
    } 
}

function Install-WinGet {
    # Install WinGet, if not already installed
    if (!(Get-AppPackage -name "Microsoft.DesktopAppInstaller")) {
        Write-Host "Installing WinGet..." -ForegroundColor Yellow
        Install-Script -Name winget-install
    }
}
    
function Install-WinGetApp {
    param (
        [string]$PackageID
    )
    Write-Host "Installing $PackageID" -ForegroundColor Yellow
    winget install --id "$PackageID" --silent --accept-source-agreements --accept-package-agreements --source winget
}

function Activate-Windows {
        Write-Host "Activating Windows" -ForegroundColor Yellow
    & ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID
}


function Install-Office {
    Write-Host "Installing Office" -ForegroundColor Yellow

    # download url
    $DownloadUrl = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=en-us&version=O16GA"

    # path where the file will be saved
    $DestinationPath = "$env:TEMP\officesetup.exe"

    # Download the file
    Write-Host "Downloading Office setup from $DownloadUrl..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $DestinationPath

    # Check if the file was downloaded successfully
    if (Test-Path $DestinationPath) {
        Write-Host "Download completed successfully. File saved to $DestinationPath." -ForegroundColor Green
        
        # Run the installer
        Write-Host "Starting the Office setup installation..." -ForegroundColor Yellow
        Start-Process -FilePath $DestinationPath -ArgumentList "/configure" -Wait -NoNewWindow
        
        Write-Host "Office setup installation completed." -ForegroundColor Green

        Write-Host "Activating"
        & ([ScriptBlock]::Create((irm https://get.activated.win))) /Ohook

    } 
    else {
        Write-Host "Download failed. Please check the URL and try again." -ForegroundColor Red
    }
}


## RUN SCRIPT ##

# Check if the script is running with administrator privileges
CheckAdminPrivileges

# Install WinGet
Install-winGet

# Install WinGet Apps
foreach ($app in $WinGet) {
    Install-WinGetApp -PackageID "$app"
}

# Install and Activate Office
Install-Office