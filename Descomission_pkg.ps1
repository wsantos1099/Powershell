$Paths = Get-Content ".\Paths.txt"
$destination = "\\ceawsccm12casp1\sources$\Packages\SCRIPTS\_old"

forEach ($path in $paths) {   

    write-host "Moving $path to $destination"
    Move-item  $path $destination
           
    }
    
}