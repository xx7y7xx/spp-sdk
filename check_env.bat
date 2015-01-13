@echo off

SET X_EXPORT_PLG=C:\Program Files\Autodesk\3ds Max 2009\plugins\PandaDirectXMaxExporter_x64.dle

echo 检查X文件导出器
IF NOT EXIST %X_EXPORT_PLG% (
	echo    ！！！没有安装X文件导出器！！！
	pause
)

