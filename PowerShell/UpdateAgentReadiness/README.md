<b>UpdateAgentReadiness</b>
<br><br>1) Run the 01-BearerToken.ps1 while logged into Azure PowerShell with an active account and pointed at the working sub.
<br>2) The 01-BearerToken.ps1 loads the actual Bearer Token into memory. This gets called upon in the UpdateAgentReadiness.ps1
script by way of using Get-AzureRmCachedAccessToken.
<br>3) The 02-UpdateAgentReadiness.ps1 script will output all servers checked into Update Management inside 1 .csv file. Having
this information will be helpful if grouping servers within a patch group. If the server reports as "Not configured" or 
"Disconnected," the patching fails.
