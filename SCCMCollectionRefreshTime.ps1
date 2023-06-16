Start-Transcript "C:\temp\SCCMCollections_$(get-date -format "dd-MM-yyyy_hhmm").log"
$Collections = Get-Content "C:\TEMP\SCCMCollectionRefreshTime\Collections.txt"

ForEach ($Collection in $Collections) {
	Write-host "Setting Collection $Collection as Periodic"
	Get-CMCollection -Name "$Collection" | Set-CMCollection -RefreshType Periodic
}
Stop-Transcript
