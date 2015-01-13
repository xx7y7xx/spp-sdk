@echo off
set /p var=请输入项目名: 
echo 输入的项目名为：%var%   如果正确按回车！
pause
sppbuild --create=%var%