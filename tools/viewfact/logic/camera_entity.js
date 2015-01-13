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
			defaultDistance: 3.2,	// 记录摄像机离角色的最佳距离
			defaultPitch : -0.04499990493059158,
			_isWheelClose: false,
			is_near : true //摄像机是拉近还是拉远
		},
		
		pc : {
			"pcdefaultcamera" : {
				action : [
					{
						name : "SetCamera",
						param : [
							['modename', 'firstperson'],
							['pitch', -0.04499990493059158]
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
						value : 1
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
							['rotation',[0, -3.129185438156128, 0]]
						]
					}
				]
			},
			"pclight" : {},
			"pcmover" : {},
			"pclinearmovement" : {
				action : [
					{
						name : "InitCD",
						param : [
							['offset',[0, 0.0, 0]],
							['body',[0.5,0.65,0.5]],
							['legs',[0.5,1.1,0.5]]
						]
					}
				]
			},
			"pcactormove" : {
				action : [
					{
						name : "SetSpeed",
						param : [
							['movement',1.1],
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
		// 一般这些事件都是entity内部的property class发出的。
		event : {
			
			/* 实时改变摄像机的distance */
			"pctimer_sendDistance":function(){
				var bool = iCamera.is_near ; 
				//判断是摄像机的拉近还是拉远
				if(bool){
					Event.Send({
						name : "change.camera.distance.near"
					});
				}else{
					Event.Send({
						name : "change.camera.distance.far"
					});
				}
			}
		},
		
		// 订阅全局的事件
		subscribe : {
			"change.camera.distance.near":function(){
				var range_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
				range_distance = range_distance - 0.5;
				iCamera.pcarray['pcdefaultcamera'].SetProperty('distance', range_distance);
			},
			
			// 控制摄像机的 distance 拉远
			"change.camera.distance.far":function(){
				var range_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
				range_distance = range_distance + 0.5;
				iCamera.pcarray['pcdefaultcamera'].SetProperty('distance', range_distance);
			},
			
			// 关闭摄像机的 distance 控制
			"close.camera.distance.change":function(e){
				var flag = e.close;
				this._isWheelClose = flag;
				this.pcarray["pcdefaultcamera"].SetProperty("distance", this.defaultDistance);
			}
		}
	};
}
catch (e)
{
	alert(e);
}