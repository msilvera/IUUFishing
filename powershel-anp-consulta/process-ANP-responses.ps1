#List all directories in path


$initial_path = 'C:\Users\Mariana\CODE\iuu-fishing-occ\powershel-anp-consulta\resultados'
$pathToOutputFile = $initial_path + '\' +  "BrokenFiles.csv"
$pathToOutputVesselsFile = $initial_path + '\' +  "ListOfVessels.csv"

$folders = Get-ChildItem -Path $initial_path  –Directory

$folders.Count



For ($i=0; $i -le ($folders.Count-1); $i++) {

    $next_folder = $folders.Item($i) | Select-Object -ExpandProperty  "Name"

    $next_folder = $initial_path + '\'+ $next_folder

    
    #$init_file = Get-ChildItem -Path $next_folder  –File 'ANP*.html'
    #$init_file
    #$list = Get-Content -Path ($next_folder + '\' + $init_file)

    $detail_files = Get-ChildItem -Path $next_folder  –File 'datos*.html'
    
    $array = @() #empty array
    $array2 = @() #empty array
   [System.Collections.ArrayList] $Broken_files= $array
   [System.Collections.ArrayList] $ListOfVessels= $array2

   foreach ($detail_file in $detail_files) {
   
       $file_content = Get-Content -Path ($next_folder + '\' + $detail_file)

       $data =''
       $fecha = $detail_file.Name.Substring(62,8)

       foreach($line in $file_content){
       
           if ($line.IndexOf('NOMBRE:') -ne -1) 
           {
            $data = $line

            break

           }
       
       }
        
    
    if ($data -ne '' ) 
    {
        
            $indx= $data.IndexOf('NOMBRE:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('</b>',$indx)
            $name = $data.Substring($start_indx,($end_indx -$start_indx))
           # 'NOMBRE: ' + $name

            $indx= $data.IndexOf('BANDERA:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('</b>',$indx)
            $bandera = $data.Substring($start_indx,($end_indx -$start_indx))
            #'BANDERA: ' + $bandera

            $item = $fecha  + ',' + $name + ',' + $bandera
            #$item 
            $ListOfVessels.Add($item.ToString());
 
    }
   else{
    #broken file?

    $Broken_files.Add($detail_file);
   }
   
   }
    $Broken_files | ConvertTo-Csv -NoTypeInformation | Add-Content $pathToOutputFile
    $ListOfVessels | Add-Content $pathToOutputVesselsFile

}