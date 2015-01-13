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

try{

require("console.js");
//  声明全局对象
var WanderManager = null;

(function(){

	WanderManager = new Object();
	
	//  WanderManager的属性
	WanderManager.IsSuspending = false;
	WanderManager.IsRunning = false;
	WanderManager.IsStoped = false;
	WanderManager.IsResuming = false;
	
	//  局部对象
	var dataValue = {};
	
	//  用来解析xml文件
	var parserWanders = function(filePath){
		var wandersXML = new xmlDocument();
		var wandersFile = VFS.Open(filePath);
		var flag = wandersXML.Parse(wandersFile);
		if(!flag){
			alert("文件没有打开，请检查路径是否正确！");
		}
		var wanders = wandersXML.root.GetChild("wanders");
		var wander = wanders.GetChild("wander");
		return wander;
		
	};
	
	//   获得当前的系统时间
	var gainTime = function(){
		var time = new Date();
		var timer = time.getTime();
		return timer;
	};
	
	//  从xml文件中获得数据
	var getValue = function(wandChildren){
		var WanderValue = {};
		//  Number,从xml中读取到的数据typeof为string,需要转换为number类型
		WanderValue.posX = Number( wandChildren.GetAttribute("posX").value );
		WanderValue.posY = Number( wandChildren.GetAttribute("posY").value );
		WanderValue.posZ = Number( wandChildren.GetAttribute("posZ").value );
		WanderValue.rotX = Number( wandChildren.GetAttribute("rotX").value );
		WanderValue.rotY = Number( wandChildren.GetAttribute("rotY").value );
		WanderValue.rotZ = Number( wandChildren.GetAttribute("rotZ").value );
		return WanderValue;
	};
	
	//  获得帧间的数据差值
	var getDiffValue = function(prev, next, factor){
		var WanderValue = {};
		// 保存position和rotation的差值
		var posDiffX = next.posX - prev.posX ;
		var posDiffY = next.posY - prev.posY ;
		var posDiffZ = next.posZ - prev.posZ ;
		var rotDiffX = next.rotX - prev.rotX ;
		var rotDiffY = next.rotY - prev.rotY ;
		var rotDiffZ = next.rotZ - prev.rotZ ;
		
		//  插值计算
		WanderValue.posX = prev.posX + posDiffX * factor;
		WanderValue.posY = prev.posY + posDiffY * factor;
		WanderValue.posZ = prev.posZ + posDiffZ * factor;
		WanderValue.rotX = prev.rotX + rotDiffX * factor;
		WanderValue.rotY = prev.rotY + rotDiffY * factor;
		WanderValue.rotZ = prev.rotZ + rotDiffZ * factor;
		
		return WanderValue;
	};

	WanderManager.RunWander = function(entity, frame, time, filePath, eventName){

		if(WanderManager.IsSuspending){
			return false;
		}
		WanderManager.IsRunning = true;
		WanderManager.IsSuspending = false;
		WanderManager.IsStoped = false;
		
		dataValue.obj = entity;
		dataValue.frame = frame;
		dataValue.time = time;
		dataValue.filePath = filePath;
		
		// 先将Entity隐藏
		// entity.pcarray['pcmesh'].SetVisible(false);
		// 解析xml
		var wander = parserWanders(filePath);
		dataValue.wander = wander;
		
		// 通过Entity获得其绑定的meshObj
		var meshObjName = entity.pcarray['pcmesh'].meshname;
		var meshwrapper = C3D.engine.FindMeshObject(meshObjName);
		var camera = entity.pcarray['pcdefaultcamera'].QueryInterface('iPcCamera').GetCamera();

		//对是否继续进行判断
		if( WanderManager.IsResuming ){
			var currentTime = gainTime();
			var startTime = currentTime - dataValue.diffTime;
			WanderManager.IsResuming = true;
		}else{
			// 获得漫游之前的位置信息
			dataValue.pos = entity.pcarray['pcmesh'].position;
			dataValue.rot = entity.pcarray['pcmesh'].rotation;
			
			// 设置漫游的初始值
			var wanderFirst = wander.GetChild("start");
			if(wanderFirst)
			{
				var wanderFirstValue = getValue(wanderFirst);
			}else {
				alert("XML has no '<start/>'");
				return false;
			}
			entity.pcarray['pcmesh'].PerformAction("MoveMesh", 
				["position", [wanderFirstValue.posX, wanderFirstValue.posY, wanderFirstValue.posZ]], 
				["rotation", [wanderFirstValue.rotX, wanderFirstValue.rotY, wanderFirstValue.rotZ]]
			);
			WanderManager.IsResuming = false;
			//保存了一个wander的启动时间。
			var startTime = gainTime();
		}
		
		dataValue.startTimer = startTime;
		
		dataValue.id = C3D.engine.SubscribeFrame(function(){
			
			var currentTime = gainTime();
			//  diff保存了离开本序列距开始所过去的时间。
			var diff = currentTime - startTime;
			// ceil为JS中的进一法
			var nextID = Math.ceil(diff/time);
			var prevID = nextID - 1;
			
			//  数据读取完毕,需要处理停止
			if(nextID >= frame){
				// 此处需要添加到时间停止的功能
				// 1.读取最后一帧的位置信息数据
				var wanderLast = getValue(wander.GetChild("wander" + frame));
				// 2.移动到最后一帧的位置
				entity.pcarray['pcmesh'].PerformAction("MoveMesh",
					["position", [wanderLast.posX, wanderLast.posY, wanderLast.posZ]],
					["rotation", [wanderLast.rotX, wanderLast.rotY, wanderLast.rotZ]]
				);
				// 3.执行停止事件
				WanderManager.Stop(eventName);
				return;
			}
			
			dataValue.wanderID = nextID;
			// 读取xml中的数据
			// 获得第N 和 N-1节点
			var wanderPrevChild = wander.GetChild("wander" + prevID);
			var wanderNextChild = wander.GetChild("wander" + nextID);
			// 读取第N 和 N-1节点的数值
			var factor = ( diff % time ) / time;
			//  判断是否undefined
			if(wanderPrevChild && wanderPrevChild)
			{
				//  getValue()返回值为Obj
				var wanderPrevValue = getValue(wanderPrevChild);
				var wanderNextValue = getValue(wanderNextChild);
				// 保存差值
				var diffValue = getDiffValue(wanderPrevValue, wanderNextValue, factor);

				if( (diff % time) != 0 ){
					// 当diff和每帧时间不成整倍时，N-1和N之间插值
					entity.pcarray['pcmesh'].PerformAction("MoveMesh",
						["position", [diffValue.posX, diffValue.posY, diffValue.posZ]],
						["rotation", [diffValue.rotX, diffValue.rotY, diffValue.rotZ]]
					);
				}else {
					// 当diff和每帧时间成整倍时，直接MoveMesh到N
					entity.pcarray['pcmesh'].PerformAction("MoveMesh",
						["position", [wanderNextValue.posX, wanderNextValue.posY, wanderNextValue.posZ]],
						["rotation", [wanderNextValue.rotX, wanderNextValue.rotY, wanderNextValue.rotZ]]
					);
				}
			}
		});
		
		//  如果没继续事件的话，不会在SubscribeFrame
		if( !WanderManager.IsResuming )
		{
			dataValue.foreverID = C3D.engine.SubscribeFrame(function(){
				//  获得meshwrapper.movable的transform
				var mt = meshwrapper.movable.GetTransform();
				//  将mesh的变换设置给cam对象
				camera.SetTransform(mt);
			});
		}
		return WanderManager.IsRunning;
	};
	


	WanderManager.Suspend = function(){
		if(WanderManager.IsRunning)
		{
			WanderManager.IsSuspending = true;
			WanderManager.IsRunning = false;
			WanderManager.IsResuming = false;
			WanderManager.IsStoped = false;
			C3D.engine.UnsubscribeFrame(dataValue.id);
			var currentTime = gainTime();
			//  记录暂停时的时间差信息
			dataValue.diffTime/*5s*/ = currentTime/*10005*/ - dataValue.startTimer/*10000*/;
			//  记录暂停时的wanderID
			var nextID = dataValue.wanderID;
			var wanderNextValue = getValue(dataValue.wander.GetChild("wander" + nextID));
			dataValue.obj.pcarray['pcmesh'].PerformAction("MoveMesh",
				["position", [wanderNextValue.posX, wanderNextValue.posY, wanderNextValue.posZ]],
				["rotation", [wanderNextValue.rotX, wanderNextValue.rotY, wanderNextValue.rotZ]]
			);
		}
		return WanderManager.IsSuspending;
	};

	WanderManager.Resume = function(){
		if(WanderManager.IsSuspending)
		{
			WanderManager.IsSuspending = false;
			WanderManager.IsResuming = true;
			WanderManager.IsRunning = true;
			WanderManager.IsStoped = false;
			WanderManager.RunWander(dataValue.obj, dataValue.frame, dataValue.time, dataValue.filePath);
		}
		return WanderManager.IsRunning;
	};

	WanderManager.Stop = function(eventName){
		//  无条件的停止一切frame
		if(dataValue.foreverID){
			C3D.engine.UnsubscribeFrame(dataValue.foreverID);
		}
		if(dataValue.id){
			C3D.engine.UnsubscribeFrame(dataValue.id);
		}
		
		//	漫游结束，将Engity移动到初始位置
		dataValue.obj.pcarray['pcmesh'].PerformAction("MoveMesh",
			["position", [dataValue.pos.x, dataValue.pos.y, dataValue.pos.z]],
			["rotation", [dataValue.rot.x, dataValue.rot.y, dataValue.rot.z]]
		);
		//  dataValue.obj.pcarray['pcmesh'].SetVisible(true);
		//  当结束的时候需要触发某个事件的时候，将该事件的name传入即可
		if(eventName)
		{
			Event.Send({
				name: eventName
			});
		}
				
		WanderManager.IsRunning = false;
		WanderManager.IsSuspending = false;
		WanderManager.IsResuming = false;
		WanderManager.IsStoped = true;

		return WanderManager.IsStoped;
	};

})();

}catch(e){
	alert(e);
}
