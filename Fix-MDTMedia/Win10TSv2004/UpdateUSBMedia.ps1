#Author Carlos Martinez 

#Update USB Media MDT v1.0


#Detect USB Task Sequence Media
Get-Volume | Select-Object -Property DriveLetter -ExpandProperty DriveLetter | % { 
        
    If ( Test-Path -Path  $_":\Deploy\Control\WIN10V2004OFF19\ts.xml") {
      

        # Download the file to a specific location
        $clnt = new-object System.Net.WebClient
        $url = "https://git.io/JTm0H"
        $file = "E:\patch.zip"
        $clnt.DownloadFile($url, $file)
    }

}
