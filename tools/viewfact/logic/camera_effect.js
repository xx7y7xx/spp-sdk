/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

/* ==========================================================================================================
	以下对该文件进行说明：
		该文件主要管理鼠标事件的响应，如：
			1. 鼠标左键 ： 按住不放，滑动鼠标进行水平旋转；
			2. 鼠标右键 ： 按住不放，滑动鼠标进行自由旋转；
			3. 鼠标移动 ： 获取并记录鼠标的坐标信息；
 ==========================================================================================================*/
 
try{
	(function(){
		
		/*	通过鼠标滑动获取鼠标坐标信息	*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//在鼠标移动的过程中时刻获取当前的屏幕的像素坐标，x和y
			player.mousex = e.x;
			player.mousey = e.y;
		},"crystalspace.input.mouse.0.move");
		
		/*	鼠标右键旋转	*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//设置鼠标右键为按下状态
			// actor.mouseright = true;
			//获取player的当前位置坐标
			var position = actor.pcarray['pcmesh'].GetProperty('position');
			var rotation = actor.pcarray['pcmesh'].GetProperty('rotation');
			iCamera.pcarray['pcmesh'].PerformAction(
				'MoveMesh'
					[
						'position',[position.x, position.y, position.z],
						'rotation',[rotation.x, rotation.y, rotation.z]
					]
			);
			iCamera.pcarray['pcdefaultcamera'].PerformAction('SetFollowEntity',['entity','camera']);
		},"camera.effect.mouserightrotation");
		
		/* 鼠标的拖拽 */
		Event.Subscribe(function(e){
			var actor = e.player;
			var startX = player.startX ;
			var startY = player.startY ;
			var x = player.mousex ;
			var y = player.mousey ;
			if(player.mouseleft){
				// 计算鼠标水平拖拽的旋转角度
				if( x > startX ) {
					// 左转
					iCamera.pcarray['pcmesh'].PerformAction('RotateMesh', ['rotation',[0, -0.01, 0]]);
				}else{
					// 右转
					iCamera.pcarray['pcmesh'].PerformAction('RotateMesh', ['rotation',[0, 0.01, 0]]);
				}
			}
			if(player.mouseright){
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
				iCamera.pcarray['pcdefaultcamera'].SetProperty('pitch',cameraPitch);
			}
		},"camera.effect.mousemove");
	})();
} catch(e){
	alert(e);
}