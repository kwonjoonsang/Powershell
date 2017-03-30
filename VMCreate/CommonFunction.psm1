Function Get-WebCredential()
{
    $strUserInfo = Get-Content .\UserInfo.txt
    $arrUserInfo = $strUserInfo.Split("`t")

    $strUser = $arrUserInfo[0].ToString()
    $strPassword = $arrUserInfo[1].ToString()
    $strPassword = ConvertTo-SecureString $strPassword -AsPlainText -Force

    $autCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $strUser,$strPassword

    return $autCredential
}

Function Get-HostInfo()
{
    $strHostInfo = Get-Content .\Host.txt
    $arrHostInfo = $strHostInfo.Split("`n")

    return $arrHostInfo
}

Function Test-FileMove
{
    Param
    (
        [String] $strCFile,
        [String] $strDFile
    )

    $bolFileMove = $true
    $bolCFile = $true
    $bolDFile = $true

    Write-Host "3" + $strCFile
    Write-Host "4" + $strDFile
    $bolCFile = Test-Path $strCFile
    $bolDFile = Test-Path $strDFile

    if ($bolCFile -eq $false -or $bolDFile -eq $false)
    {
        $bolFileMove = $false
    }

    return $bolFileMove
}