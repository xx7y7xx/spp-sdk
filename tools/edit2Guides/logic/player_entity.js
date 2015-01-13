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
			currentAnim : "walk",	// 记录当前动作
			stopAnim: "stand",		// 角色停止移动后的动作
			meshName: "woman",		// 角色当前模型
			walkSpeed: {
				'movement' : 10, 
				'running' : 10, 
				'rotation': 1, 
				'jumping' : 1
			},
			strafeUpSpeed: 4,	// 向上的速度
			strafeDownSpeed: 4,	// 向下的速度
			list_position_data : "" , //记录导游路线的位置信息
			list_regional_point_position_data : "",//记录区域导游位置信息
			chinese_name  : "" ,//中文名称
			english_name : "" , //英文名称
			init_position_data : "", //记录导游初始位置信息
			one_list_position_data : "", //记录第一条路线的位置信息
			two_list_position_data : "", //记录第一条路线的位置信息
			special_list_position_data : "", //记录第一条路线的位置信息
			is_mouse_Activated : false //判断是否获取了搜索输入框的焦点
		},
		
		pc : {
			"pcmesh" : {
				action : [
					{
						name : "SetMesh",
						param : [
							['name','woman']
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
							['rotation',[0, 0, 0]]
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
							['offset',[0, 0, 0]],
							['body',[0.5,0.65,0.5]],
							['legs',[2,2,2]]
						]
					}
				],
				param:[
					{
						name: "gravity",
						value: 19.6
					}
				]
			},
			"pcactormove" : {
				action : [
					{
						name : "SetSpeed",
						param : [
							['movement',10],
							['running',5],
							['rotation',1],
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
					//左转
					{
						name : "Bind",
						param : [
							['trigger','a'],
							['command','rotateleft']
						]
					},
					//右转
					{
						name : "Bind",
						param : [
							['trigger','d'],
							['command','rotateright']
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
					//左转
					{
						name : "Bind",
						param : [
							['trigger','left'],
							['command','rotateleft']
						]
					},
					//右转
					{
						name : "Bind",
						param : [
							['trigger','right'],
							['command','rotateright']
						]
					},
					//垂直向上
					{
						name : "Bind",
						param : [
							['trigger','t'],
							['command','strafeUp']
						]
					},
					//垂直向下
					{
						name : "Bind",
						param : [
							['trigger','y'],
							['command','strafeDown']
						]
					},
					//速度等级1
					{
						name : "Bind",
						param : [
							['trigger','1'],
							['command','changespeedlevelOne']
						]
					},
					//速度等级2
					{
						name : "Bind",
						param : [
							['trigger','2'],
							['command','changespeedlevelTwo']
						]
					},
					//速度等级3
					{
						name : "Bind",
						param : [
							['trigger','3'],
							['command','changespeedlevelThree']
						]
					},
					//速度等级4
					{
						name : "Bind",
						param : [
							['trigger','4'],
							['command','changespeedlevelFour']
						]
					},
					//速度等级5
					{
						name : "Bind",
						param : [
							['trigger','5'],
							['command','changespeedlevelFive']
						]
					},
					//提高环境光亮度ambient
					{
						name : "Bind",
						param : [
							['trigger','PadPlus'],
							['command','raise']
						]
					},
					//降低环境光亮度ambient
					{
						name : "Bind",
						param : [
							['trigger','PadMinus'],
							['command','reduce']
						]
					},
					//恢复环境光亮度ambient
					{
						name : "Bind",
						param : [
							['trigger','Home'],
							['command','recover']
						]
					},
					//鼠标滚轮向前
					{
						name : "Bind",
						param : [
							['trigger','Mousebutton3'],
							['command','wheelforward']
						]
					},
					//鼠标滚轮向后
					{
						name : "Bind",
						param : [
							['trigger','Mousebutton4'],
							['command','wheelbackward']
						]
					},
					//打印坐标
					{
						name : "Bind",
						param : [
							['trigger','z'],
							['command','printTransform']
						]
					},
					//退出程序
					{
						name : "Bind",
						param : [
							['trigger','Esc'],
							['command','quite']
						]
					}
				]
			}
		},
		
		// 订阅来自entity自身发出的事件，类似于`ent.behavious();`，
		// 一般这些事件都是entity内部的property class发出的
		event : {
			
			/*	退出程序	*/
			"pccommandinput_quite1" : function(){
				System.Quit();
			},
			
			/*  开始向前  */
			"pccommandinput_forward1" : function(){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				Event.Send({
					name: "player.effect.forward",
					player: this
				});
			},
			
			/*  停止前进  */
			"pccommandinput_forward0" : function(){
				Event.Send({
					name: "player.effect.forward.stop",
					player: this
				});
			},
			
			/*  开始后退  */
			"pccommandinput_backward1" : function(){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				Event.Send({
					name: "player.effect.backward",
					player: this
				});
			},
			
			/*  停止后退  */
			"pccommandinput_backward0" : function(){
				Event.Send({
					name: "player.effect.backward.stop",
					player: this
				});
			},
			
			/*  开始左转  */
			"pccommandinput_rotateleft1" : function(){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
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
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
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
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				Event.Send({
					name: "player.effect.rotateup",
					player: this
				});
			},
			
			/*  停止抬头  */
			"pccommandinput_rotateup0" : function(){
				Event.Send({
					name: "player.effect.rotateup.stop",
					player: this
				});
			},
			
			/*  开始低头  */
			"pccommandinput_rotatedown1" : function(){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				Event.Send({
					name: "player.effect.rotatedown",
					player: this
				});
			},
			
			/*  停止低头  */
			"pccommandinput_rotatedown0" : function(){
				Event.Send({
					name: "player.effect.rotatedown.stop",
					player: this
				});
			},
			
			/*  左平移  */
			"pccommandinput_strafeLeft1" : function(){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
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
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
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
			
			/*  下平移停止  */
			"pccommandinput_strafeDown0" : function(){
				Event.Send({
					name: "player.effect.StrafeDown.stop",
					player: this
				});
			},
			
			/*	打印出摄像机当前的位置、朝向	*/
			"pccommandinput_printTransform0" : function(){
				var position = this.pcarray['pcmesh'].GetProperty("position");
				var rotation = this.pcarray['pcmesh'].GetProperty("rotation");
				var pitch = iCamera.pcarray['pcdefaultcamera'].GetProperty('pitch');
				var distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
				console.info("position："+ position.x + ", " + position.y + ", " + position.z);
				console.info("rotation：" + rotation.x +", "+ rotation.y +", "+ rotation.z);
				console.info("pitch："+pitch);
				console.info("distance"+distance);
			},

			// 速度等级1
			"pccommandinput_changespeedlevelOne1":function(e){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				this.walkSpeed["movement"] = 5;
				this.walkSpeed["rotation"] = 1;
				this.strafeUpSpeed = 2;		// 向上的速度
				this.strafeDownSpeed = 2;	// 向下的速度
				Event.Send({
					name:"player.effect.go.run.change"
				});
			},
			// 速度等级2
			"pccommandinput_changespeedlevelTwo1":function(e){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				this.walkSpeed["movement"] = 10;
				this.walkSpeed["rotation"] = 2;
				this.strafeUpSpeed = 4;		// 向上的速度
				this.strafeDownSpeed = 4;	// 向下的速度
				Event.Send({
					name:"player.effect.go.run.change"
				});
			},
			// 速度等级3
			"pccommandinput_changespeedlevelThree1":function(e){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				this.walkSpeed["movement"] = 15;
				this.walkSpeed["rotation"] = 3;
				this.strafeUpSpeed = 6;		// 向上的速度
				this.strafeDownSpeed = 6;	// 向下的速度
				Event.Send({
					name:"player.effect.go.run.change"
				});
			},
			// 速度等级4
			"pccommandinput_changespeedlevelFour1":function(e){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				this.walkSpeed["movement"] = 20;
				this.walkSpeed["rotation"] = 4;
				this.strafeUpSpeed = 8;		// 向上的速度
				this.strafeDownSpeed = 8;	// 向下的速度
				Event.Send({
					name:"player.effect.go.run.change"
				});
			},
			// 速度等级5
			"pccommandinput_changespeedlevelFive1":function(e){
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				this.walkSpeed["movement"] = 25;
				this.walkSpeed["rotation"] = 5;
				this.strafeUpSpeed = 10;	// 向上的速度
				this.strafeDownSpeed = 10;	// 向下的速度
				Event.Send({
					name:"player.effect.go.run.change"
				});
			},
			
			// 提高环境光亮度ambient
			"pccommandinput_raise1":function(e) {
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				Event.Send({
					name : "bright.effect.ambient.raise",
					player : player
				});
			},
			
			// 提高环境光亮度ambient --- 按住不放，持续执行
			"pccommandinput_raise_":function(e) {
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				Event.Send({
					name : "bright.effect.ambient.raise",
					player : player
				});
			},
			
			// 降低环境光亮度ambient
			"pccommandinput_reduce1":function(e) {
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				Event.Send({
					name : "bright.effect.ambient.reduce",
					player : this
				});
			},
			
			// 降低环境光亮度ambient --- 按住不放，持续执行
			"pccommandinput_reduce_":function(e) {
				//屏蔽搜索时,键盘操作对player的影响
				if(player.is_mouse_Activated){
					return ; 
				}
				Event.Send({
					name : "bright.effect.ambient.reduce",
					player : this
				});
			},
			
			// 恢复环境光亮度ambient
			"pccommandinput_recover1":function(e) {
				Event.Send({
					name : "bright.effect.ambient.recover",
					player : this
				});
			},
			
			/*	鼠标滚轮向前	*/
			"pccommandinput_wheelforward1" : function(){
				var con_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
				if(con_distance-5 >=0){
					Event.Send({
						name : "camera.effect.change.distance.near",
						player : this
					});
				}
			},
			
			/*	鼠标滚轮向后	*/
			"pccommandinput_wheelbackward1" : function(){
				Event.Send({
					name : "camera.effect.change.distance.far",
					player : this
				});
			}
		},
		
		// 订阅全局的事件
		subscribe : {
			// 角色选择确定后，调用角色的
			"role.select.enter.click": function(){
				this.pcarray["pccommandinput"].PerformAction("Activate", ['activate', true]);
				this.pcarray["pcmesh"].PerformAction("RotateMesh", ["rotation", [0, 3.1155, 0]]);
				this.pcarray['pclinearmovement'].SetProperty('gravity', [0]);
				this.pcarray['pcmesh'].PerformAction(
					'MoveMesh', [
						'position', [
							128.75909423828125,0,-332.3567810058594
						]
					]
				);
			}
		}
	};

}
catch (e)
{
	alert(e);
}