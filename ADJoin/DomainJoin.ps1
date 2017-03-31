#
# **************************************************************************************************
# Script Name : DomainJoin.ps1
# Usage
#		- Domain Join
# 
# Parameter
#       - strDomainNM : Domain Name
#       - strUser : Domain Join Account
# **************************************************************************************************
#
Param
(
    [Parameter(Mandatory=$true)] $strDomainNM,
    $strUser
)

Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Import-Module .\comModule.psm1

$bolCheck = Get-Requirement($strUser)

If ($bolCheck -eq 0)
{
    If ($strUser -eq $null)
    {
        $strUserInfo = Get-Content .\UserInfo.txt
        $arrUserInfo = $strUserInfo.Split("`t")

        $strUser = $arrUserInfo[0].ToString()
        $strPassword = $arrUserInfo[1].ToString()
        $strPassword = ConvertTo-SecureString $strPassword -AsPlainText -Force
    }
    Else
    {
        $strPassword = Read-Host -Prompt "Enter Password" -AsSecureString
    }

    $strUserName = "$strDomainNM\$strUser"
    $autCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $strUserName,$strPassword
}
ElseIf ($bolCheck -eq 1)
{
    Write-Host "UserInfo.txt 파일이 존재하지 않습니다."
}
ElseIf ($bolCheck -eq 2)
{
    Write-Host "Group.txt 파일이 존재하지 않습니다."
}