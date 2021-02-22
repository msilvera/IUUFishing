#FILTRO: Pesca Congelada

$WebResponseObj = Invoke-WebRequest -Uri "https://aplicaciones.anp.com.uy/montevideo/sistemas/consultas/arribos/arribos_previstos.asp" `
-Method "POST" `
-Headers @{
"Cache-Control"="max-age=0"
  "sec-ch-ua"="`"Google Chrome`";v=`"87`", `" Not;A Brand`";v=`"99`", `"Chromium`";v=`"87`""
  "sec-ch-ua-mobile"="?0"
  "Origin"="https://aplicaciones.anp.com.uy"
  "Upgrade-Insecure-Requests"="1"
  "DNT"="1"
  "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"
  "Accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  "Sec-Fetch-Site"="same-origin"
  "Sec-Fetch-Mode"="navigate"
  "Sec-Fetch-User"="?1"
  "Sec-Fetch-Dest"="iframe"
  "Referer"="https://aplicaciones.anp.com.uy/montevideo/sistemas/consultas/arribos/arribos_previstos.asp"
  "Accept-Encoding"="gzip, deflate, br"
  "Accept-Language"="es,en;q=0.9,de;q=0.8,en-US;q=0.7,pt;q=0.6"
  "Cookie"="_ga=GA1.3.1453185112.1605200219; ASPSESSIONIDQQCTDDTA=NAFAPEBBKGLBGIDNOMFNJPNL; ROUTEIDAPPS=.2; ROUTEIDWEBS=.2; ASPSESSIONIDSQAQBAQC=MHKEDBOBAAEDENEJNPMDIJNB; _gid=GA1.3.342907683.1610563488; ASPSESSIONIDSSBRBBQC=JFPLMFHDONANCCCDDAPEJGMD"
} `
-ContentType "application/x-www-form-urlencoded" `
-Body "bn=&ta=0&tb=20&am=TTTTTTTT&o=F&Submit=++Aceptar++"


$WebResponseObj| Get-Member


$fecha = Get-Date -format yyyyMMddHHmm
$folder = 'C:\Users\Mariana\CODE\iuu-fishing-occ\powershel-anp-consulta\resultadosArribos' + '\' + $fecha

md $folder


$filename =  $folder + '/ANP_arribos_previstos_congelada' + $fecha +  '.html'

$WebResponseObj.content >> $filename


#Getting table by ID.
#$oTable = $oHtmlDoc.getElementByID("table6")
#----------


#[regex]$regex = "(?s)<TABLE ID=.*?</TABLE>"
[regex]$regex ="(?s)<A HREF=.*?>"
$tables = $regex.matches((GC $filename -raw)).groups.value

$tables

ForEach($string in $tables){

$url = ''
$uri=''
$newfile=''

$url = $string -replace '<A HREF="',''
$url = $url -replace '">',''
$url

$newfile = (($url -replace '.asp\?','_') -replace '&','_')-replace '=','_'
$newfile = $folder + '/' + $newfile  + $fecha +  '.html'
$newfile

$uri = "http://aplicaciones.anp.com.uy/montevideo/sistemas/consultas/arribos/" + $url

$WebResponseObj2 = Invoke-WebRequest -Uri $uri -Headers @{
"Upgrade-Insecure-Requests"="1"
  "DNT"="1"
  "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36"
  "Accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  "Referer"="http://aplicaciones.anp.com.uy/montevideo/sistemas/consultas/arribos/ocupacion_puerto.asp"
  "Accept-Encoding"="gzip, deflate"
  "Accept-Language"="es,en;q=0.9,de;q=0.8,en-US;q=0.7,pt;q=0.6"
  "Cookie"="ASPSESSIONIDAASARRBS=PFNJIHHDAGOAGEADMINOCIMG; ASPSESSIONIDAABSAQBQ=DNODFBGDMFJOLEDINFNCIPIJ"
}
$WebResponseObj2.content >> $newfile


}

