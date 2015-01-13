# coding=utf-8

import sys

import config

##
# @brief 该数字（num变量）的以2为底的对数是整数（Binary logarithm is natural number）。
# 函数名称最后一个大写的N意思是Natural number，参照wikipedia中对自然数的符号表示（Notation）
# 比如2,4,8,16,32,64,128,256,512
##
def log2n_is_N(num) :
	import math
	return math.log(num, 2) - int(math.log(num, 2)) == 0

def spdebug(str) :
	if config.DEBUG == True :
		print str

##
# @brief encode utf-8 to gbk
# msg in utf-8 format, return gbk format.
## 
def encodeChinese(msg):
	type = sys.getfilesystemencoding()
	return msg.decode('UTF-8').encode(type)