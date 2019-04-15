# Carlos Martinez 8/13/18 GitHub @cmartinezone

#Add the Provisioned Windows apps that you or your organization don't want for a new user
#Apps Reference: https://docs.microsoft.com/en-us/windows/application-management/apps-in-windows-10

$WhiteListedApps = @(
    "Microsoft.3DBuilder"
    "Microsoft.BingWeather"
    "microsoft.windowscommunicationsapps"
    "Microsoft.DesktopAppInstaller"
    "Microsoft.HEIFImageExtension"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MixedReality.Portal"
    "Microsoft.MSPaint"
    "Microsoft.Print3D"
    "Microsoft.ScreenSketch"
    "Microsoft.StorePurchaseApp"
    "Microsoft.VP9VideoExtensions"
    "Microsoft.Wallet"
    "Microsoft.WebMediaExtensions"
    "Microsoft.HEVCVideoExtension"
    "Microsoft.WebpImageExtension"
    "Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

# To use this script with offline image state:  Get-AppxProvisionedPackage -Path "c:\offline"
try { 
    $apps = Get-AppxProvisionedPackage -online | ForEach-Object {

        if (($_.DisplayName -notin $WhiteListedApps)) {

            Write-Host "Removing the following Built-in app:" -ForegroundColor Green
            Write-Host "Deprovisioned:" $_.DisplayName -ForegroundColor yellow
            Remove-AppxProvisionedPackage -online -PackageName $_.PackageName 

            #Progress bar added  3\21\2018
            Write-Progress -Activity 'Removing:' -Status $_.DisplayName -PercentComplete 100 
            Start-Sleep -Seconds 1
        } 
    }
    
}
	
catch [Exception] {
    Write-Host "Removing Built-in apps failed..." -ForegroundColor Red;
    Write-Host "Error:" $_.Exception.Message -ForegroundColor Red; 
    
}


   