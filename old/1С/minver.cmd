:: define cycle for updating
@ECHO OFF & chcp 65001 >NUL & SETLOCAL ENABLEDELAYEDEXPANSION

SET CURRENT_VER=3_0_138_24
SET CF_DIR=C:\Users\user\AppData\Roaming\1C\1cv8\tmplts\1c\AccountingBase
rem SET CF_FILE=

for /f "usebackq" %%i in (`dir /b /on /ad %CF_DIR%`) do (
	if /i "%CURRENT_VER%" LSS "%%i" (
		echo update to %%i
	) else (
		echo do not update %%i
	)
)
