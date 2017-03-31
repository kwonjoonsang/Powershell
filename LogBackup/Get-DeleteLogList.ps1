#
# **************************************************************************************************
# Script Name : Get-DeleteLogList.ps1
# Usage
#		- Get Log Delete List 
# 
# Parameter
#       - strServerIP : Get Log Server IP
#       - intDay : 
#       - strDrive : 
# **************************************************************************************************
#
Param
(
	[Parameter (Mandatory=$true)] $strServerIP,
	[Parameter (Mandatory=$true)] $intDay = 30,
	[Parameter (Mandatory=$true)] $strDrive
)

Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$seeCredential = Get-WebCredential
$sesConnection = New-PSSession -ComputerName $strServerIP -Credential $seeCredential

$strSites = Get-IISWebsite -sesConnection $sesConnection

ForEach ($strSite In $strSites)
{
    $strRDir = $strSite.LogFile.Directory
    $strRLogDir = $strRDir + "\W3SVC" + $strSite.ID
    $strLogDir = "\\" + $strServerIP + "\" + $strRDir.Replace(':', '$') + "\W3SVC" + $strSite.ID
	
    $strHostName = Get-HostName -Session $sesConnection
        
    $strCLogDir = $strDrive + ":\LOGS\" + $strHostname + "\" + $strSite.Name
    $strLogLists = Get-BeforeLogData -strLogDir $strRLogDir -intDay $intDay -Session $sesConnection

    ForEach ($strLogList In $strLogLists)
    {
        $bolIsBackupLog = Get-IsBackupLog -strLogName $strLogList.Name -strCLogDir $strCLogDir
        
        If ($bolIsBackupLog -eq $true)
        {
            $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Out-File -FilePath $strRLogDir\LogList.txt -InputObject $strLogList -Append ")
            $strLog = Invoke-Command -Command $strCmd -Session $sesConnection
        }
    }
}