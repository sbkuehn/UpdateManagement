## Script performs the following tasks:
## 1) Imports ActiveDirectory PoSH module.
## 2) Stores recent date as a variable to loop through and query servers.
## 3) Stores a list of recently created servers.
## 4) Loops through each recently created server to determine if a metadata json file is on the server. 
## 5) If server has a json file saved, server name will be stored as a variable.
## 6) Loops through server name and extracts SamAccountName. SamAccountName is necessary for AD Security Group assignment.
## 7) Formulates a patch schedule based upon json file for each server.
## Note permissions, Run on a machine with RSAT

Import-Module ActiveDirectory
$recently = [DateTime]::Today.AddDays(-180)
$servers = Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties whenCreated | Select-Object -ExpandProperty Name
$ADservers = ForEach($server in $servers){
    $path = Test-Path "\\$server\C$\mstar-metadata\base.json" 
        If($path -eq $true){
        $patchSchedule = Get-Content -Raw -Path "\\$server\c$\mstar-metadata\base.json" | ConvertFrom-Json | Select-Object -ExpandProperty patch_schedule
        $SAMAccountName = Get-ADComputer -Identity $server | Select-Object -ExpandProperty SamAccountName
        $patchScheduleName = ""  
        Switch ($patchSchedule){
            '01' {
                $patchScheduleName = "patch_schedule_01"
            }
            '02'{$patchScheduleName = "patch_schedule_02"}
            '03'{$patchScheduleName = "patch_schedule_03"}
            '04'{$patchScheduleName = "patch_schedule_04"}
             }
        Add-ADGroupMember -Identity $patchScheduleName -Members $SAMAccountName       
        }
        }