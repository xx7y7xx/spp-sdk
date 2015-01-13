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
 //  1、控制基本的移动事件响应，如前进,后退,左转,右转,左平移,右平移，垂直向上，垂直向下，抬头，低头以及跳跃等
 //  2、走跑切换---改变移动的速度
 //  3、搜索meshobj的name时快速定位到模型所在地方
//========================================================================
try{
	(function(){
	
// ==========================================================================================================
// ======  订阅的事件  ======================================================================================
// ==========================================================================================================
		
		/*  走跑切换 */
		Event.Subscribe(function(e){
			var speed = player.walkSpeed;
			player.pcarray['pcactormove'].PerformAction(
				'SetSpeed', 
					['movement', speed['movement'] ], 
					['running', speed['running']   ], 
					['rotation', speed['rotation'] ], 
					['jumping', speed['jumping']   ]
			);
		}, "effect.go.run.change");
		
		/*人物 前进 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('Forward',['start',true]);
			}
		}, "player.effect.forward");
		
		/*人物 停止前进 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('Forward',['start',false]);
			}
		}, "player.effect.forward.stop");
		
		/*人物 后退 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('Backward',['start',true]);
			}
		}, "player.effect.backward");
		
		/*人物 停止后退 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('Backward',['start',false]);
			}
		}, "player.effect.backward.stop");
		
		/*人物 左转 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('RotateLeft',['start',true]);
			}
		}, "player.effect.rotateleft");
		
		/*人物 停止左转 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('RotateLeft',['start',false]);
			}
		}, "player.effect.rotateleft.stop");
		
		/*人物 右转 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('RotateRight',['start',true]);
			}
		}, "player.effect.rotateright");
		
		/*人物 停止右转 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('RotateRight',['start',false]);
			}
		}, "player.effect.rotateright.stop");
		
		/*人物 左平移 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('StrafeLeft',['start',true]);
			}
		}, "player.effect.StrafeLeft");
		
		/*人物 左平移停止 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('StrafeLeft',['start',false]);
			}
		}, "player.effect.StrafeLeft.stop");
		
		/*人物 右平移 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('StrafeRight',['start',true]);
			}
		}, "player.effect.StrafeRight");
		
		/*人物 右平移停止 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pcactormove'].PerformAction('StrafeRight',['start',false]);
			}
		}, "player.effect.StrafeRight.stop");

		/*人物 抬头 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = iCamera;
				actor.pcarray['pcdefaultcamera'].SetProperty('pitchvelocity',1.0);
			}
		}, "player.effect.rotateup");
		
		/*人物 停止抬头 事件触发*/
		Event.Subscribe(function(e){
			var actor = iCamera;
			actor.pcarray['pcdefaultcamera'].SetProperty('pitchvelocity',0);
		}, "player.effect.rotateup.stop");

		/*人物 低头 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = iCamera;
				actor.pcarray['pcdefaultcamera'].SetProperty('pitchvelocity',-1.0);
			}
		}, "player.effect.rotatedown");
		
		/*人物 停止低头 事件触发*/
		Event.Subscribe(function(e){
			var actor = iCamera;
			actor.pcarray['pcdefaultcamera'].SetProperty('pitchvelocity',0);
		}, "player.effect.rotatedown.stop");
		
		/*人物 垂直向上 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pctimer'].PerformAction(
					'WakeUp', 
					['time', 10], 
					['repeat', true], 
					['name', 'StrafeUp']
				);
			}
		}, "player.effect.StrafeUp");
		
		/*人物 垂直向上停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pctimer'].PerformAction('Clear', ['name','StrafeUp']); 
		}, "player.effect.StrafeUp.stop");
		
		/*人物 垂直向下 事件触发*/
		Event.Subscribe(function(e){
			if(player.anjian_isabled == true){
				var actor = e.player;
				actor.pcarray['pctimer'].PerformAction(
					'WakeUp', 
					['time', 10], 
					['repeat', true], 
					['name', 'StrafeDown']
				);
			}
		}, "player.effect.StrafeDown");
		
		/*人物 垂直向下停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pctimer'].PerformAction('Clear', ['name','StrafeDown']);
		}, "player.effect.StrafeDown.stop");
		
		/* 人物 向上的时间控制 */
		Event.Subscribe(function(e){
			var actor = e.player;
			var pos = actor.pcarray['pcmesh'].position;
			var pos1 = pos[1] + player.strafeUpSpeed;
			actor.pcarray['pcmesh'].PerformAction(
				'MoveMesh', [
					'position', [
						pos[0], pos1, pos[2]
					]
				]
			);
		}, "player.effect.pctimer.StrafeUp");
		
		/* 人物 向下的时间控制 */
		Event.Subscribe(function(e){
			var actor = e.player;
			var pos = actor.pcarray['pcmesh'].position;
			var pos1 = pos[1] - player.strafeDownSpeed; 
			// if(pos1 < 0) {
				// pos1 = 0;
			// }
			actor.pcarray['pcmesh'].PerformAction('MoveMesh', ['position', [pos[0], pos1, pos[2]]]);
		}, "player.effect.pctimer.StrafeDown");
		
		//跳跃
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].Jump();
		}, "player.effect.jump");
		
		//快速定位---搜索meshobj名称
		Event.Subscribe(function(e){
			var actor = e.player;
			var pos = e.id;
			actor.pcarray['pcmesh'].PerformAction(
				'MoveMesh',
				[
					'position',
					[
						pos.x,
						pos.y,
						pos.z-2
					]
				],
				[
					'rotation',
					[
						0,
						0+3.094,
						0
					]
				]
			);
		}, "player.effect.quick_to_pos");
	})();
} catch(e){
	alert(e);
}