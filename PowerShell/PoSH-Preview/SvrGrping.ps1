$scriptBlock = .{
$serverinfo = Get-Content -Path "C:\temp\servergrouping.csv" | ConvertFrom-Csv
$query = "Heartbeat | summarize arg_max(TimeGenerated, *) by SourceComputerId | top 500000 by Computer asc"
$queryResults = Invoke-AzureRmOperationalInsightsQuery -WorkspaceId "{log analytics workspace Id}" -Query $query
$queryResults.Results
$servers = $queryResults.Results | Select-Object -ExpandProperty Computer
}
$group1 = @()
$group2 = @()
$group3 = @()

ForEach($server in $serverinfo) 
{
        Switch ($server.patchSchedule){
            'patch_schedule01' {
                $new1 = $servers | ? {$_ -eq $server.servername} | Select-Object -First 1
                $group1+=$new1
            }
            'patch_schedule02' {
                $new2 = $servers | ? {$_ -eq $server.servername} | Select-Object -First 1
                $group2+=$new2
            }
            'patch_schedule03' {
                $new3 = $servers | ? {$_ -eq $server.servername} | Select-Object -First 1
                $group3+=$new3
            }
        }
}
