#
# **************************************************************************************************
# Script Name : Run-SendMail.ps1
# Usage
#		- Mail Send
# Argument
#		- strMail : Mail Content
# **************************************************************************************************
#
Param
(
    $strMail
)

$strFrom = "Sender Mail Address"
$strTo = "To Email Address#1", "To Email Address#2"
$strCC = "CC Email Address"
$strSubject = "[Check Mail] Gameweb Log Backup Missing List"
$strBody = $strMail
$strSMTPServer = "SMTP Address"

Send-MailMessage -From $strFrom -To $strTo -Cc $strCC -Subject $strSubject -Body $strBody -SmtpServer $strSMTPServer
