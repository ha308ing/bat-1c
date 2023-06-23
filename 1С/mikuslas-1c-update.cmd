    @ECHO OFF
    CLS

    SET BASE_NAME=ИмяБазыДанных
    SET CONNECT_STR="File=""D:\1C_Base\МояБазаДанных"";"
    SET USER_NAME=Update
    SET USER_PWD=123

    SET START_FILE="C:\Program Files (x86)\1cv82\8.2.19.90\bin\1cv8.exe"
    SET BACKUP_DIR=D:\1C_Base\etc\Backup
    SET CF_DIR=D:\1C_Base\etc\Update
    SET LOG_DIR=D:\1C_Base\etc\Update\Log

    SET UNLOCK_CODE=КодРазрешения

    SET CF_FILE=%CF_DIR%\1Cv8.cf
    SET LOG_FILE=%LOG_DIR%\%BASE_NAME%_%date:~6,4%-%date:~3,2%-%date:~0,2%.log
    SET DUMP_FILE=%BACKUP_DIR%\%BASE_NAME%_%date:~6,4%-%date:~3,2%-%date:~0,2%.dt

    IF NOT EXIST %CF_FILE% EXIT

    ECHO --- Start the update %DATE% %TIME% ---
    ECHO --- Start the update %DATE% %TIME% --- >> %LOG_FILE%
    ECHO.
    ECHO. >> %LOG_FILE%

    ECHO --- Completion of the inactive terminal sessions ---
    ECHO --- Completion of the inactive terminal sessions --- >> %LOG_FILE%
    tskill *1cv8* /a /v
    @ECHO.
    @ECHO. >> %LOG_FILE%

    ECHO --- Shutdown users ---
    ECHO --- Shutdown users --- >> %LOG_FILE%
    START "" /wait %START_FILE% ENTERPRISE /IBConnectionString%CONNECT_STR% /N%USER_NAME% /P%USER_PWD% /WA- /DisableStartupMessages /CЗавершитьРаботуПользователей /Out%LOG_FILE% -NoTruncate
    ECHO.
    ECHO. >> %LOG_FILE%

    IF EXIST %DUMP_FILE% GOTO NO_BACKUP

    ECHO --- Creating a backup ---
    ECHO --- Creating a backup --- >> %LOG_FILE%
    ECHO Backup file: %DUMP_FILE%
    ECHO Backup file: %DUMP_FILE% >> %LOG_FILE%
    START "" /wait %START_FILE% DESIGNER /IBConnectionString%CONNECT_STR% /N%USER_NAME% /P%USER_PWD% /WA- /UC%UNLOCK_CODE% /DumpIB%DUMP_FILE% /Out%LOG_FILE% -NoTruncate
    ECHO.
    ECHO. >> %LOG_FILE%

    :NO_BACKUP

    ECHO --- Configuration update ---
    ECHO --- Configuration update --- >> %LOG_FILE%
    ECHO Update file: %CF_FILE%
    ECHO Update file: %CF_FILE% >> %LOG_FILE%
    START "" /wait %START_FILE% DESIGNER /IBConnectionString%CONNECT_STR% /N%USER_NAME% /P%USER_PWD% /WA- /UC%UNLOCK_CODE% /LoadCfg%CF_FILE% -WarningsAsErrors /Out%LOG_FILE% -NoTruncate
    ECHO.
    ECHO. >> %LOG_FILE%

    ECHO --- Information base update ---
    ECHO --- Information base update --- >> %LOG_FILE%
    START "" /wait %START_FILE% DESIGNER /IBConnectionString%CONNECT_STR% /N%USER_NAME% /P%USER_PWD% /WA- /UC%UNLOCK_CODE% /UpdateDBCfg -WarningsAsErrors /Out%LOG_FILE% -NoTruncate
    ECHO.
    ECHO. >> %LOG_FILE%

    ECHO --- Unlock database ---
    ECHO --- Unlock database --- >> %LOG_FILE%
    START "" /wait %START_FILE% ENTERPRISE /IBConnectionString%CONNECT_STR% /N%USER_NAME% /P%USER_PWD% /WA- /DisableStartupMessages /CРазрешитьРаботуПользователей /UC%UNLOCK_CODE% /Out%LOG_FILE% -NoTruncate
    ECHO.
    ECHO. >> %LOG_FILE%

    ECHO --- End of update %DATE% %TIME% ---
    ECHO --- End of update %DATE% %TIME% --- >> %LOG_FILE%
    ECHO.
    ECHO. >> %LOG_FILE%

    PAUSE