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

	PLAYER = {
		name : "player",
		
		property : {
			meshName: "mesh_obj",	// 角色当前模型
			strafeUpSpeed: 0.3,		// 向上的速度
			strafeDownSpeed: 0.3,	// 向下的速度
			startX : 0  , // 鼠标左键按下的X值
			startY : 0 ,  // 鼠标左键按下的Y值 
			rotationX : 0 , // 鼠标左键按下,player在X轴移动的角度
			rotationY : 0 , // 鼠标左键按下,player在Y轴移动的角度 
		},
		
		pc : {
			"pcmesh" : {
				action : [
					{
						name : "SetMesh",
						param : [
							['name','mesh_obj']
						]
					},
					{
						name : "SetAnimation",
						param : [
							['animation','stand'],
							['cycle',true]
						]
					},
					{
						name : "SetVisible",
						param : [
							['visible',true]
						]
					},
					{
						name : "RotateMesh",
						param : [
							['rotation',[-0.001, 0, 0]]
						]
					}
				]
			},
			"pclight" : {},
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
							['rotation',2],
							['jumping',1]
						]
					}
				]
			},
			"pcmover" : {},
			"pctimer" : {},
			"pccommandinput" : {
				action : [
					{
						name: "Activate",
						param:[
							['activate', true]
						]
					},
					//前进
					{
						name : "Bind",
						param : [
							['trigger','w'],
							['command','forward']
						]
					},
					//后退
					{
						name : "Bind",
						param : [
							['trigger','s'],
							['command','backward']
						]
					},
					//左旋转
					{
						name : "Bind",
						param : [
							['trigger','a'],
							['command','rotateleft']
						]
					},
					//右旋转
					{
						name : "Bind",
						param : [
							['trigger','d'],
							['command','rotateright']
						]
					},
					//左平移
					{
						name : "Bind",
						param : [
							['trigger','q'],
							['command','strafeLeft']
						]
					},
					//右平移
					{
						name : "Bind",
						param : [
							['trigger','e'],
							['command','strafeRight']
						]
					},
					//抬头
					{
						name : "Bind",
						param : [
							['trigger','r'],
							['command','rotateup']
						]
					},
					//低头
					{
						name : "Bind",
						param : [
							['trigger','f'],
							['command','rotatedown']
						]
					},
					//向上
					{
						name : "Bind",
						param : [
							['trigger','t'],
							['command','strafeUp']
						]
					},
					//向下
					{
						name : "Bind",
						param : [
							['trigger','y'],
							['command','strafeDown']
						]
					},
					//鼠标移动
					{
						name : "Bind",
						param : [
							['trigger','MouseAxis0'],
							['command','mousemove']
						]
					},
					//鼠标左键
					{
						name : "Bind",
						param : [
							['trigger','MouseButton0'],
							['command','mouseleft']
						]
					},
					//鼠标右键
					{
						name : "Bind",
						param : [
							['trigger','MouseButton1'],
							['command','mouseright']
						]
					},
					//鼠标滚轮向前
					{
						name : "Bind",
						param : [
							['trigger', '0Mousebutton3'],
							['command', 'wheelForward']
						]
					},
					//鼠标滚轮向后
					{
						name : "Bind",
						param : [
							['trigger', '0Mousebutton4'],
							['command', 'wheelBackward']
						]
					},
					//前进
					{
						name : "Bind",
						param : [
							['trigger','up'],
							['command','forward']
						]
					},
					//后退
					{
						name : "Bind",
						param : [
							['trigger','down'],
							['command','backward']
						]
					},
					//左旋转
					{
						name : "Bind",
						param : [
							['trigger','left'],
							['command','rotateleft']
						]
					},
					//右旋转
					{
						name : "Bind",
						param : [
							['trigger','right'],
							['command','rotateright']
						]
					},
					//灯光移动
					{
					  name : "Bind",
					  param:[
						['trigger','l'],
						['command','changelight']
					  ]
					},
					//降低环境光亮度ambient
					{
						name : "Bind",
						param : [
							['trigger','PadMinus'],
							['command','darkness']
						]
					},
					//提高环境光亮度ambient
					{
						name : "Bind",
						param : [
							['trigger','PadPlus'],
							['command','brilliance']
						]
					},
					//恢复环境光亮度ambient
					{
						name : "Bind",
						param : [
							['trigger','Home'],
							['command','revert']
						]
					},
					//退出程序---关闭窗口
					{
						name : "Bind",
						param : [
							['trigger','ESC'],
							['command','quit']
						]
					}
				]
			}
		},
		
		// 订阅来自entity自身发出的事件，类似于`ent.behavious();`，
		// 一般这些事件都是entity内部的property class发出的。
		event : {
			
			//退出程序 --- 关闭窗口
			"pccommandinput_quit1" : function(){
				System.Quit();
			},
			
			/*  降低环境光亮度ambient  */
			"pccommandinput_darkness1" : function(){
				Event.Send({
					name: "bright.effect.darkness",
					player: this
				});
			},
			
			/*  降低环境光亮度ambient --- 按住不放，持续执行  */
			"pccommandinput_darkness_" : function(){
				Event.Send({
					name: "bright.effect.darkness",
					player: this
				});
			},
			
			/*  提高环境光亮度ambient  */
			"pccommandinput_brilliance1" : function(){
				Event.Send({
					name: "bright.effect.brilliance",
					player: this
				});
			},
			
			/*  提高环境光亮度ambient --- 按住不放，持续执行  */
			"pccommandinput_brilliance_" : function(){
				Event.Send({
					name: "bright.effect.brilliance",
					player: this
				});
			},
			
			/*  恢复环境光亮度ambient  */
			"pccommandinput_revert1" : function(){
				Event.Send({
					name: "bright.effect.revert",
					player: this
				});
			},
			
			/*  开始向前  */
			"pccommandinput_forward1" : function(){
				// 控制摄像机拉近
				Event.Send({
					name:"player.effect.forward.begin",
					player : this
				});
			},
			
			/*  停止前进  */
			"pccommandinput_forward0" : function(){
				iCamera.pcarray['pctimer'].PerformAction('Clear', ['name','sendDistance']);
			},
			
			/*  开始后退  */
			"pccommandinput_backward1" : function(){
				// 控制摄像机拉远
				Event.Send({
					name:"player.effect.backward.begin",
					player : this
				});
			},
			
			/*  停止后退  */
			"pccommandinput_backward0" : function(){
				iCamera.pcarray['pctimer'].PerformAction('Clear', ['name','sendDistance']);
			},
			
			/*  开始左转  */
			"pccommandinput_rotateleft1" : function(){
				Event.Send({
					name: "player.effect.rotateleft",
					player: this
				});
			},
			
			/*  停止左转  */
			"pccommandinput_rotateleft0" : function(){
				Event.Send({
					name: "player.effect.rotateleft.stop",
					player: this
				});
			},
			
			/*  开始右转  */
			"pccommandinput_rotateright1" : function(){
				Event.Send({
					name: "player.effect.rotateright",
					player: this
				});
			},
			
			/*  停止右转  */
			"pccommandinput_rotateright0" : function(){
				Event.Send({
					name: "player.effect.rotateright.stop",
					player: this
				});
			},
			
			/*  开始抬头  */
			"pccommandinput_rotateup1" : function(){
				Event.Send({
					name : "player.effect.rotateup" ,
					player : this
				});
				
			},
			
			/*  开始抬头  --- 按住不放，持续执行 */
			"pccommandinput_rotateup_" : function(){
				Event.Send({
					name : "player.effect.rotateup" ,
					player : this
				});
				
			},
			
			/*  开始低头  */
			"pccommandinput_rotatedown1" : function(){
				Event.Send({
					name: "player.effect.rotatedown",
					player: this
				});
			},
			
			/*  开始低头 --- 按住不放，持续执行 */
			"pccommandinput_rotatedown_" : function(){
				Event.Send({
					name: "player.effect.rotatedown",
					player: this
				});
			},
			
			/*  左平移  */
			"pccommandinput_strafeLeft1" : function(){
				Event.Send({
					name: "player.effect.StrafeLeft",
					player: this
				});
			},
			
			/*  左平移停止  */
			"pccommandinput_strafeLeft0" : function(){
				Event.Send({
					name: "player.effect.StrafeLeft.stop",
					player: this
				});
			},
			
			/*  右平移  */
			"pccommandinput_strafeRight1" : function(){
				Event.Send({
					name: "player.effect.StrafeRight",
					player: this
				});
			},
			
			/*  右平移停止  */
			"pccommandinput_strafeRight0" : function(){
				Event.Send({
					name: "player.effect.StrafeRight.stop",
					player: this
				});
			},
			
			/*  上平移  */
			"pccommandinput_strafeUp1" : function(){
				Event.Send({
					name: "player.effect.StrafeUp",
					player: this
				});
			},
			/*  上平移停止  */
			"pccommandinput_strafeUp0" : function(){
				Event.Send({
					name: "player.effect.StrafeUp.stop",
					player: this
				});
			},
			/*  下平移  */
			"pccommandinput_strafeDown1" : function(){
				Event.Send({
					name: "player.effect.StrafeDown",
					player: this
				});
			},
			/*  上平移停止  */
			"pccommandinput_strafeDown0" : function(){
				Event.Send({
					name: "player.effect.StrafeDown.stop",
					player: this
				});
			},
			
			/*  垂直向上  */
			"pctimer_StrafeUp" : function(){
				Event.Send({
					name: "player.effect.pctimer.StrafeUp",
					player: this
				});
			},
			/*  垂直向下  */
			"pctimer_StrafeDown" : function(){
				Event.Send({
					name: "player.effect.pctimer.StrafeDown",
					player: this
				});
			},
			
			/*鼠标滚轮向前	*/
			"pccommandinput_wheelForward1":function(){
				var cur_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
				if(cur_distance-1 >=0){
					Event.Send({
						name:"change.camera.distance.near",
					});
				}
			},
			
			/*鼠标滚轮向后	*/
			"pccommandinput_wheelBackward1":function(){
				Event.Send({
					name:"change.camera.distance.far",
				});
			},
			
			//鼠标移动
			"pccommandinput_mousemove" : function (msgid, x, y){
				if(this.mouseleft || this.mouseright){
					Event.Send({
						name : "camera.effect.mousemove",
						player : this
					});
				}
			},
			
			//鼠标左键按下
			"pccommandinput_mouseleft1" : function (){
				//标记鼠标左键是否按下
				this.mouseleft = true;
				//记录鼠标左键按下时的鼠标坐标
				this.startX = player.mousex;
			},
			
			//鼠标左键弹起
			"pccommandinput_mouseleft0" : function (){
				//标记鼠标左键是否按下
				this.mouseleft=false;
			},
			
			//鼠标右键按下
			"pccommandinput_mouseright1" : function (){
				//标记鼠标右键是否按下
				this.mouseright = true;
				//记录鼠标右键按下时的鼠标坐标
				player.startX = player.mousex;
				player.startY = player.mousey;
				//获取并记录camera的rotation值
				var rotation = iCamera.pcarray['pcmesh'].GetProperty('rotation');
				player.startRotationY = rotation.y;
				//获取并记录camera的pitch值
				var pitch = iCamera.pcarray['pcdefaultcamera'].GetProperty('pitch');
				player.startPitch = pitch;
				Event.Send({
					name : "camera.effect.mouserightrotation",
					player : this
				});
			},
			
			//鼠标右键弹起
			"pccommandinput_mouseright0" : function (){
				//标记鼠标右键是否按下
				this.mouseright = false;
			},
			
			//L键按下
			"pccommandinput_changelight1":function(){
				Event.Send({
					name : "change.light.position",
					player:this
				});
			},
			
			//L键抬起
			"pccommandinput_changelight0":function(){
				Event.Send({
					name : "change.light.position.stop",
					player:this
				});
			}
		},
		
		// 订阅全局的事件
		subscribe : {
			// 角色选择确定后，调用角色的
			"role.select.enter.click": function(e){
				this.pcarray["pccommandinput"].PerformAction("Activate", ['activate', true]);
				this.pcarray["pcmesh"].PerformAction("RotateMesh", ["rotation", [0, 3.1155, 0]]);
				this.role_ok = "ok";
			}
		}
	};
}
catch (e)
{
	alert(e);
}