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

/// 为全局对象xmlDocument添加更多功能。

(function(){

/**
 * @brief 克隆节点
 * @param {Object} dnode
 * @param {Object} snode
 * @details 如果失败了，则返回false
 */
var CopyNode = function (dnode, snode)   //参数均为iDocumentNode对象
{
	dnode.value = snode.value;
	var sai = snode.GetAttribute();  //获取snode的所有属性的迭代器
	while(sai.HasNext())      //扫描所有属性
	{
		var att = sai.Next();    //获取属性
		dnode.SetAttribute(att.name,att.value);   //为dnode创建相同的属性名
	}
	var sci = snode.GetChildren();   //获取snode的所有子节点的迭代器
	while(sci.HasNext())     //扫描所有的子节点
	{
		var tchild = sci.Next();
		if(!CopyNode(dnode.CreateChild(tchild.type), tchild))  //检查执行是否成功
		{
			return false;
		}
	}
	return true;
};
xmlDocument.CopyNode = CopyNode;

	/**
	 * @brief 获取根节点。
	 * @param filename {String} 文件的VFS绝对路径。
	 * @param nodename {String} 根节点名称，比如“world”或者“library”
	 */
	xmlDocument.getRootNode = function(filename, nodename)
	{
		var libdoc = new xmlDocument();
		var libfile = VFS.Open(filename);
		
		console.debug("Opening file [" + filename + "]");
		if(!libfile)
		{
			console.debug("Failed to open file [" + filename + "]");
			return false;
		}
		
		console.debug("Parsing file [" + filename + "]");
		if(!libdoc.Parse(libfile))
		{
			console.debug("Failed to parse file [" + filename + "]");
			return false;
		}
		
		return libdoc.root.GetChild(nodename);
	};

})();