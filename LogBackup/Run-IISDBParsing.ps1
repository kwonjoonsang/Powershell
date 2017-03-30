Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$dtDate = Get-Date
$strDayOfWeek = $dtDate.AddDays(-1).DayOfWeek
$dtBDate = $dtDate.AddDays(-1)
$strBDate = $dtBDate.ToString("yyyy-MM-dd")

$strTod = Get-DayOfWeek -strDayOfWeek $strDayOfWeek

Python .\IISLog\clsInsertParsing.py $strTOD, $strBDate