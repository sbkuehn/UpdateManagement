<b><u>Automated Compliance Reporting</b></u>
<br>
1) Run the 01-BearerToken.ps1 while logged into Azure PowerShell with an active account pointed at the working sub. 
2) The 01-BearerToken.ps1 loads the actual Bearer Token into memory. This gets called upon in the each of the automation scripts script by way of using Get-AzureRmCachedAccessToken. The bearer token allows the logged in user to hit the API directly to query information. 
3) Each script will run a Log Analytics query against the Update Management environment, whether it be for pre-analysis or post analysis. 
4) In addition, the output of each script will export to a csv file that can be used for regulatory records of patch compliance.
