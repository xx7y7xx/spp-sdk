# -*- coding: utf-8 -*-

import Image
import os
import sys
import ImageEnhance
import argparse
import common

# utils.py
import utils
from utils import encodeChinese

# config.py
import config

parser = argparse.ArgumentParser(description = encodeChinese('进行亮度整理'))
parser.add_argument('--src', action='store', dest='src_image_dir',
                    help = encodeChinese('待处理贴图路径，比如D:\\tmp，也可以是一个包含贴图路径的txt文件，比如D:\\tmp\\texlist.txt，所有贴图必须是绝对路径'))
parser.add_argument('--dst', action='store', dest='dst_image_dir',
				          help = encodeChinese('处理后贴图路径'))
parser.add_argument('--brightness', action='store',dest='bright',
                    help = encodeChinese('设定亮度值'))
parser.add_argument('--contrast',action='store',dest='contrast',
				help = encodeChinese('设定对比度'))
parser.add_argument('--donotwait', action='store_true', dest='notwait',
                    help= encodeChinese('程序结束之后是否等待用户按任意键，如果需要将本程序继承到其他工具集中，可以考虑打开donotwait开关'))
parser.add_argument('--debug', action='store_true', dest='isdebug',
                    help= encodeChinese('调试程序的开关'))
parser.add_argument('--version', action='version', version='%(prog)s 1.0')		    
args = parser.parse_args()
					
# 判断必须给定的参数
if args.src_image_dir is None :
	print encodeChinese('Error : 没有输入待处理贴图路径！\n<按任意键退出>')
	os.system('pause>nul')
	sys.exit()

if args.dst_image_dir is None:
	print encodeChinese('Error: 没有输入处理后贴图路径! \n<按任意键退出>')
	os.system('pause>nul')
	sys.exit()
	
if args.bright is None:
	print encodeChinese('Error: 没有输入亮度值! \n<按任意键退出>')
	os.system('pause>nul')
	sys.exit()

if args.contrast is None:
	print encodeChinese('Error:没有输入对比度! \n<按任意键退出>')
	os.system('pause>nul')
	sys.exit()

if args.isdebug is True :
	config.DEBUG = True
else :
	config.DEBUG = False

#判断接受到的路径是否为目录
def judgeDir(path):
	return os.path.isdir(path)
	
rootDir = args.src_image_dir
# targetDir = rootDir.split('src\\')[0]
targetDir = args.dst_image_dir
brightnessValue = args.bright

def changeBrightness(img,brightnessValue):
	brightnessValue = 1 + 0.01 * float(brightnessValue)
	if img.mode == 'RGB':
		enhancer = ImageEnhance.Brightness(img)
		img = enhancer.enhance(brightnessValue)
		return img
	elif img.mode == 'RGBA':
		data = img.getdata()
		enhancer = ImageEnhance.Brightness(img)
		img = enhancer.enhance(brightnessValue)
		newdata = img.getdata()
		truedata = list()
		i = 0
		for item in newdata:
			truedata.append((item[0],item[1],item[2],data[i][3]))
			i += 1
		img.putdata(truedata)
		return img

#改变图片对比度
def changeContrast(img,contrastValue):
	#获取图片对比度
	myContrast = ImageEnhance.Contrast(img)
	contrast_img = myContrast.enhance(float(contrastValue))
	return contrast_img
		
def loop(rootdir, brightnessValue):
	# src is a dir
	if judgeDir(rootdir):
		for parent,dirnames,filenames in os.walk(rootdir):
			for filename in filenames:
				fName = filename
				filename = parent + os.sep + fName
				try:
					img = Image.open(filename)
				except:
					print str(filename) + '\t' + encodeChinese('不是贴图')
					continue
				if img.mode.lower() == 'rgb' and fName.find('sky') == -1:
					newimg = changeBrightness(img,brightnessValue)
					try:
						newimg.save(targetDir + os.sep + fName, quality = 100)
						#print targetDir + fName
					except:
						os.makedirs(targetDir)
						#print 'os.mkdir'
						newimg.save(targetDir + os.sep + fName, quality = 100)
	# src is a txt file, containing all textures path.
	else:
		file_path = open(rootdir,'r')
		file_info = file_path.read()
		#print file_info
		
		for fileline in file_info.split('\n'):
			if len(fileline) != 0:
				#依次获取文件名,亮度值,对比度数值
				filename,brightnessValue,contrastValue = fileline.split('$')
				#print filename,brightnessValue
				
				utils.spdebug(filename)
				utils.spdebug("brightness : " + brightnessValue)
				utils.spdebug("contrast : " + contrastValue)
				
				if os.path.exists(filename) is False :
					print str(filename) + '\t' + encodeChinese('文件不存在')
					continue
				
				try:
					img = Image.open(filename)
				except:
					print str(filename) + '\t' + encodeChinese('ImageEnhance库打开图片文件时候抛出异常！')
					continue
				
				if img.mode.lower() == 'rgb' or img.mode.lower() == 'rgba': 
					newimg = changeBrightness(img,brightnessValue)
					newimg = changeContrast(newimg,contrastValue)
					try:
						newimg.save(filename, quality = 100)
						utils.spdebug(filename + ' is ok!')
					except:
						os.makedirs(targetDir)
						#print 'os.mkdir'
						newimg.save(filename, quality = 100)
					
loop(rootDir, brightnessValue)

if args.notwait is False :
	print common.encodeChinese('亮度设置成功！点任意键继续！')
	common.pause()