Start-Transcript -Path C:\Windows\Temp\Xstore_Copyfile_AZ-151406.log #Arquivo de Log


$version = "4.4.0.21"

Function Get-XstoreVersion ($version) {
        #Verifica Versao do Xstore
        
        $product = gwmi win32_product -filter "Name LIKE '%Xstore%'"
        write-host "versao: " $product.version
        
        write-host "Verificando aplicabilidade do patch"
        Try {
                If ($product.version -eq $version) {
                        Write-Host "Versao corresponde, Sera aplicado o Patch"
        
                }
                Else {
                        Write-Host "Versao nao corresponde, saindo do Script e o Patch nao sera aplicado"
                        exit 10
                }

        } Catch {
                throw $_.exception.message
        }
}

Function Stop-Xstore {
    
    taskkill  /F /IM xstore.exe
    Write-Host "Parando servição Xstore"

    Write-Host "Removendo arquivos .ANCHOR da pasta c:\xstore\tmp\"
    Remove-Item -Path c:\xstore\tmp\*.anchor -Force

    Write-Host " Removendo arquivos .ANCHOR da pasta C:\environment\tmp\"
    Remove-Item -Path C:\environment\tmp\*.anchor -Force
}

Get-XstoreVersion $version


#COPIA Da Cust_config.xml
    $Folder = 'C:\xstore\cust_config' #VALIDA SE A PASTA EXISTE
    Write-Host "Valida se a pasta [$Folder] existe"
    if (Test-Path -Path $Folder) {
        Write-Host " Pasta cust_config ja existe"
        remove-Item 'C:\xstore\cust_config' -force -Recurse
        Copy-Item -Path .\cust_config -Destination C:\xstore -Force -Recurse # EXECUTA A COPIA DO ARQUIVO

        Start-Sleep 15
      
    } else {
        Write-Host "Pasta nao existe"
        New-Item $Folder -ItemType Directory # CRIAR PASTA CASO NÃO EXISTA"
        Write-Host " Pasta criada com sucesso"
        Copy-Item -Path .\cust_config -Destination C:\xstore -Force -Recurse # EXECUTA A COPIA DO ARQUIVO
        Start-Sleep 15
    }
    
Stop-Transcript