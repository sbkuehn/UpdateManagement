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

$subscriptionId = "9c29eddd-8897-46b5-b8ca-503e7ba5b463"
$rG = "sbk-oms"
$workspaceName = "sbk-log-analytics-49950"
$bearer = Get-AzureRmCachedAccessToken
$header = @{"Authorization"="Bearer $bearer";"Content-Type"="application/json";"Prefer"="response-v1=true"}
$apiCall = "https://management.azure.com/subscriptions/"+$subscriptionId+"/resourceGroups/"+$rG+"/providers/Microsoft.OperationalInsights/workspaces/"+$workspaceName+"/api/query?api-version=2017-01-01-preview"
$body = @"
    {"query": "UpdateRunProgress | where InstallationStatus == 'Succeeded' | where TimeGenerated > now(-30d) | project Computer , TimeGenerated , SourceComputerId , InstallationStatus , Product , Title , KBID ,  UpdateId , ErrorResult , UpdateRunName | take 100 | sort by Computer asc"}
"@

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

$tableObj | Export-Csv C:\users\skuehn\PostAnalysis.csv -NTI
}