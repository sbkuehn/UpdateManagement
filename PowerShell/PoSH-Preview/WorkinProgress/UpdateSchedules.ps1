$updateschedules = Get-AzureRmAutomationSoftwareUpdateConfiguration -ResourceGroupName sbk-oms -AutomationAccountName sbk-oms-automation-01
foreach ($updateschedule in $updateschedules)
{
    Write-Host $updateschedule.AzureVMResourceIds
}