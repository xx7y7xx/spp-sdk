@echo off
python -c "from os.path import join; import sys,os; sys.path=[join(os.environ['SPP_HOME'] ,'tools','script','python')]+sys.path; import sppbuild" %*
IF NOT %ERRORLEVEL%==0 pause
pause