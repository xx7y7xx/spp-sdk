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
  //  1、打开视角控制面板 --- "logic.effect.shijiaokongzhi_in"
  //  2、关闭视角控制面板 --- "logic.effect.shijiaokongzhi_close"
  //  3、有人无人模式切换 --- "camare.effect.change.mode"
//========================================================================
try{
	(function(){
		/* 打开 视角控制功能  切换为第一人称 */
		Event.Subscribe(function(e){
			player.pcarray['pcmesh'].SetVisible(false);
			//iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','firstperson']);
			player.prePosition = player.pcarray['pcmesh'].position;
			player.preRotation = player.pcarray['pcmesh'].rotation;
			var speed = player.viewCtrlSpeed;
			player.pcarray['pcactormove'].PerformAction(
				'SetSpeed', 
					['movement', speed['movement'] ], 
					['running', speed['running']   ], 
					['rotation', speed['rotation'] ], 
					['jumping', speed['jumping']   ]
			);
			player.pcarray['pclinearmovement'].SetProperty('gravity', 0);
		},"logic.effect.shijiaokongzhi_in");
		
		/* 关闭 视角控制功能 */
		Event.Subscribe(function(e){
			var pos = player.prePosition;
			var rot = player.preRotation;
			var pos1 = player.pcarray['pcmesh'].GetProperty("position");
			var rot1 = player.pcarray['pcmesh'].GetProperty("rotation");
			if(pos1.y > 2){
				player.pcarray['pcmesh'].PerformAction(
					'MoveMesh', 
					[
						'position', [pos.x, pos.y ,pos.z],
					],
					[
						'rotation', [rot.x, rot.y ,rot.z],
					]
				);
			}else{
				player.pcarray['pcmesh'].PerformAction(
					'MoveMesh',
						[
							'position', [pos1.x, 0, pos1.z],
						],
						[
							'ratation', [rot1.x, rot.y, rot.z],
						]
				);
			}
			player.pcarray['pcmesh'].SetVisible(true);
			//iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
			player.pcarray['pclinearmovement'].SetProperty('gravity', [0]);
			
			// 改变角色的动作和速度
			Event.Send({
				name : "effect.go.run.change",
			});
			
		},"logic.effect.shijiaokongzhi_close");
		
		/* 有人 无人模型切换 */
		var isPersonMode = true;
		Event.Subscribe(function(e){
			if(isPersonMode){ 
				isPersonMode = false;
				player.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','firstperson']);
				player.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
				//去除碰撞检测
				player.pcarray['pclinearmovement'].PerformAction(
				'InitCD',
					['offset',[0, 0.0, 0]],
					['body',[0,0,0]],
					['legs',[0,0,0]] //  ['legs',[0.5,0.4,0.5]] (方便自动寻路跨越障碍物)
				);
				player.pcarray['pclinearmovement'].SetProperty('gravity', [0]);
			}else{ 
				isPersonMode = true;
				player.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
				player.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
				player.pcarray['pclinearmovement'].PerformAction(
				'InitCD',
					['offset',[0, 0.0, 0]],
					['body',[0.5,0.5,0.5]],
					['legs',[0.5,0.5,0.5]] //  ['legs',[0.5,0.4,0.5]] (方便自动寻路跨越障碍物)
				);
				player.pcarray['pclinearmovement'].SetProperty('gravity', [0]);
			}
		},"camare.effect.change.mode");
	})();
} catch(e){
	alert(e);
}