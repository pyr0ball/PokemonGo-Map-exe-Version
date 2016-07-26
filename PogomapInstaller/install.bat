@echo off
cd /d "%~dp0"
REM start "%~dp0logo.bat"
setlocal enabledelayedexpansion

:: Running prompt elevated
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
::    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

cd /d "%~dp0"

:checkpyinstall
	set py_regkey=
	if not exist "%PROGRAMFILES(X86)%" (
		set py_regkey="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Python.exe"
	) else (
		set py_regkey="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\Python.exe"
	)

:: Check for presence of key first.
	reg query %py_regkey% >NUL 2>&1 || (goto nopython)

:: Pipe the registry key through findstring to extract the install directory
	set python=
	for /f "tokens=2,*" %%a in ('reg query %py_regkey% ^| findstr Python') do (
		set python=%%b
	)
	goto installpogo
:nopython
	echo Python 2.7 was not detected. An installer for it will be opened. Please finish installing Python 2.7 before proceeding.
	call wget.exe https://www.python.org/ftp/python/2.7.12/python-2.7.12.msi -O python.msi
	call msiexec /i %~dp0\python.msi
	cls
	echo Python 2.7 installer finished, proceeding...
	ping 127.0.0.1 -n 3 >NUL
	goto checkpyinstall
	
:installpogo
	set /p wdir=Please specify an installation directory for PokemonGo-Map. (hit ENTER to use default C:\PokemonGo-Map)
	if (%wdir%) == () set wdir=C:\PokemonGo-Map
	call wget.exe https://github.com/AHAAAAAAA/PokemonGo-Map/archive/master.zip --no-check-certificate -O master.zip
	call unzip.exe master.zip
	xcopy /i /y /d /e /f /h /k "%~dp0PokemonGo-Map-master" "%wdir%"
	pause
	
:installreqs
	set py_regkey=
	if not exist "%PROGRAMFILES(X86)%" (
		set py_pathkey="HKEY_LOCAL_MACHINE\SOFTWARE\Python\PythonCore\2.7\InstallPath"
	) else (
		set py_pathkey="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Python\PythonCore\2.7\InstallPath"
	)
	set py_path=
	for /f "tokens=2,*" %%a in ('reg query %py_pathkey% ^| findstr Python') do (
		set py_path=%%b
	)
	
	set PATH2=%py_path%

	setx PATH "%PATH%;%PATH2%;%PATH2%\Scripts;"

	REM popd
	REM cd /d "%wdir%\Easy Setup"
	REM ::"%python%" ez_setup.py
	REM "%python%" get-pip.py
	REM cd ..
	
	REM ::pip install --index-url=http://pypi.python.org/simple/ --trusted-host pypi.python.org  	protobuf==2.6.1
	REM pip install -r requirements.txt
	REM pip install -r requirements.txt --upgrade
	cd /d "%~dp0"
	call %~dp0pipinstall.bat
	echo python requirements installation complete.
:configure
	cls
	echo Time to configure your map!
	
:service

	echo.
	set /p  service="How are you logging in to PokemonGo? Please type "ptc" or "google"   "
	if (%service%) == () echo No service defined & goto service
		if %service% EQU google goto login
		if %service% EQU ptc goto login
		echo.
		echo Invalid option.
			goto service
			
:login
	cls
	echo Please paste your GoogleMaps API key
	echo.
	set /p API="   "
	if (%API%) == () echo No API key entered. This is required for the map to work & goto login
	cls
	set /p username="What's your login username?   "
	cls
	set /p password="What's your password?   "
	cls
	echo Where would you like the server to search?
	echo You can use a lat,lon coordinate or an address. Example: 
	set /p location="   "
	cls
	echo How many steps (in a radius) would you like the map to search for pokemon?
	set /p steps="Minimum of 1, not recommended to set higher than 15    "
	cls
	echo How many process threads would you like your map to use?
	echo The more threads, the fastre your map will load, but higher CPU requirements
	set /p threads="Minimum 1. Most users should be fine between 2-10   "
	cls
	echo How many seconds should the map wait to start a new scan when one completes?
	set /p scandelay="Default is usually 1   "
	cls
	echo Would you like to bind your host to a particular interface?
	set /p host="If you don't know just hit ENTER   "
	if (%host%) == () set host=127.0.0.1
	echo.
	echo Would you like to set an alternate host port?
	set /p port=" (Hit ENTER to use default 5000)   "
	if (%port%) == () set port=5000
	cls
	echo Let's review!
	echo.
	echo.
	echo.
	echo ##### Login Information #####
	echo You're going to be using %service% to log in, with user %username% and password %password%
	set /p prompt=Is this information correct? Hit ENTER to confirm, or type NO to go back and try again.
	if (%prompt%) == (NO) goto configure
:confperf
	cls
	echo ##### Performance Options #####
	echo Your server will be searching %location% for %steps% step(s) using %threads% thread(s), and waiting %scandelay% second(s) before starting a new search.
	set /p prompt=Is this information correct? Hit ENTER to confirm, or type NO to go back and try again.
	if (%prompt%) == (NO) goto configure
:confhost
	cls
	echo ##### Host Options #####
	echo your map will be hosted on the interface configured for IP address %host% on port %port%
	set /p prompt=Is this information correct? Hit ENTER to confirm, or type NO to go back and try again.
	if (%prompt%) == (NO) goto configure
:confdone
	echo done.
	cls
	echo Alrightey, we're good to go! just a moment while we set things up.
	echo.
	echo If you'd like to make any changes to these settings, edit config.ini located at %wdir%\config\config.ini
	pause
	
cd /d "%wdir%\config"
	(
	echo	#Provide Pokemon Go Credentials here. This section must be filled out!
	echo.
	echo	[Authentication]
	echo	# ptc or google
	echo	Service: %service%
	echo	Username: %username%
	echo	Password: %password%
	echo.
	echo	[Database]
	echo	# Possible values: sqlite, mysql
	echo	Type: sqlite
	echo	# The following are only required if it's not sqlite
	echo	Database_Name: 
	echo	Database_User: 
	echo	Database_Pass: 
	echo	Database_Host: 
	echo.
	echo	[Search_Settings]
	echo	Steps: %steps%
	echo	Location: %location%
	echo	#Time delay before beginning new scan
	echo	Scan_delay: %scandelay%
	echo	# Disable Map elements
	echo	disable_pokemon: false
	echo	disable_pokestops: false
	echo	disable_gyms: false
	echo.
	echo	[Misc]
	echo	#you need a google maps api key to run this!
	echo	Google_Maps_API_Key : %API%
	echo	Host: %host%
	echo	Port: %port%
	) > "%wdir%\config\config.ini"

cd /d "%wdir%"	
	(
	echo	::PokemonGo-Map server run script
	echo	cd /d "%wdir%"
	echo	call %python% runserver.py -se -t %threads%
	) > "%wdir%\RunServer.bat"


cd /d config
    (
    echo {
    echo "gmaps_key" : "%API%"
    echo }
    ) > "%wdir%\config\credentials.json"

	cls
	set /p shortcut=Would you like us to make a shortcut on your Desktop? Type YES if so.
	echo %shortcut% | findstr /r "[yY][eE][sS]*" >NUL 2>&1
	if errorlevel 1 (
		goto installdone
	) else (
		goto makeshortcut
	)

:makeshortcut
	cd /d "%wdir%"
	call %~dp0createshortcut.bat -linkfile "%userprofile%\Desktop\PokemonGo-Map.lnk" -target "cmd %wdir%\RunServer.bat" -iconlocation "%wdir%\static\appicons\favicon.ico" -workingdirectory "%wdir%"
	
	:installdone
	