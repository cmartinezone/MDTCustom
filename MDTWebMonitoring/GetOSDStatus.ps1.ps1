# Contact Carlos Martinez for any issue with the script - carlos0492@outlook.com

#Configuration Variables:
$Date = get-date -Format g
$Your_Host = ""
$URL = "http://" + $Your_Host + ":9801/MDTMonitorData/Computers/"
$HTML_Deployment_List = "status.htm" #path location and file named in the web server

#Web Page config 
$LogoPath = 'LOGO.jpg'
$PageMessage =  'C-Martinez MDT Deployment Status'
$EngineerName = 'Carlos Martinez'
$EmailSubject = 'MDT Deployment status support'
$SupportEmail = 'carlos0492@outlook.com'
$EmailSubject = "carlos0492@outlook.com?subject=$EmailSubject"       
$FooterPage =   'Designed By: Carlos Martinez'

function GetMDTData { 
  $Data = Invoke-RestMethod $URL
  foreach($property in ($Data.content.properties)) 
  { 
		$Percent = $property.PercentComplete.'#text' 		
		$Current_Steps = $property.CurrentStep.'#text'			
		$Total_Steps = $property.TotalSteps.'#text'		
		
		If ($Current_Steps -eq $Total_Steps)
			{
				If ($Percent -eq $null)
					{			
						$Step_Status = "Not started"
					}
				Else
					{
						$Step_Status = "$Current_Steps / $Total_Steps"
					}					
			}
		Else
			{
				$Step_Status = "$Current_Steps / $Total_Steps"			
			}

	
		$Step_Name = $property.StepName		
		If ($Percent -eq 100)
			{
				$Global:StepName = "Deployment finished"
				$Percent_Value = $Percent + "%"				
			}
		Else
			{
				If ($Step_Name -eq "")
					{					
						If ($Percent -gt 0) 					
							{
								$Global:StepName = "Computer restarted"
								$Percent_Value = $Percent + "%"
							}	
						Else							
							{
								$Global:StepName = "Deployment not started"	
								$Percent_Value = "Not started"	
							}

					}
				Else
					{
						$Global:StepName = $property.StepName		
						$Percent_Value = $Percent + "%"					
					}					
			}

		$Deploy_Status = $property.DeploymentStatus.'#text'					
		If (($Percent -eq 100) -and ($Step_Name -eq "") -and ($Deploy_Status -eq 1))
			{
				$Global:StepName = "Running in PE"						
			}			
			
			
		$End_Time = $property.EndTime.'#text' 	
		If ($End_Time -eq $null)
			{
				If ($Percent -eq $null)
					{									
						$EndTime = "Not started"
						$Ellapsed = "Not started"												
					}
				Else
					{
						$EndTime = "Not finished"
						$Ellapsed = "Not finished"					
					}
			}
		Else
			{
				$EndTime = ([datetime]$($property.EndTime.'#text')).ToLocalTime().ToString('hh:mm:ss tt')  	 
				$Ellapsed = new-timespan -start ([datetime]$($property.starttime.'#text')).ToString('hh:mm:ss tt') -end ([datetime]$($property.endTime.'#text')).ToString('hh:mm:ss tt'); 				
			}

    New-Object PSObject -Property @{ 
      "Computer Name" = $($property.Name); 
      "Percent Complete" = $Percent_Value; 	  
      "Step Name" = $StepName;	  	  
      "Step status" = $Step_Status;	  
      Warnings = $($property.Warnings.'#text'); 
      Errors = $($property.Errors.'#text'); 
      "Deployment Status" = $( 
        Switch ($property.DeploymentStatus.'#text') { 
        1 { "Running" } 
        2 { "Failed" } 
        3 { "Success" } 
        4 { "Unresponsive" } 		
        Default { "Unknown" } 
        } 
      ); 	  
      "Date" = $($property.StartTime.'#text').split("T")[0]; 
      "Start time" = ([datetime]$($property.StartTime.'#text')).ToLocalTime().ToString('hh:mm:ss tt')  
	  "End time" = $EndTime;
      "Ellapsed time" = $Ellapsed;	  	  
    } 
  } 
} 



$AllDatas = GetMDTData | Select Date, "Computer Name", "Percent Complete", "Step Name", Warnings, Errors, "Start time", "End Time", "Ellapsed time", "Step status", "Deployment Status"

If ($AllDatas -eq $null)
	{
		
		$NB_Success = "0"
		$NB_Failed = "0"
		$NB_Runnning = "0"	
        $NB_Unresponsive = "0"
		
		$Search = " "
	}
Else
	{
		$Search = "
		<h6> Type something like computer name, deployment status, step name... </h6>  

		<input class='form-control' id='mySearchText' type='text' placeholder='Search..'>
		"  
		
		 #Get all objects that they contain the deployment status word
         $Total_Running      = $AllDatas."Deployment Status" -eq "Running"
         $Total_Failed       = $AllDatas."Deployment Status" -eq "Failed"
         $Total_Sucess       = $AllDatas."Deployment Status" -eq "Success"
         $Total_Unresponsive = $AllDatas."Deployment Status" -eq "Unresponsive"

         #Count the total of Object for each word 
		 $NB_Success      =  $Total_Sucess.Count
		 $NB_Failed       =  $Total_Failed.Count
		 $NB_Runnning     =  $Total_Running.Count
		 $NB_Unresponsive =  $Total_Unresponsive.Count		
		
		 if (	$Total_Sucess   	-eq  $false ) { $NB_Success = 0 }
		 if (	$Total_Failed    	-eq  $false ) { $NB_Failed = 0 }
		 if (	$Total_Running  	-eq  $false ) { $NB_Runnning = 0 }
		 if (	$Total_Unresponsive -eq  $false ) { $NB_Unresponsive = 0 }

		If (	$NB_Success  -eq  $null	)	{ $NB_Success = 0 }
		If (	$NB_Failed   -eq  $null	)   { $NB_Failed  = 0 }
        If (	$NB_Runnning -eq  $null	)	{ $NB_Runnning= 0 }
		If (    $NB_Unresponsive -eq $null) { $NB_Unresponsive = 0 }			
		
		
		If (($NB_Failed -ne 0) -or ($NB_Unresponsive -ne 0))
			{
				$Alert_Type = "'alert alert-danger alert-dismissible'"
				$Alert_Title = "Oops !!!"		
				$Alert_Message = " There is an issue during one of your deployments"			
			}
			
		ElseIf (($NB_Failed -eq 0) -and ($NB_Success -ne 0) -and ($NB_Runnning -eq 0))
			{
				$Alert_Type = "'alert alert-success alert-dismissible'"
				$Alert_Title = "Congrats !!!"		
				$Alert_Message = " All your deployments have been completed with success"
			}	

		ElseIf (($NB_Failed -eq 0) -and ($NB_Success -eq 0) -and ($NB_Runnning -ne 0))
			{
				$Alert_Type = "'alert alert-info alert-dismissible'"
				$Alert_Title = "Info !!!"		
				$Alert_Message = " All your computers are currently being installed"
			}					
	}



$head = '
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="refresh" content="60">
  
  <link rel="stylesheet" href="JS/bootstrap4.1.3/css/bootstrap.min.css">
  <link rel="stylesheet" href="JS/DataTables-1.10.18/css/jquery.dataTables.min.css">
  
  <script src="JS/jquery-3.3.1.min.js"></script>
  <script src="JS/bootstrap4.1.3/JS/bootstrap.min.js"></script>
  <script src="JS/DataTables-1.10.18/js/jquery.dataTables.min.js"></script> 
  <title>MDT Deployment Status </title>'
  
$Title = "
<p align='center' > 
<a href='' alt='Click to refresh this page'> <img src='$LogoPath' height='100' width='auto'  alt='$PageMessage'  style='margin:20px 0px'/> </a>
<br>
<span class='text-primary font-weight-bold lead'>$PageMessage</span>
<br><span class=text-success font-italic>Last Updated on $Date</span></p>
"


$Badges = "

<div id='demo' class='show' align='center'>
<button type='button' class='btn btn-primary'>
	Running <span class='badge badge-light'>$NB_Runnning</span>
</button>
<button type='button' class='btn btn-success'>
	Success <span class='badge badge-light'>$NB_Success</span>
</button>
<button type='button' class='btn btn-danger'>
	Failed <span class='badge badge-light'>$NB_Failed</span>
</button>
<button type='button' class='btn btn-warning'>
	Unresponsive <span class='badge badge-light'>$NB_Unresponsive</span>
</button>
</div>

"

$Script = '
<script>

$("#myTable_filter").addClass("hidden"); // hidden search input
  $(document).ready( function () {
  var table = $("#myTable").DataTable({
    responsive: true,
  "bFilter": true, // show search input
     "order": [[ 0,"desc" ]],
	 "columnDefs" : [{"targets":0, "type":"date-eu"}],
     "pageLength": 25
     
  });
  
  $("#mySearchText").on( "keyup click", function () {
    table.search($(this).val()).draw();
  } );
} );

</script>

'
$Support = "<h6> For more details or assistance, contact: $EngineerName - <a href='mailto:$EmailSubject'>$SupportEmail</a></h6>"

$footer = "
<footer class='page-footer font-small blue'> <div class='footer-copyright text-center py-3'> $FooterPage </div> </footer>
</body>
"

$MyData = GetMDTData | Select Date, "Computer Name", "Percent Complete", "Step Name", Warnings, Errors, "Start time", "End Time", "Ellapsed time", "Step status", "Deployment Status" | Sort -Property Date |
ConvertTo-HTML `
-head $head -body "$title $Badges $Search <br> $MyData $Script $Support"	|

ForEach {
if($_ -like "*<td>Failed</td>*"){$_ -replace "<tr>", "<tr class=table-danger>"}
elseif($_ -like "*<td>Success</td>*"){$_ -replace "<tr>", "<tr class=table-success>"}
elseif($_ -like "*<td>Running</td>*"){$_ -replace "<tr>", "<tr class=table-primary>"}
elseif(($_ -like "*<td>Unresponsive</td>*") -or ($_ -like "*<td>Unknown</td>*")){$_ -replace "<tr>", "<tr class=table-warning>"}
else{$_}
} > $HTML_Deployment_List 

#add-content $HTML_Deployment_List $footer
	
$HTML = get-content $HTML_Deployment_List	
$HTML.replace("<table>","<table id=myTable class=table>").replace("<tr><th>Date",'<thead class="thead-dark"><tr><th>Date').replace('Deployment Status</th></tr>','Deployment Status</th></tr></thead><tbody id="myTable">').replace('</td></tr></table>','</td></tr></tbody></table>').replace("</body>", $footer) | out-file -encoding ASCII $HTML_Deployment_List
