:: Do 1C bases backup
:: https://infostart.ru/1c/articles/104654/
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

start "" /b /wait "C:\Program Files\1cv8\8.3.22.1750\bin\1cv8.exe" CONFIG /DisableStartupDialogs /F"\\192.168.2.1\e\1С\TimberDis" /UpdateCfg"C:\Users\user\AppData\Roaming\1C\1cv8\tmplts\1c\AccountingBase\3_0_138_24\1cv8.cfu" /UpdateDBCfg -BackgroundStart -Dynamic- /Out "C:\1С\update.log" -NoTruncate