Invoke-CimMethod -Namespace 'root\ccm' -ClassName 'SMS_Client' -MethodName 'TriggerSchedule' -Arguments @{sScheduleID='{00000000-0000-0000-0000-000000000113}'}


$logFilePath = "C:\Windows\CCM\Logs\UpdatesStore.log"
$MissingUpdates = Get-Content -Path $logFilePath | Where-Object { $_ -like "*were loaded.*" }

if ($MissingUpdates) {
    $true
} else {
    $false
}
