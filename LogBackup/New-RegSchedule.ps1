#
# **************************************************************************************************
# Script Name : New-RegSchedule.ps1
# 용도
#		- 스케쥴러에 새로운 스케쥴을 등록
#		- Run-Logbackup.ps1을 호출하여 ClientTime.txt에 등록된 Web 서버들에 대해 백업을 수행
# 매개변수
#                - strIP : 스케쥴을 등록할 서버 IP
#		- strBackupTime : Backup Time
#                - strBackupName : 스케쥴러에 등록될 이름
#                - strPath : 스케쥴러에서 실행될 기본 위치
#                - strExePowershell : 수행할 Powershell Script
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