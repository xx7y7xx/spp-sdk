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
		

		// 换装备、衣服
		var changeMeshRole = {
			"woman":{
				// 角色所有可以更换的mesh，按部位分类;
				// 每个部位的第一件装备为默认穿着装备;
				"allChangeMesh" : {
					'toufa' : ['toufa1','toufa2'],
					'yifu' : ['yifu4','yifu2']
				},
				// 角色上次穿的mesh，按部位分
				"currentMesh" : {
					'toufa' : 'toufa1',
					'yifu' : 'yifu4'
				}
			}
		};
		
		// 初始化角色的 mesh
		Event.Subscribe(function(e){
			try{
				var roleName = e.role;
				var iEngine = Registry.Get('iEngine');
				var iMeshWrapper = iEngine.FindMeshObject(roleName,0);
				var iMeshObject = iMeshWrapper.meshObject;
				var iSpriteCal3DState = iMeshObject.QueryInterface('iSpriteCal3DState');
				// 先将重复的装备detach，留下默认装备
				var allMesh = changeMeshRole[roleName]["allChangeMesh"];
				for(var mesh in allMesh){
					var partMesh = allMesh[mesh];
					var isFirst = true;
					for(var oneMesh in partMesh){
						if(isFirst){
							isFirst = false;
							continue;
						}
						iSpriteCal3DState.DetachMesh(partMesh[oneMesh]);
					}
				}
			}catch(e){
				alert('ERROR: init.role.mesh error!  '+e);
			}
		},"init.role.mesh");
		
// ==========================================================================================================
// ======  订阅的事件  ======================================================================================
// ==========================================================================================================

		/* 点中了mesh */
		Event.Subscribe(function(e){
			console.debug("click on mesh : " + e.mesh);
			
			// 记录住mesh名称
			player.clickedMesh = e.mesh;
			
			// 显示模型名称
			FUNCTION_DATA.get_windows("kuaisudingwei/name").SetProperty("text_theme",
				"模型名称为" + e.mesh + "");
			
			// 显示以前的tip，如果没有，则创建
			var input_box = GUI.Editbox.Get("kuaisudingwei/chinses_name");
			if(AnywhereDoorData[player.clickedMesh] == undefined)
			{
				console.debug("该mesh以前没有定义过任意门");
				// 创建临时的门，在“定位”之后再保存到JSON中。
				player.tmpData = {
					tip : "",
					pos : {}
				};
			}
			else
			{
				console.debug("该mesh以前定义过任意门了，读取数据");
				player.tmpData = AnywhereDoorData[player.clickedMesh];
			}
			input_box.SetProperty("Text", player.tmpData.tip);
			
			// 显示信息窗口。
			FUNCTION_DATA.get_windows("kuaisudingwei/name").SetProperty("Visible", "True");
			
		}, "tool.anywheredoor.mesh.mouse.click");

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
		}, "effect.go.run.change");
		
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
		
		//王鑫新增(2012-06-14)
		Event.Subscribe(function(e){
			var bol = e.bol ;
			if(bol){
				return ; 
			}
			player.window_init_x = e.pos_x
			player.window_init_y = e.pos_y
			var x = player.mouseStartX - player.window_init_x ; 
			var y = player.mouseStartY - player.window_init_y ; 
			var first = x/e.map_win_width; 
			var second = y/e.map_win_height; 
			var third = first + e.btn_win_width/e.map_win_width; 
			var four = second + e.btn_win_height/e.map_win_height; 
			var half_w = (third - first)/2;
			var half_h = (four-second)/2;
			var UnifiedAreaRect = "{{"+(first-half_w)+",0},{"+(second-half_h)+",0},{"+(third-half_w)+",0},{"+(four-half_h)+",0}}" ;
			System.Report("\n UnifiedAreaRect:"+UnifiedAreaRect, 0, "test");
			player.u_message =  UnifiedAreaRect ; 
			Event.Send({
				name : "ui.move.dingwei_button" ,
				areaRect : UnifiedAreaRect 
			});
			player.but_index++ ; 
		},"player.effect.create_new_button");
		
		//获取输入信息
		Event.Subscribe(function(e){
			var xmlString = player.list_position_data ;
			var pos = player.pcarray['pcmesh'].GetProperty('position');
			var rot = player.pcarray['pcmesh'].GetProperty('rotation');
			if(isNaN(pos.x) || isNaN(pos.y) || isNaN(pos.z) || isNaN(rot.y)){
				alert("获取的为非数值类型！请重新获取");
				return;
			}else{
				xmlString = player.but_index+"|"+player.chinese_name+"|"+player.english_name+
							"|"+pos.x+"|"+pos.y+"|"+pos.z+"|"+rot.y+"|"+player.u_message+"%";
				player.list_position_data += xmlString;
				Event.Send({
					name : "ui.create.dingwei_button",
					index : player.but_index,
					btn_name : player.chinese_name,
					btn_pos : player.u_message
				});
			}
		},"player.effect.get_message") ; 
		
		//第一个确定按钮，把第一次输入的信息，包括位置信息读出来保存
		Event.Subscribe(function(e){
			player.first_chinese_name = e.chinese_name;
			player.first_english_name = e.english_name;
			player.first_id = e.id;
			player.first_pos = player.pcarray['pcmesh'].GetProperty('position');
			player.first_rot = player.pcarray['pcmesh'].GetProperty('rotation');
		},"player.effect.get_first_360message");
		//获取360全景点输入的信息
		Event.Subscribe(function(e){
			var xmlString = player.list_360point_position_data ; 
			var pos = player.pcarray['pcmesh'].GetProperty('position');
			var rot = player.pcarray['pcmesh'].GetProperty('rotation');
			if(isNaN(pos.x) || isNaN(pos.y) || isNaN(pos.z) || isNaN(rot.y) || isNaN(player.first_pos.x) || isNaN(player.first_pos.y) || isNaN(player.first_pos.z) || isNaN(player.first_rot.y)){
				alert("获取的为非数值类型！请重新获取");
				return;
			}else{
				xmlString = "index"+"|"+player.first_chinese_name+"|"+player.first_english_name+"|"+player.first_id+
							"|"+player.first_pos.x+"|"+player.first_pos.y+"|"+player.first_pos.z+"|"+player.first_rot.y+
							"|"+e.id+
							"|"+pos.x+"|"+pos.y+"|"+pos.z+"|"+rot.y+"|"+"%";
				player.list_360point_position_data += xmlString;
			}
		},"player.effect.get_360point_message") ; 
		})();
} catch(e){
	alert(e);
}
