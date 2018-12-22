<b>PowerShell Scripts - Explained</b>
<br><br>1) SvrGrping.ps1 - An example script of how to group servers based upon a .csv input. Potentially helpful in the event
of a company not using WSUS or ADDS for server grouping. 
<br><br>2) WinSvrSched.ps1 - Using variables from the SvrGrping.ps1 script, schedule an Azure Automation runbook job with a 
corresponding patch schedule for Windows Servers using the new PowerShell preview cmdlets 
(New-AzureRmAutomationSoftwareUpdateConfiguration).
<br><br>3) LinuxSvrSched.ps1 - Using variables from the SvrGrping.ps1 script, schedule an Azure Automation runbook job with a
corresponding patch schedule for Linux servers, using the new PowerShell preview cmdlets
(New-AzureRmAutomationSoftwareUpdateConfiguration).
