@echo off & chcp 65001 >NUL & setlocal ENABLEDELAYEDEXPANSION
@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION

@REM %1 - 1cv8.exe path ("C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe")
@REM %2 - base path
@REM %3 - dump file path
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

set "_dumpPath=%3"
if "%_dumpPath:"=%" equ "" goto :setDumpPath
goto :skipSetDumpPath
:setDumpPath
set /p "_dumpPath=Папка для выгрузки базы: " || goto :setDumpPath
:skipSetDumpPath
set "_dumpPath="%_dumpPath:"=%""
mkdir %_dumpPath%

call :setDumpFile

set "_logPath=%4"
if "%_logPath:"=%" equ "" goto :setLogPath
goto :skipSetLogPath
:setLogPath
set /p "_logPath=Путь для лога выгрузки базы: " || goto :setLogPath
:skipSetLogPath
set "_logPath="%_logPath:"=%""
:: block users
:baseDump
echo Выгрузка информационной базы.
start "Выгрузка информационной базы" /b /wait %_startFile% DESIGNER /F %_basePath% /WA- /UCКодРазрешения /DumpIB%_dumpFile% /Out%_logPath% -NoTruncate
if errorlevel 1 (
  echo Не удалось выгрузить базу.
  pause
  goto :baseDump
)
echo База выгружена.

echo Копирование базы
robocopy %_basePath% %_dumpPath% "1Cv8.1CD"
exit /b

:setDumpFile
set "_time=%TIME: =0%"
set "_year=%DATE:~6,4%"
set "_month=%DATE:~3,2%"
set "_day=%DATE:~0,2%"
set "_hour=%_time:~0,2%"
set "_minute=%_time:~3,2%"
set "_dumpFile="%_dumpPath:"=%\%_year%-%_month%-%_day%_%_hour%%_minute%.dt""
exit /b