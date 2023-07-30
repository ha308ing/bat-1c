@echo off & chcp 65001 >NUL & setlocal ENABLEDELAYEDEXPANSION
@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION

set "_startFile="C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe""
set "_bases="%~dp0bases.txt""
set "_logsPath="D:\1C\Logs""
set "_backupsPath="D:\1C\Backups""
set "__endProcess="%~dp0end-process.cmd""
set "__usersBlock="%~dp0base-users-block.cmd""
set "__baseBackup="%~dp0base-backup.cmd""
set "__baseUpdate="%~dp0base-update.cmd""
set "__usersUnblock="%~dp0base-users-unblock.cmd""

cls
call %__endProcess%
pause

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
for /f "eol=; skip=1 usebackq delims====" %%a in (%_bases%) do (
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
@REM pass each string with base info to split
for /f "skip=1 delims====" %%a in (%_bases%) do (
    call :updateString "%%a"
)
exit /b

:updateId
@REM get id - pass string with base info for updating
@REM %1 - id to filter string
findstr /r "^%1.*$" %_bases% >NUL
if errorlevel 1 goto :EOF
for /f "usebackq delims=" %%a in (`findstr /r "^%1.*$" %_bases%`) do (
    call :updateString "%%a"
)
exit /b

:updateString
@REM get string with base info - split - pass it to updating base
@REM updateString: id basePath updatePath currentVersion title
@REM %1 - string (should be in "")
for /f "tokens=1-4,* delims=|" %%g in (%1) do (
    @REM 1 - startFile, 2 - basePath h, 3 - updatesDir i, 4 - currentVersion j, 5 - backupDir, 6 - logFile
    set "_id=%%g"
    set "_basePath="%%h""
    set "_baseName="%%~nh""
    set "_updatePath="%%i""
    set "_currentVersion=%%j"
    set "_baseTitle="%%k""
)
set "_backupDir="%_backupsPath:"=%\%_baseName:"=%""
set "_logFile="%_logsPath:"=%\%_baseName:"=%.log""

@REM block
call %__usersBlock% %_startFile% %_basePath% %_logFile%

@REM backup
call %__baseBackup% %_startFile% %_basePath% %_backupDir% %_logFile%

@REM update
for /f "usebackq" %%i in (`dir /b /ad %_updatePath%`) do (
    if "!_currentVersion!" lss "%%i" (
        echo Обновление %%i.
        set "_updateFile="%_updatePath:"=%\%%i\1cv8.cfu""
        call %__baseUpdate% %_startFile% %_basePath% !_updateFile! %_logFile%
        set "_currentVersion=%%i"
    )
)

@REM unblock
call %__usersUnblock% %_startFile% %_basePath% %_logFile%

exit /b
