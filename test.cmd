chcp 65001 & setlocal ENABLEDELAYEDEXPANSION
@REM %1 - 1cv8.exe path ("C:\Program Files\1cv8\8.3.23.1739\bin\1cv8.exe")
@REM %2 - base path (1c\bases\AccountingBase)
@REM %3 - backup path (1c-backup\AccountingBase)
@REM %4 - log path
set "_time=%TIME: =0%"
set "_year=%DATE:~6,4%"
set "_month=%DATE:~3,2%"
set "_day=%DATE:~0,2%"
set "_hour=%_time:~0,2%"
set "_minute=%_time:~3,2%"
echo %_day%.%_month%.%_year% %_hour%:%_minute%
set "_dumpFile=%2\%~n1\%~n1_%_year%-%_month%-%_day%_%_hour%%_minute%.dt"
echo %_dumpFile%
@REM echo base name: %~n2
exit /b