$Caminho = "C:\Temp\TESTE_PING"
$Computers = Get-Content "$Caminho\HOSTS.txt"

$cont = 0
forEach ($comp in $Computers) {
    
        $varComputer = $comp
        Write-Host "Executando script na máquina $comp"
        Set-Service WinRM -StartupType Manual -Status Running -ComputerName $varComputer
        Invoke-Command -ComputerName $varComputer {
        Disable-NetAdapter -Name Ethernet* -Confirm:$false
        Start-Sleep -Seconds 10
        Enable-NetAdapter -Name Ethernet -Confirm:$false
       
    }
    $cont = $cont + 1
    Write-Host "Finalizado em $cont de " $Computers.Length
}