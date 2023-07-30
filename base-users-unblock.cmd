@echo off & chcp 65001 >NUL & setlocal ENABLEDELAYEDEXPANSION
@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION

@REM %1 - 1cv8.exe path ("C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe")
@REM %2 - base path
@REM %3 - log path

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

set "_logPath=%3"
if "%_logPath:"=%" equ "" goto :setLogPath
goto :skipSetLogPath
:setLogPath
set /p "_logPath=Путь для лога снятия блокировки пользователей базы: " || goto :setLogPath
:skipSetLogPath
set "_logPath="%_logPath:"=%""
:: unlock users
:unlockUsers
echo Снятие блокировки пользователей.
start "Снятие блокировки пользователей" /b /wait %_startFile% ENTERPRISE /DisableStartupDialogs /F %_basePath% /WA- /CРазрешитьРаботуПользователей /UCКодРазрешения /Out%_logPath% -NoTruncate
if errorlevel 1 (
  echo Не удалось снять блокировку пользователей.
  pause
  goto :unlockUsers
)
echo Блокировка пользователей снята.
exit /b
