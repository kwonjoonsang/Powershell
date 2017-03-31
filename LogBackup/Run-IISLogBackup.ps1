#
# **************************************************************************************************
# Script Name : Run-IISLogBackup.ps1
# Usage
#		- IIS Log Backup
# 
# Parameter
#       - strServerIP : Get Log Server IP 
#       - strDrive : 
#       - strAllGbn : 
#                       1 -> Specified Server Log
#                       2 -> All Server Log
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
            Set-FileCopy -LogDir $strLogDir -CLogDir $strCLogDir -LogList $strLogList
        }
    }
}