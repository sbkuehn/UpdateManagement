# Update Management

Sample Code and Documentation to Assist Deployment and Management of On-Premises Servers

<b><u>Microsoft Documentation</u>:</b>
<br><a href="https://docs.microsoft.com/en-us/powershell/module/azurerm.automation/new-azurermautomationschedule?view=azurermps-6.13.0">Azure Rm Automation Schedule</a>
<br><a href="https://docs.microsoft.com/en-us/powershell/module/azurerm.automation/new-azurermautomationsoftwareupdateconfiguration?view=azurermps-6.13.0">Azure Rm Automation Software Update Configuration</a>
<br><br><b><u>Troubleshooting</u>:</b><br>1) Ensure Azure RM PowerShell module is completely up to date.<br>2) <a href="https://www.youtube.com/watch?v=6fhvYSgQRwg">Troubleshoot Update Agent Readiness: Not Configured</a>
<br><br>
<b><u>Update Agent Readiness - Explained</b></u>
<br>In the portal, the Update Agent Readiness column’s data is lazy-loaded. Azure checks readiness of every machine individually using the following REST API: https://docs.microsoft.com/en-us/rest/api/automation/hybridrunbookworkergroup/get
The readiness metric is solely about checking that the patch agent (System HybridWorker) is registered and actively pinging.
<br><br><b>Update Agent Readiness - GET Calls</b>
<br>1) <i>Not Configured</i> - the GET call resolves with 404.
<br>2) <i>Disconnected</i> - The GET call resolves to 200, but the lastSeen property value, which denotes ping time, is older than an hour ago.
<br>3) <i>Ready</i> - The GET call resolves to 200 and the lastSeen property is less than an hour ago.
If the GET call resolves to 200, but lastSeen property value (denotes the ping time) is older than an hour ago – we call it 
<br><br><b><u>Kusto Queries - Known Limitations</u>:</b>
<br>1) CVE Numbers are only listed for Linux within the underlying database engine for Kusto, except not every Linux server contains a CVE Number.
<br>2) TimeGenerated refers to when the scheduled job started. There is currently no way to capture the time a patch applied. 
