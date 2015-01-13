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
	
/* ==========================================================================================================
	以下对该文件进行说明：
		该文件主要管理一些基本按键的事件响应，如：
			1. W/↑ S/↓ : 前进（拉远摄像机距离） 后退（拉近摄像机距离）；
			2. A/← D/→ : 左转 右转；
			3. Q E : 左平移 右平移；
			4. T Y : 上平移 下平移；
			5. R F : 向上看 向下看；
 ==========================================================================================================*/
		
		/*人物 前进 --- 摄像机拉远 事件触发*/
		Event.Subscribe(function(e){
			iCamera.pcarray['pctimer'].PerformAction('Clear', ['name','sendDistance']);
			// 启动pctimer实时发送camera的pitch值
			iCamera.pcarray['pctimer'].PerformAction(
				'WakeUp', 
				['time', 100], 
				['repeat', true], 
				['name', 'sendDistance']
			);
			iCamera.is_near = false ; 
		},"player.effect.forward.begin");
		
		/*人物 后退 --- 摄像机拉近 事件触发*/
		Event.Subscribe(function(e){
			iCamera.pcarray['pctimer'].PerformAction('Clear', ['name','sendDistance']);
			// 启动pctimer实时发送camera的pitch值
			iCamera.pcarray['pctimer'].PerformAction(
				'WakeUp', 
				['time', 100], 
				['repeat', true], 
				['name', 'sendDistance']
			);
			iCamera.is_near = true ; 
		}, "player.effect.backward.begin");
		
		/*人物 左转 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('RotateLeft',['start',true]);
		}, "player.effect.rotateleft");
		
		/*人物 停止左转 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('RotateLeft',['start',false]);
		}, "player.effect.rotateleft.stop");
		
		/*人物 右转 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('RotateRight',['start',true]);
		}, "player.effect.rotateright");
		
		/*人物 停止右转 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('RotateRight',['start',false]);
		}, "player.effect.rotateright.stop");
		
		/*人物 左平移 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('StrafeLeft',['start',true]);
		}, "player.effect.StrafeLeft");
		
		/*人物 左平移停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('StrafeLeft',['start',false]);
		}, "player.effect.StrafeLeft.stop");
		
		/*人物 右平移 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('StrafeRight',['start',true]);
		}, "player.effect.StrafeRight");
		
		/*人物 右平移停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pcactormove'].PerformAction('StrafeRight',['start',false]);
		}, "player.effect.StrafeRight.stop");

		/*人物 抬头 事件触发*/
		Event.Subscribe(function(e){
			player.pcarray['pcmesh'].PerformAction('RotateMesh', ['rotation',[-0.01, 0, 0]]);
		}, "player.effect.rotateup");

		/*人物 低头 事件触发*/
		Event.Subscribe(function(e){
			player.pcarray['pcmesh'].PerformAction('RotateMesh', ['rotation',[0.01, 0, 0]]);
		}, "player.effect.rotatedown");
		
		/*人物 垂直向上 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pctimer'].PerformAction(
				'WakeUp', 
				['time', 10], 
				['repeat', true], 
				['name', 'StrafeUp']
			);
		}, "player.effect.StrafeUp");
		
		/*人物 垂直向上停止 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pctimer'].PerformAction('Clear', ['name','StrafeUp']); 
		}, "player.effect.StrafeUp.stop");
		
		/*人物 垂直向下 事件触发*/
		Event.Subscribe(function(e){
			var actor = e.player;
			actor.pcarray['pctimer'].PerformAction(
				'WakeUp', 
				['time', 10], 
				['repeat', true], 
				['name', 'StrafeDown']
			);
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
	})();
} catch(e){
	alert(e);
}