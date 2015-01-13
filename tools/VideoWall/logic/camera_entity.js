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

try {

	CAMERA = {
		name : "camera",
		
		property : {
			currentDistance: 30,	// 记录摄像机离角色的当前距离
			defaultDistance: 3,	// 记录摄像机离角色的最佳距离
			minDistance: 1.8,		// 摄像机离角色的最近距离
			maxDistance: 8,			// 摄像机离角色的最远距离
			wheelSpeed: 0.5,		// 摄像机的拉近/远速度
			
			defaultPitch : -0.04499990493059158,

			defaultMode:{
				'minDistance' : 1.8,	// 摄像机离角色的最近距离
				'maxDistance' : 8,		// 摄像机离角色的最远距离
				'wheelSpeed' : 0.5,		// 摄像机的拉近/远速度
				'currentDistance':3.2
			},
			
			sandMode:{
				'minDistance' : 10,		// 摄像机离角色的最近距离
				'maxDistance' : 800,	// 摄像机离角色的最远距离
				'wheelSpeed' : 5,		// 摄像机的拉近/远速度
				'currentDistance':340
			},
			
			_isWheelClose: false
		},
		
		pc : {
			"pcdefaultcamera" : {
				action : [
					{
						name : "SetCamera",
						param : [
							['modename', 'firstperson'],
							['pitch', -0.54499990493059158]
						]
					},
					{
						name : "SetZoneManager",
						param : [
							['entity', 'camera'], //player 是 entity.name 的属性值
							['region', 'main'],
							['start', 'Camera']
						]
					}
				],
				property : [
					{
						name : "distance",
						value : 10
					}
				]
			},
			"pcmesh" : {
				action : [
					{
						name : "SetMesh",
						param : [
							['name','mesh___camera']
						]
					},
					{
						name : "SetVisible",
						param : [
							['visible',false]
						]
					},
					{
						name : "RotateMesh",
						param : [
							['rotation',[0, 0, 0]]
						]
					}
				]
			},
			"pcmover" : {},
			"pclight" : {
			},
			"pclinearmovement" : {
				action : [
					{
						name : "InitCD",
						param : [
							['offset',[0, 0, 0]],
							['body',[0, 0, 0]],
							['legs',[0, 0, 0]]
						]
					}
				],
				param:[
					{
						name: "gravity ",
						value: 19.6
					}
				]
			},
			"pcactormove" : {
				action : [
					{
						name : "SetSpeed",
						param : [
							['movement',10.1],
							['running',3],
							['rotation',1],
							['jumping',1]
						]
					}
				]
			},
			"pctimer" : {},
			"pccommandinput" : {}
		},
		
		// 订阅来自entity自身发出的事件，类似于`ent.behavious();`，
		// 一般这些事件都是entity内部的property class发出的
		event : {},
		
		// 订阅全局的事件。
		subscribe : {
			// 角色选择确定后，调用摄像机的模式切换，第三人称
			"role.select.enter.click": function(){
				this.pcarray["pcdefaultcamera"].PerformAction("SetFollowEntity",['entity','player']);
				this.pcarray["pccommandinput"].PerformAction("Activate", ['activate', false]);
				this.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
				this.pcarray["pcdefaultcamera"].SetProperty("distance", 3.2);
				this.pcarray["pcdefaultcamera"].SetProperty("pitch", -0.169999957);
				
				this.pcarray["pcmesh"].PerformAction("SetVisible",['visible',true]);
				
			}
		
		}
	};

}
catch (e)
{
	alert(e);
}