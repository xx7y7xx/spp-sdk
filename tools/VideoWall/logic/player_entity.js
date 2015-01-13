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
			isClickOnUI : false,	// 当点中UI的时候，该标志位会被定义。
			tmpData : false,		// 临时的门
			stopAnim: "stand",		// 角色停止移动后的动作
			meshName: "star",		// 角色当前模型
			viewCtrlSpeed: {
				'movement' : 18, 
				'running' : 10, 
				'rotation': 1, 
				'jumping' : 1
			},
			walkSpeed: {
				'movement' : 11.1, 
				'running' : 10, 
				'rotation': 1, 
				'jumping' : 1
			},
			runSpeed: {
				'movement' : 13.2, 
				'running' : 10, 
				'rotation': 1, 
				'jumping' : 1
			},
			
			strafeUpSpeed: 0.02,	// 向上的速度
			strafeDownSpeed: 0.02,	// 向下的速度
			
			prePosition: [0,0,0], 	// 角色的上一个位置
			preRotation: [0,0,0],	// 角色的上一个朝向
			window_name: "",          //执行动画后关闭的窗口
			list_position : [],
			nonce_position : [0,0,0],
			sand_state : true,
			sand_text_name : "",
			nonce_rotation :[0,0,0],
			mouse_click_star : 0,
			btn_click : false,
			role_data :[],
			woman_Scale : 0,
			map_pos_roes : [0,0,0],
			
			clickedMesh : "",
			
			map_enter_Is : false,
			enter_int : 1,
			list_map_data :[],
			person: "firstperson",
			sex:"nv",
			sand_map_flag: false,
			/*	Add by yuechaofeng at 2012-5-22 begin	*/
			startX : 0,	//鼠标左键按下时X轴初始坐标
			startY : 0,	//鼠标左键按下时Y轴初始坐标
			/*	Add by yuechaofeng at 2012-5-22 end		*/
			list_position_data : "" , //王鑫新增(2012-06-14)
			list_360point_position_data : "", //
			chinese_name  : "宁远楼" ,//中文名称
			english_name : "NingYuanFloor" , //英文名称
			u_message : "" , //按钮在图中的位置信息
			// window_width : 751 , //快速定位窗体的宽度 
			// window_height : 510 , //快速定位窗体的高度
			// window_init_x : 179 , // 初始 x值
			// window_init_y : 130 ,  // 初始 y值
			// but_width : 0.0681 , //按钮的长度 , 
			// but_height : 0.0453 ,// 按钮的宽度
			but_index : 0 ,//按钮顺序
			first_pos : "" ,//第一次点击确定按钮的时候的位置
			first_rot : "" ,//第一次点击确定按钮的时候的rotation
			first_chinese_name : "" ,//第一次点击确定按钮的时候的name(chinese
			first_english_name : "" ,//第一次点击确定按钮的时候的name(english
			first_id : "",   //第一次点击确定按钮的时候的输入的数字
			first_trigger_locateevent : 0 //标记是否为第一次触发定位事件
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
			"pclight" : {
			},
			"pclinearmovement" : {
				action : [
					{
						name : "InitCD",
						param : [
							['offset',[0, 0.0, 0]],
							['body',[0.5,0.65,0.5]],
							['legs',[2,2,2]]
						]
					}
				],
				param:[
					{
						name: "gravity ",
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
							['rotation',4],
							['jumping',3]
						]
					}
				]
			},
			"pcmover" : {},
			"pctimer" : {
			},
			"pccommandinput" : {
				property : [
					{
						name : "cooked",
						value : true
					}
				],
				action : [
					{
						name: "Activate",
						param:[
							['activate', true]
						]
					},
					//角色向前
					{
						name : "Bind",
						param : [
							['trigger','w'],
							['command','forward']
						]
					},
					//角色向后
					{
						name : "Bind",
						param : [
							['trigger','s'],
							['command','backward']
						]
					},
					//角色左转
					{
						name : "Bind",
						param : [
							['trigger','a'],
							['command','rotateleft']
						]
					},
					//角色右转
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
							['trigger','g'],
							['command','strafeDown']
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
					//角色向前
					{
						name : "Bind",
						param : [
							['trigger','up'],
							['command','forward']
						]
					},
					//角色向后
					{
						name : "Bind",
						param : [
							['trigger','down'],
							['command','backward']
						]
					},
					//角色左转
					{
						name : "Bind",
						param : [
							['trigger','left'],
							['command','rotateleft']
						]
					},
					//角色右转
					{
						name : "Bind",
						param : [
							['trigger','right'],
							['command','rotateright']
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
					/*	Add by yuechaofeng at 2012-5-22 begin	*/
					//鼠标左键
					{
						name : "Bind",
						param : [
							['trigger','MouseButton0'],
							['command','mouseleft']
						]
					},
					//鼠标滑动
					{
						name : "Bind",
						param : [
							['trigger','MouseAxis0'],
							['command','mousemove']
						]
					},
					//	鼠标滚轮向前
					{
						name : "Bind",
						param : [
							['trigger','Mousebutton3'],
							['command','wheelforward']
						]
					},
					//	鼠标滚轮向后
					{
						name : "Bind",
						param : [
							['trigger','Mousebutton4'],
							['command','wheelbackward']
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
					//退出程序
					{
						name : "Bind",
						param : [
							['trigger','ESC'],
							['command','quit']
						]
					},
					//定位到[0,0,0]点
					{
						name : "Bind",
						param : [
							['trigger','0'],
							['command','initPosition']
						]
					}
				]
			}
		},
		
		// 订阅来自entity自身发出的事件，类似于`ent.behavious();`，
		// 一般这些事件都是entity内部的property class发出的
		event : {
			
			//退出程序
			"pccommandinput_quit1" : function(){
				System.Quit();
			},
			
			//定位到[0,0,0]点
			"pccommandinput_initPosition1" : function(){
				player.pcarray["pcmesh"].MoveMesh([0,0,0],[0,0,0]);
			},
			
			/*  降低环境光亮度ambient  */
			"pccommandinput_darkness1" : function(){
				Event.Send({
					name: "bright.effect.darkness",
					player: this
				});
			},
			
			/*  降低环境的亮度 --- 按住不放，持续执行  */
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
			
			/*  下平移停止  */
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
			
			// 激活控制
			"active.control":function(){
				// this.pcarray["pccommandinput"].PerformAction("Activate", ['activate', true]);
			},
			
			/*	打印出摄像机当前的位置、朝向	*/
			"pccommandinput_printTransform0" : function(){
				if(!player.mouse_view_way){
					var position = this.pcarray['pcmesh'].GetProperty("position");
					var rotation = this.pcarray['pcmesh'].GetProperty("rotation");
					var pitch = iCamera.pcarray['pcdefaultcamera'].GetProperty('pitch');
					var distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
					console.info("position： "+ position.x + ", " + position.y + ", " + position.z);
					console.info("rotation： " + rotation.x +", "+ rotation.y +", "+ rotation.z);
					console.info("pitch： " + pitch);
					console.info("distance： " + distance);
				}
			},
			
			// 改变速度
			"pccommandinput_changespeedlevelOne1":function(e){
				if(!player.mouse_view_way){
					this.walkSpeed["movement"] = 5;
					this.walkSpeed["rotation"] = 1;
					this.strafeUpSpeed = 0.02;		// 向上的速度
					this.strafeDownSpeed = 0.02;	// 向下的速度
					Event.Send({
						name:"effect.go.run.change"
					});
				}
			},
			
			// 改变速度
			"pccommandinput_changespeedlevelTwo1":function(e){
				if(!player.mouse_view_way){
					this.walkSpeed["movement"] = 10;
					this.walkSpeed["rotation"] = 2;
					this.strafeUpSpeed = 0.1;	// 向上的速度
					this.strafeDownSpeed = 0.1;	// 向下的速度
					Event.Send({
						name:"effect.go.run.change"
					});
				}
			},
			
			// 改变速度
			"pccommandinput_changespeedlevelThree1":function(e){
				if(!player.mouse_view_way){
					this.walkSpeed["movement"] = 15;
					this.walkSpeed["rotation"] = 3;
					this.strafeUpSpeed = 0.2;	// 向上的速度
					this.strafeDownSpeed = 0.2;	// 向下的速度
					Event.Send({
						name:"effect.go.run.change"
					});
				}
			},
			
			// 改变速度
			"pccommandinput_changespeedlevelFour1":function(e){
				if(!player.mouse_view_way){
					this.walkSpeed["movement"] = 20;
					this.walkSpeed["rotation"] = 4;
					this.strafeUpSpeed = 0.3;	// 向上的速度
					this.strafeDownSpeed = 0.3;	// 向下的速度
					Event.Send({
						name:"effect.go.run.change"
					});
				}
			},
			
			// 改变速度
			"pccommandinput_changespeedlevelFive1":function(e){
				if(!player.mouse_view_way){
					this.walkSpeed["movement"] = 25;
					this.walkSpeed["rotation"] = 5;
					this.strafeUpSpeed = 0.5;	// 向上的速度
					this.strafeDownSpeed = 0.5;	// 向下的速度
					Event.Send({
						name:"effect.go.run.change"
					});
				}
			}//,
			
			/*	鼠标滑动	*/
			// "pccommandinput_mousemove" : function(msgid,x,y){
				// if(this.mouseleft){
				// }
			// },
			
			/*	鼠标左键按下 */
			// "pccommandinput_mouseleft1" : function(){
				// player.mouseleft = true;
				// if( player.mousex < 179 || player.mousex > 930 ){
					// return ; 
				// }
				// if(player.mousey < 130 || player.mousey > 640){
					// return ; 
				// }
				// Event.Send({
					// name : "player.effect.create_new_button" 
				// });
			// },
			
			/*	鼠标左键弹起	*/
			// "pccommandinput_mouseleft0" : function(){
				// player.mouseleft = false;
			// },
			
			/*	鼠标滚轮向前	*/
			// "pccommandinput_wheelforward1" : function(){
				// var con_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
				// if(con_distance-5 >=0){
					// Event.Send({
						// name : "camera.effect.change.distance.near",
						// player : this
					// });
				// }
			// },
			
			/*	鼠标滚轮向后 	*/
			// "pccommandinput_wheelbackward1" : function(){
				// Event.Send({
					// name : "camera.effect.change.distance.far",
					// player : this
				// });
			// }
		},
		
		// 订阅全局的事件
		subscribe : {
			// 订阅鼠标点击事件
			"crystalspace.input.mouse.0.button.click" : function(e) {
				// 显示UI的时候不处理cs的鼠标事件。
				if(player.isClickOnUI)
				{
					console.debug("点中了UI，虽然UI下可能存在mesh");
					player.isClickOnUI = false; // 重置标志位
					return;
				}
				
				var pccam = iCamera.pcarray['pcdefaultcamera'].QueryInterface("iPcDefaultCamera");
				var iPcCamera = pccam.QueryInterface('iPcCamera');
				var cameraobj = iPcCamera.GetCamera();
				//通过像素坐标获取当前像素坐标对应的场景中的meshobj的name
				var targetObj = C3D.engine.FindScreenTarget([e.x, e.y], 50, cameraobj);
				if(targetObj && targetObj.mesh){
					Event.Send({
						name : "tool.videowall.mesh.mouse.click",
						mesh : targetObj.mesh.object.name
					});
				}
			}
		}
	};
}
catch (e)
{
	alert(e);
}