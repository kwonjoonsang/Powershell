# Powershell
Windows 관리하면서 사용한 Powershell 모음입니다.

## ADJoin
> AD Join을 자동으로 시켜주는 Powershell

* 설정 파일 정보
  * Group.txt : Local Administrators 그룹에 넣을 Group 정보 
  * UserInfo.txt : AD Join 시 사용할 Account Info

* 사용 방법
  ``` powershell
    DomainJoin.ps1 -strDomainNM [Join할 Domain Name] -strUser [Domain할 때 사용하는 Account Info]
  ```

## LogBackup
> Log Backup, Log Delete, Email 전송등 Log 관리할 수 있는 Script


## VMCreate
> Hyper-V 가상화 환경에서 VM을 Create하는 Script
