#
# **************************************************************************************************
# Script Name : Get-DeleteLogList.ps1
# ?©ÎèÑ
#		- Host?êÏÑú Web Server??Î°úÍ∑∏ Ï§???†ú??Î°úÍ∑∏???Ä??Í≤Ä??
#                  (Backup Host???¥Îãπ ?åÏùº??Î∞±ÏóÖ ?òÏóà?îÏ? ?ïÏù∏)
#		- Backup Host -> Web Server???ëÏÜç?Ä Í∞Ä?•Ìïò??Î∞òÎ???Î∂àÍ??•Ìï®(Î≥¥Ïïà)
#		- ?¥Îãπ ?åÏõå?òÏóê??Í≤Ä?âÌïú Log??WebServer??Log ?¥Îçî???Ä?•Îêò?¥Ï?Î©?Log List???Ä??
#		  ??†ú ÏßÑÌñâ
# Îß§Í∞úÎ≥Ä??
#		- strServerIP : Web Server IP
#                - intDay : Î≥¥Í? Ï£ºÍ∏∞
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
    Write-Host $strSite
        $strRDir = $strSite.LogFile.Directory
        $strRLogDir = $strRDir + "\W3SVC" + $strSite.ID
        $strLogDir = "\\" + $strServerIP + "\" + $strRDir.Replace(':', '$') + "\W3SVC" + $strSite.ID
	Write-Host $strLogDir
        $strHostName = Get-HostName -Session $sesConnection
        
        $strCLogDir = $strDrive + ":\LOGS\" + $strHostname + "\" + $strSite.Name
        $strLogLists = Get-BeforeLogData -strLogDir $strRLogDir -intDay $intDay -Session $sesConnection
      Write-Host $strRLogDir

        ForEach ($strLogList In $strLogLists)
        {
            $bolIsBackupLog = Get-IsBackupLog -strLogName $strLogList.Name -strCLogDir $strCLogDir
         Write-Host $strLogList " " $bolIsBackupLog
            If ($bolIsBackupLog -eq $true)
            {
                $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Out-File -FilePath $strRLogDir\LogList.txt -InputObject $strLogList -Append ")
                $strLog = Invoke-Command -Command $strCmd -Session $sesConnection
            }
        }
}