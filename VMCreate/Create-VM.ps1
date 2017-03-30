Param
(
    #strGbn : Web, DB
    [Parameter(Mandatory=$true)]
    [String] $strGbn
)

Import-Module .\CommonFunction.psm1
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

If ($strGbn -eq "Web")
{
    $strSDirectory = "E:\Deploy\WEB"
}
ElseIf ($strGbn -eq "DB")
{
    $strSDirectory = "E:\Deploy\WEBDB"
}
Else
{
    $strSDirectory = ""
}

If ($strSDirectory -eq "")
{
    Write-Host "매개변수가 잘못 입력 되었습니다.(Web or DB)"
}
Else
{
    $arrHostInfo = Get-HostInfo
        
    ForEach ($strHostInfo In $arrHostInfo)
    {
        $arrServerInfo = $strHostInfo.Split("`t")

        $strHost = $arrServerInfo[0].ToString()
        $strVM = $arrServerInfo[1].ToString()

        $seeCredential = Get-Webcredential
        $sesConnection = New-PSSession -ComputerName $strHost -Credential $seeCredential

        $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Get-VM | findstr $strVM | Measure ")
	    $strSites = Invoke-Command -Command $strCmd -Session $sesConnection

        If ($bolISVM.Count -gt 0)
        {
            Write-Host $strVMNM + " 해당 VM은 이미 존재합니다."
        }
        Else
        {
            $strODirectory = "G:\VM"
            $strTDirectory = "\\" + $strHost + "\G$\VM\" + $strVM
            $strCFile = "Windows2012R2_C.vhdx"
            $strDFile = "Windows2012R2_D.vhdx"
            #중앙 서버에 있는 vhdx파일을 해당 Host의 G:\VM\[HostName] 밑으로 Copy 한다.
            robocopy $strSDirectory $strTDirectory $strCFile /NP
            robocopy $strSDirectory $strTDirectory $strDFile /NP

            $strCCVhdx = $strVM + "_C.vhdx"
            $strDCVhdx = $strVM + "_D.vhdx"
            $strVCFile = "G:\VM\" + $strVM + "\" + $strCCVhdx
            $strVDFile = "G:\VM\" + $strVM + "\" + $strDCVhdx
            #해당 서버 이름으로 vhdx 파일 이름을 수정한다.
            $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" New-Item -Type D $strTdirectory ")
	        $strSites = Invoke-Command -Command $strCmd -Session $sesConnection
            $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Set-Location $strTdirectory ")
	        $strSites = Invoke-Command -Command $strCmd -Session $sesConnection
            $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Rename-Item $strCFile $strCCVhdx ")
	        $strSites = Invoke-Command -Command $strCmd -Session $sesConnection
            $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Rename-Item $strDFile $strDCVhdx ")
	        $strSites = Invoke-Command -Command $strCmd -Session $sesConnection

            #해당 VM 이름으로 VM 생성
            $intMemSize = 4GB
            If ($strGbn -eq "Web")
            {
                $intCpuCnt = 8
            }
            Else
            {
                $intCpuCnt = 4
            }
            $intGeneration = 1
            $strSwitchName1 = "Private"
            $strSwitchName2 = "Public"

            try
            {
                $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" New-Vm -Name $strVM -MemoryStartupBytes $intMemSize -Generation $intGeneration -Path $strODirectory -VHDPath $strVCFile -SwitchName $strSwitchName1 ")
                Invoke-Command -Command $strCmd -Session $sesConnection
                If ($strGbn -eq "WEB")
                {
                    $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Add-VMNetworkAdapter -VMName $strVM -SwitchName $strSwitchName2 ")
                    Invoke-Command -Command $strCmd -Session $sesConnection
                }
                $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Set-VMProcessor -VMName $strVM -Count $intCpuCnt ")
                Invoke-Command -Command $strCmd -Session $sesConnection
                $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Add-VMHardDiskDrive -VMName $strVM -ControllerType SCSI -Path $strVDFile ")
                Invoke-Command -Command $strCmd -Session $sesConnection
                $strCmd = $ExecutionContext.InvokeCommand.NewScriptBlock(" Disable-VMIntegrationService -Name ""Time Synchronization"" -Vmname $strVM ")
                Invoke-Command -Command $strCmd -Session $sesConnection                               
            }
            catch
            {
            }
        }
    }
}