#
# **************************************************************************************************
# Script Name : Run-IISLogBackup.ps1
# ?⑸룄
#		- Client Web Server Log Backup
#		- L4-Check, L4_Check Site瑜??쒖쇅???ъ씠?몄뿉 ???Log Backup ?섑뻾 
#                - Log File??Backup Server濡?Copy ??Zip ?뺤텞
# 留ㅺ컻蹂??
#		- strServerIP : Web Server IP
#		- strAllGbn
#			1(Default) : 1????Log Backup
#			2 : ?꾩껜 Log Backup
# **************************************************************************************************
#
Param
(
    [Parameter(Mandatory=$true)] $strServerIP,
    [Parameter(Mandatory=$true)] $strDrive
)

Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$seeCredential = Get-WebCredential
$sesConnection = New-PSSession -ComputerName $strServerIP -Credential $seeCredential

$strSites = Get-IISWebsite -sesConnection $sesConnection

ForEach ($strSite in $strSites)
{
    If (($strSite.Name -ne "L4_Check") -and ($strSite.Name -ne "L4-Check"))
    {
        $strRDir = $strSite.LogFile.Directory
	    $strRLogDir = $strRDir + "\W3SVC" + $strSite.ID
        $strLogDir = "\\" + $strServerIP + "\" + $strRDir.Replace(':', '$') + "\W3SVC" + $strSite.ID
        $strHostname = Get-Hostname -Session $sesConnection

        $strCLogDir = $strDrive + ":\LOGS\" + $strHostname + "\" + $strSite.Name
        $strBLogList = Get-BDayLog -intDay 1
        $strCLogFile = $strCLogDir + "\" + $strBLogList
        $dtDate = Get-Date
        $strDayOfWeek = $dtDate.AddDays(-1).DayOfWeek

        $strTod = Get-DayOfWeek -strDayOfWeek $strDayOfWeek
        $strTable = "TRAW00" + $strTOD

        If(Test-Path $strCLogFile)
        {
            #Write-Host $strHostname
            Python .\IISLog\clsInsertLog.py $strCLogFile $strSite.Name $strHostname $strTOD
        }
    }
}