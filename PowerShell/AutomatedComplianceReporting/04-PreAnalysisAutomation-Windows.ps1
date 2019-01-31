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

#Required parameters.
param(
[Parameter(Mandatory=$true)]
[string]$subscriptionId,
[Parameter(Mandatory=$true)]
[array]$rG,
[Parameter(Mandatory=$true)]
[string]$workspaceName
)

#Generate bearer token and use token + header for the API call. Ensure the header has more information to grab the records.
$bearer = Get-AzureRmCachedAccessToken
$header = @{"Authorization"="Bearer $bearer";"Content-Type"="application/json";"Prefer"="response-v1=true"}
$apiCall = "https://management.azure.com/subscriptions/"+$subscriptionId+"/resourceGroups/"+$rG+"/providers/Microsoft.OperationalInsights/workspaces/"+$workspaceName+"/api/query?api-version=2017-01-01-preview"
$body = @"
    {"query": "Update | where TimeGenerated>ago(30d) and OSType!='Linux' and (Optional==false or Classification has 'Critical' or Classification has 'Security') and SourceComputerId in ((Heartbeat | where TimeGenerated>ago(30d) and OSType=~'Windows' and notempty(Computer) | summarize arg_max(TimeGenerated, Solutions) by SourceComputerId | where Solutions has 'updates' | distinct SourceComputerId)) | summarize hint.strategy=partitioned arg_max(TimeGenerated, *) by Computer, SourceComputerId, UpdateID | where UpdateState=~'Needed' and Approved!=false | project Computer , TimeGenerated , PublishedDate , KBID , Product , Title , UpdateState , Optional , RebootBehavior | sort by Computer asc , PublishedDate"}
"@

#Run the script, which extracts columns and rows as objects, then adds them to a data table, which can be extracted as a csv.
$response = Invoke-WebRequest -Uri $apiCall -Headers $header -Method Post -Body $body
$jsonResponses = $response.Content | ConvertFrom-Json 
$ScriptBlock = .{
$tableObj = New-Object System.Data.DataTable "Post-Analysis"
$jsonResponse.tables.columns | ForEach {
    $newcol = New-Object System.Data.DataColumn
    $newcol.ColumnName=$_.Name
    $newcol.DataType=$_.Type 
    $tableObj.Columns.Add($newcol)
}

$jsonResponse.tables.rows | ForEach {
    $tableObj.Rows.Add($_)
}

$tableObj | Export-Csv C:\users\skuehn\PreAnalysisWindows.csv -NTI
}
