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

dataPath = "%s\\data"%(config.SPP_HOME)
libsPath = "%s\\libs"%(config.SPP_HOME)
pluginsPath = "%s\\plugins"%(config.SPP_HOME)
libzPath = "%s\\libz-cs.dll"%(config.SPP_HOME)
sppPath = "%s\\spp.exe"%(config.SPP_HOME)
v8Path = "%s\\v8.dll"%(config.SPP_HOME)

nsiFile = "%s\\setup\\spp.nsi"%(temPath)
setupInfoPath = "%s\\src\\product\\setupInfo"%(config.PROJECT_HOME)
vcPath = "%s\\setup\\vcredist_x86.exe"%(temPath)
icoPath = "%s\\setup\\logo.ico"%(temPath)
target = "%s\\target"%(config.PROJECT_HOME)

############################################################# HouDongqiang：0705

# 执行nsi脚本生成安装程序
def packDir(templateName):
	publishPath = "%s\\publish"%(config.PROJECT_HOME)
	addPath = "%s\\addition"%(publishPath) #安装包存放路径

	# if templateName=="":
	templateName="spp"
	if len(sppbuild.mergeList)>1:

		publishPath = "%s%s\\publish"%(sppbuild.pathP1,sppbuild.merName)
		addPath = "%s\\addition"%(publishPath) #安装包存放路径
	vcPath = "%s\\setup\\vcredist_x86.exe"%(temPath)
	target = "%s\\target"%(config.PROJECT_HOME)
	global tempName
	tempName = templateName
	newSppPath = "%s\\%s"%(publishPath, templateName)

	# 创建目录
	if  not os.path.isdir(publishPath):
		print publishPath
		os.makedirs(publishPath)		

	# 把模板pack打包素材拿到target下（因为nsis作为第三方，外路径下项目打包很蹩脚）
	
	os.system("xcopy /E /y /q "+	dataPath+" "+ newSppPath+"\\data\\")
	os.system("xcopy /E /y /q "+	pluginsPath +" "+newSppPath+"\\plugins\\")
	os.system("xcopy  /y /q " + sppPath+ " "+ newSppPath)
	os.system("xcopy  /y /q " + libzPath +" "+ newSppPath)
	os.system("xcopy  /y /q " +	v8Path+" "+ newSppPath)
	
	#VC环境安装包
	os.system("xcopy  /y /q " +	vcPath+ " "+newSppPath)
	os.system("xcopy  /y /q " +	icoPath+ " "+newSppPath)
	
	# shutil.copyfile(vcPath, newSppPath+"\\vcredist_x86.exe")	# 使用这种方式复制文件是为避免出现“是文件还是目录”的提示
		
	#拷贝target下的项目
	if len(sppbuild.mergeList) >1:            ### 合并时候操作
		pPath =os.path.join(sppbuild.pathP1,sppbuild.merName)
		shutil.copyfile(nsiFile, pPath+"\\school.nsi")		# 使用这种方式复制文件是为避免出现“是文件还是目录”的提示

	else:
		shutil.copyfile(nsiFile, publishPath+"\\school.nsi")		# 使用这种方式复制文件是为避免出现“是文件还是目录”的提示
		############### os.system("xcopy  /E/y /q "+target+" "+newSppPath)
	
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
	if sppbuild.setupType=="setupBurnGo":
		#
		tmpDir="%s\\template\\school\\python"%(config.SPP_HOME)
		sys.path.append(tmpDir)
		import burnGO
		burnGO.process()

	
	# 使用bat命令 调用nsis自身的编译器编译nsi脚本
def compileNsis():
	global tempName,flag
	flag=False
	publishPath = "%s\\publish"%(config.PROJECT_HOME)
	addPath = "%s\\addition"%(publishPath) #安装包存放路径

	if len(sppbuild.mergeList)>1:	
		publishPath = "%s%s\\publish"%(sppbuild.pathP1,sppbuild.merName)
		addPath = "%s\\addition"%(publishPath) #安装包存放路径
		os.chdir(sppbuild.pathP1+"\\"+sppbuild.merName)
	else:
		os.chdir(publishPath)

	nowPath=os.getcwd()
	changeProName()	
	#编译nsis脚本
	if sppbuild.setupType=="setupBurnGo":
		flag=True
	if flag:
		tempName="CD"
	else:
		tempName="CM"
	os.system("makensis "+tempName+".nsi")
	
	#执行完成后删除
	os.remove("school.nsi")
	os.remove(tempName+".nsi")
	
	# 删除spp目录
	newSppPath = "%s\\spp"%(publishPath)

	if os.path.exists(newSppPath):
		shutil.rmtree(newSppPath)
		


	
#修改安装包的
def changeProName():	
	flag=False
	
	if sppbuild.setupType == "setupBurnGo":
		flag=True
		
	try:
		nsisStr=common.readFile('school.nsi')
		
		# 获取安装包名称
		setupName = common.readFile(setupInfoPath+'\\setupName.txt') # 本地安装包
		if os.path.exists(setupInfoPath+'\\setupName360.txt'):
			setupName360 = common.readFile(setupInfoPath+'\\setupName360.txt') # 360全景版
		if os.path.exists(setupInfoPath+'\\setupName_cd.txt'):
			setupName_cd = common.readFile(setupInfoPath+'\\setupName_cd.txt') # 光盘版
		
		merName=sppbuild.mergeList[0].split("_")[0]
		prName=(config.PROJECT_HOME).split("\\")[-1]
		prName=prName.replace("_","") #临时解决下划线问题
		
		nameLnk =""
		
		#刻录版打包
		if flag:
			print common.encodeChinese("光盘版打包")
			prName +="BG" #替换安装包的名字为刻录版 

			#替换nsis代码
			oldString="File /r spp\*"
			bgString=oldString+"\n  File /r ../web360\\*"  	# 添加压缩360wab     
			executeSpp='ExecShell "" "$INSTDIR\spp.exe" "start.js --thread"' # 修改执行程序   
			executeHtml='ExecShell "open" "iexplore" "$INSTDIR\index_hd.html"'
			nsisStr=nsisStr.replace(oldString,bgString)
			nsisStr=nsisStr.replace(executeSpp,executeHtml)    
			nsisStr=nsisStr.replace(";O_O","")     #360全景快捷方式
		
		if os.path.isfile(setupInfoPath+'\\setupName.txt'):
			
			print common.encodeChinese("判断是模板类型")

			if common.IsHighSchoolTemplate() or \
				common.IsMiddleSchoolTemplate() or \
				common.IsTourTemplate() :
				
				# 光盘版
				if flag:
					nameLnk = setupName_cd
					nsisStr = nsisStr.replace('360LnkName', setupName360)
				# 本地安装包
				else:
					nameLnk =  setupName
				
				print common.encodeChinese("安装包的名称为："), nameLnk
				print 
					
				content=nsisStr.replace('n__n', nameLnk) #替换安装包的名字
				content=content.replace('lnkName', nameLnk)	 # 替换快捷方式的名字
				content=content.replace('n_n_n', prName)#替换安装完成后的名字，因为spp不能在中文下运行

				
			else:
				print ""
				print setupName, common.encodeChinese("该模板类型尚未支持，请检查项目文件夹中的src\product\init\type.txt文件！")
				print "-------------------------------------------------------------"
				common.exit(1)
					
			
				

			
			
			#合并版打包
			if len(sppbuild.mergeList)>1:
				content=nsisStr.replace('n__n',merName)#替换安装包的名字
				content=content.replace('n_n_n',merName)#替换安装完成后的名字，因为spp不能在中文下运行
				content1=content.split("Section  SecSpp")[0]
				content2=content.split("Section  SecSpp")[1]  #  File addition\vcredist_x86.exe    File /r addition\setupInfo
			
			#添加合并的事宜
				for merge in sppbuild.mergeList:
					content1+="\n Section  project_"+merge
					content1+="\n  SetOutPath \"$INSTDIR\\"+merge+"\""
					content1+="\n  File /r "+merge+"\\*"
					content1+="\n SectionEnd"
					content1+="\n "
					
				content1+="\n Section  SecSpp"
				content=content1+content2
				content=content.replace("addition","publish\\addition")		
				content=content.replace("school","publish\\school")	
				content=content.replace("OutFile \""+merName+".exe\"","OutFile \"publish\\"+merName+".exe\"")	
				content+=do_merge.overrideNsis()
			
			
			#如果是刻录版，生成CD.nsi
			if flag:
				f=open('CD.nsi','w')
			else:
				f=open('CM.nsi','w')
			f.write(content)
			f.close()
		else:
			print common.encodeChinese("找不到文件/src/product/setupInfo/setupName.txt")
	except:
		print common.encodeChinese(config.ERR800)
	

