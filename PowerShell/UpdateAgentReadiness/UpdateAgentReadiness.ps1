$path = "{local file path}"
$subId = "{subscription ID}"
$rg = "{resource group}"
$automationAccount = "{automation account}"
$bearer = Get-AzureRmCachedAccessToken
$header = @{"Authorization"="Bearer $bearer"}
$hybridWorkerGroups = Get-AzureRmAutomationHybridWorkerGroup -ResourceGroupName $rg -AutomationAccountName $automationAccount
$csv = "MachineName,State,LastSeenTime`r`n"
$file = New-Object -ComObject Scripting.FileSystemObject
$csvFile = $file.CreateTextFile($path,$true)
$csvFile.Write($csv)
$csvFile.Close()

ForEach($hybridworkerGroup in $hybridWorkerGroups){
    $apiCall = "https://management.azure.com/subscriptions/"+$subId+"/resourceGroups/"+$rg+"/providers/Microsoft.Automation/automationAccounts/"+$automationAccount+"/hybridRunbookWorkerGroups/"+$hybridWorkerGroup.Name+"?api-version=2015-10-31"
    $invokeStatus = (Invoke-WebRequest -Uri $apiCall -Headers $header -Method Get)
    $state = ""
    $lastSeenTime = ""
    if($invokeStatus.StatusCode -eq 200)
    {
        $invokeVar = Invoke-RestMethod -Uri $apiCall -Headers $header -Method Get
        $lastSeenDate = Get-Date -Date $invokeVar.hybridRunbookWorkers[0].lastSeenDateTime
        $diffTimeSpan = (Get-Date) - $lastSeenDate
        if($diffTimeSpan.Hours -gt 1)
        {
            $state = "disconnected" 
        }
        else {
            $state = "ready"
        }    
    }
    elseif($invokeStatus.StatusCode -eq 404)
    {
            $state = "not configured"
    }
    else
    {
        $state = "error"    
    }
    $lastSeenTime = $hybridworkerGroup.RunbookWorker.LastSeenDateTime.LocalDateTime.ToShortDateString()+ " " + $hybridworkerGroup.RunbookWorker.LastSeenDateTime.LocalDateTime.ToLongTimeString()
    Add-Content $path "$($hybridworkerGroup.RunbookWorker.Name),$state,$lastSeenTime"            
}