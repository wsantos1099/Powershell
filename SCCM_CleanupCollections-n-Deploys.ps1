
#Remove Deploy in All SCCM Collections (Excluding Builtin Collections Like All Systems)
$Collections = Get-CMCollection | Select-Object name, isbuiltin | Where-Object -FilterScript {$_.isbuiltin -eq $false}

ForEach($Collection in $Collections) {

    Write-Host "Removing All Deployments in Collection: $collection"
    Get-CMDeployment -CollectionName "$Collection" | Remove-CMDeployment -Force

}

#Remove Collection Without any members (Excluding Builtin Collections Like All Systems)
$Collections2 = Get-CMCollection  | Where-Object -FilterScript {$_.isbuiltin -eq $false -and $_.Membercount -eq 0}
ForEach($item in $Collections2) {
 
    Write-Host "Removing Collection: $($item.name)"
    Get-CMCollection -name $($item.name) | Remove-CMCollection -Force
   
}