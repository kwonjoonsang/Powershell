#
# **************************************************************************************************
# Script Name : Run-LogDelete.ps1
# Usage
#		- Get Log Delete
# 
# Parameter
#       - strServerIP : Get Log Server IP
# **************************************************************************************************
#
Param
(
	[Parameter (Mandatory=$true)] $strServerIP
)

Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$seeCredential = Get-Webcredential
$sesConnection = New-PSSession -ComputerName $strServerIP -Credential $seeCredential

$strSites = Get-IISWebsite -sesConnection $sesConnection

ForEach ($strSite In $strSites)
{
        $strRDir = $strSite.LogFile.Directory
        $strRLogDir = $strRDir + "\W3SVC" + $strSite.ID

        $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Get-Content $strRLogDir\LogList.txt ")
        $arrLogList = Invoke-Command -Command $strCmd -Session $sesConnection

        ForEach ($strLogList In $arrLogList)
        {
            $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Remove-Item $strRLogDir\$strLogList ")
            Invoke-Command -Command $strCmd -Session $sesConnection
        }

        $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Remove-Item $strRLogDir\LogList.txt ")
        $arrLogList = Invoke-Command -Command $strCmd -Session $sesConnection
}