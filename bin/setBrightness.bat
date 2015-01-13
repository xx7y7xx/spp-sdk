@echo off
python -c "import os,sys;from os.path import join;sys.path=[join(os.environ['SPP_HOME'],'tools','script','python')]+sys.path; import setBrightness" %*