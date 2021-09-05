@Echo off
cd %~dp0
chcp 65001 >> nul
color F
set ver=1.2.0
set name=Droid_Package_Manager
set shortname=DPM
title %shortname% - %ver%
echo cd %%~dp0\..\ >Links\droid.cmd
echo dpm.cmd %%* >>Links\droid.cmd
md Links >> nul
md Packages >> nul
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
call data\xecho Yellow "Help_menu..."
echo Syntax:
echo dpm (action) (optional:package_name) (optional:author_name)
echo.
echo Actions:
echo install (installing\reinstalling new repo)
echo uninstall (uninstalling repo)
echo update (rewriting exist repo)
echo list (opens repo links folder)
echo upgrade (updates self)
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
:finish

:finish
echo.
call data\xecho Green "DPM_work_completed!"
echo.
exit /b

:install
if exist Packages\%package_name% call data\xecho Red "Uninstalling-%package_name%..." & rmdir /q /s Packages\%package_name%

call data\xecho Cyan "Downloading-%package_name%..."
data\gh.exe repo clone %sub_arg%/%package_name% Packages\%package_name%

call data\xecho Blue "Installing-%package_name%..."
echo.
cd Packages\%package_name%
dir /b
cd %~dp0
echo.
set /p ex=Please, choose file for exec(1.py, 1.exe, 1.bat, 1.jar etc):
echo @Echo off > Links\%package_name%.cmd
echo "%%~dp0..\Packages\%package_name%\%ex%" %%*>> Links\%package_name%.cmd
goto finish

:uninstall
call data\xecho Red "Uninstalling-%package_name%..."
rmdir /q /s Packages\%package_name%
del /f Links\%package_name%.cmd
goto finish

:update
call data\xecho Yellow "Updating-%package_name%..."
data\gh.exe repo clone %sub_arg%/%package_name% Packages\TempUpdate%package_name%
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
xcopy Packages\TempUpgradeSelf %~dp0 /H /Y /C /R /S /I
rmdir /q /s Packages\TempUpgradeSelf
goto finish