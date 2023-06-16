$Caminho = "C:\TEMP\Valida_patch"
$remoteMachines  = Get-Content "$Caminho\HOSTS.txt"

# Define the folder path to validate
$folderPath = "c:\environment\download\tmp"

# Create an empty array to store the results
$results = @()

# Loop through each remote machine
foreach ($machine in $remoteMachines) {
    # Create a new PS session to the remote machine
    Set-Service WinRM -StartupType Manual -Status Running -ComputerName $machine
    $session = New-PSSession -ComputerName $machine

    Write-Host "Verificando a Maquina $machine" -nonewline -ForegroundColor Yellow

    # Check if the folder exists on the remote machine
    $folderExists = Invoke-Command -Session $session -ScriptBlock {
        param($folderPath)
        Test-Path -Path $folderPath -ErrorAction SilentlyContinue
    } -ArgumentList $folderPath

    # Close the PS session

    Write-host " - $folderExists" -ForegroundColor Green

    Remove-PSSession -Session $session

    # Create a custom object with the machine name and folder existence status
    $result = [PSCustomObject]@{
        Maquina = $machine
        PastaExiste = $folderExists
    }

    # Add the result to the array
    $results += $result
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\TEMP\Valida_patch\FolderValidationResults.csv" -NoTypeInformation

# Display a message indicating the completion of the script
Write-Host "Folder validation completed. Results saved to FolderValidationResults.csv."


<#
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
#>