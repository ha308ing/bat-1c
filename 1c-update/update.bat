:: Do 1C bases backup
:: https://infostart.ru/1c/articles/104654/
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

SET binDir="C:\Program Files\1cv8\8.3.23.1688\bin"
"C:\Program Files\1cv8\common\1cestart.exe" CONFIG /DisableStartupMessages /F "C:\1С\TimberDis" /UpdateDBCfg /Out "C:\1С\update.log" -NoTruncate /UC"ПакетноеОбновлениеКонфигурацииИБ"