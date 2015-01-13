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

setupInfoPath = "%s\\src\\product\\setupInfo"%(config.PROJECT_HOME)
icoPath = "%s\\setup\\logo.ico"%(temPath)

publishPath = "%s\\publish"%(config.PROJECT_HOME)
nsiFile = "%s\\setup\\web360.nsi"%(temPath)

############################################################# HouDongqiang��0705

# ִ��nsi�ű����ɰ�װ����
def packDir(templateName):

	templateName="spp"
	vcPath = "%s\\setup\\vcredist_x86.exe"%(temPath)
	target = "%s\\target"%(config.PROJECT_HOME)
	
	global tempName
	tempName = templateName
	newSppPath = "%s\\%s"%(publishPath, templateName)

	# ����Ŀ¼
	if  not os.path.isdir(publishPath):
		os.makedirs(publishPath)		
	
	# ����sppĿ¼
	if  not os.path.isdir(newSppPath):
		os.makedirs(newSppPath)
	# ��ģ��pack����ز��õ�target�£���Ϊnsis��Ϊ����������·������Ŀ��������ţ�
	

	os.system("xcopy  /y /q /E " +	icoPath+ " "+newSppPath)
	
		
	#����nsis�µ���Ŀ
	shutil.copyfile(nsiFile, publishPath+"\\web360.nsi")		# ʹ�����ַ�ʽ�����ļ���Ϊ������֡����ļ�����Ŀ¼������ʾ
	
	

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
	os.system("makensis web360.nsi")
	
	#ִ����ɺ�ɾ���齨
	# ɾ������ű�
	# os.remove("web360.nsi")
	
	#ɾ��spp·��
	newSppPath = "%s\\spp"%(publishPath)
	if os.path.exists(newSppPath):
		shutil.rmtree(newSppPath)	

	
#�޸İ�װ����
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
		prName=prName.replace("_","") #��ʱ����»�������
		
		installerName = proName + "ȫ��У԰"
		nameLnk =""
		
		if os.path.isfile(setupInfoPath+'\\setupName.txt'):
		

			if proName.find("ѧ") > 0 or proName.find("У") > 0:
					
				nameLnk =  installerName
					
				content=nsisStr.replace('n__n',installerName) #�滻��װ��������
				content=content.replace('lnkName',nameLnk)	 # �滻��ݷ�ʽ������
				content=content.replace('n_n_n',prName)#�滻��װ��ɺ�����֣���Ϊspp����������������
			
			else:
				print ""
				print proName,common.encodeChinese("������ʹ��У԰ģ����..........")
				print "-------------------------------------------------------------"
				os._exit(0)
					

			#����ǿ�¼�棬����CD.nsi
			f=open('web360.nsi','w')
			f.write(content)
			f.close()
		else:
			print common.encodeChinese("�Ҳ����ļ�/src/product/setupInfo/setupName.txt")
	except:
		print common.encodeChinese(config.ERR802)
	

