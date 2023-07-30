:: Do 1C bases backup
:: https://infostart.ru/1c/articles/104654/
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

SET processName=1cv8
SET UNLOCK_CODE=КодРазрешения
SET START_FILE="C:\Program Files\1cv8\8.3.22.1750\bin\1cv8.exe"
SET VERSIONS_ORDER=

SET BASE_DIR=\\192.168.2.1\e\1С
SET BASE_NAME=InfoBase1

SET DATE_SHORT=%date:~6,4%-%date:~3,2%-%date:~0,2%

SET BACKUP_DIR=\\192.168.2.1\e\1С\bat-backup\%BASE_NAME%
SET DUMP_FILE=%BACKUP_DIR%\%BASE_NAME%_%DATE_SHORT%.dt

SET LOG_DIR=\\192.168.2.1\e\1С\bat-log
SET LOG_FILE=%LOG_DIR%\%BASE_NAME%_%DATE_SHORT%.log

rem allow user sessions
:allowUserSessions
echo Allow user sessions
echo ===Allow user sessions=== >> %LOG_FILE%
start "Allow user sessions" /b /wait %START_FILE% ENTERPRISE /DisableStartupDialogs /F "%BASE_DIR%\%BASE_NAME%" /WA- /C "РазрешитьРаботуПользователей" /UC%UNLOCK_CODE% /Out%LOG_FILE% -NoTruncate 2>&1 >NUL
if errorlevel 0 (
echo Работа пользователей разрешена
echo Работа пользователей разрешена>> %LOG_FILE%
) else (
echo Не удалось разрешить работу пользователей
echo Не удалось разрешить работу пользователей >> %LOG_FILE%
)
echo. >> %LOG_FILE%
echo.
:end
pause