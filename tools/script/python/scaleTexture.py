# -*- coding: utf-8 -*-

import os,sys,Image
import argparse # 处理参数使用

# config.py
import config
# utils.py
from utils import encodeChinese
from utils import spdebug

#########################文件调用方法#########################
# scaleTexture --src 待处理贴图路径 --dst 处理完的贴图的输出路径
##############################################################

# 命令行参数,用于传进贴图地址和处理后贴图保存地址
parser = argparse.ArgumentParser(description = encodeChinese('对lightmap进行ResetBrightness'))
parser.add_argument('--src', action='store', dest='src_image_dir',
                    help = encodeChinese('待处理贴图路径'))
parser.add_argument('--dst', action='store', dest='dst_image_dir',
                    help = encodeChinese('处理完的贴图的输出路径'))
parser.add_argument('--debug', action='store_true', dest='isdebug',
                    help= encodeChinese('调试程序的开关'))
args = parser.parse_args()

# 判断必须给定的参数
if args.src_image_dir is None :
	print encodeChinese('Error : 没有输入待处理贴图路径！\n<按任意键退出>')
	os.system('pause>nul')
	sys.exit()
if args.dst_image_dir is None :
	print encodeChinese('Error : 没有输入处理完的贴图的输出路径！\n<按任意键退出>')
	os.system('pause>nul')
	sys.exit()

if args.isdebug is True :
	config.DEBUG = True
else :
	config.DEBUG = False

rootDir = args.src_image_dir
targetDir = args.dst_image_dir
filepath = rootDir.split('\\target')[0] + os.sep + 'target\\errFile.txt'
spdebug( encodeChinese('文件路径: ') + filepath )
errFile = open(filepath,'w')

def judgeSize(im):
	#判断图片分辨率,如果最大边超过1024返回False,如果不超过返回True
	sizeOne = im.size[0]
	sizeTwo = im.size[1]
	if(sizeOne >sizeTwo):
		max = sizeOne
		min = sizeTwo
	else:
		max = sizeTwo
		min = sizeOne
	if(max > 1024):
		return False
	else:
		return True

def returnSize(im):
	#返回图片大小,返回两个值,第一个返回值总为最大
	max,min = im.size
	if max > min:
		return max,min
	else:
		return min,max
#判断文件夹是否存在
def judgeDir(rootDir):
	return os.path.exists(rootDir)
	
def changeSize(im,max,min):
	value = max/1024
	min = min/value
	newimg = im.resize((1024,min),Image.ANTIALIAS)
	return newimg

def main():
	for parent,dirnames,filenames in os.walk(rootDir):
		for filename in filenames:
			fName = filename
			filename = parent + os.sep + filename
			fPostfix = os.path.splitext(filename)[1]
			#连接成需处理文件夹链
			#indexValue = parent.index('image')
			#newPath = parent.split('\\image')[-1]
			#连接成保存处文件夹链
			newTarget = parent
			#print encodeChinese('newPath是: ') + newPath
			#print encodeChinese('newTarget是: ') + newTarget + '\n'
			try:
				img = Image.open(filename)
			except:
				print filename
				print encodeChinese('打开这个文件出错')
				continue
			#img.load()
			#print filename
			#print fPostfix
			if(fPostfix.lower() !='.jpg' and fPostfix.lower() !='.png'):	
				errFile.write(str(filename) + '\n')
				errFile.write(encodeChinese('上面这个文件不是图片,请检查...') + '\n')
				errFile.write('\n')
			else:
				#print 'juageSize()'	
				#如果尺寸不正确那么就调整它
				spdebug( encodeChinese('正在处理的文件是: \n') + filename)
				if(judgeSize(img) == False):
					#print 'judgeSize == False'
					max,min = returnSize(img)
					newimg = changeSize(img,max,min)
					if(judgeDir(newTarget)):
						#print encodeChinese('newTarget文件夹存在,文件处理后保存到这里,newTarget是: '),newTarget
						newimg.save(newTarget + os.sep + fName)
					else:
						#os.makedirs()默认的mode为0777,用于创建多级目录结构
						os.makedirs(newTarget)
						newimg.save(newTarget + os.sep + fName)
					#print str(newTarget + os.sep + fName) 
					spdebug( encodeChinese('保存完毕\n') )
				#如果尺寸正确就保存
				else:
					if (judgeDir(newTarget)):
						img.save(newTarget + os.sep + fName)
					else:
						os.makedirs(newTarget)
						img.save(newTarget + os.sep + fName)
					spdebug( encodeChinese('保存完毕\n') )
	spdebug( encodeChinese('\n所有文件处理完毕!') )
	errFile.close()

main()