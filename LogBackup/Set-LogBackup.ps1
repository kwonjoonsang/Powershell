#
# **************************************************************************************************
# Script Name : Set-LogBackup.ps1
# ?�도
#		- 로그 백업, 로그 ??�� ?��?쥴을 ?�록
#                - New-RegSchedule???�용?�여 ?��?쥴을 ?�록??
#                - 모든 ?��?쥴�? Main ?�버?�서 ?�록??
# 매개변??
#		- strGbn
#                       1 : Backup Host ?�버??Log ?�일 Backup
#                       2 : Web Server?�서 보�? 주기가 지??Log ??��
#                       3 : Backup Host ?�버??보�? 주기가 지??Log ??��
# **************************************************************************************************
#
Param
(
    [Parameter (Mandatory=$true)] $strGbn
)

If ($strGbn -eq 1)
{
    .\New-RegSchedule.ps1 -strBackupTime 1 -strBackupName "Log Backup" -strPath "D:\SE_DIR\Script\LogBackup" -strExePowershell "Run-InterfacePowershell.ps1 -strScript 1"
}
ElseIf ($strGbn -eq 2)
{
    .\New-RegSchedule.ps1 -strIP 192.168.81.16 -strBackupTime 6 -strBackupName "Host Delete Log" -strPath "D:\SE_DIR\Script\LogBackup" -strExePowershell  "Run-HostLogDelete.ps1"
}
ElseIf ($strGbn -eq 3)
{
    .\New-RegSchedule.ps1 -strBackupTime 5 -strBackupName "Enumerlate Delete Log" -strPath "D:\SE_DIR\Script\LogBackup" -strExePowershell "Run-InterfacePowershell.ps1 -strScript 2"
    .\New-RegSchedule.ps1 -strBackupTime 6 -strBackupName "Delete Log" -strPath "D:\SE_DIR\Script\LogBackup" -strExePowershell "Run-InterfacePowershell.ps1 -strScript 3"
}
ElseIf ($strGbn -eq 4)
{
    .\New-RegSchedule.ps1 -strBackupTime 14 -strBackupName "Check the Log" -strPath "D:\SE_DIR\Script\LogBackup" -strExePowershell "Run-InterfacePowershell.ps1 -strScript 4"
}