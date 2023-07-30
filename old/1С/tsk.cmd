:: Do 1C bases backup
:: https://infostart.ru/1c/articles/104654/
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

SET processName=1cv8
SET UC=КодРазрешения
SET START_FILE="C:\Program Files\1cv8\8.3.22.1750\bin\1cv8.exe"
SET VERSIONS_ORDER=

tasklist /fi "IMAGENAME eq %processName%*" /nh | findstr /i /c:%processName% >NUL

IF errorlevel 1 (
	goto :noProcess
	rem goto :endUserSessions
) ELSE (
	goto :yesProcess
	rem goto :killProcess
)

:yesProcess
rem :killProcess
echo yesProcess
tskill *1cv8* /a /v
rem if errorlevel 1 (
rem echo failed to end %processName% process. Try manually and restart
rem goto :end
rem ) else (
rem echo %processName% processes have been ended continue...
rem )
goto :endUserSessions

:noProcess
echo noProcess

rem :endUserSessions
rem echo Ending user sessions
rem start /wait %START_FILE% ENTERPRISE /DisableStartupDialogs /IBConnectionString %CONNECT_STR% /WA- /C "ЗавершитьРаботуПользователей" /UC%UC% /Out%LOG_FILE% -NoTruncate
rem :end
rem pause