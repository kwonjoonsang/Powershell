#
# **************************************************************************************************
# Script Name : Set-LogBackup.ps1
# Usage
#		- Register the Schedule
# 
# Parameter
#       - strGbn
#           1 -> Log Backup
#           2 -> Host Delete Log
#           3 -> Delete Specified Server Log
#           4- > Check the Log
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