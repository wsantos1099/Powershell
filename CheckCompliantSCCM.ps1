#Force Policies

#Force machine Policy
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}"

#Force Software Updates Scan
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000113}"
#Invoke-CimMethod -Namespace 'root\ccm' -ClassName 'SMS_Client' -MethodName 'TriggerSchedule' -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000113}'}

#Check the Log for missing updates
$logFilePath = "C:\Windows\CCM\Logs\UpdatesStore-20241216-160824.log"
$MissingUpdates = Get-Content -Path $logFilePath | Where-Object { $_ -like "*Status=Missing*" }

if ($MissingUpdates) {
    $true
} else {
    $false
}
