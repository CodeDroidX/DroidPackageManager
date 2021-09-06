@Echo off
cd %~dp0
chcp 65001 >> nul
color F
set ver=1.5.0
set name=Droid_Package_Manager
set shortname=DPM
echo cd %%~dp0\..\ >Links\droid.cmd
echo dpm.cmd %%* >>Links\droid.cmd
if not exist Links md Links >> nul
if not exist Packages md Packages >> nul

echo.
call data\xecho Green "%name%-%ver%"
echo.
chcp 65001 >> nul

call data\xecho DarkCyan "Parsing_args..."
echo.
set todo=%~1
set package_name=%~2
set sub_arg=%~3

call data\xecho Magenta "Select_action..."
echo.
if "%todo%"=="install" goto install
if "%todo%"=="uninstall" goto uninstall
if "%todo%"=="update" goto update
if "%todo%"=="list" goto list
if "%todo%"=="upgrade" goto upgrade
if "%todo%"=="tips" goto tips
if "%todo%"=="pass" goto finish
:help
call data\xecho Yellow "Help_menu..."
echo.
echo Note:
echo You should add "Links" folder to PATH for running droid and installed repos from cmd!
echo.
echo Syntax:
echo droid (action) (optional:package_name) (optional:author_name)
echo.
echo Actions:
echo install (installing\reinstalling new repo)
echo uninstall (uninstalling repo)
echo update (rewriting exist repo)
echo list (opens repo links folder)
echo upgrade (updates self)
echo tips (shows what you should to do)
echo.
echo Examples:
echo.
echo droid upgrade
echo.
echo droid install D-ino CodeDroidX
echo.
echo droid list
echo.
echo droid uninstall D-ino
echo.
echo droid install Impulse LimerBoy
echo.
echo Impulse
echo.
echo droid update Impulse LimerBoy
echo.
pause
goto finish

:inval
call data\xecho Red "Invalid_Syntax!"
goto help

:uninerr
call data\xecho Red "No_Package!"
echo You cant unins %package_name%, it caused or not exist!
goto finish

:repoerror
call data\xecho Red "Downloding_error!"
echo Repo called %sub_arg%/%package_name% renamed or not exist!
echo.
pause
goto finish

:finish
echo.
call data\xecho Green "DPM_work_completed!"
echo.
exit /b

:install
if "%package_name%"=="" goto inval
if "%sub_arg%"=="" goto inval

call data\xecho Cyan "Downloading-%package_name%..."
data\gh.exe repo clone %sub_arg%/%package_name% Packages\%package_name%temp
if %errorlevel% NEQ 0 goto repoerror

if exist Packages\%package_name% call data\xecho Red "Uninstalling-%package_name%..." & rmdir /q /s Packages\%package_name%

call data\xecho Blue "Installing-%package_name%..."
xcopy Packages\%package_name%temp Packages\%package_name% /H /Y /C /R /S /I
rmdir /q /s Packages\%package_name%temp


if not exist Packages\%package_name%\requirements.txt goto noinstrequirements
pip
if "%errorlevel%"=="0" pip install -r Packages\%package_name%\requirements.txt
:noinstrequirements


echo.
cd Packages\%package_name%
dir /b
cd %~dp0
echo.
:reinput
set /p ex=Please, choose file for exec(1.py, 1.exe, 1.bat, 1.jar etc):
if not exist Packages\%package_name%\%ex% echo Input correct exec file! & goto reinput
echo @Echo off > Links\%package_name%.cmd
echo "%%~dp0..\Packages\%package_name%\%ex%" %%*>> Links\%package_name%.cmd
goto finish

:uninstall
if "%package_name%"=="" goto inval
if not exist Packages\%package_name% goto uninerr

call data\xecho Red "Uninstalling-%package_name%..."

if not exist Packages\%package_name%\requirements.txt goto nounrequirements
echo.
call data\xecho Red "Found_pip_connected_modules"
call data\xecho DarkRed "Delete_them?"
set /p delmod=y\n:
if "%delmod%"=="n" goto nounrequirements
pip
if "%errorlevel%"=="0" pip uninstall -y -r Packages\%package_name%\requirements.txt
:nounrequirements

rmdir /q /s Packages\%package_name%
del /f Links\%package_name%.cmd
goto finish

:update
if "%package_name%"=="" goto inval
if "%sub_arg%"=="" goto inval

call data\xecho Cyan "DownloadingUpdate-%package_name%..."
data\gh.exe repo clone %sub_arg%/%package_name% Packages\TempUpdate%package_name%
if %errorlevel% NEQ 0 goto repoerror

call data\xecho Yellow "Updating-%package_name%..."
xcopy Packages\TempUpdate%package_name% Packages\%package_name% /H /Y /C /R /S /I
rmdir /q /s Packages\TempUpdate%package_name%
goto finish

:list
call data\xecho Gray "Open-List..."
start Links
goto finish

:upgrade
call data\xecho DarkYellow "Upgrade-%name%..."
data\gh.exe repo clone CodeDroidX/DroidPackageManager Packages\TempUpgradeSelf
if %errorlevel% NEQ 0 goto repoerror
xcopy Packages\TempUpgradeSelf %~dp0 /H /Y /C /R /S /I
rmdir /q /s Packages\TempUpgradeSelf
goto finish

:tips
call data\xecho DarkCyan "Welcome_to_the_TIPS!"
echo -------Tips List-------------------------
echo exit() | python >>nul
if not "%errorlevel%"=="0" echo -!!!- Many projects need python. It isnot at you pc, but if you have python and see this tip: please add python to path (in python setup) 
pip >>nul
if not "%errorlevel%"=="0" echo -!!!- You should have PIP at your pc if you wont to install python projects, (tick it in python setup or download it yourself) 
call droid pass>>nul
if not "%errorlevel%"=="0" echo -!!!- You should add Links\ folder to PATH, for use installed apps and DPM from cmd!!!!!
echo -----------------------------------------
pause
goto finish