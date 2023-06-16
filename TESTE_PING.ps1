#VALIDA HOSTS QUE RESPONDEM AO PING

$Caminho = ".\"
$Computers = Get-Content ".\HOSTS.txt"

$cont = 1
 
forEach ($comp in $Computers) {
    $total = $Computers.Length
   if (Test-Connection -ComputerName $comp -Count 1 -Quiet) {
      $comp | Out-File -FilePath $Caminho\ONLINE.txt -Append
      Write-Host "$comp`tONLINE" -ForegroundColor Green
   }
   else{
      $comp | Out-File -FilePath $Caminho\OFFLINE.txt -Append
      Write-Host "$comp`tOFFLINE" -ForegroundColor Red
   }

   Write-Output "PING $cont de $total" 
   $cont = $cont + 1
}

#VALIDA DNS DOS HOSTS ONLINE

$Caminho = ".\"
$Computers = Get-Content "$Caminho\ONLINE.txt"

$cont = 1

forEach ($comp in $Computers){
    
    $total = $Computers.Length

    $varComputer = $comp + ".lojas.brasil.latam.cea"

    $varIP=[system.net.dns]::GetHostbyname($varComputer) |Select-Object -ExpandProperty addresslist|Select-Object -ExpandProperty ipaddresstostring #RESOLVE O IP
    $varCheckName=[system.net.dns]::GetHostentry($varIP) |Select-Object -ExpandProperty hostname #RESOLVE O NOME

    if ($varComputer -eq $varCheckName){
        $comp | Out-File -FilePath $Caminho\DNS_OK.txt -Append
        Write-Host "$comp`tDNS_OK" -ForegroundColor Green
    }
    Else{
        $comp | Out-File -FilePath $Caminho\DNS_NOK.txt -Append
        Write-Host "$comp`tDNS_NOK" -ForegroundColor Red
    }  

    Write-Output "PING $cont de $total" 
   $cont = $cont + 1

}




$Computers = Get-Content -Path .\DNS_OK.txt

ForEach ($comp in $Computers){

    Set-Service WinRM -StartupType Manual -Status Running -ComputerName $comp
    invoke-command -ComputerName $comp {Get-EventLog -LogName System -After (Get-Date).AddHours(-8) | where {$_.InstanceId -eq 7001} | Select-Object PSComputerName, InstanceID, TimeGenerated, Source} |Format-Table -AutoSize -ErrorAction Ignore


}
