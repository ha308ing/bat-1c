@echo off & chcp 65001 >NUL & setlocal ENABLEDELAYEDEXPANSION
@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION

@REM %1 - 1cv8.exe path ("C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe")
@REM %2 - base path
@REM %3 - update file (.cfu file)
@REM %4 - log path

set "_startFile=%1"
if "%_startFile:"=%" equ "" goto :setStartFile
goto :checkStartFile
:setStartFile
set /p "_startFile=Путь 1cv8.exe: " || goto :setStartFile
:checkStartFile
set "_startFile="%_startFile:"=%""
echo %_startFile%| findstr /iec:"1cv8.exe""" >NUL
if errorlevel 1 (
  echo Путь должеть быть до 1cv8.exe
)
if not exist %_startFile% (
  echo Файл %_startFile% не найден.
  goto :setStartFile
)

set "_basePath=%2"
if "%_basePath:"=%" equ "" goto :setBasePath
goto :checkBasePath
:setBasePath
set /p "_basePath=Путь базы: " || goto :setBasePath
:checkBasePath
set "_basePath="%_basePath:"=%""
dir /b /a:-d "%_basePath:"=%\1Cv8.1CD" >NUL
if errorlevel 1 (
  echo Путь не содержит файл 1Cv8.1CD
  goto :setBasePath
)

set "_updateFile=%3"
if "%_updateFile:"=%" equ "" goto :setUpdateFile
goto :checkUpdateFile
:setUpdateFile
set /p "_updateFile=Файл обновления базы (.cfu): " || goto :setUpdateFile
:checkUpdateFile
set "_updateFile="%_updateFile:"=%""
echo %_updateFile%| findstr /iec:".cfu""" >NUL
if errorlevel 1 (
  echo Файл обновления должен иметь разширение .cfu
)
if not exist %_updateFile% (
  echo Файл обновления не найден %_updateFile%
  goto :setUpdateFile
)

set "_logPath=%4"
if "%_logPath:"=%" equ "" goto :setLogPath
goto :skipSetLogPath
:setLogPath
set /p "_logPath=Путь для лога обновления базы: " || goto :setLogPath
:skipSetLogPath
set "_logPath="%_logPath:"=%""
:: unlock users
:baseUpdate
echo Обновление базы.
start "Обновление конфигурации" /b /wait %_startFile% DESIGNER /DisableStartupDialogs /F %_basePath% /WA- /UCКодРазрешения /UpdateCfg %_updateFile% /UpdateDBCfg -Dynamic- /BackgroundStart /WarningsAsErrors /Out%_logPath% -NoTruncate
if errorlevel 1 (
  echo Не удалось обновить базу.
  exit /b 1
)
echo База обновлена.
exit /b
