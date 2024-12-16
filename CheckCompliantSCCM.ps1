#Log to Verify
$logFilePath = "C:\Windows\CCM\Logs\UpdatesStore.log"
#Force Policies

#Force machine Policy
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}" | out-null
Write-Host "Waiting for policies to been applied.." -ForegroundColor Yellow -NoNewline
timeout 15 | Out-Null
Write-Host " - Done!" -ForegroundColor Green

#Force Software Updates Scan
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000113}" | Out-Null #Software Update Scan Cycle
timeout 5 | Out-Null
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000114}" | Out-Null #Software updates Deployment Evaluation Cycle
timeout 5 | Out-Null
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000108}" | Out-Null #Software Updates Assignments Evaluation Cycle
timeout 5 | Out-Null



#Invoke-CimMethod -Namespace 'root\ccm' -ClassName 'SMS_Client' -MethodName 'TriggerSchedule' -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000113}'}
Write-Host "Waiting for Software Updates Scan" -ForegroundColor Yellow -NoNewline
timeout 15 | Out-Null
Write-Host " - Done!" -ForegroundColor Green


#Check the Log for missing updates

$MissingUpdates = Get-Content -Path $logFilePath | Where-Object { $_ -like "*Status=Missing*" }

if ($MissingUpdates) {
    
    Write-Host "Server $env:COMPUTERNAME is not Compliant" -ForegroundColor red
} else {
    
    Write-Host "Server $env:COMPUTERNAME is Compliant" -ForegroundColor Green
}
