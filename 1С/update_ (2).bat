:: Do 1C bases backup
:: https://infostart.ru/1c/articles/104654/
@ECHO OFF & chcp 65001 >NUL
endlocal & SETLOCAL ENABLEDELAYEDEXPANSION

tskill *1cv8* /a /v && echo 1C Processes have been ended || Processes have not been ended 2>&1

start "Update 1C" /b /wait "C:\Program Files\1cv8\8.3.22.1750\bin\1cv8.exe" DESIGNER /DisableStartupDialogs /F"\\192.168.2.1\e\1С\TimberDis" /UpdateCfg"C:\Users\user\AppData\Roaming\1C\1cv8\tmplts\1c\AccountingBase\3_0_137_39\1cv8.cfu" /UpdateDBCfg -Dynamic-/Out "C:\1С\update.log" -NoTruncate