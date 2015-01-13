/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

//========================================================================
 //  该文件主要管理以下事件的响应 --- Event.Subscribe({});
 //  1、实时获取鼠标信息 --- "crystalspace.input.mouse.0.move"
 //  2、鼠标滚轮向前 摄像机拉近 --- "mouse.effect.change.distance.near"
 //  3、鼠标滚轮向后 摄像机拉远 --- "mouse.effect.change.distance.far"
 //  4、鼠标拖拽场景 --- "mouse.effect.mousemove"
 //  5、鼠标点击模型，打印模型名称 --- "mouse.effect.click.mesh"
//========================================================================
try{
	(function(){
		// /*	实时获取鼠标信息	*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//在鼠标移动的过程中时刻获取当前的屏幕的像素坐标，x和y
			player.mousex = e.x;
			player.mousey = e.y;
		},"crystalspace.input.mouse.0.move");

		/*	鼠标左键旋转	*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//设置鼠标左键为按下状态
			actor.mouseleft = true;
			//获取player的当前位置坐标和朝向坐标
			var position = actor.pcarray['pcmesh'].GetProperty('position');
			var rotation = actor.pcarray['pcmesh'].GetProperty('rotation');
			//点击的时候不要改变镜头的位置和跟随的目标，滑动鼠标的时候在做此操作 @huyanan 2012-07-03 
			iCamera.pcarray['pcmesh'].PerformAction(
				'MoveMesh'
					[
						'position',[position.x, position.y, position.z],
						'rotation',[rotation.x, rotation.y, rotation.z]
					]
			);
			// iCamera.pcarray['pcdefaultcamera'].PerformAction('SetFollowEntity',['entity','camera']);
		},"mouse.effect.mouseleftrotation");
		
		/*	鼠标滚轮向前 摄像机拉近		*/
		Event.Subscribe(function(e){
			var actor = e.player;
			iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
			var range_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
			range_distance = range_distance - 0.5;
			iCamera.pcarray['pcdefaultcamera'].SetProperty('distance', range_distance);
		},"mouse.effect.change.distance.near");
		
		/*	鼠标滚轮向后 摄像机拉远		*/
		Event.Subscribe(function(e){
			var actor = e.player;
			iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
			var range_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
			range_distance = range_distance + 0.5;
			iCamera.pcarray['pcdefaultcamera'].SetProperty('distance', range_distance);
		},"mouse.effect.change.distance.far");
		
		/*	Add by yuechaofeng at 2012-5-25 begin	*/
		/*	鼠标拖拽场景	*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//接收鼠标左键按下时鼠标坐标值作为鼠标的起始坐标
			var startX = player.startX;
			var startY = player.startY;
			//获取鼠标的实时坐标
			var x = player.mousex;
			var y = player.mousey;
			/*	鼠标坐标变化以及摄像机rotation的变化	*/
			var g2d = C3D.g2d;
			var screen_width = g2d.width;
			//计算camera的偏转
			var rotationy = ((x - startX)/screen_width)*Math.PI/2;
			var rotationY = actor.startRotationY - rotationy;
			if(rotationY <= -Math.PI){
				rotationY = 2*Math.PI + rotationY;
			}
			if(rotationY <= Math.PI){
				rotationY = -2*Math.PI + rotationY;
			}
			//	获得player当前的位置
			var current_pos = actor.pcarray['pcmesh'].GetProperty('position');
			//	摄像机发生旋转
			player.pcarray['pcmesh'].PerformAction(
				'MoveMesh',
					[
						'position',[current_pos.x, current_pos.y,current_pos.z],
					],
					[
						'rotation',[0, 0-rotationY, 0]
					]
			);
			//计算camera的pitch值 
			var screen_height = g2d.height;
			var cameraPitch = player.startPitch + ((startY-y)/screen_height)*0.5;
			iCamera.pcarray['pcdefaultcamera'].SetProperty('pitch',cameraPitch);
		},"mouse.effect.mousemove");
		/*	Add by yuechaofeng at 2012-5-25 end 	*/
		
		/*	鼠标右键点击模型，打印模型名称	*/
		Event.Subscribe(function(e){
			var pccam = iCamera.pcarray['pcdefaultcamera'].QueryInterface("iPcDefaultCamera");
			if(pccam){
				var iPcCamera = pccam.QueryInterface('iPcCamera');
			}
			if(iPcCamera){
				var cameraobj = iPcCamera.GetCamera();
			}
			if(cameraobj){
				//通过像素坐标获取当前像素坐标对应的场景中的meshobj的name
				var targetObj = engine.FindScreenTarget([player.mousex, player.mousey], 50, cameraobj);
			}
			if(targetObj && targetObj.mesh){
				var meshwrapper = targetObj.mesh.object.name;
				console.info("鼠标所点击模型的名称为： " + meshwrapper);
				// var boundingBox = targetObj.mesh.GetWorldBoundingBox();
				// console.info("该模型的Boundingbox为 ： " + boundingBox.Description());
			}
		},"mouse.effect.click.mesh");
	})();
} catch(e){
	alert(e);
}