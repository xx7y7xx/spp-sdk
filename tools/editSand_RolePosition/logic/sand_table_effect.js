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
	
		// 进入沙盘模式
		Event.Subscribe(function(e){
			
			console.info('进入沙盘');
			
			// 把角色隐藏
			player.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
			iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
			
			// 修改速度为 沙盘模式 速度
			var speed = player.sandSpeed;
			player.pcarray['pcactormove'].PerformAction(
				'SetSpeed', 
					['movement', speed['movement'] ], 
					['running', speed['running']   ], 
					['rotation', speed['rotation'] ], 
					['jumping', speed['jumping']   ]
			);
			
			// 设置重力为0
			player.pcarray['pclinearmovement'].SetProperty('gravity', 0);
			
			if(player.sand_view_pos == "" || player.sand_view_rot == "" || player.sand_view_pitch == "" || player.sand_view_distance == ""){
				player.pcarray['pcmesh'].PerformAction('MoveMesh',['position',[0,134.04000854492188,0]],['rotation',[0,0,0]]);
				var distance = 130;
				var pitch = -0.4529995918273926;
			}else{
				var positionX = player.sand_view_pos_x;
				var positionY = player.sand_view_pos_y;
				var positionZ = player.sand_view_pos_z;
				var rotationX = player.sand_view_rot_x;
				var rotationY = player.sand_view_rot_y;
				var rotationZ = player.sand_view_rot_z;
				
				player.pcarray['pcmesh'].PerformAction(
					'MoveMesh',
					[
						'position',
						[
							positionX,
							positionY,
							positionZ
						]
					],
					[
						'rotation',
						[
							rotationX,
							rotationY/-1,
							rotationZ
						]
					]
				);
				var distance = player.sand_view_distance;
				var pitch = player.sand_view_pitch;
			}
			
			var cameraSets = iCamera.sandMode;
			iCamera.minDistance = cameraSets['minDistance'];		// 摄像机离角色的最近距离
			iCamera.maxDistance = cameraSets['maxDistance'];		// 摄像机离角色的最远距离
			iCamera.wheelSpeed = cameraSets['wheelSpeed'];			// 摄像机的拉近/远速度
			iCamera.currentDistance = cameraSets['currentDistance'];
			
			// 改变摄像机的 distance 
			iCamera.pcarray["pcdefaultcamera"].SetProperty("distance", distance);
			
			// 改变摄像机的 俯角
			iCamera.pcarray["pcdefaultcamera"].SetProperty("pitch", pitch);
			//记录此时是在沙盘状态下
			player.isSand = true;
		},"player.effect.hoarse");
		
		// 退出沙盘模式
		Event.Subscribe(function(e){
			
			console.info('离开沙盘');
			
			// 改变角色的动作和速度
			Event.Send({
				name : "effect.go.run.change",
			});
			
			// 设置重力
			player.pcarray['pclinearmovement'].SetProperty('gravity', 0);
			
			// 将角色放回到地面
			var pos = player.prePosition;
			var rot = player.preRotation;
			// alert("player.prePosition"+player.prePosition);
			// alert("player.preRotation"+player.preRotation);
			if(player.isSand==true){
				player.pcarray['pcmesh'].PerformAction(
					'MoveMesh',
					[
						'position',
						[player.prePosition.x,player.prePosition.y,player.prePosition.z]
					],
					[
						'rotation',
						[player.preRotation.x,player.preRotation.y,player.preRotation.z]
					]
				);
			}
			player.isSand = false;
			//alert(player.prePosition);
			var cameraSets = iCamera.defaultMode;
			iCamera.minDistance = cameraSets['minDistance'];		// 摄像机离角色的最近距离
			iCamera.maxDistance = cameraSets['maxDistance'];		// 摄像机离角色的最远距离
			iCamera.wheelSpeed = cameraSets['wheelSpeed'];	        // 摄像机的拉近/远速度
			iCamera.currentDistance = 3.2;
			
			// 改变摄像机的 distance 
			iCamera.pcarray["pcdefaultcamera"].SetProperty("distance", iCamera.defaultDistance);
			
			// 改变摄像机的 俯角
			iCamera.pcarray["pcdefaultcamera"].SetProperty("pitch", iCamera.defaultPitch);
			
			// 显示角色
			// player.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
			
			//退出沙盘后，改回第一人称视角
			iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','firstperson']);
			
		},"player.effect.hoarse.backing_out");
		
	})();

} catch(e){
	alert(e);
}