#
# **************************************************************************************************
# Script Name : Run-LogCompress.ps1
# Usage
#		- Log Compress
# 
# Parameter
#       - strServerIP : Get Log Server IP
#       - strDrive : 
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
        $strBLogList = Get-BDayLog -intDay 2
        $strFLogList = $strCLogDir + "\" + $strBLogList

        If (Test-Path $strFLogList)
        {
            Set-Compress -CLogDir $strCLogDir -LogList $strBLogList
        }
    }
}