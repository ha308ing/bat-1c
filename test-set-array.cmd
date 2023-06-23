:: set test
@echo off & chcp 65001 > NUL & setlocal ENABLEDELAYEDEXPANSION

set bases=legion_hrm legion_corp profi_sn
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
if %select% EQU 1 goto legion_hrm
if %select% EQU 2 goto legion_corp
if %select% EQU 3 goto profi_sn

:wrongSelect
echo Wrong selection. Select from 0 to %numberOfBases%
goto doSelect

:all
echo.
echo %select%: Все

:step0
:legion_hrm
echo.
SET BASE_DIR=legion_hrm
SET BASE_TYPE=hrm
echo %select%: legion_hrm
echo.
goto copy

:step1
:legion_corp
echo.
SET BASE_DIR=legion_corp
SET BASE_TYPE=corp
echo %select%: legion_corp
echo.
goto copy

:step2
:profi_sn
echo.
SET BASE_DIR=profi_sn
SET BASE_TYPE=basic
echo %select%: profi_sn
echo.
goto copy

:copy
echo copy %BASE_TYPE% %BASE_DIR%
if %operation% EQU 1 goto noupdate

:update
echo update %BASE_TYPE% %BASE_DIR%
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
