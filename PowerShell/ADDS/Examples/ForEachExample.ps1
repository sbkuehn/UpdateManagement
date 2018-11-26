$hostnames = Get-Content "mstar-metadata\base.json"
$searchtext = "imaging completed"

foreach ($hostname in $hostnames)
{
    $file = "\\$hostname\C$\GhostImage.log"

    if (Test-Path $file)
    {
        if (Get-Content $file | Select-String $searchtext -quiet)
        {
            Write-Host "$hostname: Imaging Completed"
        }
        else
        {
            Write-Host "$hostname: Imaging not completed"
        }
    }
    else
    {
        Write-Host "$hostname: canot read file: $file"
    }
}