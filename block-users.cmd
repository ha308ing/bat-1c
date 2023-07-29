chcp 65001 & setlocal ENABLEDELAYEDEXPANSION
@REM %1 - 1cv8.exe path ("C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe")
@REM %2 - base path
@REM %3 - log path
:blockUsers
echo Блокировка пользователей..
start "Блокировка работы пользователей" /b /wait %1 ENTERPRISE /DisableStartupDialogs /F %2 /WA- /CЗавершитьРаботуПользователей /UCКодРазрешения /Out%3 -NoTruncate
if errorlevel 1 (
  echo Не удалось заблокировать работу пользователей.
  pause
  goto :blockUsers
)
echo Работа пользователей заблокирована.
exit /b