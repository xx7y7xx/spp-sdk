"c:\Program Files\TortoiseSVN\bin\TortoiseProc.exe" /command:update /path:"D:\spp_sdk" /closeonend:2

REM -- update scene tool in max

copy /y %SPP_HOME%tools\script\max\scenetool.mcr "%LOCALAPPDATA%\Autodesk\3dsmax\2009 - 64bit\enu\UI\usermacros\Superpolo-SPP_sceneTool.mcr"
copy /y %SPP_HOME%tools\script\max\scenetool_modify.mcr "%LOCALAPPDATA%\Autodesk\3dsmax\2009 - 64bit\enu\UI\usermacros\Superpolo-SPP_sceneToolModify.mcr"