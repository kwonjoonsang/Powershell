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

$strFrom = "LogMan@nexon.co.kr"
#$strTo = "kjs0624@nexon.co.kr"
$strTo = "kjs0624@nexon.co.kr", "cookis@nexon.co.kr", "gsohn@nexon.co.kr"
$strCC = "system_gameweb@nexon.co.kr"
$strSubject = "[Check Mail] Gameweb Log Backup Missing List"
$strBody = $strMail
$strSMTPServer = "inrelay.nexon.co.kr"

#Send-MailMessage -From $strFrom -To $strTo -Subject $strSubject -Body $strBody -SmtpServer $strSMTPServer
Send-MailMessage -From $strFrom -To $strTo -Cc $strCC -Subject $strSubject -Body $strBody -SmtpServer $strSMTPServer