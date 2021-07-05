
function isVesselBlacklisted {
param ($name)

#CSV Headers cannot be duplicated
$iuu_file_path = 'C:\Users\msilvera\Documents\CODE\iuu-fishing-occ\IUUFishing\powershel-anp-consulta\IUUList-20210704.csv'

$iuu_list = import-csv -path $iuu_file_path 
$find = $iuu_list | select-string $name

if ($find -eq $null){ 

    $find = "NOT FOUND"
}

 Write-Output $find

}
function processLine_BUQUE {

    param (
        $data
    )

   
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

            $indx= $data.IndexOf('TIPO de BUQUE:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('</b>',$indx)
            $tipo = $data.Substring($start_indx,($end_indx -$start_indx))
            
            $indx= $data.IndexOf('SEÑAL DISTINTIVA:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('</b>',$indx)
            $sign = $data.Substring($start_indx,($end_indx -$start_indx))
            
            $indx= $data.IndexOf('AGENCIA MARITIMA:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('<b>',$start_indx)
            $agencia = $data.Substring($start_indx,($end_indx -$start_indx))
            
            $indx= $data.IndexOf('PLANTA FRIGORIFICA DE AMONIACO:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('<b>',$start_indx)
            $planta = $data.Substring($start_indx,($end_indx -$start_indx)) -replace '&nbsp;',''

            $indx= $data.IndexOf('CALADO MÁXIMO DEL BUQUE:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('<b>',$start_indx)
            $calado = $data.Substring($start_indx,($end_indx -$start_indx))-replace ',','.'

            
            $item = $fecha  + ',' + $name + ',' + $bandera + ',' + $tipo + ',' + $sign + ',' + $agencia + ',' + $planta + ',' + $calado

            #check if the name is in iuu blacklist
            $blacklist = isVesselBlacklisted($name)-replace ',','';
         

            $item = $item  + ',' + $blacklist

             Write-Output $item
}

function processLine_VIAJE {

    param (
         $data
    )
      
      
            $indx= $data.IndexOf('NUMERO de ESCALA:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('</b>',$start_indx)
            $escala = $data.Substring($start_indx,($end_indx -$start_indx))

            $indx= $data.IndexOf('NUMERO de VIAJE:')
            $start_indx = $data.IndexOf('<b>',$indx) + 3
            $end_indx = $data.IndexOf('</b>',$start_indx)
            $nroviaje = $data.Substring($start_indx,($end_indx -$start_indx))

            $indx= $data.IndexOf('ARRIBO')
            $start_indx = $data.IndexOf('<tr><td ',$indx) + 21
            $end_indx = $data.IndexOf('</td>',$start_indx)
            $arribo_eta = $data.Substring($start_indx,($end_indx -$start_indx))

            $indx= $data.IndexOf('SALIDA')
            $start_indx = $data.IndexOf('<tr><td ',$indx) + 21
            $end_indx = $data.IndexOf('</td>',$start_indx)
            $salida_eta = $data.Substring($start_indx,($end_indx -$start_indx))

            $indx= $data.IndexOf('REPARACION')
            $start_indx = $data.IndexOf('<table>',$indx) + 15
            $end_indx = $data.IndexOf('</td>',$start_indx)
            $reparacion = $data.Substring($start_indx,($end_indx -$start_indx))

            
            $indx= $data.IndexOf('AVITUALLAMIENTO')
            $start_indx = $data.IndexOf('<table>',$indx) + 24
            $end_indx = $data.IndexOf('</td>',$start_indx)
            $avituallamiento = $data.Substring($start_indx,($end_indx -$start_indx))

                        
            $indx= $data.IndexOf('COMBUSTIBLE')
            $start_indx = $data.IndexOf('<table>',$indx) + 24
            $end_indx = $data.IndexOf('</td>',$start_indx)
            $combustible = $data.Substring($start_indx,($end_indx -$start_indx))

            $indx= $data.IndexOf('CANTIDAD de PASAJEROS')
            $start_indx = $data.IndexOf('<table>',$indx) + 15
            $end_indx = $data.IndexOf('</td>',$start_indx)
            $pasajeros = $data.Substring($start_indx,($end_indx -$start_indx)) -replace '&nbsp;',''

            $indx= $data.IndexOf('OBSERVACIONES')
            $start_indx = $data.IndexOf('<td ',$indx) + 14
            $end_indx = $data.IndexOf('</td>',$start_indx)
            $obs = ($data.Substring($start_indx,($end_indx -$start_indx)) -replace ',',' ') -replace '&nbsp;',''
            

            $item = $escala + ',' + $nroviaje + ',' + $arribo_eta + ',' + $salida_eta + ',' +$reparacion + ',' + $avituallamiento + ',' + $combustible + ',' + $pasajeros + ','  + $obs 

             Write-Output $item
}
function processLine_OPERACION {

    param (
         $data
    )
      
            #En este caso me traigo todo el HTML de la tabla, ya ue no se cuantos datos puedan haber
            #el procesamiento quedará para más adelante
      
            $indx= $data.IndexOf('OPERACION PREVISTA')
            if($indx -gt 0) {
                $start_indx = $indx
                $end_indx = $data.ToUpper().IndexOf('</TABLE>',$start_indx)
                $operacion = "<TABLE><b>" + $data.Substring($start_indx,($end_indx -$start_indx)) -replace '&nbsp;',''
            }else{$operacion = ""}

            $item = $operacion

            Write-Output $item
}

function processLine_PUERTOSANTERIORES {

    param (
         $data
    )
      
            #En este caso me traigo todo el HTML de la tabla, ya ue no se cuantos datos puedan haber
            #el procesamiento quedará para más adelante
      
            $indx= $data.IndexOf('PUERTOS ANTERIORES')
            if($indx -gt 0) {
                $start_indx = $indx
                $end_indx = $data.IndexOf('</table>',$start_indx)
                $puertos = "<TABLE><b>" + $data.Substring($start_indx,($end_indx -$start_indx)) -replace '&nbsp;',''
            }else{$puertos =""}

            $indx= $data.IndexOf('PUERTOS SIGUIENTES')
            if($indx -gt 0) {
                $start_indx = $indx
                $end_indx = $data.IndexOf('</table>',$start_indx)
                $puertos_prox =  "<TABLE><b>" + $data.Substring($start_indx,($end_indx -$start_indx)) -replace '&nbsp;',''  
            }else {$puertos_prox = ""}

            $item = $puertos + "," + $puertos_prox

             Write-Output $item
}


function obtainBody {

    param (
         $data
    )
      
            #in this case $data is an array of strings
            $start_indx= $data.ToUpper().IndexOf('<BODY>')
            $end_indx = $data.ToUpper().IndexOf('</BODY>')
            $body = $data[$start_indx..$end_indx]


             Write-Output $body
}

function prepareBody {

    param (
         $data_array
    )


            $data = New-Object System.Collections.ArrayList(,$data_array)
            #in this case $data is an array of strings, I need to convert it to an arraylist in order to be able to remove elements
            #for($i=0; $i -le $data.Length-1; $i++){
            for($i=($data.Count-1); $i -ge 0 ; $i--){
      
                $str_aux = $data[$i].Trim();
                if (($str_aux.Length -gt 0) -and ($str_aux.Substring(0,1) -ne "<")) 
                { 
                    #si el item no empieza con "<" -> lo concateno al final del item anterior
                     $data[$i-1] = $data[$i-1].Trim() + " " + $data[$i].Trim();
                     $data.RemoveAt($i);
                }
            }


             Write-Output $data
}


#PROCESS FOLDER FOR A SPECIFIC DATE


#$initial_path = 'C:\Users\msilvera\Documents\CODE\iuu-fishing-occ\IUUFishing\powershel-anp-consulta\resultadosArribos'
#$next_folder ="202107041734"
#$next_folder = $initial_path + '\'+ $next_folder

$next_folder = $folder

$pathToOutputFile = $next_folder + '\' +  "BrokenFiles.csv"
$pathToOutputVesselsFile = $next_folder + '\' +  "ListOfVessels.csv"

$detail_files = Get-ChildItem -Path $next_folder  –File 'datos*.html'
    
$array = @() #empty array
$array2 = @() #empty array
[System.Collections.ArrayList] $Broken_files= $array
[System.Collections.ArrayList] $ListOfVessels= $array2

$Header = "FECHA, NOMBRE, BANDERA,TIPO de BUQUE,SEÑAL DISTINTIVA,AGENCIA MARITIMA,PLANTA FRIGORIFICA DE AMONIACO,CALADO MÁXIMO DEL BUQUE, BLACKLIST,NUMERO de ESCALA,NUMERO de VIAJE, ARRIBO ETA, SALIDA ETA,REPARACION,AVITUALLAMIENTO,COMBUSTIBLE,CANTIDAD de PASAJEROS,OBSERVACIONES,PUERTOS ANTERIORES,PUERTOS SIGUIENTES, OPERACION PREVISTA"
$ListOfVessels.Add($Header);

foreach ($detail_file in $detail_files) {
   
   $file_content = Get-Content -Path ($next_folder + '\' + $detail_file)
   $file_content = obtainBody( $file_content) #me quedo solo con el body
   $file_content = prepareBody( $file_content)#ajusto formatos
  

   #$file_content

   $fecha = $detail_file.Name.Substring(62,8)
    
   $item =''

    foreach($line in $file_content){
      
     
      #Proceso segun el contenido de la linea
      if ($line.IndexOf('NOMBRE:') -ne -1) 
      {
            $aux= processLine_BUQUE($line).ToString();
            if ($item.Length -gt 0) {
                $item = $item + ',' + $aux;
                }
            else {  $item = $aux;}
                  
      }
      
      if ($line.IndexOf('OBSERVACIONES') -ne -1) 
      {
            $aux= processLine_VIAJE ($line);
            if ($item.Length -gt 0) {
                $item = $item + ',' + $aux;
                }
            else {  $item = $aux;}
                  
      }
       
      if ($line.IndexOf('PUERTOS ANTERIORES') -ne -1) 
      {
            $aux= processLine_PUERTOSANTERIORES ($line);
            if ($item.Length -gt 0) {
                $item = $item + ',' + $aux;
                }
            else {  $item = $aux;}
                  
      }
      
      if ($line.IndexOf('OPERACION PREVISTA') -ne -1) 
      {
            $aux= processLine_OPERACION ($line);
            if ($item.Length -gt 0) {
                $item = $item + ',' + $aux;
                }
            else {  $item = $aux;}
                  
      }
     } 
        
    #Agrego el registro al archivo 
    $ListOfVessels.Add($item.ToString());


   #else{
   #broken file?
   #$Broken_files.Add($detail_file);
   #}
   
   }

  $Broken_files | ConvertTo-Csv -NoTypeInformation | Add-Content $pathToOutputFile
  $ListOfVessels | Add-Content $pathToOutputVesselsFile

