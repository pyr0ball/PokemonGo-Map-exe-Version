@echo off
	setlocal enabledelayedexpansion
	set py_pathkey=
	if not exist "%PROGRAMFILES(X86)%" (
		set py_pathkey="HKEY_LOCAL_MACHINE\SOFTWARE\Python\PythonCore\2.7\InstallPath"
	) else (
		set py_pathkey="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Python\PythonCore\2.7\InstallPath"
	)
	set py_path=
	for /f "tokens=2,*" %%a in ('reg query %py_pathkey% ^| findstr Python') do (
		set py_path=%%b
	)
		set python=
	for /f "tokens=2,*" %%a in ('reg query %py_regkey% ^| findstr Python') do (
		set python=%%b
	)

	set PATH2=%py_path%

	setx PATH "%PATH%;%PATH2%;%PATH2%\Scripts;"

	popd
	cd /d "%wdir%\Easy Setup"
	::"%python%" ez_setup.py
	"%python%" get-pip.py
	cd ..
	
	::pip install --index-url=http://pypi.python.org/simple/ --trusted-host pypi.python.org  	protobuf==2.6.1
	pip install -r requirements.txt
	pip install -r requirements.txt --upgrade
