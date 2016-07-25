:: WA logo display
@echo off
setlocal disableDelayedExpansion
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: This region is the design portion. Create the ASCII art here and use calls to :c to change color
set q=^"
cls
echo(
echo(
call :c 08 "            ############" /n
call :c 08 "        ####"&call :c CC "@@@@@@@@@@@@"&call :c 08 "####" /n
call :c 08 "      ##"&call :c CC "@@@@@@@@@@@@@@@@@@"&call :c C4 "@@"&call :c 08 "##" /n
call :c 08 "    ##"&call :c CC "@@"&call :c FC "HHHH"&call :c CC "@@@@@@@@@@@@@@@@"&call :c C4 "@@"&call :c 08 "##" /n
call :c 08 "  ##"&call :c CC "@@"&call :c FC "HH"&call :c FF "####"&call :c FC "HH"&call :c CC "@@@@@@@@@@@@@@"&call :c C4 "@@@@"&call :c 08 "##" /n
call :c 08 "  ##"&call :c CC "@@"&call :c FC "HH"&call :c FF "####"&call :c FC "HH"&call :c CC "@@@@@@@@@@@@@@"&call :c C4 "@@@@"&call :c 08 "##" /n
call :c 08 "##"&call :c CC "@@@@@@"&call :c FC "HHHH"&call :c CC "@@@@@@@@@@@@@@"&call :c C4 "@@@@@@@@"&call :c 08 "##" /n
call :c 08 "##"&call :c CC "@@@@@@@@@@@@@@@@@@@@@@@@"&call :c C4 "@@@@@@@@"&call :c 08 "##" /n
call :c 08 "##"&call :c CC "@@@@@@@@@@@@@@@@@@@@@@"&call :c C4 "@@@@@@@@@@"&call :c 08 "##" /n
call :c 08 "####"&call :c CC "@@@@@@@@@@@@@@@@"&call :c C4 "@@@@@@@@@@@@"&call :c 08 "####" /n
call :c 08 "######"&call :c CC "@@@@"&call :c 08 "######"&call :c CC "@@"&call :c C4 "@@@@@@@@"&call :c 08 "##########" /n
call :c 08 "##########"&call :c F7 "HH"&call :c FF "@@"&call :c F7 "HH"&call :c 08 "##############"&call :c F7 "HH"&call :c 08 "####" /n
call :c 08 "  ##"&call :c FF "HH"&call :c 08 "####"&call :c FF "@@@@@@"&call :c 08 "##########"&call :c FF "HHHH"&call :c F7 "HH"&call :c 08 "##" /n
call :c 08 "  ##"&call :c FF "HHHH"&call :c 08 "##"&call :c F7 "HH"&call :c FF "@@"&call :c F7 "HH"&call :c 08 "##"&call :c FF "HHHHHHHHHHHH"&call :c F7 "HH"&call :c 08 "##" /n
call :c 08 "    ##"&call :c F7 "HH"&call :c FF "HH"&call :c 08 "######"&call :c FF "HHHHHHHHHHHH"&call :c F7 "HH"&call :c 08 "##" /n
call :c 08 "      ##"&call :c F7 "HH"&call :c FF "HHHHHHHHHHHHHH"&call :c F7 "HHHH"&call :c 08 "##" /n
call :c 08 "        ####"&call :c F7 "HHHHHHHHHHHH"&call :c 08 "####" /n
call :c 08 "            ############" /n
echo(
ping 127.0.0.1 -n 10 >NUL
exit

:c
setlocal enableDelayedExpansion
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:colorPrint Color  Str  [/n]
setlocal
set "s=%~2"
call :colorPrintVar %1 s %3
exit /b

:colorPrintVar  Color  StrVar  [/n]
if not defined DEL call :initColorPrint
setlocal enableDelayedExpansion
pushd .
':
cd \
set "s=!%~2!"
:: The single blank line within the following IN() clause is critical - DO NOT REMOVE
for %%n in (^"^

^") do (
  set "s=!s:\=%%~n\%%~n!"
  set "s=!s:/=%%~n/%%~n!"
  set "s=!s::=%%~n:%%~n!"
)
for /f delims^=^ eol^= %%s in ("!s!") do (
  if "!" equ "" setlocal disableDelayedExpansion
  if %%s==\ (
    findstr /a:%~1 "." "\'" nul
    <nul set /p "=%DEL%%DEL%%DEL%"
  ) else if %%s==/ (
    findstr /a:%~1 "." "/.\'" nul
    <nul set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%"
  ) else (
    >colorPrint.txt (echo %%s\..\')
    findstr /a:%~1 /f:colorPrint.txt "."
    <nul set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
  )
)
if /i "%~3"=="/n" echo(
popd
exit /b


:initColorPrint
for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do set "DEL=%%A %%A"
<nul >"%temp%\'" set /p "=."
subst ': "%temp%" >nul
exit /b


:cleanupColorPrint
2>nul del "%temp%\'"
2>nul del "%temp%\colorPrint.txt"
>nul subst ': /d
exit /b	
	ping 127.0.0.1 -n 3 >NUL
