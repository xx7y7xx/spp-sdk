# coding=utf-8
import os
import sys
import shutil 
from os.path import join

import config
import common

#------------------------------------

src_temPath = "%ssrc_template\\"%(config.schoolTemDir)
log = "svn.log"
def createProject(pname):
	# 选择模板
	templateName = "school"

	res = os.system('svn log http://192.168.4.10/svn/t/'+pname+'>svn.log')
	if res == 1:
		print ''
		print common.encodeChinese('忽略这个错误，程序正常执行....')
		print ''
		print '-------------------------------'
		print common.encodeChinese('正在创建项目...')
		# 将svn 中的 src 标准模板导出
		# os.system('svn export http://192.168.1.7/svn/project/template/trunk/'+templateName+'/src_template  '+pname)
		
		# copy src_template
		
		#检测本地是否已经存在该项目
		if os.path.isdir(pname):
			print""
			print common.encodeChinese('<<< 错误！ '+pname+'在本地已经存在 !')
			os._exit(0)
		
		shutil.copytree(src_temPath,pname)
		
		#提交svn4.10
		msg = "Create new project: "+pname
		os.system('svn import -m "'+msg+'" '+pname+' http://192.168.4.10/svn/t/'+pname)
		
		if os.path.exists(pname):
			shutil.rmtree(pname)
		# 再检出项目
		os.system('svn checkout  http://192.168.4.10/svn/t/'+pname+' '+pname)
		print ''
		print '-------------------------------'
		print os.getcwd()
		print common.encodeChinese('<<< 项目已经checkout到当前目录中。')
	else:
		print ''
		print ''
		print 'ERROR:'
		print common.encodeChinese('你要创建的目录SVN上已经存在了！')
		print ''
		print ''
		print ''
	
	if os.path.isfile(log):
		os.remove(log)
			
	common.pause()
		

