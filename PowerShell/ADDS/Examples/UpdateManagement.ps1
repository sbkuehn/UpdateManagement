$recently = [DateTime]::Today.AddDays(-30)
$servers = Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties whenCreated | Format-Table Name -Autosize -Wrap
ForEach($server in $servers){
Invoke-Command


$recently = [DateTime]::Today.AddDays(-30)
Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties whenCreated | Format-Table Name,whenCreated,distinguishedName -Autosize -Wrap

$patchSchedule = Get-Content -Raw -Path "c:\mstar-metadata\base.json" | ConvertFrom-Json | Select patch_schedule