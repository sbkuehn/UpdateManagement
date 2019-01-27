<#
Created 
2019.01.25
Shannon Kuehn
Last Updated

© 2019 Microsoft Corporation. 
All rights reserved. Sample scripts/code provided herein are not supported under any Microsoft standard support program 
or service. The sample scripts/code are provided AS IS without warranty of any kind. Microsoft disclaims all implied 
warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event 
shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for 
any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of 
business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or 
documentation, even if Microsoft has been advised of the possibility of such damages.
#>

#Required parameters to run on a schedule.
param(
[Parameter(Mandatory=$true)]
[string]$query = 'Heartbeat | where OSType == "Windows" | distinct Computer',
[Parameter(Mandatory = $true)]
[string]$workspaceId = "{Log Analytics Workspace Id}",
[Parameter(Mandatory = $true)]
[string]$KB = '{KBs to Uninstall}'
)

$RunAsConnection = Get-AutomationConnection -Name sbkhybrbwrk
Connect-AzureRmAccount -CertificateThumbprint $RunAsConnection.CertificateThumbprint `
-ApplicationId $RunAsConnection.ApplicationID -Tenant $RunAsConnection.TenantID -ServicePrincipal
Set-AzureRmContext -SubscriptionId $RunAsConnection.SubscriptionID

#Variables to test automation runbook, either in the portal or via the AzureAutomationAuthoringToolkit.
$workspaceId = "{Log Analytics Workspace Id}"
$KB = '{KB to Uninstall}'
$query = 'Heartbeat | where OSType == "Windows" | distinct Computer'
$queryResults = Invoke-AzureRmOperationalInsightsQuery -WorkspaceId $workspaceId -Query $query
$computers = $queryResults.Results | Select-Object -ExpandProperty Computer
foreach ($computer in $computers)
    {
        Invoke-Command -ComputerName $computer -ScriptBlock {C:\Windows\System32\wusa.exe /kb:$KB /uninstall /quiet /norestart} -Verbose
    }
