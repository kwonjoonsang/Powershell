#
# **************************************************************************************************
# Script Name : New-RegSchedule.ps1
# Usage
#		- Register Windows Scheduler
 
# 
# Parameter
#       - strIP : Server IP
#       - strBackupTime : Backup Time
#       - strBackupName : Schedule Name
#       - strPath : 
#       - strExePowershell : PowerShell Script
# **************************************************************************************************
#
Param
(
    $strIP,
    $strBackupTime = 1,
    $strBackupName,
    $strPath = "D:\SE_DIR\Script\LogBackup",
    $strExePowershell
 )

Switch ($strBackupTime)
{
        1 { $dateTrigger = New-JobTrigger -Daily -At 01:00AM }
        2 { $dateTrigger = New-JobTrigger -Daily -At 02:00AM }
        3 { $dateTrigger = New-JobTrigger -Daily -At 03:00AM }        
        4 { $dateTrigger = New-JobTrigger -Daily -At 04:00AM }
        5 { $dateTrigger = New-JobTrigger -Daily -At 05:00AM }
        6 { $dateTrigger = New-JobTrigger -Daily -At 06:00AM }
        14 { $dateTrigger = New-JobTrigger -Daily -At 02:00PM }
}

$strUserInfo = Get-Content .\UserInfo.txt
$arrUserInfo = $strUserInfo.Split("`t")

$strUser = $arrUserInfo[0].ToString()
$strPassword = $arrUserInfo[1].ToString()
$strPath = "D:\SE_DIR\Script\LogBackup"

$strCmd = " -nologo -noprofile -file " + $strExePowershell
$objTaskAction = New-ScheduledTaskAction -Execute "Powershell" -Argument $strCmd -WorkingDirectory "D:\SE_DIR\Script\Logbackup"
$objSettings = New-ScheduledTaskSettingsSet

Register-ScheduledTask -Action $objTaskAction -Trigger $dateTrigger -TaskName $strBackupName -User $strUser -Password $strPassword -Settings $objSettings