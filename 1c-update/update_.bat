:: Do 1C bases backup
:: https://infostart.ru/1c/articles/104654/
:: https://www.mikuslas.ru/1c_autobackup_and_autoupdate
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

"C:\Program Files\1cv8\common\1cestart.exe" CONFIG /DisableStartupDialogs /UpdateDBCfg /Out "C:\1С\update.log" -NoTruncate