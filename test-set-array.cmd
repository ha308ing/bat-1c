:: set test
@echo off & chcp > 65001 & setlocal ENABLEDELAYEDEXPANSION

set bases=legion_hrm legion_corp profi_sn
set numberOfBases=0
set step=0

echo 0: all
for %%i in (%bases%) do (
  set /a numberOfBases=!numberOfBases!+1
  echo !numberOfBases!: %%i
)

:: echo numberOfBases: %numberOfBases%

:doSelect
echo;
set /p select="What to copy: "

if %select% EQU 0 goto all
if %select% EQU 1 goto legion_hrm
if %select% EQU 2 goto legion_corp
if %select% EQU 3 goto profi_sn

:wrongSelect
echo Wrong selection. Select from 0 to %numberOfBases%
goto doSelect

:all
echo;
echo copy all

:step0
:legion_hrm
echo;
SET BASE_DIR=legion_hrm
SET BASE_TYPE=hrm
echo copy legion_hrm
goto update
if %select% NEQ 0 goto end

:step1
:legion_corp
echo;
SET BASE_DIR=legion_corp
SET BASE_TYPE=corp
echo copy legion_corp
goto update
if %select% NEQ 0 goto end

:step2
:profi_sn
echo;
SET BASE_DIR=profi_sn
SET BASE_TYPE=basic
echo copy profi_sn
goto update
if %select% NEQ 0 goto end

:update
echo update %BASE_TYPE% %BASE_DIR%
if %select% EQU 0 (
  set /a step=%step%+1
  echo next step: !step!
  if !step! LSS %numberOfBases% goto step!step!
)

:end
echo;
echo copy finished

