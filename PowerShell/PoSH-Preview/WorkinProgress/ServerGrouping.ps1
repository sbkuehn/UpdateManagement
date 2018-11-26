$startTime = [DateTimeOffset]"2018-11-22T21:00"
 
#Group all target machines
$duration = New-TimeSpan -Hours 2
$schedule = New-AzureRmAutomationSchedule -ResourceGroupName "sbk-oms" `
                                                      -AutomationAccountName "sbk-oms-automation-01" `
                                                      -Name MyWeeklySchedule `
                                                      -StartTime $startTime `
                                                      -DaysOfWeek Saturday `
                                                      -WeekInterval 1 `
                                                      -ForUpdateConfiguration
 
    New-AzureRmAutomationSoftwareUpdateConfiguration -ResourceGroupName "sbk-oms" `
                                                     -AutomationAccountName "sbk-oms-automation-01" `
                                                     -Schedule $schedule `
                                                     -Windows `
                                                     -NonAzureComputer $group1 `
                                                     -IncludedUpdateClassifications Critical `
                                                     -Duration $duration