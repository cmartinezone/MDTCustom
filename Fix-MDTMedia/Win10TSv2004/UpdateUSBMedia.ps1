#Author Carlos Martinez 

#Update USB Media MDT v1.0


#Detect USB Task Sequence Media
Get-Volume | Select-Object -Property DriveLetter -ExpandProperty DriveLetter | % { 
        
    If ( Test-Path -Path  $_":\Deploy\Control\WIN10V2004OFF19\ts.xml") {
      
        $TempPatch = $_+":\patch.zip"
        $DeployPath = $_+":\Deploy"

        $url = "https://git.io/JTm0H"
        Write-Host "Dowloading update..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $url -OutFile $TempPatch
        Write-Host "Extracting Update..." -ForegroundColor Yellow
        Expand-Archive -Path $TempPatch -DestinationPath $DeployPath -Force
        Remove-Item -Path $TempPatch -Force
        Write-Host "Update Completed!" -ForegroundColor Green
    }

}
