#!/usr/bin/python
# -*- coding: utf-8 -*-

#*************************************************************************
#
#  This file is part of the UGE(Uniform Game Engine).
#  Copyright (C) by SanPolo Co.Ltd. 
#  All rights reserved.
#
#  See http://uge.spolo.org/ for more information.
#
#  SanPolo Co.Ltd
#  http://uge.spolo.org/  sales@spolo.org uge-support@spolo.org
#
#************************************************************************

# 检查文件夹中的贴图是否符合如下几个规范
# 1. 文件夹中的文件必须是一种图片格式。
# 2. 贴图的width和height都必须小于512px。
# 3. 贴图的width和height都必须是2的指数。
# 4. 贴图的file size不能超过1MB。

import Image
import os,sys
import argparse
import common
import utils

def encodeChinese(msg):
	type = sys.getfilesystemencoding()
	return msg.decode('utf-8').encode(type)
	
image_path='保存图片的路径'
log_path='输出错误日志'
help_image_path=encodeChinese(image_path)
help_log_path=encodeChinese(log_path)
help_path=encodeChinese('检测给定的文件夹中的文件是否符合要求(格式,大小,分辨率)')

parser = argparse.ArgumentParser(description=encodeChinese('检测给定的文件夹中的文件是否符合要求(格式,大小,分辨率)'))
parser.add_argument('--dir', action='store', dest='image_dir',
                    help=help_image_path) #common.encodeChinese(help_log_path))
parser.add_argument('--log', action='store', dest='log_filename',
                    help=help_log_path) #common.encodeChinese(help_log_path))
parser.add_argument('--version', action='version', version='%(prog)s 1.0')
args = parser.parse_args()

err_image_dir=encodeChinese('没有输入保存图片文件的文件夹')
err_log_dir=encodeChinese('没有输入保存错误信息的日志文件名称')
                    
# 判断必须给定的参数
if args.image_dir is None :
	print err_image_dir#common.encodeChinese('没有输入保存图片文件的文件夹')
	sys.exit()
if args.log_filename is None :
	print err_log_dir #common.encodeChinese('没有输入保存错误信息的日志文件名称')
	sys.exit()


file_path = open(args.image_dir,'r')
errPath=args.log_filename
imageList = file_path.read()
print args.log_filename
#判断原错误日至是否存在,若存在则删除
if os.path.isfile(errPath):
	os.remove(errPath)
#判断文件类型
def judgeImageType(filename):
	img = Image.open(filename)
	fPostfix = os.path.splitext(filename)[1]
	if((fPostfix.lower() == '.png' or fPostfix.lower() == '.jpg')
	and (img.mode.lower() == 'rgb' or img.mode.lower() == 'rgba')):
		return True
	else:
		#print str(filename) + '\t' + encodeChinese('文件不是图片')
		return False

#判断这个文件类型是否为P
def judgeImageMode(filename):
	img = Image.open(filename)
	if img.mode.lower() == 'p':
		return True
	else:
		return False
	
def judgeImageSize(img):
	width,height = img.size
	if width > height:
		max = width
	else:
		max = height
	if max > 512:
		# print str(filename) + '\t' + encodeChinese('文件尺寸超过512')
		return False
	else:
		# print str(filename) + '\t' + encodeChinese('文件尺寸不超过512')
		return True

def judgeImageScale(img):
	width,height = img.size
	# 贴图的width和height必须都是2的指数。
	#
	#                                      整数
	# log width == 整数       或者        2       == width
	#    2
	#
	if(utils.log2n_is_N(width) and utils.log2n_is_N(height)):
		# print str(filename
		return True
	else:
		return False

def judgeImageByte(filename):
	f = open(filename,'rb')
	f.seek(0,2)
	fSize = f.tell()
	standard = 1024
	if(fSize / standard > standard):
		return False
	else:
		return True

def main():
	for filename in imageList.split("\n"):
#	for parent,dirnames,filenames in os.walk(rootdir):
#		print 'ok'
#		for filename in filenames:
#			fName = filename 
#			filename = parent + os.sep + fName
		if len(filename) != 0:
			try:
				img = Image.open(filename)
			except:
				print str(filename) + '\t' + encodeChinese('这个文件打开错误,不是贴图')
				errFile=open(errPath,'a')
				errFile.write(str(filename) + '\t' + encodeChinese('这个文件打开错误,不是贴图') + '\n')
				errFile.close()
				continue
			if(judgeImageType(filename)):
				print str(filename) + '\t' + encodeChinese('这个文件类型正确')
				if(judgeImageSize(img)):
					print str(filename) + '\t' + encodeChinese('这个文件的尺寸小于512')
					if(judgeImageScale(img)):
						str(filename) + '\t' + encodeChinese('这个文件的尺寸是2的倍数')
						if(judgeImageByte(filename)):
							print str(filename) + '\t' + encodeChinese('这个文件不超过1M')
						else:
							print str(filename) + '\t' + encodeChinese('这个文件超过1M')
							errFile=open(errPath,'a')
							errFile.write(str(filename) + '\t' + encodeChinese('这个文件超过1M'))
							errFile.write('\n')
							errFile.close()
							continue
					else:
						str(filename) + '\t' + encodeChinese('这张贴图的长度或者宽度不是2的指数')
						errFile=open(errPath,'a')
						errFile.write(str(filename) + '\t' + encodeChinese('这张贴图的长度或者宽度不是2的指数'))
						errFile.write('\n')
						errFile.close()
						continue
				else:
					print str(filename) + '\t' + encodeChinese('这个文件的尺寸大于512')
					errFile=open(errPath,'a')
					errFile.write(str(filename) + '\t' + encodeChinese('这个文件的尺寸大于512'))
					errFile.write('\n')
					errFile.close()
					continue
			elif(judgeImageMode(filename)):
				print str(filename) + '\t' + encodeChinese('mode = p') + '\n'
				# errFile = open(errPath,'a')
				# errFile.write(str(filename) + '\t' + encodeChinese('mode = p') + '\n')
				# errFile.close()
				continue
			else:
				print str(filename) + '\t' + encodeChinese('这个文件类型不正确')
				errFile=open(errPath,'a')
				errFile.write(str(filename) + '\t' + encodeChinese('这个文件类型不正确') + '\n')
				errFile.close()
				continue

main()

#EOF