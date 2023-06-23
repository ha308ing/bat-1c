:: set test
@echo off & chcp 65001 > NUL & setlocal ENABLEDELAYEDEXPANSION

set bases=ProfiSN ProfiSN_HRM
set updates_dir=%APPDATA%\1C\1cv8\tmplts\1c
set numberOfBases=0
set step=0

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
SET BASE_DIR=ProfiSN
SET BASE_TYPE=AccountingBase
SET CURRENT_VERSION=0
echo %select%: ProfiSN
echo.
goto copy

:step1
:ProfiSN_HRM
echo.
SET BASE_DIR=ProfiSN_HRM
SET BASE_TYPE=HRM
SET CURRENT_VERSION=0
echo %select%: ProfiSN_HRM
echo.
goto copy

:step10
:legion_hrm
goto next
echo.
SET BASE_DIR=legion_hrm
SET BASE_TYPE=HRM
SET CURRENT_VERSION=0
echo %select%: legion_hrm
echo.
goto copy

:step11
:legion_corp
goto next
echo.
SET BASE_DIR=legion_corp
SET BASE_TYPE=AccountingCorp
SET CURRENT_VERSION=0
echo %select%: legion_corp
echo.
goto copy

:step12
:profi_sn
goto next
echo.
SET BASE_DIR=profi_sn
SET BASE_TYPE=AccountingBase
SET CURRENT_VERSION=0
echo %select%: profi_sn
echo.
goto copy

:copy
echo copy %BASE_TYPE% %BASE_DIR%
if %operation% EQU 1 goto noupdate

:update
echo update %BASE_TYPE% %BASE_DIR%
for /f "usebackq" %%i in (`dir /b /ad /on %updates_dir%\%BASE_TYPE%`) do (
  if "%CURRENT_VERSION%" GTR "%%i" (
    echo Skip %%i update..
  ) else (
    echo Do %%i update..
    if errorlevel 0 (
      echo Update to version %%i succeeded..
      set CURRENT_VERSION=%%i
    ) else (
      echo Update failed..
    )
  )
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
