Param
(
    [Parameter(Mandatory=$true)] $strServerIP,
    [Parameter(Mandatory=$true)] $strGbn,
    $sesConnection,
    $intDay,
    $strDrive
)

Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$strSites = Get-IISWebsite -sesConnection $sesConnection

$bolIsMail = $false
$strAllMail = ""
$strMail = ""
Write-Host $strServerIP
If ($strGbn -eq 1)
{
    $strHeadMail = "`t" + "[Missing Backup]" + "`n"
}
ElseIf($strGbn -eq 2)
{
    $strHeadMail = "[Delete Missing]" + "`n"
}

ForEach ($strSite in $strSites)
{
    If (($strSite.Name -ne "L4_Check") -and ($strSite.Name -ne "L4-Check"))
    {
        $strRDir = $strSite.LogFile.Directory
	    $strRLogDir = $strRDir + "\W3SVC" + $strSite.ID
        $strLogDir = "\\" + $strServerIP + "\" + $strRDir.Replace(':', '$') + "\W3SVC" + $strSite.ID
        
        $strCLogDir = $strDrive + ":\LOGS\" + $strHostname + "\" + $strSite.Name
        Write-Host "CLogDir : " + $strCLogDir
        <#
        If ($strHostname -like "MS2-WEB*")
        {
            $strCLogDir = "F:\LOGS\" + $strHostname + "\" + $strSite.Name
        }
        Else
        {
            $strCLogDir = "E:\LOGS\" + $strHostname + "\" + $strSite.Name
        }
        #>

        If ($strGbn -eq 1)
        {
            $strLogLists = Get-LogData1 -strLogDir $strRLogDir -Session $sesConnection
        }
        ElseIf ($strGbn -eq 2)
        {
            $strLogLists = Get-BeforeLogData -strLogDir $strRLogDir -intDay $intDay -Session $sesConnection
        }

        $strSiteMail = "`t" + "Site Name : " + $strSite.Name + "`n" +"`t" + "`t"
        $strFileMail = ""

        ForEach ($strLogList in $strLogLists)
        {
            $arrLogName = $strLogList.Name.Split('.')
            $strFileName = $arrLogName[0].ToString()

            If ($strGbn -eq 1)
            {
                $bolIsFile = Get-IsFile -strFileName $strFileName -strCLogDir $strCLogDir

                If ($bolIsFile -eq $false)
                {
                    $strFileMail = $strFileMail + $strLogList.Name + " "
                    $bolIsMail = $true
                    #$strMail = $strMail + $strLogList + " "
                }
            }
            ElseIf ($strGbn -eq 2)
            {
                If ($strLogList.Name -ne "")
                {
                    $strFileMail = $strFileMail + $strLogList.Name + " "
                    $bolIsMail = $true
                    #$strMail = $strMail + $strLogList.Name + " "
                }
            }
        }

        If ($bolIsMail -eq $true)
        {
            $strAllMail = $strAllMail + $strSiteMail + $strFileMail
            $strAllMail = $strAllMail + "`n"
            $bolIsMail = $false
        }
    }
}

If ($strAllMail  -ne "")
{
    $strMail = $strHeadMail + $strAllMail
}

return $strMail