@echo off
:: Sunbringer Astral installer for Windows: runs install.ps1 from this folder, or
:: the published copy when this file was downloaded on its own.  Arguments
:: pass through, for example:  install.cmd -Version v1.4.3.b3.3.4
setlocal
if "%REMIELLE_REPO%"=="" (set "REPO=thaxao/Sunbringer-Astral") else (set "REPO=%REMIELLE_REPO%")
where powershell >nul 2>nul
if errorlevel 1 (
    echo PowerShell is needed ^(it comes with Windows 10 and 11^).
    exit /b 1
)
if exist "%~dp0install.ps1" goto local
rem Arguments with spaces or quotes would be mangled inside a -Command string,
rem so download the script and run it with -File, which parses %* natively.
set "RA_PS1=%TEMP%\sunbringer-astral-install.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; Invoke-RestMethod -UseBasicParsing 'https://raw.githubusercontent.com/%REPO%/main/tools/install.ps1' -OutFile $env:RA_PS1"
if errorlevel 1 (
    echo Could not download install.ps1 from %REPO%.
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%RA_PS1%" %*
set "CODE=%ERRORLEVEL%"
del "%RA_PS1%" 2>nul
goto finish
:local
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
set "CODE=%ERRORLEVEL%"
:finish
:: Opened by a double click: keep the window until the result is read.
echo %CMDCMDLINE% | find /i "%~0" >nul && pause
exit /b %CODE%
