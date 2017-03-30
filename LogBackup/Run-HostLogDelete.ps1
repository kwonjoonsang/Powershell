Param
(
    $intDay = 40
)

Import-Module .\CommonFunction.psm1

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$dateNow = Get-Date
$strTFolder = "E:\LOGS"
$strMS2TFolder = "F:\LOGS"

$strExtension = @("*.log", "*.zip")
$dateLastWrite = $dateNow.AddDays(-$intDay)

$strFiles = Get-ChildItem $strTFolder -Include $strExtension -Recurse | Where {$_.LastWriteTime -le $dateLastWrite}
Remove-HostLog -strFiles $strFiles

$strFiles = Get-ChildItem $strMS2TFolder -Include $strExtension -Recurse | Where {$_.LastWriteTime -le $dateLastWrite}
Remove-HostLog -strFiles $strFiles