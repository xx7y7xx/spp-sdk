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
			current_height: 2,      // 当前角色的高度
			current_width : 2,      // 当前角色的宽度(wangxin add 2012-08-10 )
			has_gravity : true,    //是够拥有重力
			
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
			
			sandSpeed : {
				'movement' : 25, 
				'running' : 10, 
				'rotation': 0.3, 
				'jumping' : 1
			},
			
			strafeUpSpeed: 1.02,	// 向上的速度
			strafeDownSpeed: 1.02,	// 向下的速度
			
			prePosition: [0,0,0], 	// 角色的上一个位置
			preRotation: [0,0,0],	// 角色的上一个朝向
			
			window_name: "",          //执行动画后关闭的窗口
			
			person: "firstperson",
			sex:"nv",
			
			mouse_view_way : false,	//判断当前查看方式
			
			startX : 0,	//鼠标左键按下时X轴初始坐标
			startY : 0,	//鼠标左键按下时Y轴初始坐标
			
			view_control : true ,	//判断是否打开视角控制的UI面板
			anjian_isabled : true   //按键是否被屏蔽掉，初始为没有
		},
		
		pc : {
			"pcmesh" : {
				action : [
					{
						name : "SetMesh",
						param : [
							['name','cube#01']
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
							['body',[0.5,0.5,0.5]],
							['legs',[0.5,0.9,0.5]]
						]
					}
				],
				param:[
					{
						name: "gravity ",
						value: 0
					}
				]
			},
			"pcactormove" : {
				action : [
					{
						name : "SetSpeed",
						param : [
							['movement',3],
							['running',1],
							['rotation',1],
							['jumping',10]
						]
					}
				]
			},
			"pcmover" : {},
			"pctimer" : {
				action : [
					{
						name : "WakeUp",
						param : [
							['time', 33],
							['repeat', true],
							['name', 'player_position']
						]
					}
				]
			},
			"pccommandinput" : {
				// 支持组合键
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
					{
						name : "Bind",
						param : [
							['trigger','w'],
							['command','forward']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','s'],
							['command','backward']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','a'],
							['command','rotateleft']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','d'],
							['command','rotateright']
						]
					},
					//跳跃：一般跳
					{
						name : "Bind",
						param : [
							['trigger', 'space'],
							['command', 'jump']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','r'],
							['command','rotateup']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','f'],
							['command','rotatedown']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','q'],
							['command','strafeLeft']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','e'],
							['command','strafeRight']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','t'],
							['command','strafeUp']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','g'],
							['command','strafeDown']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','z'],
							['command','printTransform']
						]
					},
					{
						name : "Bind",//角色向前
						param : [
							['trigger','up'],
							['command','forward']
						]
					},
					{
						name : "Bind",//角色向后
						param : [
							['trigger','down'],
							['command','backward']
						]
					},
					{
						name : "Bind",//角色向左
						param : [
							['trigger','left'],
							['command','rotateleft']
						]
					},
					{
						name : "Bind",//角色向右
						param : [
							['trigger','right'],
							['command','rotateright']
						]
					},
					{
						name : "Bind",//切换人称
						param : [
							['trigger','tab'],
							['command','changepersonmode']
						]
					},
					{
						name : "Bind",//速度等级1
						param : [
							['trigger','1'],
							['command','changespeedlevelOne']
						]
					},
					{
						name : "Bind",//速度等级2
						param : [
							['trigger','2'],
							['command','changespeedlevelTwo']
						]
					},
					{
						name : "Bind",//速度等级2
						param : [
							['trigger','3'],
							['command','changespeedlevelThree']
						]
					},
					{
						name : "Bind",//速度等级2
						param : [
							['trigger','4'],
							['command','changespeedlevelFour']
						]
					},
					{
						name : "Bind",//速度等级2
						param : [
							['trigger','5'],
							['command','changespeedlevelFive']
						]
					},
					// 修改亮度，饱和度，以及gamma值。
					{
						name : "Bind",
						param : [
							['trigger','PadPlus'],
							['command','LightUp']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','PadMinus'],
							['command','LightDown']
						]
					},
					// 修改gamma值。
					{
						name : "Bind",
						param : [
							['trigger','Shift+PadPlus'],
							['command','GammaUp']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','Shift+PadMinus'],
							['command','GammaDown']
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
					//鼠标右键
					{
						name : "Bind",
						param : [
							['trigger','MouseButton1'],
							['command','mouseright']
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
					//绑定快捷键 切换查看方式
					{
						name : "Bind",
						param : [
							['trigger','x'],
							['command','changeviewway']
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
					//绑定快捷键 
					{
						name : "Bind",
						param : [
							['trigger','k'],
							['command','viewControl']
						]
					},
					
					{
						name : "Bind",//比例增加0.01m
						param : [
							['trigger','.'],
							['command','scaleplus']
						]
					},
					{
						name : "Bind",//比例减小0.01m
						param : [
							['trigger',','],
							['command','scalereduce']
						]
					},
					/* BOX宽度比例添加 wangxin 2012-08-10 */
					{
						name : "Bind",//比例增加0.01m
						param : [
							['trigger','j'],
							['command','widthplus']
						]
					},
					/* BOX宽度比例减小 wangxin 2012-08-10 */
					{
						name : "Bind",//比例减小0.01m
						param : [
							['trigger','h'],
							['command','widthreduce']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','/'],
							['command','switchGravity']
						]
					},
					/*	Add by yuechaofeng at 2012-5-22 end		*/
					/*	Add by yuechaofeng at 2012-10-16 begin		*/
					{
						name : "Bind",
						param : [
							['trigger','o'],
							['command','Lamp_raise']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','p'],
							['command','Lamp_reduce']
						]
					},
					{
						name : "Bind",
						param : [
							['trigger','Backspace'],
							['command','Lamp_recover']
						]
					},
					/*	Add by yuechaofeng at 2012-10-16 end	*/
					{
						name : "Bind",//退出程序
						param : [
							['trigger','ESC'],
							['command','quit']
						]
					},
					{
						name : "Bind",  //还原环境光亮度
						param : [
							['trigger','Home'],
							['command','revert']
						]
					}
				]
			}
		},
		
		// 订阅来自entity自身发出的事件，类似于`ent.behavious();`，
		// 一般这些事件都是entity内部的property class发出的。
		event : {
			/*	关闭程序	*/
			"pccommandinput_quit1" : function(){
				C3D.g2d.gamma = gamma;
				System.Quit();
			},
			/*  改变重力 @author 张泽龙 */
			"pccommandinput_switchGravity1" : function(){
				if(this.has_gravity==false){
					var current_pos = this.pcarray['pcmesh'].GetProperty('position');
					FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
					" Height:" +  this.current_height.toFixed(2) + 
					" Width:" + this.current_width.toFixed(2)+
					" G:"+this.has_gravity); 
					this.has_gravity = true;
					this.pcarray['pclinearmovement'].SetProperty('gravity', [0]);
					this.pcarray['pcmesh'].PerformAction(
					'MoveMesh',
						[
							'position',[current_pos.x, current_pos.y, current_pos.z],
						]
					);
				}else{
					FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
					" Height:" +  this.current_height.toFixed(2) + 
					" Width:" + this.current_width.toFixed(2)+
					" G:"+this.has_gravity); 
					this.has_gravity=false;
					this.pcarray['pclinearmovement'].SetProperty('gravity', [19.6]);
				}
			},
			
			/*  比例增大 */
			"pccommandinput_scaleplus1" : function(){
				var star_meshObj2 = engine.meshes.FindByName("cube#01");
				var trans2 = star_meshObj2.movable.GetTransform();
				var matrix2 = trans2.GetT2O();
				var ch = this.current_height;
				var temp_ch = ch + 0.01;
				var scale_Y = ch / temp_ch;
				this.current_height = temp_ch;
				matrix2.SetScale(1, scale_Y, 1);
				trans2.SetT2O(matrix2);
				trans2.SetTransform(trans2);
				star_meshObj2.movable.SetTransform(trans2);
				FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
				" Height:" +  this.current_height.toFixed(2) + 
				" Width:" + this.current_width.toFixed(2)+
				" G:"+this.has_gravity); 
			},
			
			/*  比例增大 按住持续增大 */
			"pccommandinput_scaleplus_" : function(){
				var star_meshObj2 = engine.meshes.FindByName("cube#01");
				var trans2 = star_meshObj2.movable.GetTransform();
				var matrix2 = trans2.GetT2O();
				var ch = this.current_height;
				var temp_ch = ch + 0.01;
				var scale_Y = ch / temp_ch;
				this.current_height = temp_ch;
				matrix2.SetScale(1, scale_Y, 1);
				trans2.SetT2O(matrix2);
				trans2.SetTransform(trans2);
				star_meshObj2.movable.SetTransform(trans2);
				FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
				" Height:" +  this.current_height.toFixed(2) + 
				" Width:" + this.current_width.toFixed(2)+
				" G:"+this.has_gravity); 
			},
			
			/*  比例减小 */
			"pccommandinput_scalereduce1" : function(){
				var star_meshObj2 = engine.meshes.FindByName("cube#01");
				var trans2 = star_meshObj2.movable.GetTransform();
				var matrix2 = trans2.GetT2O();
				var ch = this.current_height;
				var temp_ch = ch - 0.01;
				var scale_Y = ch / temp_ch;
				this.current_height = temp_ch;
				matrix2.SetScale(1, scale_Y, 1);
				trans2.SetT2O(matrix2);
				trans2.SetTransform(trans2);
				star_meshObj2.movable.SetTransform(trans2);
				FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
				" Height:" +  this.current_height.toFixed(2) + 
				" Width:" + this.current_width.toFixed(2)+
				" G:"+this.has_gravity); 
			},
			
			/*  比例减小 按住持续减小  */
			"pccommandinput_scalereduce_" : function(){
				var star_meshObj2 = engine.meshes.FindByName("cube#01");
				var trans2 = star_meshObj2.movable.GetTransform();
				var matrix2 = trans2.GetT2O();
				var ch = this.current_height;
				var temp_ch = ch - 0.01;
				var scale_Y = ch / temp_ch;
				this.current_height = temp_ch;
				matrix2.SetScale(1, scale_Y, 1);
				trans2.SetT2O(matrix2);
				trans2.SetTransform(trans2);
				star_meshObj2.movable.SetTransform(trans2);
				FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
				" Height:" +  this.current_height.toFixed(2) + 
				" Width:" + this.current_width.toFixed(2)+
				" G:"+this.has_gravity); 
			},
			
			/*  BOX宽度比例增大 */
			"pccommandinput_widthplus1" : function(){
				var star_meshObj = C3D.engine.meshes.FindByName("cube#01");
				var meshFac = star_meshObj.GetFactory();
				var meshObjFac = star_meshObj.meshObject.GetFactory();
				var meshObjFacHardtran = meshObjFac.IsSupportsHardTransform();
				if(meshObjFacHardtran)
				{
					var transf = meshFac.GetTransform();
					var matrix2 = transf.GetT2O();
					var ch = this.current_width;
					var temp_ch = ch + 0.01;
					var scale_X = temp_ch / ch;
					this.current_width = temp_ch;
					matrix2.SetScale(scale_X, 1, scale_X);
					transf.SetT2O(matrix2);
					meshFac.HardTransform(transf);
				}
				FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
				" Height:" +  this.current_height.toFixed(2) + 
				" Width:" + this.current_width.toFixed(2)+
				" G:"+this.has_gravity); 
			},
			
			/*  BOX宽度比例增大 按住持续增大 */
			"pccommandinput_widthplus_" : function(){
				var star_meshObj = C3D.engine.meshes.FindByName("cube#01");
				var meshFac = star_meshObj.GetFactory();
				var meshObjFac = star_meshObj.meshObject.GetFactory();
				var meshObjFacHardtran = meshObjFac.IsSupportsHardTransform();
				if(meshObjFacHardtran)
				{
					var transf = meshFac.GetTransform();
					var matrix2 = transf.GetT2O();
					var ch = this.current_width;
					var temp_ch = ch + 0.01;
					var scale_X = temp_ch / ch;
					this.current_width = temp_ch;
					matrix2.SetScale(scale_X, 1, scale_X);
					transf.SetT2O(matrix2);
					meshFac.HardTransform(transf);
				}
				FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
				" Height:" +  this.current_height.toFixed(2) + 
				" Width:" + this.current_width.toFixed(2)+
				" G:"+this.has_gravity); 
			},
			
			/* BOX宽度比例减小 */
			"pccommandinput_widthreduce1" : function(){
				var star_meshObj = C3D.engine.meshes.FindByName("cube#01");
				var meshFac = star_meshObj.GetFactory();
				var meshObjFac = star_meshObj.meshObject.GetFactory();
				var meshObjFacHardtran = meshObjFac.IsSupportsHardTransform();
				if(meshObjFacHardtran)
				{
					// 需要添加一个参数
					// meshFac.HardTransform( csReversibleTransform );
					var transf = meshFac.GetTransform();
					// GetMatrix
					var matrix2 = transf.GetT2O();
					// change Matrix
					var ch = this.current_width;
					var temp_ch = ch - 0.01;
					var scale_X = temp_ch / ch;
					this.current_width = temp_ch;
					matrix2.SetScale(scale_X, 1, scale_X);
					transf.SetT2O(matrix2);
					meshFac.HardTransform(transf);
				}
				FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
				" Height:" +  this.current_height.toFixed(2) + 
				" Width:" + this.current_width.toFixed(2)+
				" G:"+this.has_gravity); 
			},
			
			/* BOX宽度比例减小 按住持续减小 */
			"pccommandinput_widthreduce_" : function(){
				var star_meshObj = C3D.engine.meshes.FindByName("cube#01");
				var meshFac = star_meshObj.GetFactory();
				var meshObjFac = star_meshObj.meshObject.GetFactory();
				var meshObjFacHardtran = meshObjFac.IsSupportsHardTransform();
				if(meshObjFacHardtran)
				{
					// 需要添加一个参数
					// meshFac.HardTransform( csReversibleTransform );
					var transf = meshFac.GetTransform();
					// GetMatrix
					var matrix2 = transf.GetT2O();
					// change Matrix
					var ch = this.current_width;
					var temp_ch = ch - 0.01;
					var scale_X = temp_ch / ch;
					this.current_width = temp_ch;
					matrix2.SetScale(scale_X, 1, scale_X);
					transf.SetT2O(matrix2);
					meshFac.HardTransform(transf);
				}
				FUNCTION_DATA.get_windows("showheight").SetProperty("text_theme",
				" Height:" +  this.current_height.toFixed(2) + 
				" Width:" + this.current_width.toFixed(2)+
				" G:"+this.has_gravity); 
			},
			
			/*  开始向前  */
			"pccommandinput_forward1" : function(){
				keyControl("forward",1, this);
			},
			
			/*  停止前进  */
			"pccommandinput_forward0" : function(){
				keyControl("forward",0,this);
			},
			
			/*  开始后退  */
			"pccommandinput_backward1" : function(){
				keyControl("backward",1,this);
			},
			
			/*  停止后退  */
			"pccommandinput_backward0" : function(){
				keyControl("backward",0,this);
			},
			
			//跳跃：一般跳
			"pccommandinput_jump1" : function(){
				keyControl("jump",1,this);
			},
			
			/*  开始左转  */
			"pccommandinput_rotateleft1" : function(){
				keyControl("rotateleft",1,this);
			},
			
			/*  停止左转  */
			"pccommandinput_rotateleft0" : function(){
				keyControl("rotateleft",0,this);
			},
			
			/*  开始右转  */
			"pccommandinput_rotateright1" : function(){
				keyControl("rotateright",1,this);
			},
			
			/*  停止右转  */
			"pccommandinput_rotateright0" : function(){
				keyControl("rotateright",0,this);
			},
			
			/*  开始抬头  */
			"pccommandinput_rotateup1" : function(){
				keyControl("rotateup",1,this);
			},
			
			/*  停止抬头  */
			"pccommandinput_rotateup0" : function(){
				keyControl("rotateup",0,this);
			},
			
			/*  开始低头  */
			"pccommandinput_rotatedown1" : function(){
				keyControl("rotatedown",1,this);
			},
			
			/*  停止低头  */
			"pccommandinput_rotatedown0" : function(){
				keyControl("rotatedown",0,this);
			},
			
			/*  左平移  */
			"pccommandinput_strafeLeft1" : function(){
				keyControl("StrafeLeft",1,this);
			},
			
			/*  左平移停止  */
			"pccommandinput_strafeLeft0" : function(){
				keyControl("StrafeLeft",0,this);
			},
			
			/*  右平移  */
			"pccommandinput_strafeRight1" : function(){
				keyControl("StrafeRight",1,this);
			},
			
			/*  右平移停止  */
			"pccommandinput_strafeRight0" : function(){
				keyControl("StrafeRight",0,this);
			},
			
			/*  上平移  */
			"pccommandinput_strafeUp1" : function(){
				keyControl("StrafeUp",1,this);
			},
			/*  上平移停止  */
			"pccommandinput_strafeUp0" : function(){
				keyControl("StrafeUp",0,this);
			},
			/*  下平移  */
			"pccommandinput_strafeDown1" : function(){
				keyControl("StrafeDown",1,this);
			},
			/*  上平移停止  */
			"pccommandinput_strafeDown0" : function(){
				keyControl("StrafeDown",0,this);
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
			
			/*	快速定位	*/
			"pccommandinput_quick.to.position1" :function(){
				Event.Send({
					name : "player.effect.quick.to.position",
					player : this,
					id:POSITION[10]
				});
			},
			
			// 激活控制
			"active.control":function(){
				// alert(111);
				// this.pcarray["pccommandinput"].PerformAction("Activate", ['activate', true]);
			},

			/*打印出摄像机当前的位置、朝向	*/
			"pccommandinput_printTransform0" : function(){
				keyControl("printTransform",0,this);
			},
		
			/*  定时发送角色的位置 */
			"pctimer_player_position" : function(e){
				//使灯光跟随人物移动
				Event.Send({
					name : "bright.effect.Lamp.move",
					player : this,
					position : this.pcarray['pcmesh'].position
				});
			},
			//动画执行完后关闭窗口
			"pctimer_ui_close_Animations" : function(e){
				Event.Send({
					name : "ui.close.Animations",
					window_name : this.window_name
				});
			},
			
			/*	增加人物头顶灯光的亮度		*/
			"pccommandinput_Lamp_raise1":function(e){
				Event.Send({
					name : "bright.effect.Lamp_raise",
					player : this
				});
			},
			
			/*	增加人物头顶灯光的亮度 --- 按住不放，持续执行	*/
			"pccommandinput_Lamp_raise_":function(e){
				Event.Send({
					name : "bright.effect.Lamp_raise",
					player : this
				});
			},
			
			/*	降低人物头顶灯光的亮度		*/
			"pccommandinput_Lamp_reduce1":function(e){
				Event.Send({
					name : "bright.effect.Lamp_reduce",
					player : this
				});
			},
			
			/*	降低人物头顶灯光的亮度 --- 按住不放，持续执行	*/
			"pccommandinput_Lamp_reduce_":function(e){
				Event.Send({
					name : "bright.effect.Lamp_reduce",
					player : this
				});
			},
			
			/*	恢复人物头顶灯光的亮度		*/
			"pccommandinput_Lamp_recover1":function(e){
				Event.Send({
					name : "bright.effect.Lamp_recover",
					player : this
				});
			},
			
			// 改变视角
			"pccommandinput_changepersonmode1":function(e){
				keyControl("changepersonmode",1,this);
			},
			// 改变速度
			"pccommandinput_changespeedlevelOne1":function(e){
				keyControl("changespeedlevelOne",1,this);
			},
			// 改变速度
			"pccommandinput_changespeedlevelTwo1":function(e){
				keyControl("changespeedlevelTwo",1,this);
			},
			// 改变速度
			"pccommandinput_changespeedlevelThree1":function(e){
				keyControl("changespeedlevelThree",1,this);
			},
			// 改变速度
			"pccommandinput_changespeedlevelFour1":function(e){
				keyControl("changespeedlevelFour",1,this);
			},
			// 改变速度
			"pccommandinput_changespeedlevelFive1":function(e){
				keyControl("changespeedlevelFive",1,this);
			},
			
			// 提高环境光亮度ambient
			"pccommandinput_LightUp1":function(e) {
				Event.Send({
					name: "bright.effect.ambient_lightup",
					player: this
				});
			},
			
			// 提高环境光亮度ambient --- 按下不放，持续增加
			"pccommandinput_LightUp_":function(e) {
				Event.Send({
					name: "bright.effect.ambient_lightup",
					player: this
				});
			},
			
			//降低环境光亮度ambient
			"pccommandinput_LightDown1":function(e) {
				Event.Send({
					name: "bright.effect.ambient_lightdown",
					player: this
				});
			},
			
			//降低环境光亮度ambient --- 按下不放，持续降低
			"pccommandinput_LightDown_":function(e) {
				Event.Send({
					name: "bright.effect.ambient_lightdown",
					player: this
				});
			},
			
			//还原环境光亮度ambient
			"pccommandinput_revert1" : function(){
				Event.Send({
					name: "bright.effect.ambient_revert",
					player: this
				});
			},
			
			// 提高屏幕gamma值
			"pccommandinput_GammaUp1":function(e) {
				Event.Send({
					name: "bright.effect.screen_gammaUp",
					player: this
				});
			},
			//提高屏幕gamma值 --- 按下不放，持续提高
			"pccommandinput_GammaUp_":function(e) {
				Event.Send({
					name: "bright.effect.screen_gammaUp",
					player: this
				});
			},
			
			//降低屏幕gamma值
			"pccommandinput_GammaDown1":function(e) {
				Event.Send({
					name: "bright.effect.screen_gammaDown",
					player: this
				});
			},
			//降低屏幕gamma值 --- 按下不放，持续降低
			"pccommandinput_GammaDown_":function(e) {
				Event.Send({
					name: "bright.effect.screen_gammaDown",
					player: this
				});
			},
			
			/*	鼠标滑动	*/
			"pccommandinput_mousemove" : function(msgid,x,y){
				if(this.mouseleft){
					Event.Send({
						name : "mouse.effect.mousemove",
						player : this
					});
				}
			},
			
			/*	鼠标左键按下 */
			"pccommandinput_mouseleft1" : function(){
				keyControl("mouseleft",1,this);
			},
			
			/*	鼠标左键弹起	*/
			"pccommandinput_mouseleft0" : function(){
				keyControl("mouseleft",0,this);
			},
			
			/*	鼠标右键按下	*/
			"pccommandinput_mouseright1" : function(){
				Event.Send({
					name : "mouse.effect.click.mesh",
					player : player
				});
			},
			
			/*	鼠标滚轮向前	*/
			"pccommandinput_wheelforward1" : function(){
				keyControl("wheelforward",1,this);
			},
			
			/*	鼠标滚轮向后 	*/
			"pccommandinput_wheelbackward1" : function(){
				keyControl("wheelbackward",1,this);
			},
			
			/*	快捷键抬起时控制UI方向控制的关闭	*/
			"pccommandinput_viewControl0" : function(){
				keyControl("viewControl",0,this);
			},
			
			/*	切换查看方式快捷键按下	*/
			"pccommandinput_changeviewway1" : function(){
				if(player.mouse_view_way){
					player.mouse_view_way = false;
					//让镜头跟着人物走 huyanan 2012-07-03
					iCamera.pcarray['pcdefaultcamera'].PerformAction('SetFollowEntity',['entity','player']);
					var current_pos = player.pcarray['pcmesh'].GetProperty('position');
					iCamera.pcarray['pcmesh'].PerformAction(
						'MoveMesh',
							[
								'position',[current_pos.x, current_pos.y+2,current_pos.z],
							],
							[
								'rotation',[0, 0, 0]
							]
					);
				}else{
					player.mouse_view_way = true;
				}
			}
		},
		
		// 订阅全局的事件
		subscribe : {
			// 角色选择确定后，调用角色的
			"role.select.enter.click": function(){
				this.pcarray["pccommandinput"].PerformAction("Activate", ['activate', true]);
				this.pcarray["pcmesh"].PerformAction("RotateMesh", ["rotation", [0, 3.1155, 0]]);
				this.pcarray['pclinearmovement'].SetProperty('gravity', [0]);
				// iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','firstperson']);
				//var pos = player.pcarray["pcmesh"].GetProperty("position");
				this.pcarray['pcmesh'].PerformAction(
					'MoveMesh', [
						'position', [
							0, 0 , 0
						]
					]
				);
			}
		},
	};
	
}
catch (e)
{
	alert(e);
}