Start-Transcript -Path C:\Windows\Temp\Xstore_Copyfile_Selfchekout_v083.log #Arquivo de Log

$Backup = 'C:\BACKUPxstore'

taskkill  /F /IM xstore.exe
taskkill  /F /IM selfcheckout_gui.exe
Write-Host "Parando servição Xstore"

Write-Host "Removendo arquivos .ANCHOR da pasta c:\xstore\tmp\"
Remove-Item -Path c:\xstore\tmp\*.anchor -Force

Write-Host " Removendo arquivos .ANCHOR da pasta C:\environment\tmp\"
Remove-Item -Path C:\environment\tmp\*.anchor -Force

#If the file does not exist, create it.
if (-not(Test-Path -Path $Backup)) {
     try {
        Write-Host "Pasta BackupXtore nao existe"
        New-item -itemtype directory -path $Backup -ErrorAction Continue

             }
     catch {
         throw $_.Exception.Message
     }
 }

 else {
     Write-Host " Remove selfcheckout.zip "
     Remove-Item C:\BACKUPxstore\selfcheckout.zip -Force -ErrorAction Continue
       
 }
   
    Write-Host " Compacta pasta selfcheckout "
    Compress-Archive C:\selfcheckout -DestinationPath C:\BACKUPxstore\selfcheckout.zip
    
    Write-Host " Exclui a pasta selfcheckout antiga"
    Remove-item C:\selfcheckout -Recurse

    Write-Host " Copia pasta selfcheckout "
    Expand-Archive -Path .\selfcheckout.zip -Destination C:\ -Force

Stop-Transcript

Restart-Computer -force
