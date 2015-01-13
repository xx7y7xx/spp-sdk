/**************************************************************************
 *
 *  This file is part of the UGE(Uniform Game Engine).
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *
 *  See http://uge.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://uge.spolo.org/  sales@spolo.org uge-support@spolo.org
 *
**************************************************************************/

// 这是错误，报告并退出。
function error(code, desc, detail)
{
	System.exitcode = code;
	alert("错误码：" + code + "\n",
		"问题描述：" + desc + "\n",
		"详细信息：" + detail + "\n");
	exit();
}
// 这是警告，报告但是继续运行。
function warning(code, desc, detail)
{
	System.exitcode = code;
	console.warn("错误码：" + code + "\n",
		"问题描述：" + desc + "\n",
		"详细信息：" + detail + "\n");
}

/**
 * @brief 检测数组中是否存在该mesh。数组中保存的都是mesh的index
 * @param mesharr -- 保存mesh index的数组。
 * @param meshindex -- 一个mesh的index
 */
function Checkmesh(mesharr, meshindex)
{
	for(var mi in mesharr)
	{
		if(mesharr[mi] == meshindex)
		{
			return true;
		}
	}
	return false;
}

/**
 * @brief 判断<code>factorylib.xml</code>中是否已经存在该本体了。
 * @param tworld -- <code>factorylib.xml</code>的<code><library></code>节点
 * @param Libraryename -- 本体的文件路径，比如<code>/factories/box.xml</code>
 */
function CheckLibrary(tworld, Libraryename)
{
	var Librarys = tworld.GetChildren();
	for(;Librarys.HasNext();)
	{
		var librarychild = Librarys.Next();
		if(librarychild.GetChildren().Next().value == Libraryename)
		{
			return true;
		}
	}
	return false;
}


/**
 * @brief 检查同名mesh
 * @param tworld -- world节点。
 * @param meshname -- 进行比较的mesh名称
 * @details 如果在world节点中发现了同名mesh，则返回true，否则false
 */
function CheckMeshObj(tworld, meshname)
{
	var MeshObjs = tworld.GetChild("sector").GetChildren();
	for(;MeshObjs.HasNext();)
	{
		var meshobj = MeshObjs.Next();
		if(meshobj.GetAttribute("name") == null)
		{
			continue;
		}
		if(meshobj.GetAttribute("name").value == meshname)
		{
			return true;
		}
	}
	return false;
}


function FindMeshObj(sector,meshname)
{
	var MeshObjs = sector.GetChildren();
	for(;MeshObjs.HasNext();)
	{
		var meshobj = MeshObjs.Next();
		// alert(meshobj.GetAttribute("name").value + " == " + meshname);
		// alert(meshobj.GetAttribute("name").value.length);
		// alert(meshname.length);
		if(meshobj.GetAttribute("name") == null)
		{
			continue;
		}
		if(meshobj.GetAttribute("name").value == meshname)
		{
			return meshobj;
		}
	}
	return false;
}


function CheckMeshFac(root,meshname)
{
	var MeshFacs = root.GetChildren();
	for(;MeshFacs.HasNext();)
	{
		var meshfac = MeshFacs.Next();
		if(meshfac.GetAttribute("name") == null)
		{
			continue;
		}
		if(meshfac.GetAttribute("name").value == meshname)
		{
			
			return true;
		}
	}
	return false;
}