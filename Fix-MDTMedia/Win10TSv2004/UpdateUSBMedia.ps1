#Author Carlos Martinez 

#Update USB Media MDT v1.0


#Detect USB Task Sequence Media
Get-Volume | Select-Object -Property DriveLetter -ExpandProperty DriveLetter | % { 
        
    If( Test-Path -Path  $_":\Deploy\Control\WIN10V2004OFF19\ts.xml"){
      
        #Download Ts Updated
        

        #Download patch zip 

    }

}
