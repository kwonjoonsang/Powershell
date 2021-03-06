﻿#
# **************************************************************************************************
# Script Name : Run-AllBackup.ps1
# Usage
#		- Get Log Delete List 
# 
# Parameter
#       - strServerIP : Get Log Server IP
#       - intDay : 
#       - strDrive : 
# **************************************************************************************************
#
Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$arrServerInfo = Get-Content .\ServerInfo.txt
$strDate = Get-Date -UFormat "%Y-%m-%d"
$strMail = "Date : " + $strDate + "`n"

ForEach ($strServerInfo In $arrServerInfo)
{
	$arrServerGbn = $strServerInfo.Split("`t")

	$strServerIP = $arrServerGbn[0].ToString()
	$intDays = $arrServerGbn[1].ToString()
    $strDrive = $arrServerGbn[2].ToString()

    $seeCredential = Get-WebCredential
    $sesConnection = New-PSSession -ComputerName $strServerIP -Credential $seeCredential

    $strSites = Get-IISWebsite -sesConnection $sesConnection

    ForEach ($strSite in $strSites)
    {
        Write-Host $strSite.Name
        If (($strSite.Name -ne "L4_Check") -and ($strSite.Name -ne "L4-Check"))
        {
            $strRDir = $strSite.LogFile.Directory
	        $strRLogDir = $strRDir + "\W3SVC" + $strSite.ID
            $strLogDir = "\\" + $strServerIP + "\" + $strRDir.Replace(':', '$') + "\W3SVC" + $strSite.ID
            $strHostname = Get-Hostname -Session $sesConnection

            $strCLogDir = $strDrive + ":\LOGS\" + $strHostname + "\" + $strSite.Name
            
            $strLogLists = Get-AllLogData -strRLogDir $strRLogDir -Session $sesConnection

            ForEach ($strLogList in $strLogLists)
            {
                Set-FileCopy -LogDir $strLogDir -CLogDir $strCLogDir -LogList $strLogList
                .\Run-IISDBReg.ps1 -strServerNM $strHostname -strDomainNM $strSite.Name -strCLogDir $strCLogDir -strLogList $strLogList
            }
        }
    }
}