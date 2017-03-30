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

Function Get-Hostname
{
    Param
    (
        $Session
    )

    $strHostname = Invoke-Command -Command { Hostname } -Session $Session

    return $strHostname
}

Function Set-FileCopy
{
    Param
    (
        $LogDir,
        $CLogDir,
        $LogList
    )
    
    Robocopy $LogDir $CLogDir $LogList /CopyAll
}

Function Set-Analyze
{
    Param
    (
        $strHostName,
        $strDomain,
        $strCLogDir,
        $strLogList
    )

    $arrDate = $strLogList.ToString().Split(".")
    $strDate = $arrDate[0].Replace("u_","")
    $strDate = $strDate.Replace("ex","20")
    $strDFile = $strCLogDir + "\" + $strLogList
    $strSQL = "`"SELECT `'" + $strDate + "`', `'" + $strDomain + "`', `'" + $strHostName + "`', sc-status, Count(*) AS Cnt Into tblStatusCnt FROM " + $strDFile + " GROUP BY sc-status ORDER BY sc-status`""
    
    logparser.exe $strSQL -server:127.0.0.1 -database:IISAnal -dsn:IISAnal -o:sql
}

Function Set-Compress
{
    Param
    (
        $CLogDir,
        $LogList
    )

    $strLogList = $LogList.ToString()
    Write-Host "Compress : " $CLogDir + " " + $LogList
    $strCompressFile = $CLogDir + "\" + $strLogList.Replace('log', 'zip')
    $strDFile = $CLogDir + "\" + $strLogList

    7z a -tzip $strCompressFile $strDFile
    Remove-Item $strDFile 

}

Function Get-BDayLog
{
    Param
    (
        $intDay
    )

    $dateToday = Get-Date
    $dateBDate = $dateToday.AddDays($intDay * -1)
    $strBDate = $dateBDate.ToString("yyMMdd")

    $strDay = "ex" + $strBDate + ".log"

    return $strDay

}

<#
Function Get-BDayLog
{
    Param
    (
        $LogList
    )

    $LogList = $LogList.ToString()
    $strDay = $LogList.Replace("ex", "")
    $strDay = $strDay.Replace("u_", "")
    $strDay = $strDay.Replace(".log", "")
    $strDay = "20" + $strDay
    
    $strBDay = Get-BDay -strDate $strDay -intDay 1
    $strDay = "ex" + $strBDay.SubString(2,6) + ".log"

    return $strDay

}
#>

Function Get-BDay
{
    Param
    (
        $strDate
    ,   $intDay
    )

    $dateFDate = [dateTime]::ParseExact($strDate, "yyyyMMdd", $null)
    $dateBDate = $dateFDate.AddDays($intDay * -1)
    $strBDate = $dateBDate.ToString("yyyyMMdd")

    return $strBDate
}

#Before 1 Day 
Function Get-LogData
{
    Param
    (
        $strLogDir,
        $Session
    )

    $dateDate = Invoke-Command -Command { Get-Date } -Session $Session
    $strDate = $dateDate.AddDays(-1).ToString("yyMMdd")
    $strLogs = "*" + $strDate + "*"
    $strCmd = {  Set-Location "$using:strLogDir" }
    Invoke-Command -Command $strCmd -Session $Session
    $strCmd = {  Get-ChildItem "$using:strLogs" -Name }
    $strLog = Invoke-Command -Command $strCmd -Session $Session

    return $strLog
}

#Before 1 Day 
Function Get-LogData1
{
    Param
    (
        $strLogDir,
        $Session
    )

    $strDate = Invoke-Command -Command { Get-Date } -Session $Session

    $strCmd = {  Get-ChildItem "$using:strLogDir" }
    $strLog = Invoke-Command -Command $strCmd -Session $Session

    $strLogLists = $strLog | Where-Object{$_.CreationTime -gt $strDate.AddDays(-3)} | Where-Object{$_.CreationTime -lt $strDate.AddDays(-1)}

    return $strLogLists
}

#Before intDay Day
Function Get-BeforeLogData
{
    Param
    (
        $strLogDir,
        $intDay,
        $Session
    )

    $strDate = Invoke-Command -Command { Get-Date } -Session $Session

    $strCmd = {  Get-ChildItem "$using:strLogDir" }
    $strLog = Invoke-Command -Command $strCmd -Session $Session
    
    [int]$intDDay = [Convert]::ToInt32($intDay)
    $intDDay = $intDDay * -1

    $strDelDate = $strDate.AddDays($intDDay)
    $strLogLists = $strLog | Where-Object{$_.CreationTime -lt $strDelDate}

    return $strLogLists
}

#Data All Copy
Function Get-AllLogData
{
    Param
    (
        $strRLogDir,
        $Session
    )

    $strDate = Invoke-Command -Command { Get-Date } -Session $Session
    
    $strCmd = { Get-ChildItem "$using:strRLogDir" }
    $strLog = Invoke-Command -Command $strCmd -Session $Session
    $strDelDate = $strDate.AddDays(-1)

    $strLogLists = $strLog | Where-Object{$_.LastWriteTime -lt $strDelDate} | Where-Object{$_.Length -gt 0}
    Write-Host $strLogLists

    return $strLogLists
}

Function Get-PubAddress
{
	$objNetworks = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.IPEnabled}

	ForEach ($objNetwork in $objNetworks)
	{
		$strIPAddress = $objNetwork.IPAddress[0]
	
		If ($strIPAddress.StartsWith("183") -eq $true)
		{
			$strPubAddress = $strIPAddress
		}
	}

	return $strPubAddress
}

Function Get-PriAddress
{
	$objNetworks = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.IPEnabled}

	ForEach ($objNetwork in $objNetworks)
	{
		$strIPAddress = $objNetwork.IPAddress[0]
	
		If (($strIPAddress.StartsWith("192") -eq $true) -or ($strIPAddress.StartsWith("10") -eq $true))
		{
			$strPriAddress = $strIPAddress
		}
	}

	return $strPriAddress
}

Function Get-L4Address
{
	$objNetworks = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.IPEnabled}

	ForEach ($objNetwork in $objNetworks)
	{
		$strIPAddress = $objNetwork.IPAddress[0]
	
		If ($strIPAddress.StartsWith("222") -eq $true)
		{
			$strPubAddress = $strIPAddress
		}
		ElseIf ($strIPAddress.StartsWith("220") -eq $true)
		{
			$strPubAddress = $strIPAddress
		}
	}

	return $strPubAddress
}

Function Get-IISWebsite
{
	Param
	(
		$sesConnection
	)
	Invoke-Command -Command { Import-Module WebAdministration } -Session $sesConnection
	$strSites = Invoke-Command -Command { Get-Website } -Session $sesConnection
    
	return $strSites
         
}

Function Get-IsBackupLog
{
    Param
    (
        $strLogName,
        $strCLogDir
    )
    $arrLogName = $strLogName.Split(".")
    $strBackupName = $arrLogName[0] + ".zip"

    $bolIsBackupFile = Test-Path $strCLogDir\$strBackupName

    $strBackupName2 = $arrLogName[0] + ".log"
    $bolIsBackupFile2 = Test-Path $strCLogDir\$strBackupName2

    If ($bolIsBackupFile -eq $true -or $bolIsBackupFile2 -eq $true)
    {
        return $true
    }
    Else
    {
        return $false
    }
}

Function Get-IsFile
{
    Param
    (
        $strFileName,
        $strCLogDir
    )

    $bolIsFile = $false
    $strFileName = $strCLogDir + "\" +$strFileName + "*"

    If (Test-Path $strFileName)
    {
        $bolIsFile = $true
    }
    
    return $bolIsFile
}

Function Remove-HostLog
{
    Param
    (
        $strFiles
    )

    $strDate = Get-Date
    $strDate = $strDate.ToString("yyyyMMdd")

    ForEach ($strFile in $strFiles)
    {
        If ($strFile -ne $NULL)
        {
            Write-Host "Deleting File $strFile" -ForegroundColor DarkRed
            "Deleting File $strFile" | Out-File D:\SE_DIR\Script\LogBackup\LOGS\$strDate.log -Append
            Remove-Item $strFile.FullName | Out-Null
        }
        Else
        {
            Write-Host "No More Files to Delete!" -ForegroundColor Cyan
        }
    }
}

Function Get-DayOfWeek
{
    Param
    (
        $strDayOfWeek
    )

    If ($strDayOfWeek -eq "Monday"){$strNum = '1'}
    If ($strDayOfWeek -eq "Tuesday"){$strNum = '2'}
    If ($strDayOfWeek -eq "Wednesday"){$strNum = '3'}
    If ($strDayOfWeek -eq "Thursday"){$strNum = '4'}
    If ($strDayOfWeek -eq "Friday"){$strNum = '5'}
    If ($strDayOfWeek -eq "Saturday"){$strNum = '6'}
    If ($strDayOfWeek -eq "Sunday"){$strNum = '0'}

    return $strNum

}