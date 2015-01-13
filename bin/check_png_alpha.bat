@echo off
python -c "import os,sys,Image,numpy,argparse;from os.path import join;sys.path=[join(os.environ['SPP_HOME'],'tools','script','python')]+sys.path; import check_png_alpha" %*