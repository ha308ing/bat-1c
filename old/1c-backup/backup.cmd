:: Do 1C bases backup
@ECHO OFF & chcp 65001 >NUL
SETLOCAL ENABLEDELAYEDEXPANSION

SET target=backup
SET all=Все базы
SET options[0]=%all%
SET /A numberOfBase=0
ECHO Сделать резервную копию:
ECHO 0. %all%
FOR /D %%i IN ( legion, legion_corp, profi_sn ) DO (
    set /a numberOfBase+=1
    SET options[!numberOfBase!]=%%i
    ECHO !numberOfBase!: %%i
)
ECHO;
:doChoice
SET /P choiceInput="Что копировать: "
SET /A choice=choiceInput
IF %choice% NEQ %choiceInput% GOTO :choiceWrong
IF %choice% LSS 0 GOTO :choiceWrong
IF %choice% GTR %numberOfBase% GOTO :choiceWrong
GOTO :choiceRight

:choiceWrong
ECHO Неправильный выбор
ECHO;
GOTO :doChoice

:choiceRight
CALL SET select=%%options[%choice%]%%
ECHO Копируем: %select%

IF %choice% GTR 0 GOTO :copyOne

FOR /L %%i IN (1,1,%numberOfBase%) DO (
    CALL SET select=%%options[%%i]%%
    ECHO Копируем: !select!
    XCOPY /Y !select!\info.txt %target%\!select!\ >NUL 2>&1
)
GOTO :finish

:: check if no tmp file
:copyOne
XCOPY /Y %select%\info.txt %target%\%select%\ >NUL 2>&1
GOTO :finish

:finish
echo end