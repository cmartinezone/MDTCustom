# Developed by  Carlos Martinez
#Add-packages on User level from the text file generated with EnablePhotoViwerGetPackages.ps1

#Standard  user
$path = "C:\temp\AppsPackages.txt"
if ( test-path $path ){ 
Get-Content C:\temp\AppsPackages.txt | foreach { Add-AppxPackage -DisableDevelopmentMode -Register $_ } 
remove-item $path
}
else { Write-Host "No File found, please run EnablePhotoViwerGetPackages.ps1 as administrator First!"  
sleep 5 
exit
 }
