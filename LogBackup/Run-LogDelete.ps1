#
# **************************************************************************************************
# Script Name : Run-LogDelete.ps1
# ?�도
#		- 보�? 주기가 ?��? 로그�???��
#                - Get-DeleteLogList.ps1 ?�일?�서 ?�성??LogList.txt ?�일???�는 로그 ?�일????��
# 매개변??
#		- strGbn
#                       1 : Backup Host ?�버??Log ?�일 Backup
#                       2 : Web Server?�서 보�? 주기가 지??Log ??��
#                       3 : Backup Host ?�버??보�? 주기가 지??Log ??��
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