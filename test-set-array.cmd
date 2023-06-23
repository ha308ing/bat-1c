:: set test
@echo off & chcp 65001 > NUL & setlocal ENABLEDELAYEDEXPANSION
:: rename BASE_DIR to BASE_NAME
:: add /out%log% to 1c commands
set step=0
set numberOfBases=0
set bases=ProfiSN ProfiSN_HRM
set updates_dir=%APPDATA%\1C\1cv8\tmplts\1c
SET processName=1cv8
SET UNLOCK_CODE=КодРазрешения
SET START_FILE="C:\Program Files\1cv8\8.3.22.1750\bin\1cv8.exe"
SET BASES_DIR=Y:\1С\Bases
SET BACKUP_DIR=Y:\1С\Bases\Backups
SET LOGS_DIR=Y:\1С\Bases\Logs

:selOperation
echo.
echo Резервная копия или обновление?
echo 1. Копия
echo 2. Обновление
echo 3. Выход
set /p operation="Выберете действие: "

if %operation% EQU 3 (
  echo.
  echo %operation%: Выход
  goto :EOF
)
if %operation% LSS 1 goto selOperation
if %operation% GTR 3 goto selOperation

echo.
if %operation% EQU 1 echo %operation%: Копия
if %operation% EQU 2 echo %operation%: Обновление

echo.
echo 0: Все
for %%i in (%bases%) do (
  set /a numberOfBases=!numberOfBases!+1
  echo !numberOfBases!: %%i
)

:: echo numberOfBases: %numberOfBases%

:doSelect
set /p select="Выберете базу: "
:: support set of options, i.e.  input: 1 3
if %select% EQU 0 goto all
if %select% EQU 1 goto ProfiSN
if %select% EQU 2 goto ProfiSN_HRM
:: if %select% EQU 1 goto legion_hrm
:: if %select% EQU 2 goto legion_corp
:: if %select% EQU 3 goto profi_sn

:wrongSelect
echo Wrong selection. Select from 0 to %numberOfBases%
goto doSelect

:all
echo.
echo %select%: Все

:step0
:ProfiSN
echo.
SET BASE_NAME=ProfiSN
SET BASE_TYPE=AccountingBase
SET CURRENT_VERSION=0
echo %select%: ProfiSN
echo.
goto copy

:step1
:ProfiSN_HRM
echo.
SET BASE_NAME=ProfiSN_HRM
SET BASE_TYPE=HRM
SET CURRENT_VERSION=0
echo %select%: ProfiSN_HRM
echo.
goto copy

:step10
:legion_hrm
goto next
echo.
SET BASE_NAME=legion_hrm
SET BASE_TYPE=HRM
SET CURRENT_VERSION=0
echo %select%: legion_hrm
echo.
goto copy

:step11
:legion_corp
goto next
echo.
SET BASE_NAME=legion_corp
SET BASE_TYPE=AccountingCorp
SET CURRENT_VERSION=0
echo %select%: legion_corp
echo.
goto copy

:step12
:profi_sn
goto next
echo.
SET BASE_NAME=profi_sn
SET BASE_TYPE=AccountingBase
SET CURRENT_VERSION=0
echo %select%: profi_sn
echo.
goto copy

:copy
echo Backup %BASE_NAME%
:: lock users
echo Locking users..
start "Блокировка работы пользователей" /b /wait %START_FILE% ENTERPRISE /DisableStartupDialogs /F "%BASES_DIR%\%BASE_NAME%" /WA- /CЗавершитьРаботуПользователей /UC%UNLOCK_CODE% /Out%LOGS_DIR%\%BASE_NAME%.log -NoTruncate 2>&1 >NUL
if errorlevel 0 (
  echo Работа пользователей завершена
) else (
  echo Не удалось завершить работу пользователей. Продолжить?
)
:: find 1c processes
:findProcess
tasklist /fi "IMAGENAME eq %processName%*" /nh | findstr /i /c:%processName% >NUL
if errorlevel 1 (
	goto :noProcess
) ELSE (
	goto :endProcess
)
:: 1c processes found - ending
:endProcess
echo Ending 1C processes..
tskill *1cv8* /a /v
if errorlevel 1 (
  echo Failed to end %processName% process. Try manually and continue..
  pause
  goto :findProcess
) else (
  echo %processName% processes have been ended continue...
  goto :doBackup
)
:: no 1c processes found
:noProcess
echo No 1C processes found. Continue..
:: backup base
:doBackup
echo Creating %BASE_NAME% backup..
echo Copying 1CD file..
xcopy /Y %BASES_DIR%\%BASE_NAME%\1Cv8.1CD %BACKUP_DIR%\%BASE_NAME%\ 2>&1 >NUL
if errorlevel 1 (
  echo Copy failed.. 2>&1
) else (
  echo copy finished
  if exist %BACKUP_DIR%\%BASE_NAME%\1Cv8.1CD (
    echo Copy check: target file exists.. Ok
  ) else (
    echo Copy check: target file doesn't exist.. Failed
  )
)
set DUMP_FILE=%BACKUP_DIR%\%BASE_NAME%\%BASE_NAME%_%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%%time:~3,2%.dt
echo Creating DB dump file: %DUMP_FILE%
if exist %DUMP_FILE% goto noBackup
start "Backup Information Base" /b /wait %START_FILE% DESIGNER /F "%BASES_DIR%\%BASE_NAME%" /WA- /UC%UNLOCK_CODE% /DumpIB%DUMP_FILE% /Out%LOGS_DIR%\%BASE_NAME%.log -NoTruncate 2>&1 >NUL
if errorlevel 0 (
  echo DB dump creation succeeded..
) else (
  echo DB dump creation failed..
  rem goto unlockUsers
)
:noBackup
echo DB dump file file already exists..
if %operation% EQU 1 goto noupdate

:update
echo update %BASE_TYPE% %BASE_NAME%
for /f "usebackq" %%i in (`dir /b /ad /on %updates_dir%\%BASE_TYPE%`) do (
  if "%CURRENT_VERSION%" gtr "%%i" (
    echo Skip %%i update..
  ) else (
::================================================================
    :: do updates
    echo Updating %BASE_NAME% to %%i version
    set CF_DIR=%updates_dir%\%BASE_TYPE%\%%i
    set CF_FILE=%CF_DIR%\%%i\1cv8.cfu
    start "Update to %%i version" /b /wait %START_FILE% DESIGNER /DisableStartupDialogs /F "%BASES_DIR%\%BASE_NAME%" /WA- /UC%UNLOCK_CODE% /UpdateCfg !CF_FILE! /UpdateDBCfg -Dynamic- / -WarningsAsErrors /Out%LOGS_DIR%\%BASE_NAME%.log -NoTruncate
::================================================================
    if errorlevel 0 (
      echo Update to version %%i succeeded..
      set CURRENT_VERSION=%%i
    ) else (
      echo Update failed..
      goto unlockUsers
    )
  )
)
:: unlock users
:unlockUsers
echo Unlocking users..
start "Unlocking users" /b /wait %START_FILE% ENTERPRISE /DisableStartupDialogs /F "%BASES_DIR%\%BASE_NAME%" /WA- /C "РазрешитьРаботуПользователей" /UC%UNLOCK_CODE% /Out%LOGS_DIR%\%BASE_NAME%.log -NoTruncate 2>&1 >NUL
if errorlevel 0 (
  echo Работа пользователей разрешена
) else (
  echo Не удалось разрешить работу пользователей
)
if %select% NEQ 0 goto end

:noupdate
:next
if %select% EQU 0 (
  set /a step=%step%+1
  if !step! LSS %numberOfBases% goto step!step!
)

:end
echo.
echo finished
