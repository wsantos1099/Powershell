$Caminho = "C:\TEMP\Remove-RegistryKey"
$Computers = Get-Content "$Caminho\HOSTS.txt"

$cont = 0
forEach ($comp in $Computers) {
    
        $varComputer = $comp
        Write-Host "Executando script na máquina $comp"
        Set-Service WinRM -StartupType Manual -Status Running -ComputerName $varComputer
        Invoke-Command -ComputerName $varComputer {
        $guid = '{3B699CFFD171C3F458FA3C5DA49D1D1D}'
        #Get-ChildItem -Path HKLM:\SOFTWARE -Recurse | Where-Object { $_.PSChildName -match $guid } | Remove-Item -Recurse -Force
        Get-Item -Path HKLM:\SOFTWARE\Classes\Installer\Products\3B699CFFD171C3F458FA3C5DA49D1D1D | Remove-item -Recurse -Force
       
    }
    $cont = $cont + 1
    Write-Host "Finalizado em $cont de " $Computers.Length
}