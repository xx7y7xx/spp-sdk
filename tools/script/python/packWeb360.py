# coding=utf-8
import os
import sys
import config
import common
import shutil
import sppbuild
import do_merge

####################################################
                           # ######本文件用于处理打包脚本###
############################################################
tempName = ""


################################
##配置文件的路径
temPath = "%s\\template"%(config.SPP_HOME)

setupInfoPath = "%s\\src\\product\\setupInfo"%(config.PROJECT_HOME)
icoPath = "%s\\setup\\logo.ico"%(temPath)

publishPath = "%s\\publish"%(config.PROJECT_HOME)
nsiFile = "%s\\setup\\web360.nsi"%(temPath)

############################################################# HouDongqiang：0705

# 执行nsi脚本生成安装程序
def packDir(templateName):

	templateName="spp"
	vcPath = "%s\\setup\\vcredist_x86.exe"%(temPath)
	target = "%s\\target"%(config.PROJECT_HOME)
	
	global tempName
	tempName = templateName
	newSppPath = "%s\\%s"%(publishPath, templateName)

	# 创建目录
	if  not os.path.isdir(publishPath):
		os.makedirs(publishPath)		
	
	# 创建spp目录
	if  not os.path.isdir(newSppPath):
		os.makedirs(newSppPath)
	# 把模板pack打包素材拿到target下（因为nsis作为第三方，外路径下项目打包很蹩脚）
	

	os.system("xcopy  /y /q /E " +	icoPath+ " "+newSppPath)
	
		
	#拷贝nsis下的项目
	shutil.copyfile(nsiFile, publishPath+"\\web360.nsi")		# 使用这种方式复制文件是为避免出现“是文件还是目录”的提示
	
	

	# 删除 publish/[school]/ 目录下的  shadercache  CEGUI.log  build.log 文件
	delFile1 = "%s\\shadercache"%(newSppPath)
	delFile2 = "%s\\CEGUI.log"%(newSppPath)
	delFile3 = "%s\\build.log"%(newSppPath)
	
	if os.path.isdir(delFile1):
		shutil.rmtree(delFile1)
		
	if os.path.isfile(delFile2):
		os.remove(delFile2)
	
	if os.path.isfile(delFile3):
		os.remove(delFile3)
		
	print  sppbuild.setupType
	
	# 刻录版执行入口
	# if sppbuild.setupType=="setupBurnGo":
		
		# tmpDir="%s\\template\\school\\python"%(config.SPP_HOME)
		# sys.path.append(tmpDir)
		# import burnGO
		# burnGO.process()

	
	# 使用bat命令 调用nsis自身的编译器编译nsi脚本
def compileNsis():

	global tempName,flag
	flag=False
	publishPath = "%s\\publish"%(config.PROJECT_HOME)
	# addPath = "%s\\addition"%(publishPath) #安装包存放路径


	os.chdir(publishPath)

	nowPath=os.getcwd()
	changeProName()	
	
	#编译nsis脚本
	os.system("makensis web360.nsi")
	
	#执行完成后删除组建
	# 删除打包脚本
	# os.remove("web360.nsi")
	
	#删除spp路径
	newSppPath = "%s\\spp"%(publishPath)
	if os.path.exists(newSppPath):
		shutil.rmtree(newSppPath)	

	
#修改安装包的
def changeProName():
	global content	
	flag=False
	
	# if sppbuild.setupType == "setupBurnGo":
		# flag=True
		
	try:
		nsisStr=common.readFile('web360.nsi')
		proName=common.readFile(setupInfoPath+'\\setupName.txt')
		merName=sppbuild.mergeList[0].split("_")[0]
		prName=(config.PROJECT_HOME).split("\\")[-1]
		prName=prName.replace("_","") #临时解决下划线问题
		
		installerName = proName + "全景校园"
		nameLnk =""
		
		if os.path.isfile(setupInfoPath+'\\setupName.txt'):
		

			if proName.find("学") > 0 or proName.find("校") > 0:
					
				nameLnk =  installerName
					
				content=nsisStr.replace('n__n',installerName) #替换安装包的名字
				content=content.replace('lnkName',nameLnk)	 # 替换快捷方式的名字
				content=content.replace('n_n_n',prName)#替换安装完成后的名字，因为spp不能在中文下运行
			
			else:
				print ""
				print proName,common.encodeChinese("不可以使用校园模板打包..........")
				print "-------------------------------------------------------------"
				os._exit(0)
					

			#如果是刻录版，生成CD.nsi
			f=open('web360.nsi','w')
			f.write(content)
			f.close()
		else:
			print common.encodeChinese("找不到文件/src/product/setupInfo/setupName.txt")
	except:
		print common.encodeChinese(config.ERR802)
	

