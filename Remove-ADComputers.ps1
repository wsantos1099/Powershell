Start-Transcript -Path "C:\temp\Remove-ADcomputer $(Get-Date -Format "MM-yyyy").log" -Append

$Computers = Get-ADComputer -filter {Enabled -eq "False"} -SearchBase "OU=Limpeza,DC=corp,DC=local" -Properties WhenChanged | Where {$_.WhenChanged -gt (Get-date).AddDays(30)} | Select-Object -ExpandProperty Name
$Computers | Export-Csv C:\Temp\RemovedDevices.csv -NoTypeInformation

#Remove Inactive Computers
ForEach ($Item in $Computers){
  Write-Host -ForegroundColor Yellow "Deleting Machine " $Item
  Get-ADComputer -Identity $Item | Remove-ADComputer -Confirm:$true
   
}

Stop-Transcript