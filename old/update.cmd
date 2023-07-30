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

@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION
echo off & chcp 65001 & setlocal ENABLEDELAYEDEXPANSION


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
for /f "skip=1 usebackq delims====" %%a in (bases.txt) do (
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
for /f "skip=1 delims====" %%a in (bases.txt) do (
    call :updateString "%%a"
)
exit /b

:updateId
@REM %1 - id to filter string
findstr /r "^%1.*$" bases.txt >NUL
if errorlevel 1 goto :EOF
for /f "usebackq delims=" %%a in (`findstr /r "^%1.*$" bases.txt`) do (
    call :updateString "%%a"
)
exit /b

:updateString
@REM updateString(id basePath updatePath currentVersion title)
@REM %1 - string (should be in "")
for /f "tokens=1-4,* delims=|" %%g in (%1) do (
    call :updateBase "%%h" "%%i" %%j
)
exit /b

:updateBase
@REM %1 - basePath
@REM %2 - updatePath
@REM %3 - currentVersion
echo Update %1 from dir %2 from version %3
exit /b