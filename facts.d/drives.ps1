$psDrives = Get-PSDrive -PSProvider 'FileSystem' | Select-Object * -ExcludeProperty Provider,Credential,CurrentLocation

$outDrives = @{}
foreach ($drive in $psDrives) {
  $outDrives.add($drive.name,$drive)
}

@{"drives" = $outDrives} | ConvertTo-Json -Depth 999 -Compress