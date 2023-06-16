$Caminho = "C:\TEMP\Get-ContentCustConfig"
$Computers = Get-Content "$Caminho\HOSTS.txt"

#$cont = 0
forEach ($comp in $Computers) {
    
        $varComputer = $comp
        #Write-Host "Executando script na máquina $comp"
        Set-Service WinRM -StartupType Manual -Status Running -ComputerName $varComputer
        Invoke-Command -ComputerName $varComputer {
        #$xstore = wmic product where "name='Xstore'" get version
        #$CustConfig = Get-ChildItem "C:\xstore\cust_config\version1\query\QueryConfig.xml" -ErrorAction Continue
        $computer = hostname
        If (Test-Path "C:\xstore\cust_config\version1\query\QueryConfig.xml")
        {
            $result = "True"
            
            Write-host "$computer, $result"
        } 
        Else 
        {
            $result = "False"
            Write-host "$computer, $result"
        }
       
    }
    
    #$cont = $cont + 1
    
}