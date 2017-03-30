#
# **************************************************************************************************
# Script Name : Run-LogDelete.ps1
# ?©ÎèÑ
#		- Î≥¥Í? Ï£ºÍ∏∞Í∞Ä ?òÏ? Î°úÍ∑∏Î•???†ú
#                - Get-DeleteLogList.ps1 ?åÏùº?êÏÑú ?ùÏÑ±??LogList.txt ?åÏùº???àÎäî Î°úÍ∑∏ ?åÏùº????†ú
# Îß§Í∞úÎ≥Ä??
#		- strGbn
#                       1 : Backup Host ?úÎ≤Ñ??Log ?åÏùº Backup
#                       2 : Web Server?êÏÑú Î≥¥Í? Ï£ºÍ∏∞Í∞Ä ÏßÄ??Log ??†ú
#                       3 : Backup Host ?úÎ≤Ñ??Î≥¥Í? Ï£ºÍ∏∞Í∞Ä ÏßÄ??Log ??†ú
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