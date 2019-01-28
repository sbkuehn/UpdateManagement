<#
Created 
2019.01.25
Shannon Kuehn
Last Updated

© 2018 Microsoft Corporation. 
All rights reserved. Sample scripts/code provided herein are not supported under any Microsoft standard support program or service. 
The sample scripts/code are provided AS IS without warranty of any kind. Microsoft disclaims all implied warranties including, without 
limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use 
or performance of the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, or anyone else 
involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, 
damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the 
use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages.
#>

#Required parameters to run on a schedule.
param(
[Parameter(Mandatory=$true)]
[string]$savedSearch,
[Parameter(Mandatory = $true)]
[string]$workspaceName,
[Parameter(Mandatory = $true)]
[string]$softwareName,
[Parameter(Mandatory = $true)]
[string]$installSource,
[Parameter(Mandatory = $true)]
[string]$installTemp,
[Parameter(Mandatory = $true)]
[string]$installCommand
)

#Specify the Azure Automation connection. This seems like an old ASM command, but it is accurate.
#
$Conn = Get-AutomationConnection -Name sbkhybrbwrk
Connect-AzureRmAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

#Required Parameters to test with AzureAutomationAuthoringToolkit.
$softwareName = "Java 8 Update 201"
$installSource = "\\server\AppPatching\Java\"
$installTemp = "C:\Installers\Java\"
$installCommand = "C:\Installers\Java\jre-8u202-windows-x64.exe /s" 
$workspaceName = "sbk-log-analytics-49950"
$rG = "sbk-oms"
$savedSearch = 'ConfigurationData | where ConfigDataType == "Software" | where SoftwareName=="Java 8 Update 201" | distinct Computer'

#Azure Automation Runbook script.
$query = Get-AzureRmOperationalInsightsSearchResults -ResourceGroupName $rG -WorkspaceName $workspaceName -query $savedsearch
$query.Value | ConvertFrom-Json | Select Computer
$computers = $query.Value | ConvertFrom-Json | Select Computer
foreach ($computer in $computers)
{

   if ($computer -like $env:COMPUTERNAME)
   { 
        Copy-Item -Path $installsource -Destination $installtemp -Recurse -Force
        Invoke-Expression $installcommand
        Remove-Item $installtemp -Recurse -Force
        break
   }
}
