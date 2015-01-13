SET input_SPP_HOME=%~dp0
SET input_PYTHON_HOME=D:\spp_sdk\opt\Python27
SET input_NSIS_HOME=D:\spp_sdk\opt\NSIS

reg add "HKCU\Environment" /v SPP_HOME /t reg_sz /f /d %input_SPP_HOME%
reg add "HKCU\Environment" /v CRYSTAL_PLUGIN /t reg_sz /f /d %input_SPP_HOME%plugins\ext
reg add "HKCU\Environment" /v PYTHON_HOME /t reg_sz /d "%input_PYTHON_HOME%" /f
reg add "HKCU\Environment" /v NSIS_HOME /t reg_sz /d "%input_NSIS_HOME%" /f
reg add "HKCU\Environment" /v Path /t reg_sz /d "%%SPP_HOME%%;%%PYTHON_HOME%%;%%SPP_HOME%%bin;%%NSIS_HOME%%" /f