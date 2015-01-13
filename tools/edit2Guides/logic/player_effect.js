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
	
// ==========================================================================================================
// ===   当前 effect 提取出来的公共函数   ===================================================================
// ==========================================================================================================
		// 定义一个数组用来记录角色的所有动作状态 // 分别代表[前进,后退,左转,右转,左平移,右平移]
		var arr_amin_state = [0,0,0,0,0,0];   
		// 该函数用来检查角色的当前动作是否为空, 所有动作为0时返回true,否则返回false;
		function checkAminState(){
			var res = true;
			for(var st in arr_amin_state){
				if(arr_amin_state[st] == 1){
					res = false;
					break;
				}
			}
			return res;
		}

		/* 改变角色动作 */
		function changeAnimation(actor, index, value){
			// 将动作记录到数组
			arr_amin_state[index] = value;
			// 改变动作
			actor.pcarray['pcmesh'].PerformAction('SetAnimation',['animation', actor.currentAnim],['cycle',true],['reset', false]);
		}
		
		function stopAnimation(actor, index, value){
			// 将动作记录到数组
			arr_amin_state[index] = value;
			
			if(checkAminState()){ // 如果所有控制键都弹起了，执行停止动作
				actor.pcarray['pcmesh'].PerformAction('SetAnimation',['animation', actor.stopAnim],['cycle',true],['reset', true]);
			}else{
				actor.pcarray['pcmesh'].PerformAction('SetAnimation',['animation', actor.currentAnim],['cycle',true],['reset', false]);
			}
		}
		
// ==========================================================================================================
// ======  订阅的事件  ======================================================================================
// ==========================================================================================================
		
		/*  走跑切换 */
		Event.Subscribe(function(e){
			// 改变跑的速度和转向速度
			var speed = player.walkSpeed;
			player.pcarray['pcactormove'].PerformAction(
				'SetSpeed', 
					['movement', speed['movement'] ], 
					['running', speed['running']   ], 
					['rotation', speed['rotation'] ], 
					['jumping', speed['jumping']   ]
			);
		}, "player.effect.go.run.change"); 
		
		/*人物 前进 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('Forward',['start',true]);
			changeAnimation(actor, 0, 1);
		}, "player.effect.forward");
		
		/*人物 停止前进 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('Forward',['start',false]);
			stopAnimation(actor, 0, 0);
		}, "player.effect.forward.stop");
		
		/*人物 后退 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('Backward',['start',true]);
			changeAnimation(actor, 1, 1);
		}, "player.effect.backward");
		
		/*人物 停止后退 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('Backward',['start',false]);
			stopAnimation(actor,1, 0);
		}, "player.effect.backward.stop");
		
		/*人物 左转 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('RotateLeft',['start',true]);
			changeAnimation(actor, 2, 1);
		}, "player.effect.rotateleft");
		
		/*人物 停止左转 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('RotateLeft',['start',false]);
			stopAnimation(actor, 2, 0);
		}, "player.effect.rotateleft.stop");
		
		/*人物 右转 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('RotateRight',['start',true]);
			changeAnimation(actor, 3, 1);
		}, "player.effect.rotateright");
		
		/*人物 停止右转 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('RotateRight',['start',false]);
			stopAnimation(actor, 3, 0);
		}, "player.effect.rotateright.stop");
		
		/*人物 左平移 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('StrafeLeft',['start',true]);
			changeAnimation(actor, 4, 1);
		}, "player.effect.StrafeLeft");
		
		/*人物 左平移停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('StrafeLeft',['start',false]);
			stopAnimation(actor, 4, 0);
		}, "player.effect.StrafeLeft.stop");
		
		/*人物 右平移 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('StrafeRight',['start',true]);
			changeAnimation(actor, 5, 1);
		}, "player.effect.StrafeRight");
		
		/*人物 右平移停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('StrafeRight',['start',false]);
			stopAnimation(actor, 5, 0);
		}, "player.effect.StrafeRight.stop");

		/*人物 抬头 事件触发*/
		Event.Subscribe(function(e){
			var actor = iCamera;
			actor.pcarray['pcdefaultcamera'].SetProperty('pitchvelocity',1.0);
		}, "player.effect.rotateup");
		
		/*人物 停止抬头 事件触发*/
		Event.Subscribe(function(e){
			var actor = iCamera;
			actor.pcarray['pcdefaultcamera'].SetProperty('pitchvelocity',0);
		}, "player.effect.rotateup.stop");

		/*人物 低头 事件触发*/
		Event.Subscribe(function(e){
			var actor = iCamera;
			actor.pcarray['pcdefaultcamera'].SetProperty('pitchvelocity',-1.0);
		}, "player.effect.rotatedown");
		
		/*人物 停止低头 事件触发*/
		Event.Subscribe(function(e){
			var actor = iCamera;
			actor.pcarray['pcdefaultcamera'].SetProperty('pitchvelocity',0);
		}, "player.effect.rotatedown.stop");
		
		/*人物 垂直向上 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//将重力设为0
			actor.pcarray['pclinearmovement'].SetProperty('gravity',0.0);
			//设置移动的速度
			var speed = player.strafeUpSpeed;
			actor.pcarray['pclinearmovement'].PerformAction('SetVelocity',['velocity',[0,speed,0]]);
		}, "player.effect.StrafeUp");
		
		/*人物 垂直向上停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pclinearmovement'].PerformAction('SetVelocity',['velocity',[0,0,0]]);
		}, "player.effect.StrafeUp.stop");
		
		/*人物 垂直向下 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//将重力设为0
			actor.pcarray['pclinearmovement'].SetProperty('gravity',0.0);
			//设置移动的速度
			var speed = player.strafeDownSpeed;
			actor.pcarray['pclinearmovement'].PerformAction('SetVelocity',['velocity',[0,-speed,0]]);
		}, "player.effect.StrafeDown");
		
		/*人物 垂直向下停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pclinearmovement'].PerformAction('SetVelocity',['velocity',[0,0,0]]);
		}, "player.effect.StrafeDown.stop");
	})();
} catch(e){
	alert(e);
}
