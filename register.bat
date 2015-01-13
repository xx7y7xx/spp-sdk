REM %~dp0 is D:\glue\
REM %CD% is D:\glue
cd %~dp0
SET input_SPP_HOME=%CD%
SET input_PYTHON_HOME=%input_SPP_HOME%\opt\Python27
SET input_NSIS_HOME=%input_SPP_HOME%\opt\NSIS

REM win xp

REM reg add "HKCU\Environment" /v SPP_HOME /t reg_sz /f /d %input_SPP_HOME%
REM reg add "HKCU\Environment" /v CRYSTAL_PLUGIN /t reg_sz /f /d %input_SPP_HOME%plugins\ext
REM reg add "HKCU\Environment" /v PYTHON_HOME /t reg_sz /d "%input_PYTHON_HOME%" /f
REM reg add "HKCU\Environment" /v NSIS_HOME /t reg_sz /d "%input_NSIS_HOME%" /f
REM reg add "HKCU\Environment" /v Path /t reg_sz /d "%%SPP_HOME%%;%%PYTHON_HOME%%;%%SPP_HOME%%bin;%%NSIS_HOME%%" /f

REM win7 or above

SETX SPP_HOME %input_SPP_HOME%
SETX CRYSTAL_PLUGIN %input_SPP_HOME%\plugins\ext
SETX PYTHON_HOME "%input_PYTHON_HOME%"
SETX NSIS_HOME "%input_NSIS_HOME%"
SETX Path "%%SPP_HOME%%;%%PYTHON_HOME%%;%%SPP_HOME%%\bin;%%NSIS_HOME%%"
