@echo off
@rem http://media.steampowered.com/installer/steamcmd.zip
SETLOCAL ENABLEDELAYEDEXPANSION

:: DEFINE the following variables where applicable to your install

SET STEAMLOGIN=
SET A3SERVERROOT=

IF [%STEAMLOGIN%]==[] goto :error
IF [%A3SERVERROOT%]==[] goto :error

:: _________________________________________________________

SET Arma3SteamID=107410
SET A3serverPath=%A3SERVERROOT%\server
SET STEAMPATH=%A3SERVERROOT%\Steamcmd
SET WORKSHOPPATH=%A3serverPath%\steamapps\workshop\content\107410
SET SERVER_MODPARAM=
SET SERVER_SERVERMODPARAM=

:: _________________________________________________________

echo.
echo     You are about to update/install ArmA 3 Vindicta serverside mods
echo        Dir: %A3serverPath%
echo        Branch: %A3serverBRANCH%
echo.
echo     Key "ENTER" to proceed
::pause

::If no parameters were given, continue with normal install
if [%1]==[] goto :normal_install
goto :justone

::--------------------------------------------------------------------------
:: The installation 

:normal_install
::@ace - http://steamcommunity.com/sharedfiles/filedetails/?id=463939057
call :install @ace 463939057
::@cba_a3 - http://steamcommunity.com/sharedfiles/filedetails/?id=450814997
call :install @cba_a3 450814997
::@advanced_towing - https://steamcommunity.com/sharedfiles/filedetails/?id=639837898
call :install @advanced_towing 639837898 true
::@Vindicta - https://steamcommunity.com/sharedfiles/filedetails/?id=2185874952
call :install @vindicta 2185874952
::@FileXT - https://steamcommunity.com/sharedfiles/filedetails/?id=2162811561
call :install @filext 2162811561 true

goto :end

::--------------------------------------------------------------------------
:: The installation for just one mod. 
:: call :justone %1
::
:: NOTE: This is currently broken! The MODNAME is not known and the :install routine will mklink to wrong directory
 
:justone
SET MODNAME=%1
SET MOD=%2
SET SERVERMOD=%3
echo ------------------------------------------------------------------------
echo ---Installing just ONE mod: %MODNAME% (ID: %MOD%)
call :install %MODNAME% %MOD% %SERVERMOD%
echo.
goto :end 

::--------------------------------------------------------------------------
:: The installation subroutine. 
:: call :install ModName SteamModID 
::
:: Params:
::  ModName : The name to use for the mod in server directory
::  SteamModID : ID of the workshop item defined by Steam
::	ServerModParam : 
::
:: Example:
::  call :install @ACE 463939057

:install
SET MODNAME=%1
SET MOD=%2
SET SERVERMOD=%3
echo ------------------------------------------------------------------------
echo ---Installing: %MODNAME% (ID: %MOD%)
%STEAMPATH%\steamcmd.exe +login %STEAMLOGIN% +force_install_dir %A3serverPath% +"workshop_download_item %Arma3SteamID% %MOD%" validate +quit
if not exist %A3serverPath%\%MODNAME% goto NO_RMDIR
rmdir %A3serverPath%\%MODNAME%
:NO_RMDIR
echo.
echo linking
mklink /j %A3serverPath%\%MODNAME% "%WORKSHOPPATH%\%MOD%"
:: Set server mod parameters
IF [%3]==[] SET SERVER_MODPARAM=%SERVER_MODPARAM%%MODNAME%;
IF [%3]==[true] SET SERVER_SERVERMODPARAM=%SERVER_SERVERMODPARAM%%MODNAME%;
echo.
exit /b

::--------------------------------------------------------------------------
:: The End 

:end
echo.
echo     Your ArmA 3 Vindicta server is now up to date
echo 	-mod=%SERVER_MODPARAM%
echo 	-servermod=%SERVER_SERVERMODPARAM%
echo     key "ENTER" to exit
pause
exit /b

:error
::--------------------------------------------------------------------------
:: Error
echo.
echo    ERROR: Please check that you have defined the STEAMLOGIN and A3SERVERROOT parameters
echo.
echo     key "ENTER" to exit
pause
exit /b