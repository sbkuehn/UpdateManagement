## Initial Security Group Assignment                                                                    #
#########################################################################################################
## 
## Script performs the following tasks:
## 1) Imports ActiveDirectory PoSH module.
## 2) Stores all AD DS computers as a variable to loop through.
## 3) Loops through each recently created server to determine if a metadata json file is on the server. 
## 4) If server has a json file saved, server name will be stored as a variable.
## 5) Loops through server name and extracts SamAccountName. SamAccountName is necessary for AD Security 
## Group assignment.
## 6) Formulates a patch schedule based upon json file for each server.
## Notes: 
##  a. Run on server with AD DS role installed or on a server with RSAT tools.
##  b. Test permissions to run (best with a service account): requires permissions to query server 
##  objects in AD DS and ability to assign servers to Security Groups.
#########################################################################################################

Import-Module ActiveDirectory
$servers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
ForEach($server in $servers){
    $path = Test-Path "\\$server\C$\mstar-metadata\base.json" 
        If($path -eq $true){
        $patchSchedule = Get-Content -Raw -Path "\\$server\c$\mstar-metadata\base.json" | ConvertFrom-Json | Select-Object -ExpandProperty patch_schedule
        $SAMAccountName = Get-ADComputer -Identity $server | Select-Object -ExpandProperty SamAccountName
        $patchScheduleName = ""  
        Switch ($patchSchedule){
            '01'{$patchScheduleName = "patch_schedule_01"}
            '02'{$patchScheduleName = "patch_schedule_02"}
            '03'{$patchScheduleName = "patch_schedule_03"}
            '04'{$patchScheduleName = "patch_schedule_04"}
             }
        Add-ADGroupMember -Identity $patchScheduleName -Members $SAMAccountName       
        }
        }