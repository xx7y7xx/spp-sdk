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

function GetSeperator()
{
	return ((System.osName == "win32") ? '\\' : '/');
}

function GetFullPath(path)
{
	var fullpath;
	if(System.osName == "win32")
	{
		if(path.length > 2 && path[1] == ':')
		{
			fullpath = path;
		}else{
			fullpath = System.InstallPath()　+ "\\tools\\";
			fullpath += path;
		}
	}else{
		if(path[0] == '/')
		{
			fullpath = path;
		}else{
			fullpath = System.InstallPath() + "/tools/";
			fullpath += '/';
			fullpath += path;
		}
	}
	return fullpath;
}

function  NormalizePath(path)
{
	var np;
	if(System.osName == "win32")
	{
		np = path.replace("/","\\");
	}else{
		np = path.replace("\\","/");
	}
	return np;
}

//为路径末尾添加一个路径分割符——如果不是以分隔符结尾。
function  AppendSeperator(path)
{
	if(path.length == 0)
		return ((System.osName == "win32") ? "\\" : "/");

	var lastchar = path.charAt(path.length-1);
	if(lastchar != '/' && lastchar != '\\')
	{
		return path + ((System.osName == "win32") ? "\\" : "/");
	}
	return path;
}

function pathprc(tool)
{
	//首先尝试这是一个路径。
	if(typeof tool != "string")
		return false;
	var lastSepPos = tool.lastIndexOf(GetSeperator());
	var toolpath;
	if(lastSepPos > 0)
	{
		toolpath = tool.substr(0,lastSepPos);
		toolpath = NormalizePath(toolpath);
	}
	else
	{
		toolpath = NormalizePath(tool);
	}
	//尝试将fulltool映射为根路径，如果可以映射，说明fulltool指明了一个路径。
	var realRootPath = AppendSeperator(GetFullPath(toolpath));
	if( VFS.Mount("/tools", realRootPath) )
	{//这里我们开始检查目录中的js文件。
		//检查是否有start.js

		if(VFS.Exists("/tools/start.js"))
		{
			return load("/tools/start.js");
		}

		var  startName = "/tools/";
		//最后一个分割符的位置。
		var lastSepPos = tool.lastIndexOf(GetSeperator());
		if(lastSepPos > 0)
		{//如果有分割符，最后一个分割符之后的部分是我们请求的文件名。
			startName += tool.substr(lastSepPos+1,tool.length);
		}else{
		//否则，全部路径都做为启动名称。
			startName += tool;
		}
		if(startName.substr(startName.length-3,startName.length).toLocaleLowerCase() !=".js")
		{
			startName += ".js";
		}
		if(VFS.Exists(startName))
		{
			return load(startName);
		}
	}
	
	{
		//到达这里，tool参数给出的字符串不是一个路径，包含了一个文件名。
		VFS.Unmount("/tools",realRootPath);
		VFS.Sync();
		
		var lastSepPos = tool.lastIndexOf(GetSeperator());
		if(lastSepPos > 0)
		{//如果有分割符，最后一个分割符之后的部分是我们请求的文件名。之前是我们请求的
			var pathname = tool.substr(0,lastSepPos+1);
			var startName = "/tools/" + tool.substr(lastSepPos+1,tool.length);

			var realRootPath = AppendSeperator(GetFullPath(pathname));
			if(VFS.Mount("/tools", realRootPath))
			{
				if(VFS.Exists(startName))
				{
					return load(startName);
				}
				
				VFS.Unmount("/",realRootPath);
			}
		}else{
			//没有分割符，错误参数！
		}
	}
	return false;
}


var tool = CmdLine.GetOption("tools");
if(tool != undefined)
{
	if(!pathprc(tool))
	{
		System.exitcode = -10;
		alert("can not find tool : ",tool);
	}
}

})();