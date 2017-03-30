#
# **************************************************************************************************
# Script Name : Run-LogCheck.ps1
# ?ฉ๋
#		- BackupHost????ฅ๋ Log ?? 
# ๋งค๊ฐ๋ณ??
#		- strServer IP : ?์ธ???๋ฒ IP
#		- intDay : ??ฅํ  ๋ก๊ทธ Data
# **************************************************************************************************
#
Param
(
    [Parameter (Mandatory=$true)] $strServerIP,
    [Parameter (Mandatory=$true)] $intDay,
    [Parameter (Mandatory=$true)] $strDrive,
    [Parameter (Mandatory=$true)] $seeCredential
)

Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Write-Host $strDrive
$sesConnection = New-PSSession -ComputerName $strServerIP -Credential $seeCredential

$strHostName = Get-Hostname -Session $sesConnection 

$strBMailContent = .\Run-CheckLog.ps1 -strServerIP $strServerIP -strGbn 1 -sesConnection $sesConnection -strDrive $strDrive
$strDMailContent = .\Run-CheckLog.ps1 -strServerIP $strServerIP -strGbn 2 -sesConnection $sesConnection -intDay $intDay  -strDrive $strDrive
Write-Host $strServerIP
If (($strDMailContent -ne "") -or ($strBMailContent -ne ""))
{
    $strMailContent = $strHostName + " - Save Days : " + $intDay + "`n" + "`t"
    $strMailContent = $strMailContent +  $strDMailContent + "`n" + $strBMailContent + "`n"
}
Else
{
    $strMailContent = ""
}

return $strMailContent