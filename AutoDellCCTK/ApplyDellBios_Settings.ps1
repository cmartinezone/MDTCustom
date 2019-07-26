#Author: Carlos Martinez Date: 7/19/2019

#Get Computer Manufacturer and Model
$Computer = Get-WmiObject Win32_Computersystem | Select-Object -Property Manufacturer, Model

$ModelsSupported = Import-Csv -Path ".\DellModels.csv"

#If Manufacture is Dell Inc.
if ($Computer.Manufacturer -eq "Dell Inc.") {
    
    # If model is on the Csv file
    if ($Computer.Model -in $ModelsSupported.model) {
        
        #Get single Object Properties of the model from the csv
        $Model = $ModelsSupported | Where-Object { $_.model -eq $Computer.Model }
        
        #Bios Temp password
        $TempPassword = "password"

        #file name settings template for the model
        $filesettings = $Model.filename
       
        Write-Host "Applying Dell Bios Settings to "  $Computer.Model -ForegroundColor Yellow
        
        #Uses Dell CCTK version stablished on the csv file for the model
        switch ($Model.cctk) {
            "4.2" { 
                .\DellCCTK\4.2\cctk.exe --SetupPwd=$TempPassword
                .\DellCCTK\4.2\cctk.exe -i .\Settings_Templates\$filesettings --ValSetupPwd=$TempPassword
                .\DellCCTK\4.2\cctk.exe --SetupPwd= --ValSetupPwd=$TempPassword

            }
            "4.1" { 
                .\DellCCTK\4.1\HAPI\HAPIInstall.bat 
                .\DellCCTK\4.1\cctk.exe --SetupPwd=$TempPassword
                .\DellCCTK\4.1\cctk.exe -i .\Settings_Templates\$filesettings --ValSetupPwd=$TempPassword
                .\DellCCTK\4.1\cctk.exe --SetupPwd= --ValSetupPwd=$TempPassword
                .\DellCCTK\4.1\HAPI\HAPIUninstall.bat
            }
            "4.0" { 
                .\DellCCTK\4.0\HAPI\HAPIInstall.bat 
                .\DellCCTK\4.0\cctk.exe --setuppwd=$TempPassword
                .\DellCCTK\4.0\cctk.exe bootorder --activebootlist=uefi  --valsetuppwd=$TempPassword
                .\DellCCTK\4.0\cctk.exe cctk --legacyorom=disable  --valsetuppwd=$TempPassword
                .\DellCCTK\4.0\cctk.exe --tpm=on  --valsetuppwd=$TempPassword
                .\DellCCTK\4.0\cctk.exe -i .\Settings_Templates\$filesettings  --valsetuppwd=$TempPassword
                .\DellCCTK\4.0\cctk.exe --setuppwd=   --valsetuppwd=$TempPassword
                .\DellCCTK\4.0\HAPI\HAPIUninstall.bat
            }
            "3.3" { 
                .\DellCCTK\3.3\HAPI\HAPIInstall.bat 

                .\DellCCTK\3.3\cctk.exe --setuppwd=$TempPassword
                .\DellCCTK\3.3\cctk.exe bootorder --activebootlist=uefi  --valsetuppwd=$TempPassword
                .\DellCCTK\3.3\cctk.exe cctk --legacyorom=disable  --valsetuppwd=$TempPassword
                .\DellCCTK\3.3\cctk.exe --tpm=on  --valsetuppwd=$TempPassword
                .\DellCCTK\3.3\cctk.exe -i .\Settings_Templates\$filesettings  --valsetuppwd=$TempPassword
                .\DellCCTK\3.3\cctk.exe --setuppwd=   --valsetuppwd=$TempPassword
                .\DellCCTK\3.3\HAPI\HAPIUninstall.bat
            }
            "3.2" { "It is 3.2" }
            "3.1.2" { "It is 3.1.2" }
            "3.1" { "It is 3.1" }
            "3.0" { "It is 3.0" }
        }
       
    }

}