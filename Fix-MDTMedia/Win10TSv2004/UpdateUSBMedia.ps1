#Author Carlos Martinez  Date: 10-14-2020

#Update USB Media MDT v1.0


#Detect USB Task Sequence Media
$NoMediaFound = $true
Write-Host "Detectign Media..." -ForegroundColor Yellow
Start-sleep 1

Get-Volume | Select-Object -Property DriveLetter -ExpandProperty DriveLetter | % { 
        
    If ( Test-Path -Path  $_":\Deploy\Control\WIN10V2004OFF19\ts.xml") {
        
        Write-Host "Media detected:" $_":\" -ForegroundColor Green
        $TempPatch = $_+":\patch.zip"
        $DeployPath = $_+":\Deploy"

        $url = "https://git.io/JTm0H"
        Write-Host "Dowloading update..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $url -OutFile $TempPatch
        Start-sleep 1
        Write-Host "Extracting Update..." -ForegroundColor Yellow
        Expand-Archive -Path $TempPatch -DestinationPath $DeployPath -Force
        Start-sleep 1
        Remove-Item -Path $TempPatch -Force
        Write-Host "Update Completed!" -ForegroundColor Green

        $NoMediaFound = $false 
    }
}


If($NoMediaFound){
    write-host "No Media Found for this Task Sequence Patch!" -ForegroundColor Red
}
