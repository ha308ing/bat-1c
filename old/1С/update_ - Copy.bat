@ECHO OFF & chcp 65001 >NUL
CLS

SET BASE_NAME=ТимбэДистрибуция
SET CONNECT_STR="FILE=""\\192.168.2.1\e\1С\TimberDis"";"
REM SET USER_NAME=Update
REM SET USER_PWD=123

SET START_FILE="C:\Program Files\1cv8\8.3.22.1750\bin\1cv8.exe"
SET BACKUP_DIR=\\192.168.2.1\e\1С\bat-backup
SET CF_DIR=C:\Users\user\AppData\Roaming\1C\1cv8\tmplts\1c\AccountingBase
SET LOG_DIR=C:\1С\LOG

SET UNLOCK_CODE=КодРазрешения

SET CF_FILE=%CF_DIR%\3_0_137_39\1cv8.cfu
SET LOG_FILE=%LOG_DIR%\%BASE_NAME%_%date:~6,4%-%date:~3,2%-%date:~0,2%.log
SET DUMP_FILE=%BACKUP_DIR%\%BASE_NAME%_%date:~6,4%-%date:~3,2%-%date:~0,2%.dt

IF NOT EXIST %CF_FILE% EXIT

ECHO -- Start the update %DATE% %TIME% --
ECHO -- Start the update %DATE% %TIME% -- >> %LOG_FILE%
ECHO.
ECHO.>> %LOG_FILE%

ECHO -- Completion of the inactive terminal sessions --
ECHO -- Completion of the inactive terminal sessions -- >> %LOG_FILE%
tskill *1cv8* /a /v
ECHO.
ECHO.>> %LOG_FILE%

ECHO -- Shutdown users --
ECHO -- Shutdown users -- >> %LOG_FILE%
start "" /wait %START_FILE% ENTERPRISE /DisableStartupDialogs /IBConnectionString%CONNECT_STR% /WA- /CЗавершитьРаботуПользователей /Out%LOG_FILE% -NoTruncate
ECHO.
ECHO.>> %LOG_FILE%

IF EXIST %DUMP_FILE% GOTO NO_BACKUP

:NO_BACKUP

ECHO -- Configuration update --
ECHO -- Configuration update -- >> %LOG_FILE%
ECHO Update file: %CF_FILE%
ECHO Update file: %CF_FILE% >> %LOG_FILE%
start "" /wait %START_FILE% DESIGNER /DisableStartupDialogs /IBConnectionString%CONNECT_STR% /WA- /UC%UNLOCK_CODE% /UpdateCfg%CF_FILE% /UpdateDBCfg -BackgroundStart -Dynamic- -WarningsAsErrors /Out%LOG_FILE% -NoTruncate
ECHO.
ECHO.>> %LOG_FILE%

REM ECHO -- Information base update --
REM ECHO -- Information base update -- >> %LOG_FILE%
REM start "" /wait %START_FILE% DESIGNER /DisableStartupDialogs /IBConnectionString %CONNECT_STR% /WA- /UC%UNLOCK_CODE% /UpdateDBCfg -Dynamic -WarningsAsErrors /Out%LOG_FILE% -NoTruncate
REM ECHO.
REM ECHO.>> %LOG_FILE%

ECHO -- Background Finish --
ECHO -- Background Finish -- >> %LOG_FILE%
ECHO Update file: %CF_FILE%
ECHO Update file: %CF_FILE% >> %LOG_FILE%
start "" /wait %START_FILE% DESIGNER /DisableStartupDialogs /IBConnectionString%CONNECT_STR% /WA- /UC%UNLOCK_CODE% /UpdateDBCfg -BackgroundFinish -WarningsAsErrors /Out%LOG_FILE% -NoTruncate
ECHO.
ECHO.>> %LOG_FILE%

ECHO -- Unlock database --
ECHO -- Unlock database -- >> %LOG_FILE%
start "" /wait %START_FILE% ENTERPRISE /IBConnectionString%CONNECT_STR% /WA- /DisableStartupDialogs /CРазрешитьРаботуПользователей /UC%UNLOCK_CODE% /Out%LOG_FILE% -NoTruncate
ECHO.
ECHO.>> %LOG_FILE%

ECHO -- END of update %DATE% %TIME% --
ECHO -- END of update %DATE% %TIME% -- >> %LOG_FILE%
ECHO.
ECHO.>> %LOG_FILE%

PAUSE