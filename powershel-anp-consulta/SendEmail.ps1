#https://blog.mailtrap.io/azure-send-email/

$user = "apikey"
$password = "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"

$securePassword = $password | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString 
$cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, ($securePassword | ConvertTo-SecureString)

#Attachments convert to string array
#$Attachment = 'C:\Users\Mariana\CODE\iuu-fishing-occ\powershel-anp-consulta\resultadosOcupacion\202101141646\OcupacionPuerto20210114.zip;C:\Users\Mariana\CODE\iuu-fishing-occ\powershel-anp-consulta\resultadosArribos\202101141646\ArribosPrevistos20210114.zip'
#$Body=""
#$Attachment = 'C:\ArribosPrevistos20210114.zip;C:\windows-version.txt'

[string[]]$AttachmentArray = $Attachment.Split(';')

#$AttachmentArray

##############################################################################
$From = "Mariana Silvera <mariana@occ.org.uy>"
$To = @("silvera.mariana@gmail.com", "mariana@occ.org.uy")
$Cc = "marisg@adinet.com.uy"
#$Attachment = "C:\temp\Some random file.txt"

$Subject = "Consulta ANP - Arribos y Ocupación para el día:  " + (Get-Date -format yyyy-MM-dd)
$Body = "<BR><b>Se adjuntan listados de los arribos previstos y ocupación del puerto para la fecha.</b><BR><HR><HR><BR><BR>" + $Body

$SMTPServer = "smtp.sendgrid.net"
$SMTPPort = "587"

#if ($Attachment != "")
#{
    Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject `
    -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
    -Credential $cred `
    -Attachments $AttachmentArray `
    -encoding "UTF8" `
    -BodyAsHtml
#}
##############################################################################


#SENDGRID CONFIGURATION:
#Configure your application with the settings below.

#Server	smtp.sendgrid.net
#Ports	
#25, 587	(for unencrypted/TLS connections)
#465	(for SSL connections)
#Username	apikey
#Password	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

