@echo off

SET X_EXPORT_PLG=C:\Program Files\Autodesk\3ds Max 2009\plugins\PandaDirectXMaxExporter_x64.dle

echo ���X�ļ�������
IF NOT EXIST %X_EXPORT_PLG% (
	echo    ������û�а�װX�ļ�������������
	pause
)

