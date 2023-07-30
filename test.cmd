@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION
echo off & chcp 65001 & setlocal ENABLEDELAYEDEXPANSION


cls
call :printOptions

:getId
set /p "_baseId=Введите номер базы (0 - выбрать все): " || goto :getId
if "%_baseId%" equ "0" call :updateAll
for %%a in (%_baseId%) do (
    call :updateId %%a
)

exit /b

:printOptions
echo 0. Все
for /f "skip=1 usebackq delims====" %%a in (bases.txt) do (
    for /f "tokens=1-4,* delims=|" %%g in ("%%a") do (
        @REM echo "id (1): %%g"
        @REM echo "basePath (2): %%h"
        @REM echo "updatePath (3): %%i"
        @REM echo "currentVersion (4): %%j"
        @REM echo "title (5): %%k"
        echo %%g. %%k
    )
)
exit /b

:updateAll
for /f "skip=1 delims====" %%a in (bases.txt) do (
    call :updateString "%%a"
)
exit /b

:updateId
@REM %1 - id to filter string
findstr /r "^%1.*$" bases.txt >NUL
if errorlevel 1 goto :EOF
for /f "usebackq delims=" %%a in (`findstr /r "^%1.*$" bases.txt`) do (
    call :updateString "%%a"
)
exit /b

:updateString
@REM updateString(id basePath updatePath currentVersion title)
@REM %1 - string (should be in "")
for /f "tokens=1-4,* delims=|" %%g in (%1) do (
    call :updateBase "%%h" "%%i" %%j
)
exit /b

:updateBase
@REM %1 - basePath
@REM %2 - updatePath
@REM %3 - currentVersion
echo Update %1 from dir %2 from version %3
exit /b

:getDateTime
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
set "_dumpFile=%2\%~n1\%~n1_%_year%-%_month%-%_day%_%_hour%%_minute%.dt"
echo %_dumpFile%
@REM echo base name: %~n2
exit /b