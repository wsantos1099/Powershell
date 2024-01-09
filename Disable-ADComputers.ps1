Start-Transcript -Path "C:\temp\Disable-ADDevices $(Get-Date -Format "dd-MM-yyyy-HHmm").log" -Append

$DaysInactive = 365
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))

$Computers = Get-ADComputer -Filter { LastLogonDate -lt $InactiveDate -and Enabled -eq $true } -SearchBase "OU=Workstations,OU=Corp.local,DC=corp,DC=local" -Properties LastLogonDate | Select-Object -ExpandProperty Name 
$Computers | Export-Csv C:\Temp\DisabledComputers-$(Get-Date -Format "dd-MM-yyyy-HHmm").csv -NoTypeInformation -Append

# Disable Inactive Computers
ForEach ($Item in $Computers){
  Write-Host -ForegroundColor Yellow "Disabling Machine " $Item
  Get-ADComputer -Identity $Item | Disable-ADAccount
   
  Write-Host -ForegroundColor Yellow "Moving Machine $Item to OU=Limpeza,DC=corp,DC=local"
  Get-ADComputer -Identity $Item | Move-ADObject -TargetPath "OU=Limpeza,DC=corp,DC=local"
 
}

Stop-Transcript