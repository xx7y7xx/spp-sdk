@ECHO OFF

rem ==========================================================================
rem Full SPP Demo
rem Ref : http://www.dostips.com/DtTipsMenu.php
rem ==========================================================================

REM.-- Prepare the Command Processor
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

rem Go to the dir which contains `spp.exe`
cd /d %~dp0

:menuLOOP
echo.
echo.= Menu =================================================
echo.
for /f "tokens=1,2,* delims=_ " %%A in ('"findstr /b /c:":menu_" "%~f0""') do echo.  %%B  %%C
set choice=
echo.&set /p choice=Make a choice or hit ENTER to quit: ||GOTO:EOF
echo.&call:menu_%choice%
GOTO:menuLOOP

::-----------------------------------------------------------
:: menu functions follow below here
::-----------------------------------------------------------

:menu_1   Hulu Game the Demo
spp.exe sample\demo\hulu\start.js
cls
GOTO:EOF

:menu_2   Island the Demo
spp.exe sample\demo\island\start.js
cls
GOTO:EOF

:menu_

:menu_3   SPP Effect the Demo
cls
@call sample\tutorial\effect\menu.bat
cls
GOTO:EOF

@rem  :menu_
@rem  
@rem  :menu_T   Tip
@rem  echo.It's easy to add a line separator using one or more fake labels
@rem  cls
@rem  GOTO:EOF
@rem  
@rem  :menu_C   Clear Screen
@rem  cls