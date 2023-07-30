:: Find latest configuration version
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

SET MIN_VERSION=3_0_137_34
REM MIN_VERSION=CURRENT_VERSION

SET tmpltsDir=C:\Users\user\AppData\Roaming\1C\1cv8\tmplts\1c\AccountingBase

for /f "usebackq" %%i in (`dir /b /ad /on %tmpltsDir%`) do (
	rem set currentDir=%tmpltsDir%\%%i
	rem if exist !currentDir!\ (
	rem 	echo Directory !currentDir! is present
	rem ) else (
	rem 	echo Directory !currentDir! is not present
	rem )
	if /I "%%i" GTR "%MIN_VERSION%" (
		echo Updating to %%i version..
	) else (
		echo Current version %MIN_VERSION% is newer than %%i - skip..
	)

)

rem echo latestVer: %latestVer%