#
# **************************************************************************************************
# Script Name : Run-InterfacePowershell.ps1
# ?©ÎèÑ
#		- ServerInfo.txt ?åÏùº???ΩÏñ¥ Íµ¨Î∂Ñ?êÏóê ?∞Îùº Script ?∏Ï∂ú
# Îß§Í∞úÎ≥Ä??
#		- strGbn
#                       1 : Run-IISLogBackup.ps1
#                       2 : Get-DeleteLogList.ps1
#                       3 : Run-LogDelete.ps1
# **************************************************************************************************
#
Param
(
    [Parameter (Mandatory=$true)] $strScript
)

Import-Module .\CommonFunction.psm1

$arrServerInfo = Get-Content .\ServerInfo.txt
$strDate = Get-Date -UFormat "%Y-%m-%d"
$strMail = "Date : " + $strDate + "`n"

$seeCredential = Get-WebCredential

ForEach ($strServerInfo In $arrServerInfo)
{
	$arrServerGbn = $strServerInfo.Split("`t")

	$strServerIP = $arrServerGbn[0].ToString()
	$intDays = $arrServerGbn[1].ToString()
    $strDrive = $arrServerGbn[2].ToString()

	If ($strScript -eq 1)
	{
		.\Run-IISLogBackup.ps1 -strServerIP $strServerIP -strAllGbn 1 -strDrive $strDrive
	}
	ElseIf ($strScript -eq 2)
	{
		.\Get-DeleteLogList.ps1 -strServerIP $strServerIP -intDay $intDays -strDrive $strDrive
	}
	ElseIf ($strScript -eq 3)
	{
		.\Run-LogDelete.ps1 -strServerIP $strServerIP
	}
	ElseIf ($strScript -eq 4)
	{
		$strMailContent = .\Run-LogCheck.ps1 -strServerIP $strServerIP -intDay $intDays -strDrive $strDrive -seeCredential $seeCredential
		$strMail = $strMail + $strMailContent
	}
    ElseIf ($strScript -eq 5)
    {
        #Write-Host $strServerIP
        .\Run-IISLogBackup.ps1 -strServerIP $strServerIP -strAllGbn 2 -strDrive $strDrive
    }
    ElseIf ($strScript -eq 6)
    {
        #Write-Host $strServerIP + " " + $strDrive
        .\Run-LogCompress.ps1 -strServerIP $strServerIP -strDrive $strDrive
    }
    ElseIf ($strSCript -eq 7)
    {
        .\Run-IISDBReg.ps1 -strServerIP $strServerIP -strDrive $strDrive
    }
}

If ($strScript -eq 4)
{
    .\Run-SendMail.ps1 -strMail $strMail
}
ElseIf ($strSCript -eq 8)
{
    .\Run-IISDBParsing.ps1
}