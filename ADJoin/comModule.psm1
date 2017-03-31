#
# **************************************************************************************************
# Script Name : comModule.psm1
# Usage
#		- AD Join Common Module
# Parameter
#       - strUser : AD Join User
# **************************************************************************************************
#
Function Get-Requirement
{
    Param
    (
        $strUser
    )

    $bolCheck = 0

    If ($strUser -eq $null)
    { 
        If ((Test-Path .\UserInfo.txt) -eq $false)
        { 
            $bolCheck = 1
        }
    }

    If ((Test-Path .\Group.txt) -eq $false)
    {
        $bolCheck = 2
    }

    return $bolCheck
}

Function Modify-LocalGroup
{
    Param
    (
        $strDomainNM
    )

    $strGroups = Get-Content .\Group.txt
    $strLocalGroup = "Administrators"
    $strADSI = [ADSI]"WinNT://./$strLocalGroup"

    $strADSI.Remove("WinNT://$strDomainNM/Domain Admins")

    ForEach($strGroup in $strGroups)
    {
        $strADSI.ADD("WinNT://$strGroup")
    }
}