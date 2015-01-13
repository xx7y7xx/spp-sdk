/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/
try{
	(function(){
		
		/*	实时获取鼠标信息	*/
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
			//获取player的当前位置坐标
			var position = actor.pcarray['pcmesh'].GetProperty('position');
			iCamera.pcarray['pcmesh'].PerformAction(
				'MoveMesh'
					[
						'position',[position.x, position.y, position.z]
					]
			);
			iCamera.pcarray['pcdefaultcamera'].PerformAction('SetFollowEntity',['entity','camera']);
		},"camera.effect.mouseleftrotation");
		
		/*	鼠标滚轮向前 摄像机拉近		*/
		Event.Subscribe(function(e){
			var actor = e.player;
			iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
			var range_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
			range_distance = range_distance - 5;
			iCamera.pcarray['pcdefaultcamera'].SetProperty('distance', range_distance);
		},"camera.effect.change.distance.near");
		
		/*	鼠标滚轮向后 摄像机拉远		*/
		Event.Subscribe(function(e){
			var actor = e.player;
			iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
			var range_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
			range_distance = range_distance + 5;
			iCamera.pcarray['pcdefaultcamera'].SetProperty('distance', range_distance);
		},"camera.effect.change.distance.far");
		
		/*	鼠标拖拽场景	*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//接收鼠标左键按下时鼠标坐标值作为鼠标的起始坐标
			var startX = player.startX;
			var startY = player.startY;
			//获取鼠标的实时坐标
			var x = player.mousex;
			var y = player.mousey;
			if(player.map_enter_Is==false){
				/*	鼠标坐标变化以及摄像机rotation的变化	*/
				var g2d = C3D.g2d;
				var screen_width = g2d.width;
				//计算camera的偏转
				var rotationy = ((x - startX)/screen_width)*Math.PI;
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
				iCamera.pcarray['pcmesh'].PerformAction(
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
				if(cameraPitch >= 0.5){
					iCamera.pcarray['pcdefaultcamera'].SetProperty('pitch',0.5);
				}else{
					iCamera.pcarray['pcdefaultcamera'].SetProperty('pitch',cameraPitch);
				}
			}else{
				Event.Send({
				name : "map.go.run.change",
				});
			}
			// player.startX = x;
			// player.startY = y;
			// player.startPitch = cameraPitch;
			// player.startRotationY = rotationY;
		},"camera.effect.mousemove");
	})();
} catch(e){
	alert(e);
}