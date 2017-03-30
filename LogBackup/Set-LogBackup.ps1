#
# **************************************************************************************************
# Script Name : Set-LogBackup.ps1
# ?©ÎèÑ
#		- Î°úÍ∑∏ Î∞±ÏóÖ, Î°úÍ∑∏ ??†ú ?§Ï?Ï•¥ÏùÑ ?±Î°ù
#                - New-RegSchedule???¨Ïö©?òÏó¨ ?§Ï?Ï•¥ÏùÑ ?±Î°ù??
#                - Î™®Îì† ?§Ï?Ï•¥Ï? Main ?úÎ≤Ñ?êÏÑú ?±Î°ù??
# Îß§Í∞úÎ≥Ä??
#		- strGbn
#                       1 : Backup Host ?úÎ≤Ñ??Log ?åÏùº Backup
#                       2 : Web Server?êÏÑú Î≥¥Í? Ï£ºÍ∏∞Í∞Ä ÏßÄ??Log ??†ú
#                       3 : Backup Host ?úÎ≤Ñ??Î≥¥Í? Ï£ºÍ∏∞Í∞Ä ÏßÄ??Log ??†ú
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