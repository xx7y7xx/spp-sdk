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
	/*	判断是否接收键盘事件	*/
	var keyControl = function(keycode, keystate, actor){
		if(!player.mouse_view_way){	//控制键盘是否为可用状态
			if(keystate == 1)
			{
				switch(keycode){
					case "forward" : 
						Event.Send({
							name: "player.effect.forward",
							player: actor
						});
						break;
					case "backward" : 
						Event.Send({
							name: "player.effect.backward",
							player: actor
						});
						break;
					case "jump" : 
						Event.Send({
							name : "player.effect.jump",
							player : actor
						});
						break;
					case "rotateleft" : 
						Event.Send({
							name: "player.effect.rotateleft",
							player: actor
						});
						break;
					case "rotateright" : 
						Event.Send({
							name: "player.effect.rotateright",
							player: actor
						});
						break;
					case "rotateup" : 
						Event.Send({
							name: "player.effect.rotateup",
							player: actor
						});
						break;
					case "rotatedown" : 
						Event.Send({
							name: "player.effect.rotatedown",
							player: actor
						});
						break;
					case "StrafeLeft" : 
						Event.Send({
							name: "player.effect.StrafeLeft",
							player: actor
						});
						break;
					case "StrafeRight" : 
						Event.Send({
							name: "player.effect.StrafeRight",
							player: actor
						});
						break;
					case "StrafeUp" : 
						Event.Send({
							name: "player.effect.StrafeUp",
							player: actor
						});
						break;
					case "StrafeDown" : 
						Event.Send({
							name: "player.effect.StrafeDown",
							player: actor
						});
						break;
					case "changepersonmode" :
						/*
						if(actor.person=="firstperson"){
							actor.person="thirdperson";
							iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
						}else{
							actor.person="firstperson";
							iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','firstperson']);
						}*/
						
						//发送视角人称切换的消息
						Event.Send({
							name : "camare.effect.change.mode" 
						});
						break;
					case "changespeedlevelOne" : 
						actor.walkSpeed["movement"] = 3;
						actor.walkSpeed["rotation"] = 2;
						actor.walkSpeed["jumping"] = 10;
						actor.strafeUpSpeed = 0.02;		// 向上的速度
						actor.strafeDownSpeed = 0.02;	// 向下的速度
						Event.Send({
							name:"effect.go.run.change",
							player : actor
						});
						break;
					case "changespeedlevelTwo" :
						actor.walkSpeed["movement"] = 15;
						actor.walkSpeed["rotation"] = 2;
						actor.walkSpeed["jumping"] = 20;
						actor.strafeUpSpeed = 0.5;	// 向上的速度
						actor.strafeDownSpeed = 0.5;	// 向下的速度
						Event.Send({
							name:"effect.go.run.change",
							player : actor
						});
						break;
					case "changespeedlevelThree" :
						actor.walkSpeed["movement"] = 40;
						actor.walkSpeed["rotation"] = 3;
						actor.walkSpeed["jumping"] = 30;
						actor.strafeUpSpeed = 2.02;	// 向上的速度
						actor.strafeDownSpeed = 2.02;	// 向下的速度
						Event.Send({
							name:"effect.go.run.change",
							player : actor
						});
						break;
					case "changespeedlevelFour" :
						actor.walkSpeed["movement"] = 80;
						actor.walkSpeed["rotation"] = 4;
						actor.walkSpeed["jumping"] = 40;
						actor.strafeUpSpeed = 3.02;	// 向上的速度
						actor.strafeDownSpeed = 3.02;	// 向下的速度
						Event.Send({
							name:"effect.go.run.change",
							player : actor
						});
						break;
					case "changespeedlevelFive" :
						actor.walkSpeed["movement"] = 140;
						actor.walkSpeed["rotation"] = 5;
						actor.walkSpeed["jumping"] = 50;
						actor.strafeUpSpeed = 5.02;	// 向上的速度
						actor.strafeDownSpeed = 5.02;	// 向下的速度
						Event.Send({
							name:"effect.go.run.change",
							player : actor
						});
						break;
					default : 
						break;
				}
			}
			if(keystate == 0)
			{
				switch(keycode){
					case "forward" : 
						Event.Send({
							name: "player.effect.forward.stop",
							player: actor
						});
						break;
					case "backward" : 
						Event.Send({
							name: "player.effect.backward.stop",
							player: actor
						});
						break;
					case "rotateleft" : 
						Event.Send({
							name: "player.effect.rotateleft.stop",
							player: actor
						});
						break;
					case "rotateright" : 
						Event.Send({
							name: "player.effect.rotateright.stop",
							player: actor
						});
						break;
					case "rotateup" : 
						Event.Send({
							name: "player.effect.rotateup.stop",
							player: actor
						});
						break;
					case "rotatedown" : 
						Event.Send({
							name: "player.effect.rotatedown.stop",
							player: actor
						});
						break;
					case "StrafeLeft" : 
						Event.Send({
							name: "player.effect.StrafeLeft.stop",
							player: actor
						});
						break;
					case "StrafeRight" : 
						Event.Send({
							name: "player.effect.StrafeRight.stop",
							player: actor
						});
						break;
					case "StrafeUp" : 
						Event.Send({
							name: "player.effect.StrafeUp.stop",
							player: actor
						});
						break;
					case "StrafeDown" : 
						Event.Send({
							name: "player.effect.StrafeDown.stop",
							player: actor
						});
						break;
					case "printTransform" : 
						var position = actor.pcarray['pcmesh'].GetProperty("position");
						var rotation = actor.pcarray['pcmesh'].GetProperty("rotation");
						var pitch = iCamera.pcarray['pcdefaultcamera'].GetProperty('pitch');
						var distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
						console.info("position："+ position.x + ", " + position.y + ", " + position.z);
						console.info("rotation：" + rotation.x +", "+ rotation.y +", "+ rotation.z);
						console.info("pitch："+pitch);
						console.info("distance"+distance);
						break;
					case "viewControl" :
						if(player.view_control){
							player.view_control = false;
							Event.Send({
								name : "ui.viewControl.open",
								player : actor
							});
						}else{
							player.view_control = true;
							Event.Send({
								name : "ui.viewControl.close",
								player : actor
							});
						}
						break;
					default : 
						break;
				}
			}
		}else{ //控制鼠标是否为可用状态
			if(keystate == 1){
				switch(keycode){
					case "mouseleft" :
						//记录鼠标左键按下时的鼠标坐标
						player.startX = player.mousex;
						player.startY = player.mousey;
						//获取并记录camera的rotation值
						var rotation = player.pcarray['pcmesh'].GetProperty('rotation');
						player.startRotationY = rotation.y;
						//获取并记录camera的pitch值
						var pitch = iCamera.pcarray['pcdefaultcamera'].GetProperty('pitch');
						player.startPitch = pitch;
						Event.Send({
							name : "mouse.effect.mouseleftrotation",
							player : actor
						});
						break;
					case "wheelforward" :
						var cur_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
						if(cur_distance-1 >=0){
							Event.Send({
								name : "mouse.effect.change.distance.near",
								player : actor
							});
						}
						break;
					case "wheelbackward" :
						Event.Send({
							name : "mouse.effect.change.distance.far",
							player : actor
						});
						break;
					default : 
						break;
				}
			}
			if(keystate == 0){
				switch(keycode){
					case "mouseleft" :
						player.mouseleft = false;
						break;
					default : 
						break;
				}
			}
		}
	};
}
catch (e)
{
	alert(e);
}