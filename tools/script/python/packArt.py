# coding=utf-8
import os
import sys
import config
import common
import shutil
import sppbuild
import do_merge

####################################################
                           # ######���ļ����ڴ������ű�###
############################################################
tempName = ""


################################
##�����ļ���·��
temPath = "%s\\template"%(config.SPP_HOME)

dataPath = "%s\\data"%(config.SPP_HOME)
libsPath = "%s\\libs"%(config.SPP_HOME)
pluginsPath = "%s\\plugins"%(config.SPP_HOME)
libzPath = "%s\\libz-cs.dll"%(config.SPP_HOME)
sppPath = "%s\\spp.exe"%(config.SPP_HOME)
v8Path = "%s\\v8.dll"%(config.SPP_HOME)

nsiFile = "%s\\setup\\sppweek.nsi"%(temPath)
setupInfoPath = "%s\\school\\src_template\\src\\product\\setupInfo"%(temPath)
vcPath = "%s\\setup\\vcredist_x86.exe"%(temPath)
icoPath = "%s\\setup\\logo.ico"%(temPath)
target = "%s\\target"%(config.PROJECT_HOME)
sceneDir = "%s\\tools\\viewscene"%(config.SPP_HOME)

sceStart = "%s\\tools\\viewscene\\start.js"%(config.SPP_HOME)
publishPath = "%s\\publish"%(config.PROJECT_HOME)
newscenePath = "%s\\tools\\"%(publishPath)     #scene��ʱĿ¼
sceoldStart = "%s\\start.js"%(newscenePath)  #ԭ��toos�µ�start.js
############################################################# HouDongqiang��0705

# ִ��nsi�ű����ɰ�װ����
def packDir(templateName):
	# addPath = "%s\\addition"%(publishPath) #��װ�����·��

	# if templateName=="":
	templateName="spp"
	vcPath = "%s\\setup\\vcredist_x86.exe"%(temPath)
	target = "%s\\target"%(config.PROJECT_HOME)
	global tempName
	tempName = templateName
	newSppPath = "%s\\%s"%(publishPath, templateName)

	# ����Ŀ¼
	if  not os.path.isdir(publishPath):
		os.makedirs(publishPath)		
	# ����Ŀ¼
	#s
		
	# ��ģ��pack����ز��õ�target�£���Ϊnsis��Ϊ����������·������Ŀ��������ţ�
	
	os.system("xcopy /E /y /q "+	dataPath+" "+ newSppPath+"\\data\\")
	os.system("xcopy /E /y /q "+	pluginsPath +" "+newSppPath+"\\plugins\\")
	os.system("xcopy /E /y /q "+	sceneDir +" "+newscenePath)
	
	os.system("xcopy  /y /q " + sppPath+ " "+ newSppPath)
	os.system("xcopy  /y /q " + libzPath +" "+ newSppPath)
	os.system("xcopy  /y /q " +	v8Path+" "+ newSppPath)
	os.system("xcopy  /y /q " +	sceStart+" "+ newscenePath)
	
	#VC������װ��
	os.system("xcopy  /y /q " +	vcPath+ " "+newSppPath)
	os.system("xcopy  /y /q " +	icoPath+ " "+newSppPath)
	
	# shutil.copyfile(vcPath, newSppPath+"\\vcredist_x86.exe")	# ʹ�����ַ�ʽ�����ļ���Ϊ������֡����ļ�����Ŀ¼������ʾ
		
	#����nsis�µ���Ŀ
	shutil.copyfile(nsiFile, publishPath+"\\school.nsi")		# ʹ�����ַ�ʽ�����ļ���Ϊ������֡����ļ�����Ŀ¼������ʾ
	
	
	
	#ɾ��ԭ��tools�µ�js
	print sceoldStart
	if os.path.exists(sceoldStart):
		os.remove(sceoldStart)

	# ɾ�� publish/[school]/ Ŀ¼�µ�  shadercache  CEGUI.log  build.log �ļ�
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
	
	# ��¼��ִ�����
	# if sppbuild.setupType=="setupBurnGo":
		
		# tmpDir="%s\\template\\school\\python"%(config.SPP_HOME)
		# sys.path.append(tmpDir)
		# import burnGO
		# burnGO.process()

	
	# ʹ��bat���� ����nsis����ı���������nsi�ű�
def compileNsis():

	global tempName,flag
	flag=False
	publishPath = "%s\\publish"%(config.PROJECT_HOME)
	# addPath = "%s\\addition"%(publishPath) #��װ�����·��


	os.chdir(publishPath)

	nowPath=os.getcwd()
	changeProName()	
	
	#����nsis�ű�
	os.system("makensis setupArt.nsi")
	
	#ִ����ɺ�ɾ���齨
	# ɾ������ű�
	os.remove("setupArt.nsi")
	os.remove("school.nsi")
	
	#ɾ��spp·��
	newSppPath = "%s\\spp"%(publishPath)
	if os.path.exists(newSppPath):
		shutil.rmtree(newSppPath)	
	# ɾ��toolsĿ¼	
	if os.path.exists(newscenePath):
		shutil.rmtree(newscenePath)
	
#�޸İ�װ����
def changeProName():
	global content	
	flag=False
	
	# if sppbuild.setupType == "setupBurnGo":
		# flag=True
		
	# try:
	nsisStr=common.readFile('school.nsi')
	proName=common.readFile(setupInfoPath+'\\setupName.txt')
	merName=sppbuild.mergeList[0].split("_")[0]
	prName=(config.PROJECT_HOME).split("\\")[-1]
	prName=prName.replace("_","") #��ʱ����»�������
	
	installerName = proName + "���ð汾"
	name360 = proName + "360ȫ��չʾ"
	nameLnk =""
	fileScene = " File /r "+newscenePath
	fileStartJs = " File /r "+sceStart
	baseStr="Call InstallVC"
	
	if os.path.isfile(setupInfoPath+'\\setupName.txt'):
	

		if proName.find("ѧ") > 0 or proName.find("У") > 0:
				
			nameLnk =  installerName
				
			content=nsisStr.replace('n__n',installerName) #�滻��װ��������
			content=content.replace('lnkName',nameLnk)	 # �滻��ݷ�ʽ������
			content=content.replace('n_n_n',prName)#�滻��װ��ɺ�����֣���Ϊspp����������������
			content=content.replace('target\\*','target\\art')#�滻��װ��ɺ�����֣���Ϊspp����������������
			content=content.replace('--thread','--thread --debug')#�滻��װ��ɺ�����֣���Ϊspp����������������
			
			# ���tools
			oldContent = content.split(baseStr)
			oldContent[0] += 'File /r tools'
			content = oldContent[0] +"\n " + fileStartJs + "\n  " + baseStr + oldContent[1]
			

			
		else:
			print ""
			print proName,common.encodeChinese("������ʹ��У԰ģ����..........")
			print "-------------------------------------------------------------"
			os._exit(0)
				

		#����ǿ�¼�棬����CD.nsi
		f=open('setupArt.nsi','w')
		f.write(content)
		f.close()
	else:
		print common.encodeChinese("�Ҳ����ļ�/src/product/setupInfo/setupName.txt")
	# except:
		# print common.encodeChinese(config.ERR801)
	

