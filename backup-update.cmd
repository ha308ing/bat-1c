:: set test
@echo off & chcp 65001 > NUL & setlocal ENABLEDELAYEDEXPANSION
:: rename BASE_DIR to BASE_NAME
:: add /out%log% to 1c commands
set step=0
set numberOfBases=0
set bases=TimberDis ProfiSN
set updates_dir=D:\Ivan\1C\tmplts\1c
SET processName=1cv8
SET UNLOCK_CODE=КодРазрешения
SET START_FILE="C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe"
SET BASES_DIR=D:\Ivan\1C\Bases
SET BACKUP_DIR=D:\Ivan\1C\Backup
SET LOGS_DIR=D:\Ivan\1C\Log

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
if %select% EQU 1 goto TimberDis
if %select% EQU 2 goto ProfiSN
:: if %select% EQU 3 goto ProfiSN_HRM
:: if %select% EQU 1 goto ProfiSN
:: if %select% EQU 2 goto ProfiSN_HRM
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
:TimberDis
echo.
SET BASE_NAME=TimberDis
SET BASE_TYPE=AccountingBase
SET CURRENT_VERSION=3_0_138_25
echo %select%: TimberDis
echo.
goto copy

:step1
:ProfiSN
echo.
SET BASE_NAME=ProfiSN
SET BASE_TYPE=AccountingBase
SET CURRENT_VERSION=3_0_138_24
echo %select%: ProfiSN
echo.
goto copy

:step31
:Legion_HRM
goto next
echo.
SET BASE_NAME=Legion_HRM
SET BASE_TYPE=HRM
SET CURRENT_VERSION=0
echo %select%: Legion_HRM
echo.
goto copy

:step32
:ProfiSN_HRM
goto next
echo.
SET BASE_NAME=ProfiSN_HRM
SET BASE_TYPE=HRM
SET CURRENT_VERSION=0
echo %select%: ProfiSN_HRM
echo.
goto copy

:step20
:ProfiSN
goto next
echo.
SET BASE_NAME=ProfiSN
SET BASE_TYPE=AccountingBase
SET CURRENT_VERSION=0
echo %select%: ProfiSN
echo.
goto copy

:step21
:ProfiSN_HRM
goto next
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
echo Резервное копирование %BASE_NAME%..
:: lock users
echo Блокировка пользователей..
start "Блокировка работы пользователей" /b /wait %START_FILE% ENTERPRISE /DisableStartupDialogs /F "%BASES_DIR%\%BASE_NAME%" /WA- /CЗавершитьРаботуПользователей /UC%UNLOCK_CODE% /Out%LOGS_DIR%\%BASE_NAME%.log -NoTruncate
if errorlevel 0 (
  echo Работа пользователей завершена..
) else (
  echo Не удалось завершить работу пользователей. Продолжить?.
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
echo Завершение процессов 1С..
taskkill /f /fi "IMAGENAME eq %processName%*" 2>&1 >NUL
if errorlevel 1 (
  echo Не удалось завершить процессы %processName%. Попробуйте самостоятельно..
  pause
) else (
  echo %processName% процессы завершены...
)
goto :findProcess

:: no 1c processes found
:noProcess
echo Процессов 1С не обнаружено..
:: backup base
:doBackup
echo Создание резервной копии %BASE_NAME%..
echo Копирование файла 1CD..
xcopy /Y %BASES_DIR%\%BASE_NAME%\1Cv8.1CD %BACKUP_DIR%\%BASE_NAME%\ 2>&1 >NUL
if errorlevel 1 (
  echo Копирование не удалось.. 2>&1
) else (
  echo Копирование завершено..
  if exist %BACKUP_DIR%\%BASE_NAME%\1Cv8.1CD (
    echo Проверка: копия создана..
  ) else (
    echo Проверка: копия на создана..
  )
)
set timeNoSpace=%TIME: =0%
set DUMP_FILE=%BACKUP_DIR%\%BASE_NAME%\%BASE_NAME%_%date:~6,4%-%date:~3,2%-%date:~0,2%_%timeNoSpace:~0,2%%timeNoSpace:~3,2%.dt
echo Выгрузка информационной базы: %DUMP_FILE%
if exist %DUMP_FILE% goto noBackup
start "Выгрузка информационной базы" /b /wait %START_FILE% DESIGNER /F "%BASES_DIR%\%BASE_NAME%" /WA- /UC%UNLOCK_CODE% /DumpIB%DUMP_FILE% /Out%LOGS_DIR%\%BASE_NAME%.log -NoTruncate
if errorlevel 0 (
  echo Выгрузка информационной базы завршена успешно..
) else (
  echo Выгрузка информационной базы не удалась..
  rem goto unlockUsers
)
if %operation% EQU 1 (
  goto noupdate
) else (
  goto update
)
:noBackup
echo Выгрузка информационной базы уже существует..
if %operation% EQU 1 goto noupdate

:update
echo Обновление базы %BASE_TYPE% %BASE_NAME%
for /f "usebackq" %%i in (`dir /b /ad /on %updates_dir%\%BASE_TYPE%`) do (
  if "%CURRENT_VERSION%" geq "%%i" (
    echo Пропуск версии %%i..
  ) else (
rem ================================================================
    rem do updates
    echo Обновление %BASE_NAME% до версии %%i
    set CF_FILE=%updates_dir%\%BASE_TYPE%\%%i\1cv8.cfu
    echo Файл обновления: !CF_FILE!
    if not exist !CF_FILE! (
      echo Файл обновления не найден - отмена обновления..
      goto unlockUsers
    )
    rem Каталог не обнаружен 'D:\3_0_136_32\1cv8.cfu'. 3(0x00000003): Системе не удается найти указанный путь. 
    start "Обновление конфигурации" /b /wait %START_FILE% DESIGNER /DisableStartupDialogs /F "%BASES_DIR%\%BASE_NAME%" /WA- /UC%UNLOCK_CODE% /UpdateCfg !CF_FILE! /UpdateDBCfg -Dynamic- / -WarningsAsErrors /Out%LOGS_DIR%\%BASE_NAME%.log -NoTruncate
rem ================================================================
    if errorlevel 0 (
      echo Обновление до версии %%i завершно успешно..
      set CURRENT_VERSION=%%i
    ) else (
      echo Обновление не удалось..
      goto unlockUsers
    )
  )
)


:noupdate
:: unlock users
:unlockUsers
echo Снятие блокировки пользователей..
start "Снятие блокировки пользователей" /b /wait %START_FILE% ENTERPRISE /DisableStartupDialogs /F "%BASES_DIR%\%BASE_NAME%" /WA- /C "РазрешитьРаботуПользователей" /UC%UNLOCK_CODE% /Out%LOGS_DIR%\%BASE_NAME%.log -NoTruncate
if errorlevel 0 (
  echo Блокировка пользователей снята..
) else (
  echo Не удалось снять блокировку пользователей..
)
if %select% NEQ 0 goto end

:next
if %select% EQU 0 (
  set /a step=%step%+1
  if !step! LSS %numberOfBases% goto step!step!
)

:end
echo.
echo Конец
