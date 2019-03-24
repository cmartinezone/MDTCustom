
#Carlos Martinez Github @cmartinezone

#Microsoft Office updater v.10 - 3-24-2019
#This script update Microsoft Office already installed on the system
#It will stay running if the update starts for 5 minutes. It can be integrated using MDT as a single task.

$OfficeLocation = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
$Arguments = "/update user updatepromptuser=False forceappshutdown=True displaylevel=False"

#Testing chaing channel 
#$MonthlyChannel = "/changesetting Channel=FirstReleaseCurrent"
#Start-Process -FilePath $OfficeLocation -ArgumentList $MonthlyChannel -wait -NoNewWindow 

Start-Process -FilePath $OfficeLocation -ArgumentList $Arguments -wait -NoNewWindow 


$OfficeUpdateProcess = Get-Process -Name "OfficeClickToRun"
Start-Sleep -Seconds 10


if ($OfficeUpdateProcess.Count -ge 2 ) {  
    
    Write-Progress -Activity 'MicrosoftOffice:' -Status 'Updating...' -PercentComplete 100 
    Start-Sleep -Seconds 240
    Stop-Process -Name  "OfficeClickToRun" -Force

}




