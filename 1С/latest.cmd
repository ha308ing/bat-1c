:: Find latest configuration version
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

SET VERSIONS_ORDER=3_0_138_24 3_0_137_39 30_135_24 3_0_137_34 3_0_136_32
REM OR USE All dirs in ascending order

SET tmpltsDir=C:\Users\user\AppData\Roaming\1C\1cv8\tmplts\1c\AccountingBase

for %%i in (%VERSIONS_ORDER%) do (
	set currentDir=%tmpltsDir%\%%i
	if exist !currentDir!\ (
		echo Directory !currentDir! is present
	) else (
		echo Directory !currentDir! is not present
	)
)

rem echo latestVer: %latestVer%