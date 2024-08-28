@echo off
cd /d "%~dp0"
:: Check if the batch file is running as an administrator
net session >nul 2>&1
if %errorlevel% == 0 (
  goto :admin_mode
) else (
  echo [ARDAT][ERROR]: This batch file must be run as an administrator.
  echo [ARDAT][INFO]: Right-click the batch file and select "Run as administrator" to continue.
  pause
  exit /b 1
)

:admin_mode

:: Check if the custom parameter is provided
if "%1" NEQ "optimizeSystem" (
  echo [ARDAT][ERROR]: You can't open this file manually
  echo [ARDAT][INFO]: Use the launcher instead!
  pause
  exit /b 1
)

:: Disable unnecessary startup programs
echo Disabling unnecessary startup programs...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "iTunesHelper" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Skype" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Steam" /f

:: Disable Windows Search indexing
echo [ARDAT][INFO]: Disabling Windows Search indexing...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableSearchIndexing" /t REG_DWORD /d 1 /f

:: Disable Windows Defender
echo [ARDAT][INFO]: Disabling Windows Defender...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f

:: Clear system temp files
echo [ARDAT][INFO]: Clearing system temp files...
del /q /s /f "%TEMP%\*"
del /q /s /f "%TMP%\*"
del /q /s /f "%WINDIR%\Temp\*"

:: Clear browser cache and temp files
echo Clearing browser cache and temp files...
rmdir /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
rmdir /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Media Cache"
rmdir /q /s "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
del /q /s /f "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*"

:: Disable unnecessary system services
echo [ARDAT][INFO]: Disabling unnecessary system services...
sc config WerSvc start= disabled
sc config wscsvc start= disabled
sc config WSearch start= disabled
sc config WindowsUpdate start= disabled
sc config HomeGroupListener start= disabled
sc config HomeGroupProvider start= disabled
sc config SSDPSRV start= disabled
sc config upnphost start= disabled

:: Disable unnecessary services
echo Disabling unnecessary services...
net stop "Windows Search"
net stop "Windows Defender"
net stop "Windows Update"
net stop "Superfetch"
net stop "Hibernate"
net stop "Sleep"
net stop "Windows Firewall"
net stop "Windows Error Reporting"
net stop "Windows Customer Experience Improvement Program"

:: Optimize system performance
echo [ARDAT][INFO]: Optimizing system performance...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 1 /f

:: Disable unnecessary visual effects
echo [ARDAT][INFO]: Disabling unnecessary visual effects...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f

:: Run disk cleanup
echo [ARDAT][INFO]: Running disk cleanup...
cleanmgr /sagerun:1

:: Disable telemetry
echo [ARDAT][INFO]: Disabling Windows Telemetry...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

:: Optimize network settings
echo [ARDAT][INFO]: Optimizing network settings...
netsh interface tcp set global autotuninglevel=disabled
netsh interface tcp set global chimney=disabled
netsh interface tcp set global congestionprovider=none

:: Clean up Windows Update components
echo [ARDAT][INFO]: Cleaning up Windows Update components...
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 Catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver

:: Restart system services
echo [ARDAT][INFO]: Restarting system services...
net start WerSvc
net start wscsvc
net start WSearch
net start WindowsUpdate

:: Display completion message
echo [ARDAT][INFO]: Optimization complete!
