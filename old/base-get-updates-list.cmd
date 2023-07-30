echo off & chcp 65001>NUL & setlocal ENABLEDELAYEDEXPANSION
@REM chcp 65001 & setlocal ENABLEDELAYEDEXPANSION

:gtUpdates
@REM %1 - updatePath
@REM %2 - currentVersion
dir /b /ad %1
if errorlevel 1 (
    echo No updates in dir: %1.
    goto :EOF
)
for /f "usebackq" %%i in (`dir /b /ad %1`) do (
    if %%i gtr %2 (
        echo %%i
    )
)
exit /b