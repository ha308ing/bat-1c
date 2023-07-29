chcp 65001 & setlocal ENABLEDELAYEDEXPANSION
@REM %1 - 1cv8.exe path ("C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe")
@REM %2 - base path (1c\bases\AccountingBase)
@REM %3 - updates dir (%appdata%\1c\1cv8\tmplts\AccountingBase should contain dirs with update files)
@REM %4 - current version (0 for unknown)
@REM %5 - log path
set "_baseName=%~n2"
set "_currentVersion=%4"
:update
echo Обновление базы %4 %_baseName%
for /f %%i in ('dir /b /ad /on %3') do (
  if "%_currentVersion%" geq "%%i" (
    echo Пропуск версии %%i.
    goto :skipUpdate
  )
rem ================================================================
  rem do updates
  echo Обновление %_baseName% до версии %%i
  set _cfFile=%3\%%i\1cv8.cfu
  echo Файл обновления: !_cfFile!
  if not exist !_cfFile! (
      echo Файл обновления не найден.
      pause
      goto :skipUpdate
  )
  rem Каталог не обнаружен 'D:\3_0_136_32\1cv8.cfu'. 3(0x00000003): Системе не удается найти указанный путь. 
  start "Обновление конфигурации" /b /wait %1 DESIGNER /DisableStartupDialogs /F %2 /WA- /UCКодРазрешения /UpdateCfg !_cfFile! /UpdateDBCfg -Dynamic- / -WarningsAsErrors /Out%5 -NoTruncate
rem ================================================================
  if errorlevel 1 (
    echo Обновление не удалось.
    pause
    goto :update
  )
  echo Обновление до версии %%i завершно успешно..
  set _currentVersion=%%i
  :skipUpdate
)
exit /b