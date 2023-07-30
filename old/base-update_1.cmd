@echo off & chcp 65001 >NUL & setlocal ENABLEDELAYEDEXPANSION
@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION

:updateBase
@REM %1 - 1cv8.exe
@REM %2 - basePath
@REM %3 - updatesDir
@REM %4 - currentVersion
@REM %5 - backupDir
@REM %6 - log file
set "_startFile=%1"
set "_basePath=%2"
set "_baseName=%~n2"
set "_updatesDir=%3"
set "_currentVersion=%4"
set "_backupDir=%5"
set "_logPath=%6"

dir /b /ad %3
if errorlevel 1 (
    echo No updates in dir: %3.
    goto :EOF
)
@REM backup
call "%~dp0base-backup.cmd" %_startFile% %_basePath% %_backupDir% %_logPath%
@REM block users
call "%~dp0base-users-block.cmd" %_startFile% %_basePath% %_logPath%
@REM loop through updates dir
for /f "usebackq" %%i in (`dir /b /ad %3`) do (
    if %%i gtr %_currentVersion% (
        call :updateBase %%i
    )
)
echo Updated to %_currentVersion%
@REM unblock users
call "%~dp0base-users-unblock.cmd" %_startFile% %_basePath% %_logPath%
exit /b

:updateBase
@REM %1 - version (dir name with update)
echo Обновление до версии %1
set "_cfFile="%_updatesDir:"=%\%1\1cv8.cfu""
echo Файл обновления: %_cfFile%.
if not exist %_cfFile% (
    echo Файл обновления не найден .
    goto :EOF
)
rem Каталог не обнаружен 'D:\3_0_136_32\1cv8.cfu'. 3(0x00000003): Системе не удается найти указанный путь. 
start "Обновление конфигурации" /b /wait %_startFile% DESIGNER /DisableStartupDialogs /F %_basePath% /WA- /UCКодРазрешения /UpdateCfg %_cfFile% /UpdateDBCfg -Dynamic- / -WarningsAsErrors /Out%_logPath% -NoTruncate
rem ================================================================
if errorlevel 1 (
    echo Обновление до версии %1 не удалось.
    goto :EOF
)
echo Обновление до версии %1 завершено успешно.
set "_currentVersion=%1"
exit /b