:: Do 1C bases backup
:: https://infostart.ru/1c/articles/104654/
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

:: Select Bases to Update
SET target=backup
SET all=Все базы
SET options[0]=%all%
SET /A numberOfBase=0
ECHO Сделать резервную копию:
ECHO 0. %all%
FOR /D %%i IN ( legion, legion_corp, profi_sn ) DO (
    set /a numberOfBase+=1
    SET options[!numberOfBase!]=%%i
    ECHO !numberOfBase!: %%i
)
ECHO;
:doChoice
SET /P choiceInput="Что копировать: "
SET /A choice=choiceInput
IF %choice% NEQ %choiceInput% GOTO :choiceWrong
IF %choice% LSS 0 GOTO :choiceWrong
IF %choice% GTR %numberOfBase% GOTO :choiceWrong
GOTO :choiceRight

:choiceWrong
ECHO Неправильный выбор
ECHO;
GOTO :doChoice

:choiceRight
CALL SET select=%%options[%choice%]%%
ECHO Копируем: %select%

IF %choice% GTR 0 GOTO :copyOne

FOR /L %%i IN (1,1,%numberOfBase%) DO (
    CALL SET select=%%options[%%i]%%
    ECHO Копируем: !select!
    XCOPY /Y !select!\info.txt %target%\!select!\ >NUL 2>&1
)
GOTO :finish

:: check if no tmp file
:copyOne
XCOPY /Y %select%\info.txt %target%\%select%\ >NUL 2>&1
GOTO :finish

:finish
echo end

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

echo Update start >> %LOG_FILE%

rem end user sessions
:endUserSessions
echo Ending user sessions
echo ===Ending user sessions=== >> %LOG_FILE%
start "Блокировка работы пользователей" /b /wait %START_FILE% ENTERPRISE /DisableStartupDialogs /F "%BASE_DIR%\%BASE_NAME%" /WA- /CЗавершитьРаботуПользователей /UC%UNLOCK_CODE% /Out%LOG_FILE% -NoTruncate 2>&1 >NUL
if errorlevel 0 (
echo Работа пользователей завершена
echo Работа пользователей завершена >> %LOG_FILE%
) else (
echo Не удалось завершить работу пользователей
echo Не удалось завершить работу пользователей >> %LOG_FILE%
)
rem echo. >> %LOG_FILE%
rem echo.

:findProcess
rem find 1c processes
tasklist /fi "IMAGENAME eq %processName%*" /nh | findstr /i /c:%processName% >NUL
IF errorlevel 1 (
	goto :noProcess
) ELSE (
	goto :killProcess
)

:killProcess
rem kill 1c processes
echo ===Killing 1C processes===
echo ===Killing 1C processes===>> %LOG_FILE%
tskill *1cv8* /a /v
if errorlevel 1 (
echo failed to end %processName% process. Try manually and continue
echo failed to end %processName% process. Try manually and continue>> %LOG_FILE%
pause
goto :findProcess
) else (
echo %processName% processes have been ended continue...
echo %processName% processes have been ended continue... >> %LOG_FILE%
goto :doBackup
)

:noProcess
echo no process running
echo no process running>> %LOG_FILE%

:doBackup
echo ===create backup===
echo ===create backup===>> %LOG_FILE%
echo copy 1cd file
echo copy 1cd file>> %LOG_FILE%
xcopy /Y %BASE_DIR%\%BASE_NAME%\1Cv8.1CD %BACKUP_DIR%\ 2>&1 >NUL
if errorlevel 1 (
  echo copy failed 2>&1
  echo copy failed >> %LOG_FILE%
) else (
  echo copy finished
  echo copy finished >> %LOG_FILE%
  if exist %BACKUP_DIR%\1Cv8.1CD (
    echo check: target file exists
    echo check: target file exists >> %LOG_FILE%
  ) else (
    echo target file doesn't exist
    echo target file doesn't exist >> %LOG_FILE%
  )
)
    ECHO Backup file: %DUMP_FILE%
    ECHO Backup file: %DUMP_FILE% >> %LOG_FILE%
    IF EXIST %DUMP_FILE% GOTO NO_BACKUP
    START "Backup Information Base" /b /wait %START_FILE% DESIGNER /F "%BASE_DIR%\%BASE_NAME%" /WA- /UC%UNLOCK_CODE% /DumpIB%DUMP_FILE% /Out%LOG_FILE% -NoTruncate 2>&1 >NUL
if errorlevel 0 (
echo information base dump succeeded
echo information base dump succeeded >> %LOG_FILE%
) else (
echo information base dump failed
echo information base dump failed >> %LOG_FILE%
)
goto allowUserSessions
    ECHO.
    ECHO. >> %LOG_FILE%

:NO_BACKUP
ECHO Backup file already exists..
ECHO Backup file already exists.. >> %LOG_FILE%


rem do updates
ECHO === Update config and DB===
ECHO === Update config and DB=== >> %LOG_FILE%%
SET CURRENT_VER=3_0_137_34
SET CF_DIR=C:\Users\user\AppData\Roaming\1C\1cv8\tmplts\1c\AccountingBase
SET CF_FILE=

echo current version: %CURRENT_VER%
echo current version: %CURRENT_VER% >> %LOG_FILE%%

for /f "usebackq" %%i in (`dir /b /on /ad %CF_DIR%`) do (
	if /i "%CURRENT_VER%" LSS "%%i" (
		echo update to %%i
		echo update to %%i >> %LOG_FILE%
		 SET CF_FILE=%CF_DIR%\%%i\1cv8.cfu
echo update file: !CF_FILE!
echo update file: !CF_FILE! >> %LOG_FILE%
    START "Update to %%i version" /wait %START_FILE% DESIGNER /DisableStartupDialogs /F "%BASE_DIR%\%BASE_NAME%" /WA- /UC%UNLOCK_CODE% /UpdateCfg !CF_FILE! /UpdateDBCfg -Dynamic- / -WarningsAsErrors /Out%LOG_FILE% -NoTruncate
if errorlevel 0 (
	echo Update to %%i version succeded
	echo Update to %%i version succeded >> %LOG_FILE%%
) else (
	echo Update to %%i version failed
	echo Update to %%i version failed >> %LOG_FILE%%
)

	) else (
		echo skip update %%i
		echo skip update %%i >> %LOG_FILE%%
	)
)

    ECHO.
    ECHO. >> %LOG_FILE%

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
