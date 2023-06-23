:: set test
@echo off & chcp 65001 > NUL & setlocal ENABLEDELAYEDEXPANSION

set updates_dir=%APPDATA%\1C\1cv8\tmplts\1c
echo %time:~0,5%

:selType
echo 1. HRM
echo 2. AccountingBase
echo 3. AccountingCorp
set /p type="Enter 1c type: "
if %type% LSS 1 goto selType
if %type% GTR 3 goto selType
if %type% EQU 1 set type=HRM
if %type% EQU 2 set type=AccountingBase
if %type% EQU 3 set type=AccountingCorp

if not exist %updates_dir%\%type% (
  echo no such dir:
  echo %updates_dir%\%type%
  goto end
)

for /f "usebackq" %%i in (`dir /b /on /ad %updates_dir%\%type%`) do (
  echo %%i
)

:end
echo.
echo finished
