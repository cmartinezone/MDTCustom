#Carlos Martinez V.1.2

#Set location path
Set-Location 'C:\Program Files\WindowsApps\'
$TempFile = 'C:\temp\AppsPackages.txt'

#Function for determinate if script is running with elevation   
function isadmin
 {
 # Returns true/false
   ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
 }

#if file exist delete, it will be re-created on the next sequence
if ( Test-Path $TempFile ) { Remove-Item $TempFile }

function  Get-PackageDirectoriesPath {


#Get list of directories if they have the word between * * and if they contain an AppxManifest.xml file on it 
#For each directory found, add the package Directories path to a file C:\temp\AppsPackages.txt for being use on standard user level

Get-ChildItem  *WindowsCamera* -Recurse "AppxManifest.xml" | Sort CreationTime | foreach { Add-Content $TempFile "$($_.Directory)\appxmanifest.xml" }
Get-ChildItem  *MicrosoftStickyNotes* -Recurse "AppxManifest.xml" | Sort CreationTime | foreach { Add-Content $TempFile "$($_.Directory)\appxmanifest.xml" }
Get-ChildItem  *WindowsCalculator* -Recurse "AppxManifest.xml" | Sort CreationTime | foreach {  Add-Content $TempFile "$($_.Directory)\appxmanifest.xml" }
Get-ChildItem  *WindowsStore* -Recurse "AppxManifest.xml" | Sort CreationTime | foreach { Add-Content $TempFile "$($_.Directory)\appxmanifest.xml" }



sleep 5 
exit

}


if (isadmin -en true ) { Get-PackageDirectoriesPath } else { 
  
  Write-Host "Please run this  file with elevation"
  sleep 5
 }