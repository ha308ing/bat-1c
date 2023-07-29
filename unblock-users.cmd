chcp 65001 & setlocal ENABLEDELAYEDEXPANSION
@REM %1 - 1cv8.exe path ("C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe")
@REM %2 - base path
@REM %3 - log path
:: unlock users
:unlockUsers
echo Снятие блокировки пользователей.
start "Снятие блокировки пользователей" /b /wait %1 ENTERPRISE /DisableStartupDialogs /F %2 /WA- /C "РазрешитьРаботуПользователей" /UCКодРазрешения /Out%3 -NoTruncate
if errorlevel 1 (
  echo Не удалось снять блокировку пользователей.
  pause
  goto :unlockUsers
)
echo Блокировка пользователей снята.
exit /b
