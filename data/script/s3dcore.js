/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

require("console.js");

/**
 * @brief 用来提供一种便利的方式操作场景树。
 **/
var SceneTree = null;
(function(){

SceneTree = new Object();

/**
 * @brief 获取第几个sector
 **/
var getSector = function(n)
{
	var engine = Registry.Get('iEngine');
	var sectorList = engine.sectors;  // 取到sectorlist 每个sector都有一个标签（index） 
	return sectorList.Get(n);
}
SceneTree.getSector = getSector;

/**
 * @brief 获取world中的第一个sector
 **/
SceneTree.getFirstSector = function()
{
	return getSector(0);
}

/**
 * @brief 场景树中是否有camera存在了。
 **/
SceneTree.isCameraExist = function()
{
	return (C3D.engine.camPositions.count == 0) ? false : true;
}

/**
 * @brief 在场景中扔进来一个模型
 * @param libPath -- 定义该模型工厂的文件路径。比如<code>/art/models/player/factories/genMonster.xml</code>
 * @param meshFactName -- 定义上述模型工厂的名字，比如<code>genMonster</code>
 * @param sectorName -- 往哪个sector中添加该mesh。
 * @param meshObjectName -- mesh的名称，比如<code>Monster</code>。
 * @param pos -- 该模型在场景中的坐标。
 **/
SceneTree.CreateMeshFromFactory = function(libPath, meshFactName, sectorName, meshObjName, pos)
{
	// 加载包含模型工厂的xml文件。
	console.debug("Loading lib : " + libPath);
	C3D.loader.LoadLibrary(libPath);
	
	// 在已经加载的xml文件中寻找所需要的模型工厂。
	console.debug("Finding meshfact : " + meshFactName);
	var mf = C3D.engine.FindMeshFactory(meshFactName);
	if(!mf)
	{
		console.error("Failed to find mesh factory!");
		return false;
	}
	
	// 为模型工厂创建实例。
	console.debug("Creating mesh wrapper : " + meshObjName);
	var mw = C3D.engine.CreateMeshWrapper(mf, meshObjName);
	if(!mw)
	{
		console.error("Failed to create mesh wrapper!");
		return false;
	}
	
	/// TODO 不是所有添加到场景树中的物体都需要碰撞的。
	C3D.colsys.InitializeCollision(mw);
	
	// 给新添加的meshobj设定一个位置。
	mw.movable.pos = pos;
	mw.movable.Update(); //更新粒子效果的位置，让其跟随player显示。在这里的用处是创建出来的mesh需要阻挡，如果不添加这句，有时候会没有阻挡，并且有时显示，有时不显示。
	var sl = C3D.engine.sectors;
	console.debug("Finding sector : " + sectorName);
	var s = sl.FindByName(sectorName);
	if(!s)
	{
		console.error("Failed to find sector!");
		return false;
	}
	var ml = s.meshes; // 获取到sector的mesh列表
	return ml.Add(mw); // 将获取到的对象插入到列表中 attack_effect_index是一个它的index
}
// 保留废弃接口。
SceneTree.addMeshFact2SceneTree = function(libPath, meshFactName, sectorName, meshObjName, pos)
{
	alert("SceneTree.addMeshFact2SceneTree接口废弃\n",
		"请使用如下接口替代：SceneTree.CreateMeshFromFactory");
	SceneTree.CreateMeshFromFactory(libPath, meshFactName, sectorName, meshObjName, pos);
}

/**
 * @brief 从场景中删除一个模型。
 * @param sectorName -- 往哪个sector中添加该mesh。
 * @param index -- 模型所在list的索引值。
 * @detail 如果一个list中有0，1，2，3三个index，删除1之后，2和3会填充过来，也就是变成了0，1，2，最新的1和2分别是以前的2和3代表的mesh wrapper。
 **/
SceneTree.RemoveMesh = function(sectorName, index)
{
	var sl = C3D.engine.sectors;
	console.debug("Finding sector : " + sectorName);
	var s = sl.FindByName(sectorName);
	if(!s)
	{
		console.error("Failed to find sector!");
		return false;
	}
	var ml = s.meshes; // 获取到sector的mesh列表
	return ml.Remove(index); // 将获取到的对象插入到列表中 attack_effect_index是一个它的index
}

})();