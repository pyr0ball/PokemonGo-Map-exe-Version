@echo off
setlocal enabledelayedexpansion
REM :: get local directory variable in wmic format
	REM echo "%~dp0" >CUR_DIR.txt
	REM call jrepl.bat "\" "\\" /l /f CUR_DIR.txt /o -
		 REM set CUR_DIR=
	 REM @for /f "tokens=* delims=" %%a in (CUR_DIR.txt) do (
		 REM set CUR_DIR=%%a
	 REM )
	REM set CUR_DIR=%CUR_DIR:~0,-1%

:buildarchive

:: Create executible SFX using 7-zip
	echo Please wait while the archive is built...
	call 7za.exe a -t7z "%~dp0\install.7z" @listfile.lst >NUL
	echo Zip created. Building self-extracting installer...
	copy /Y /B 7zS.sfx+config.txt+install.7z PokemonGo-Map.exe >NUL
	echo Build Complete, ready to clean up files
	pause
	del install.7z
	REM del CUR_DIR.txt
	goto end


:end
	REM exit