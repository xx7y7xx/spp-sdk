/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

(function(){

require("lang.js");

// 增强字符串处理函数
require("utils/string.js");

/// 增强`xmlDocument`对象的功能。
require("xmlDocument.js");

if(CmdLine.GetOption('debug',0))
{
	require("debug.js");
}else{
	require("ndebug.js");
}

// chenyang: 自动测试时候alert会造成程序停止运行。
if(CmdLine.GetOption('autotest',0))
{
	alert = function() {};
}

//require("watch.js");
require("s3dcore.js");

// 处理用户调用废弃的接口
require("deprecated.js");

//处理--tools命令行参数。
require("toolpath_prc.js");

if(CmdLine.GetOption('debug',0))
{
	(function(){
		var con = Registry.Get("iConsole");
		var mounters = VFS.GetMounts();

		var vp,i; 
		con.WriteLine("");
		con.WriteLine("Mounted VFS Table show as flowing:");
		for(i in mounters){
			var rp, j;
			vp = mounters[i];
			var mountees = VFS.GetRealMountPaths(vp);
			for(j in mountees){
				rp = mountees[j];
				con.WriteLine(vp + "\tmounted from:" + "\n" + rp);
				con.WriteLine("");
			}
		}
	
		con.WriteLine("Mounted VFS Table show end~");
		con.WriteLine("");
	})();
}
})();
