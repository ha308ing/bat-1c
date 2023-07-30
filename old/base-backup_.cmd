@echo off & chcp 65001 >NUL & setlocal ENABLEDELAYEDEXPANSION
@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION

@REM %1 - 1cv8.exe path ("C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe")
@REM %2 - base path (1c\bases\AccountingBase)
@REM %3 - backup path (1c-backup\AccountingBase)
@REM %4 - log path
set "_time=%TIME: =0%"
set "_year=%DATE:~6,4%"
set "_month=%DATE:~3,2%"
set "_day=%DATE:~0,2%"
set "_hour=%_time:~0,2%"
set "_minute=%_time:~3,2%"
echo %_day%.%_month%.%_year% %_hour%:%_minute%
set "_dumpFile=%3\%~n2\%~n2_%_year%-%_month%-%_day%_%_hour%%_minute%.dt"
@REM echo base name: %~n2
echo Выгрузка информационной базы: %_dumpFile%
if exist %_dumpFile% (
    echo Выгрузка уже существует.
    exit /b
)
:createDump
start "Выгрузка информационной базы" /b /wait %1 DESIGNER /F %2 /WA- /UCКодРазрешения /DumpIB%_dumpFile% /Out%4 -NoTruncate
if errorlevel 1 (
  echo Выгрузка информационной базы не удалась.
  pause
  goto :createDump
) 
echo Выгрузка информационной базы завршена успешно.
:createCopy
echo Копирование базы.
robocopy %2 "%3\%~n2\%~n2" 1cv8.1CD
if errorlevel 1 (
    echo Не удалось скопировать базу.
    pause
    goto :createCopy
)
echo База %~n2 скопирована.
exit /b