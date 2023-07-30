@echo off & chcp 65001 >NUL & setlocal ENABLEDELAYEDEXPANSION
@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION

:: find 1c processes
:findProcess
tasklist /fi "IMAGENAME eq 1cv8*" /nh | findstr /i /c:1cv8 >NUL
if errorlevel 1 goto :noProcess
:: 1c processes found - ending
:endProcess
echo Завершение процессов 1С.
taskkill /f /fi "IMAGENAME eq 1cv8*" 2>&1 >NUL
if errorlevel 1 (
  echo Не удалось завершить процессы 1cv8. Попробуйте самостоятельно.
  pause
  goto :findProcess
)
echo Процессы 1С завершены.
goto :findProcess

:: no 1c processes found
:noProcess
echo Процессов 1С не обнаружено.
exit /b