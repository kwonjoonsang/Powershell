#
# **************************************************************************************************
# Script Name : Run-IISLogBackup.ps1
# ?©ÎèÑ
#		- Client Web Server Log Backup
#		- L4-Check, L4_Check SiteÎ•??úÏô∏???¨Ïù¥?∏Ïóê ?Ä??Log Backup ?òÌñâ 
#                - Log File??Backup ServerÎ°?Copy ??Zip ?ïÏ∂ï
# Îß§Í∞úÎ≥Ä??
#		- strServerIP : Web Server IP
#		- strAllGbn
#			1(Default) : 1????Log Backup
#			2 : ?ÑÏ≤¥ Log Backup
# **************************************************************************************************
#
Param
(
    [Parameter(Mandatory=$true)] $strServerIP,
    [Parameter(Mandatory=$true)] $strDrive,
    $strAllGbn = 1
)

Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$seeCredential = Get-WebCredential
$sesConnection = New-PSSession -ComputerName $strServerIP -Credential $seeCredential

$strSites = Get-IISWebsite -sesConnection $sesConnection
$strDate = Get-Date -Format yyyyMMdd

ForEach ($strSite in $strSites)
{
    If (($strSite.Name -ne "L4_Check") -and ($strSite.Name -ne "L4-Check"))
    {
        $strRDir = $strSite.LogFile.Directory
	    $strRLogDir = $strRDir + "\W3SVC" + $strSite.ID
        $strLogDir = "\\" + $strServerIP + "\" + $strRDir.Replace(':', '$') + "\W3SVC" + $strSite.ID
        $strHostname = Get-Hostname -Session $sesConnection

        $strCLogDir = $strDrive + ":\LOGS\" + $strHostname + "\" + $strSite.Name

        If($strAllGbn -eq "1")
        {
            $strLogLists = Get-LogData -strLogDir $strRLogDir -Session $sesConnection 
        }
        ElseIf($strAllGbn -eq "2")
        {
            $strLogLists = Get-AllLogData -strRLogDir $strRLogDir -Session $sesConnection
        }

        ForEach ($strLogList in $strLogLists)
        {
            Write-Host "log"
            Write-Host $strLogDir
            Write-Host $strLogList
            Write-Host $strCLogDir
            Set-FileCopy -LogDir $strLogDir -CLogDir $strCLogDir -LogList $strLogList
            #.\Run-IISDBReg.ps1 -strServerNM $strHostname -strDomainNM $strSite.Name -strCLogDir $strCLogDir -strLogList $strLogList
            #$strBLogList = Get-BDayLog -LogList $strLogList
            #Set-Compress -CLogDir $strCLogDir -LogList $strBLogList
        }
    }
}