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
	ZHUCAIDAN_LAYOUT = {
		name : "zhucaidan.layout",
		method : {
			school_sand_window_close : function(){
				player.mouse_view_way = false;
				FUNCTION_DATA.get_windows("sand/background").SetProperty("Visible","False");
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				FUNCTION_DATA.get_windows("sand/Editbox").SetProperty("Text","");
				player.sand_text_name = "";
				player.sand_state = true;
				//同时把上一个创建的销毁
				//if(player.currentIcon != ""){
					// alert(player.currentIcon);
					// if(GUI.Windows.IsWindowPresent(player.currentIcon)){
						// GUI.Windows.DestroyWindow(player.currentIcon);
					// }
					var button = FUNCTION_DATA.get_windows("sand/table/static_button");
					button.jointVisibleCtrl = false;
					button.SetProperty("Visible","False"); 
					if(player.isSand==false){
						player.prePosition = iCamera.pcarray['pcmesh'].GetProperty("position");
						player.preRotation = iCamera.pcarray['pcmesh'].GetProperty("rotation");
					}
					Event.Send({
						name : "player.effect.hoarse.backing_out"
					});
				// }
			},
			school_sand_notarize : function(){
				var sand_text_value = FUNCTION_DATA.get_windows("sand/Editbox").GetProperty("Text");
				
				/** 动态创建ui按钮 */
				//声明ui的名称变量
				var ui_name = "";
				//解析sand.xml文件
				var document = new xmlDocument();
				var fread_sand = VFS.Open("/tools/ui/sand.xml");
				var flag_sand = document.Parse(fread_sand);
				if(!flag_sand){
					alert("文件没有打开，请检查");
				}
				// 获取跟节点的名字为"section"的子节点
				var rc_sand = document.root.GetChild("application");
				// 获取该节点的所有属性
				var sandTable = rc_sand.GetChild("sandTable");
				var label = sandTable.GetChildren()
				var count = label.GetEndPosition();
				if(count)
				{
					// 循环遍历label
					do
					{
						count--;
						
						// 具体label id=""....
						var labelX = label.Next();
						var id = labelX.GetAttribute("id")
						ui_name = id.value;
						if(ui_name == sand_text_value){
							alert("输入的ui名称有重复，请重新输入ui名称！！！");
							return;
						}
					}while(count > 0)
				}
				if(sand_text_value!=''){
					var icon_name = "sand/table"+sand_text_value;
					var button = GUI.Windows.CreateWindow("General/Button",icon_name);
					button.SetProperty("HoverImage","set:introschool image:ui_bg");
					button.SetProperty("NormalImage","set:introschool image:ui_bg");
					button.SetProperty("PushedImage","set:introschool image:ui_bg");
					button.SetProperty("UnifiedMaxSize","{{1,0},{1,0}}");
					button.SetProperty("UnifiedAreaRect","{{0.886397,0},{0.0883174,0},{0.938122,0},{0.127377,0}}");
					button.parent=GUI.GUISheet.Get("root");
					button.jointPivot = [player.nonce_position[0],0,player.nonce_position[2]];
					button.jointMethod = 5;
				}
				
				if(sand_text_value!=''){
					if(player.panorama_int == 1){
						player.sand_state = true;	
						sand_value = sand_text_value+":"+player.nonce_position+"%";
						player.list_position += sand_value;
						FUNCTION_DATA.get_windows("sand/Editbox").SetProperty("Text","");
					}else{
						sand_value = sand_text_value+":"+player.nonce_position;
						player.sand_state = false;
						FUNCTION_DATA.get_windows("sand/Editbox").SetProperty("Text","");
						var text_t2 = "步骤2--"+sand_text_value+"定位";
						FUNCTION_DATA.get_windows("sand/background/text_t2").SetProperty("Text",text_t2);
					}
					
					player.sand_text_name = sand_text_value; 
					if(player.isSand==false){
						player.prePosition = iCamera.pcarray['pcmesh'].GetProperty("position");
						player.preRotation = iCamera.pcarray['pcmesh'].GetProperty("rotation");
					}
					// if(player.list_position==''){
						// player.list_position = sand_value;
					// }else{
						// player.list_position = player.list_position +"%"+ sand_value;
					// }
					player.mouse_view_way = false;
					FUNCTION_DATA.get_windows("sand/background").SetProperty("Visible","False");
					star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
					Event.Send({
						name : "player.effect.hoarse.backing_out"
					});
				}
			},
			panorama_export : function(){
				player.panorama_int == 0;
				FUNCTION_DATA.get_windows("school_sand_serch/sand").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("school_sand_serch/role").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("school_sand/360").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("school_sand_360/export").SetProperty("Visible","false");
				player.sand_state = true;
				player.mouse_view_way = false;	
				player.mouse_click_star = 0;
				xmlString = "<application type=\"school\">\n"
				xmlString += "\t<sandTable_360>\n"
				var sand_string = player.list_position;
				if(sand_string == ""){
					alert("数组为空，请选择坐标！！！");
					return;
				}else{
					var list = sand_string.split('%'); 
					for(var i = 0;i<list.length-1;i++){
						var name = "\""+list[i].split(':')[0]+"\"";
						xmlString += "\t\t<label id="+name+">\n"
						xmlString += "\t\t\t<uiPosition>["+list[i].split(':')[1]+"]</uiPosition>\n"
						xmlString += "\t\t</label>\n"
					}
					xmlString +="\t</sandTable_360>\n"
					xmlString +="</application>"
					var file_to_write = VFS.Open("/tools/ui/sand_position_360.xml",VFS.WRITE);
					VFS.WriteFile("/tools/ui/sand_position_360.xml",xmlString);
					sand_value = "";
					player.list_position = [];
				}
			},
			school_sand_yulan : function(){
				woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
			},
			school_sand_notarize2 : function(){
				//rotation求了一下负值是因为导出来的快速定位的值，需要做一下负运算
				var camera_rot_sand = [0,0-player.nonce_rotation[1],0];
				sand_value += "/"+player.nonce_position+"$"+camera_rot_sand;
				if(player.list_position==''){
					player.list_position = sand_value;
				}else{
					player.list_position = player.list_position + "%" + sand_value;
				}
				FUNCTION_DATA.get_windows("sand/background2").SetProperty("Visible","False");
				player.nonce_position = [];
				player.nonce_rotation = [];
				player.sand_state = true;
				player.mouse_view_way = false;
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				
				
				xmlString = "<application type=\"school\">\n"
				xmlString += "\t<sandTable>\n"
				var sand_string = player.list_position;
				var list = sand_string.split('%'); 
				for(var i = 0;i<list.length;i++){
					var name = "\""+list[i].split(':')[0]+"\"";
					xmlString += "\t\t<label id="+name+">\n"
					xmlString += "\t\t\t<uiPosition>["+list[i].split(':')[1].split('/')[0]+"]</uiPosition>\n"
					xmlString += "\t\t\t<playerPosition>["+list[i].split(':')[1].split('/')[1].split('$')[0]+"]</playerPosition>\n"
					xmlString += "\t\t\t<playerRotation>["+list[i].split(':')[1].split('/')[1].split('$')[1]+"]</playerRotation>\n"
					xmlString += "\t\t</label>\n"
				}
				xmlString +="\t</sandTable>\n"
				xmlString +="</application>"
				var file_to_write = VFS.Open("/tools/ui/sand.xml",VFS.WRITE);
				VFS.WriteFile("/tools/ui/sand.xml",xmlString);
				xmlString = "";
				
				//如果人物当前是显示的，需隐藏掉
				woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
			},
			school_sand_serch_annul2 : function(){
				player.nonce_position = [];
				player.nonce_rotation = [];
				FUNCTION_DATA.get_windows("sand/background2").SetProperty("Visible","False");
				player.sand_state = false;
				player.mouse_view_way = false;
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				//如果人物当前是显示的，需隐藏掉
				woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
			},
			role_preview : function(){
				FUNCTION_DATA.get_windows("role/preview").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("role/change").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("role/notarize").SetProperty("Visible","True");
				var camera_p = iCamera.pcarray['pcmesh'].GetProperty("position");
				var camera_r = iCamera.pcarray['pcmesh'].GetProperty("rotation");
				var player_r = player.pcarray['pcmesh'].GetProperty("rotation");
				var camera_pos = [camera_p.x,camera_p.y,camera_p.z];
				var camera_rot = [camera_r.x,(camera_r.y)/(-1),camera_r.z];
				var r_camera_rot = [camera_r.x,3.14-camera_r.y,camera_r.z];
				if(player.sex == "nv"){
					woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
					woman.pcarray['pcmesh'].PerformAction('MoveMesh',["position",player.nonce_position] , ['rotation',r_camera_rot]);
				}else{
					man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
					man.pcarray['pcmesh'].PerformAction('MoveMesh',["position",player.nonce_position] , ['rotation',r_camera_rot]);
				}
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				iCamera.pcarray['pcmesh'].PerformAction('MoveMesh',["position",camera_pos] , ['rotation',camera_rot]);
				player.ui_control_rotate = true;
			},
			role_change : function(){
				var camera_p = iCamera.pcarray['pcmesh'].GetProperty("position");
				var camera_r = iCamera.pcarray['pcmesh'].GetProperty("rotation");
				var player_r = player.pcarray['pcmesh'].GetProperty("rotation");
				var camera_pos = [camera_p.x,camera_p.y,camera_p.z];
				var camera_rot = [camera_r.x,(camera_r.y)/(-1),camera_r.z];
				var r_camera_rot = [camera_r.x,3.14-camera_r.y,camera_r.z];
				if(player.sex == "nv"){
					man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
					woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
					man.pcarray['pcmesh'].PerformAction('MoveMesh',["position",player.nonce_position] , ['rotation',r_camera_rot]);
					player.sex = "nan";
				}else{
					woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
					man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
					woman.pcarray['pcmesh'].PerformAction('MoveMesh',["position",player.nonce_position] , ['rotation',r_camera_rot]);
					player.sex = "nv";
				}
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				iCamera.pcarray['pcmesh'].PerformAction('MoveMesh',["position",camera_pos] , ['rotation',camera_rot]);
				player.ui_control_rotate = true;
			},
			role_annul : function(){
				player.mouse_view_way = false;
				FUNCTION_DATA.get_windows("role/background").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("role/preview").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("role/notarize").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("role/change").SetProperty("Visible","False");
				woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				player.sand_state = true;
				player.role_data = [];
				player.ui_control_rotate = false;
			},
			role_notarize : function(){
				player.sand_state = false; 
				player.mouse_view_way = false;
				var camera_p = iCamera.pcarray['pcmesh'].GetProperty("position");
				var camera_r = iCamera.pcarray['pcmesh'].GetProperty("rotation");
				var camera_pos = [camera_p.x,camera_p.y,camera_p.z];
				var camera_rot = [camera_r.x,(camera_r.y)/(-1),camera_r.z];
				var r_camera_rot = [camera_r.x,3.14-camera_r.y,camera_r.z];
				player.role_data = player.nonce_position+"$"+r_camera_rot+"%"+camera_pos+"$"+camera_rot;
				FUNCTION_DATA.get_windows("role/background").SetProperty("Visible","False");
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				FUNCTION_DATA.get_windows("button/zuoxuan").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("button/youxuan").SetProperty("Visible","False");
				player.ui_control_rotate = false;
			},
			role_yulan : function(){
				if(player.sex == "nv"){
					woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
					man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				}else{
					man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
					woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				}
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				FUNCTION_DATA.get_windows("role/yulan").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("role/change2").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("role/notarize2").SetProperty("Visible","True");
			},
			role_change2 : function(){
				if(player.sex == "nv"){
					man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
					woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
					player.sex = "nan";
				}else{
					woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', true]);
					man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
					player.sex = "nv";
				}
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
			},
			role_notarize2 : function(){
				var camera_rot2 = [0,player.nonce_rotation[1],0];
				player.role_data += "%"+player.nonce_position+"$"+camera_rot2;
				player.map_pos_roes = player.nonce_position;
				FUNCTION_DATA.get_windows("role/background2").SetProperty("Visible","False");
				player.nonce_position = [];
				player.nonce_rotation = [];
				player.sand_state = true;
				player.mouse_view_way = false;
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				player.mouse_click_star = 0;
				FUNCTION_DATA.get_windows("school_sand_serch/sand").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("school_sand_serch/role").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("role/change2").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("role/notarize2").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("role/yulan").SetProperty("Visible","True");
				
				// FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","True");
				var list2 = player.role_data.split("%");
				xmlString = "<application type=\"school\">\n"
				xmlString +="\t<roleSelect>\n"
				
				xmlString +="\t\t<role>\n"
				xmlString +="\t\t\t<position>["+list2[0].split("$")[0]+"]</position>\n"
				xmlString +="\t\t\t<rotation>["+list2[0].split("$")[1]+"]</rotation>\n"
				xmlString +="\t\t</role>\n"
				
				xmlString +="\t\t<camera>\n"
				xmlString +="\t\t\t<position>["+list2[1].split("$")[0]+"]</position>\n"
				xmlString +="\t\t\t<rotation>["+list2[1].split("$")[1]+"]</rotation>\n"
				xmlString +="\t\t</camera>\n"
				
				xmlString +="\t</roleSelect>\n"
				
				xmlString +="\t<roleInitialize>\n"
				
				xmlString +="\t\t<role>\n"
				xmlString +="\t\t\t<position>["+list2[2].split("$")[0]+"]</position>\n"
				xmlString +="\t\t\t<rotation>["+list2[2].split("$")[1]+"]</rotation>\n"
				xmlString +="\t\t</role>\n"
				
				xmlString +="\t\t<camera>\n"
				xmlString +="\t\t\t<position>[0,0,0]</position>\n"
				xmlString +="\t\t\t<rotation>[0,0,0]</rotation>\n"
				xmlString +="\t\t</camera>\n"
				
				xmlString +="\t</roleInitialize>\n"
				xmlString +="</application>"
				var file_to_write = VFS.Open("/tools/ui/role.xml",VFS.WRITE);
				VFS.WriteFile("/tools/ui/role.xml",xmlString);
				xmlString = "";
				player.role_data = [];
				// FUNCTION_DATA.get_windows("school_map/btn").SetProperty("Visible","True");
			},
			role_annul2 : function(){
				player.nonce_position = [];
				player.nonce_rotation = [];
				FUNCTION_DATA.get_windows("role/background2").SetProperty("Visible","False");
				player.sand_state = false;
				player.mouse_view_way = false;
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				woman.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				man.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				FUNCTION_DATA.get_windows("role/yulan").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("role/notarize2").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("role/change2").SetProperty("Visible","False");
			},
			
			but_enter : function(){
				player.btn_click = true;
			},
			but_leave : function(){
				player.btn_click = false;
			},
			
			map_click : function(){
				player.map_enter_Is = true;
				FUNCTION_DATA.get_windows("school_map/btn").SetProperty("Visible","false");
				FUNCTION_DATA.get_windows("school_sand_serch/sand").SetProperty("Visible","false");
				FUNCTION_DATA.get_windows("school_sand_serch/role").SetProperty("Visible","false");
				FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","false");
				FUNCTION_DATA.get_windows("zhucaidan/mini_map").SetProperty("Visible","true");
				FUNCTION_DATA.get_windows("school_map/notarize_diyi").SetProperty("Visible","true");
				FUNCTION_DATA.get_windows("school_sand/360").SetProperty("Visible","false");
			},
			map_leave :function(){
				player.map_enter_Is = false;
			},
			school_sand : function(){
				//第一次触发button事件时，加载并解析sand.xml 和 sand_view.xml文件
				if(player.first_trigger_buttonevent == 0){
					var document = new xmlDocument();
					
					//解析sand_view.xml文件
					var fread_view = VFS.Open("/tools/ui/sand_view.xml");
					var flag_view = document.Parse(fread_view);
					if(!flag_view){
						alert("文件没有打开，请检查");
					}
					// 获取根节点的名字为"SAND_VIEW"的子节点
					var rc_view = document.root.GetChild("SAND_VIEW");
					var children = rc_view.GetChildren();
					if(children.HasNext()){
						//获取该节点的所有属性
						var position = rc_view.GetChild("position");
						var rotation = rc_view.GetChild("rotation");
						var pitch = rc_view.GetChild("pitch");
						var distance = rc_view.GetChild("distance");
						
						//将解析后的数据保存起来，方便调用
						var sand_view_pos = position.contentsValue;
						var sand_view_rot = rotation.contentsValue;
						var sand_view_distance = distance.contentsValue;
						var sand_view_pitch = pitch.contentsValue;
						console.info("\n'sand_view_pos' = " + sand_view_pos + "\n");
						console.info("\n'sand_view_rot' = " + sand_view_rot + "\n");
						console.info("\n'sand_view_distance' = " + sand_view_distance + "\n");
						console.info("\n'sand_view_pitch' = " + sand_view_pitch + "\n");
						
						player.sand_view_pos = sand_view_pos.substring(1, sand_view_pos.length-1);
						player.sand_view_rot = sand_view_rot.substring(1, sand_view_rot.length-1);
						player.sand_view_distance = sand_view_distance;
						player.sand_view_pitch = sand_view_pitch;
						
						//处理解析后的数据以便使用
						player.sand_view_pos_x = player.sand_view_pos.split(',')[0];
						player.sand_view_pos_y = player.sand_view_pos.split(',')[1];
						player.sand_view_pos_z = player.sand_view_pos.split(',')[2];
						
						player.sand_view_rot_x = player.sand_view_rot.split(',')[0];
						player.sand_view_rot_y = -(player.sand_view_rot.split(',')[1]);
						player.sand_view_rot_z = player.sand_view_rot.split(',')[2];
					}
					
					//解析sand.xml文件
					var fread_sand = VFS.Open("/tools/ui/sand.xml");
					var flag_sand = document.Parse(fread_sand);
					if(!flag_sand){
						alert("文件没有打开，请检查");
					}
					// 获取跟节点的名字为"section"的子节点
					var rc_sand = document.root.GetChild("application");
					
					// 获取该节点的所有属性
					var sandTable = rc_sand.GetChild("sandTable");
					
					var label = sandTable.GetChildren()
					
					var count = label.GetEndPosition();
					
					if(count)
					{
						// 循环遍历label
						do
						{
							count--;
							
							// 具体label id=""....
							var labelX = label.Next();
							var id = labelX.GetAttribute("id")
							console.info("\n'n_nX' = '" + labelX.value + "'\n");
							console.info("\n'id' = '" + id.value + "'\n");
							
							var uiPosition = labelX.GetChild("uiPosition");
							var playerPosition = labelX.GetChild("playerPosition");
							var playerRotation = labelX.GetChild("playerRotation");
							console.info("\n'uiPosition' = " + uiPosition.contentsValue + "\n");
							console.info("\n'playerPosition' = " + playerPosition.contentsValue + "\n");
							console.info("\n'playerRotation' = " + playerRotation.contentsValue + "\n");
							
							//截取解析后的字符串有”[0,0,0]“变成”0,0,0“格式
							uiPosition = uiPosition.contentsValue;
							uiPosition = uiPosition.substring(1, uiPosition.length-1);
							
							playerPosition = playerPosition.contentsValue;
							playerPosition = playerPosition.substring(1, playerPosition.length-1);
							
							playerRotation = playerRotation.contentsValue;
							playerRotation = playerRotation.substring(1, playerRotation.length-1);
							if(count == 0){
								var String = id.value + ":" + (uiPosition.split(','))[0] + "," + 
											(uiPosition.split(','))[1] + "," + (uiPosition.split(','))[2] + "/" + 
											(playerPosition.split(','))[0] + "," + (playerPosition.split(','))[1] + "," + 
											(playerPosition.split(','))[2] + "$" + (playerRotation.split(','))[0] + "," + 
											(playerRotation.split(','))[1] + "," + (playerRotation.split(','))[2];
							}else{
								var String = id.value + ":" + (uiPosition.split(','))[0] + "," + 
											(uiPosition.split(','))[1] + "," + (uiPosition.split(','))[2] + "/" + 
											(playerPosition.split(','))[0] + "," + (playerPosition.split(','))[1] + "," + 
											(playerPosition.split(','))[2] + "$" + (playerRotation.split(','))[0] + "," + 
											(playerRotation.split(','))[1] + "," + (playerRotation.split(','))[2] + "%";
							}
							player.list_position += String;
							
							//需要动态生成三维UI
							var icon_name = "sand/table" + id.value;
							var button = GUI.Windows.CreateWindow("General/Button",icon_name);
							if(button){
								button.SetProperty("HoverImage","set:introschool image:ui_bg");
								button.SetProperty("NormalImage","set:introschool image:ui_bg");
								button.SetProperty("PushedImage","set:introschool image:ui_bg");
								button.SetProperty("UnifiedMaxSize","{{1,0},{1,0}}");
								button.SetProperty("UnifiedAreaRect","{{0.886397,0},{0.0883174,0},{0.938122,0},{0.127377,0}}");
								button.parent=GUI.GUISheet.Get("root");
								
								button.jointPivot = [(uiPosition.split(','))[0],(uiPosition.split(','))[1],(uiPosition.split(','))[2]];
								button.jointMethod = 5;
							}else{
								console.info("解析xml时，动态创建三维UI失败！！！");
							}
						}while(count > 0)
						player.first_trigger_buttonevent = 1;
					}
				}
				player.mouse_click_star = 1;
				FUNCTION_DATA.get_windows("school_sand_serch/sand").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_sand_serch/role").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_sand_view/sand").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("school_sand/360").SetProperty("Visible","false");
				if(this.associatedWindow[0]=="360"){
					player.panorama_int = 1;
					FUNCTION_DATA.get_windows("school_sand_view/sand").SetProperty("Visible","false");
					FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","false");
					FUNCTION_DATA.get_windows("school_sand_360/export").SetProperty("Visible","True");
				}else{
					player.panorama_int = 0;
				}
			},
			school_sand_view : function(){
				FUNCTION_DATA.get_windows("school_sand_view/sand").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_sand_view/export").SetProperty("Visible","True");
				player.mouse_click_star = 0;
				// 保存角色沙盘模式之前的位置
				player.prePosition = iCamera.pcarray['pcmesh'].GetProperty("position");
				player.preRotation = iCamera.pcarray['pcmesh'].GetProperty("rotation");
				Event.Send({
					name : "player.effect.hoarse"
				});
				
			},
			school_sand_view_export : function(){
				var position = player.pcarray['pcmesh'].GetProperty("position");
				var rotation = player.pcarray['pcmesh'].GetProperty("rotation");
				var pitch = iCamera.pcarray['pcdefaultcamera'].GetProperty('pitch');
				var distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
				if(isNaN(position.x) || isNaN(position.y) || isNaN(position.z) || isNaN(rotation.y) || isNaN(pitch)){
					alert("导出错误，非数值类型");
				}else{
					xmlString ="<SAND_VIEW>\n"
					xmlString +="\t<position>["+position.x+","+position.y+","+position.z+"]</position>\n"
					xmlString +="\t<rotation>[0,"+(((rotation.y)/-1))+",0]</rotation>\n"
					xmlString +="\t<pitch>"+pitch+"</pitch>\n"
					xmlString +="\t<distance>"+distance+"</distance>\n"
					xmlString +="</SAND_VIEW>"
					var file_to_write = VFS.Open("/tools/ui/sand_view.xml",VFS.WRITE);
					VFS.WriteFile("/tools/ui/sand_view.xml",xmlString);
					xmlString = "";
					FUNCTION_DATA.get_windows("school_sand_view/export").SetProperty("Visible","False");
					FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","True");
					player.mouse_click_star = 1;
					Event.Send({
						name : "player.effect.hoarse.backing_out"
					});
					player.sand_view_pos = position;
					player.sand_view_rot = rotation;
					
					
					player.sand_view_pos_x = position.x;
					player.sand_view_pos_y = position.y;
					player.sand_view_pos_z = position.z;
					player.sand_view_rot_x = rotation.x;
					player.sand_view_rot_y = rotation.y;
					player.sand_view_rot_z = rotation.z;
					
					player.sand_view_pitch = pitch;
					player.sand_view_distance = distance;
				}
			},
			school_role : function(){
				player.mouse_click_star = 2;
				FUNCTION_DATA.get_windows("school_sand_serch/sand").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_sand_serch/role").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_sand/360").SetProperty("Visible","false");
				FUNCTION_DATA.get_windows("role/preview").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("role/notarize").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("role/change").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("button/zuoxuan").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("button/youxuan").SetProperty("Visible","True");
			},
			school_sand_serch_export : function(){
				if(player.mouse_click_star == 1){
					xmlString = "<application type=\"school\">\n"
					xmlString += "\t<sandTable>\n"
					var sand_string = player.list_position;
					if(sand_string == ""){
						alert("数组为空，请选择坐标！！！");
						return;
					}else{
						var list = sand_string.split('%'); 
						for(var i = 0;i<list.length;i++){
							var name = "\""+list[i].split(':')[0]+"\"";
							xmlString += "\t\t<label id="+name+">\n"
							xmlString += "\t\t\t<uiPosition>["+list[i].split(':')[1].split('/')[0]+"]</uiPosition>\n"
							xmlString += "\t\t\t<playerPosition>["+list[i].split(':')[1].split('/')[1].split('$')[0]+"]</playerPosition>\n"
							xmlString += "\t\t\t<playerRotation>["+list[i].split(':')[1].split('/')[1].split('$')[1]+"]</playerRotation>\n"
							xmlString += "\t\t</label>\n"
						}
						xmlString +="\t</sandTable>\n"
						xmlString +="</application>"
						var file_to_write = VFS.Open("/tools/ui/sand.xml",VFS.WRITE);
						VFS.WriteFile("/tools/ui/sand.xml",xmlString);
						xmlString = "";
						player.nonce_position = [];
						player.nonce_rotation = [];
						player.sand_state = true;
						player.mouse_view_way = false;
						star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
						player.mouse_click_star = 0;
						FUNCTION_DATA.get_windows("school_sand_serch/sand").SetProperty("Visible","True");
						FUNCTION_DATA.get_windows("school_sand_serch/role").SetProperty("Visible","True");
						FUNCTION_DATA.get_windows("school_sand_view/sand").SetProperty("Visible","False");
						FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","false");
						//隐藏360全景编辑入口
						// FUNCTION_DATA.get_windows("school_sand/360").SetProperty("Visible","True");
						player.list_position = [];
					}
				}
			},
			mini_map_add : function(){
				map_index1 = MINI_MAP.index;
				if(map_index1<5){
					map_index1 +=1;
					MINI_MAP.index = map_index1;
					FUNCTION_DATA.get_windows("mini_map/south").SetProperty("text_theme",map_index1);
					//player.pcarray['pcmesh'].position = [126.56758117675781,-1.1920928955078125e-7,-323.65545654296875];
					Event.Send({
						name : "pctimer.player.position"
					});
					FUNCTION_DATA.get_windows("mini_map/add").SetProperty("Visible","False");
					FUNCTION_DATA.get_windows("school_map/notarize_danyi").SetProperty("Visible","True");
				}
			},
			school_map_notarize_diyi : function(){
				var map_AreaRect2 = FUNCTION_DATA.get_windows("mini_map/image").GetProperty("UnifiedAreaRect").split("},{");
				if(player.map_edit==1){
					player.map_AreaRect2_x1_1 = parseFloat(map_AreaRect2[0].split(",")[0].split('{{')[1])+0.05;
					player.map_AreaRect2_y1_1 = parseFloat(map_AreaRect2[1].split(",")[0])+0.05;	
				}
				if(player.map_edit==2){
					player.map_AreaRect2_x1_2 = parseFloat(map_AreaRect2[0].split(",")[0].split('{{')[1])+0.05;
					player.map_AreaRect2_y1_2 = parseFloat(map_AreaRect2[1].split(",")[0])+0.05;	
				}
				if(player.map_edit==3){
					player.map_AreaRect2_x1_3 = parseFloat(map_AreaRect2[0].split(",")[0].split('{{')[1])+0.05;
					player.map_AreaRect2_y1_3 = parseFloat(map_AreaRect2[1].split(",")[0])+0.05;	
				}
				if(player.map_edit==4){
					player.map_AreaRect2_x1_4 = parseFloat(map_AreaRect2[0].split(",")[0].split('{{')[1])+0.05;
					player.map_AreaRect2_y1_4 = parseFloat(map_AreaRect2[1].split(",")[0])+0.05;	
				}
				if(player.map_edit==5){
					player.map_AreaRect2_x1_5 = parseFloat(map_AreaRect2[0].split(",")[0].split('{{')[1])+0.05;
					player.map_AreaRect2_y1_5 = parseFloat(map_AreaRect2[1].split(",")[0])+0.05;	
				}
				FUNCTION_DATA.get_windows("school_map/notarize_diyi").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_map/notarize_dier").SetProperty("Visible","True");
				player.map_p = 1;
			},
			school_map_notarize_dier : function(){
				var map_AreaRect3 = FUNCTION_DATA.get_windows("mini_map/s_s").GetProperty("UnifiedAreaRect").split("},{");
				if(player.map_edit==1){
					player.map_AreaRect2_x2_1 = parseFloat(map_AreaRect3[0].split(",")[0].split('{{')[1]);
					player.map_AreaRect2_y2_1 = parseFloat(map_AreaRect3[1].split(",")[0]);	
					//alert(player.map_AreaRect2_x2_1+"__dere___"+player.map_AreaRect2_y2_1);
					player.mouse_click_star = 3;
					player.map_enter_Is = false;
					player.mouse_view_way = false;
					FUNCTION_DATA.get_windows("role/background_map").SetProperty("Visible","True");
				}
				if(player.map_edit==2){
					player.map_AreaRect2_x2_2 = parseFloat(map_AreaRect3[0].split(",")[0].split('{{')[1]);
					player.map_AreaRect2_y2_2 = parseFloat(map_AreaRect3[1].split(",")[0]);	
					FUNCTION_DATA.get_windows("school_map/notarize_diyi").SetProperty("Visible","True");
				}
				if(player.map_edit==3){
					player.map_AreaRect2_x2_3 = parseFloat(map_AreaRect3[0].split(",")[0].split('{{')[1]);
					player.map_AreaRect2_y2_3 = parseFloat(map_AreaRect3[1].split(",")[0]);	
					FUNCTION_DATA.get_windows("school_map/notarize_diyi").SetProperty("Visible","True");
				}
				if(player.map_edit==4){
					player.map_AreaRect2_x2_4 = parseFloat(map_AreaRect3[0].split(",")[0].split('{{')[1]);
					player.map_AreaRect2_y2_4 = parseFloat(map_AreaRect3[1].split(",")[0]);	
					FUNCTION_DATA.get_windows("school_map/notarize_diyi").SetProperty("Visible","True");
				}
				if(player.map_edit==5){
					player.map_AreaRect2_x2_5 = parseFloat(map_AreaRect3[0].split(",")[0].split('{{')[1]);
					player.map_AreaRect2_y2_5 = parseFloat(map_AreaRect3[1].split(",")[0]);	
					FUNCTION_DATA.get_windows("school_map/notarize_danyi").SetProperty("Visible","True");
					var map_AreaRect4 = FUNCTION_DATA.get_windows("mini_map/image").GetProperty("UnifiedAreaRect").split("},{");
					player.map_AreaRect2_x1_5 = parseFloat(map_AreaRect4[0].split(",")[0].split('{{')[1])+0.05;
					player.map_AreaRect2_y1_5 = parseFloat(map_AreaRect4[1].split(",")[0])+0.05;	
				}
				player.map_edit +=1;
				FUNCTION_DATA.get_windows("school_map/notarize_dier").SetProperty("Visible","False");
				player.map_p = 0;
				if(player.map_edit!=1){
					map_index1 = MINI_MAP.index;
					if(map_index1<5){
						map_index1 +=1;
						MINI_MAP.index = map_index1;
						FUNCTION_DATA.get_windows("mini_map/south").SetProperty("text_theme",map_index1);
						//player.pcarray['pcmesh'].position = [126.56758117675781,-1.1920928955078125e-7,-323.65545654296875];
						Event.Send({
							name : "pctimer.player.position"
						});
					}
				}
			},
			
			role_notarize_map : function(){
				player.map_role_pos = player.nonce_position;
				FUNCTION_DATA.get_windows("role/background_map").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("school_map/notarize_diyi").SetProperty("Visible","True");
				player.map_enter_Is = true;
				player.mouse_view_way = false;
				player.mouse_click_star = 0;
				player.nonce_position = [];
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				MINI_MAP.index = 2;
				FUNCTION_DATA.get_windows("mini_map/south").SetProperty("text_theme",2);
				//player.pcarray['pcmesh'].position = [126.56758117675781,-1.1920928955078125e-7,-323.65545654296875];
				
				Event.Send({
					name : "pctimer.player.position"
				});
				
			},
			
			role_annul_map : function(){
				player.nonce_position = [];
				star.pcarray['pcmesh'].PerformAction('SetVisible',['visible', false]);
				player.map_enter_Is = false;
				player.mouse_view_way = false;
			},
			
			school_map_notarize_danyi : function(){
			
				var pos_roes_space_x = parseFloat(player.map_pos_roes[0])-parseFloat(player.map_role_pos[0]);
				var pos_roes_space_y = parseFloat(player.map_pos_roes[2])-parseFloat(player.map_role_pos[2]);
				var map_pos_1_x = -(pos_roes_space_x/(0.593108-player.map_AreaRect2_x2_1));
				var map_pos_1_y = -(pos_roes_space_y/(0.535722-player.map_AreaRect2_y2_1));
				var map_pos_2_x = -(pos_roes_space_x/(0.593108-player.map_AreaRect2_x2_2));
				var map_pos_2_y = -(pos_roes_space_y/(0.535722-player.map_AreaRect2_y2_2));
				var map_pos_3_x = -(pos_roes_space_x/(0.593108-player.map_AreaRect2_x2_3));
				var map_pos_3_y = -(pos_roes_space_y/(0.535722-player.map_AreaRect2_y2_3));
				var map_pos_4_x = -(pos_roes_space_x/(0.593108-player.map_AreaRect2_x2_4));
				var map_pos_4_y = -(pos_roes_space_y/(0.535722-player.map_AreaRect2_y2_4));
				var map_pos_5_x = -(pos_roes_space_x/(0.593108-player.map_AreaRect2_x2_5));
				var map_pos_5_y = -(pos_roes_space_y/(0.535722-player.map_AreaRect2_y2_5));
				FUNCTION_DATA.get_windows("school_map/notarize_danyi").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("mini_map/add").SetProperty("Visible","True");
				var pos_x_map = map_pos_1_x+"%"+map_pos_2_x+"%"+map_pos_3_x+"%"+map_pos_4_x+"%"+map_pos_5_x;
				var pos_y_map = map_pos_1_y+"%"+map_pos_2_y+"%"+map_pos_3_y+"%"+map_pos_4_y+"%"+map_pos_5_y;
				var ui_x = player.map_AreaRect2_x1_1+"%"+player.map_AreaRect2_x1_2+"%"+player.map_AreaRect2_x1_3+"%"+player.map_AreaRect2_x1_4+"%"+player.map_AreaRect2_x1_5;
				var ui_y = player.map_AreaRect2_y1_1+"%"+player.map_AreaRect2_y1_2+"%"+player.map_AreaRect2_y1_3+"%"+player.map_AreaRect2_y1_4+"%"+player.map_AreaRect2_y1_5;
				xmlString = "<MINI_MAP>\n"
				xmlString += "\t<index>1</index>\n"
				xmlString += "\t<data>\n"
				for(var i = 1;i<6;i++){
					xmlString += "\t\t<n__n"+i+">\n";
					xmlString += "\t\t\t<areaSize>"+MINI_MAP.data[i].areaSize+"</areaSize>\n";
					xmlString += "\t\t\t<xrationx>"+pos_x_map.split('%')[i-1]+"</xrationx>\n";
					xmlString += "\t\t\t<zrationy>"+pos_y_map.split('%')[i-1]+"</zrationy>\n";
					xmlString += "\t\t\t<ui_x>"+ui_x.split('%')[i-1]+"</ui_x>\n";
					xmlString += "\t\t\t<ui_y>"+ui_y.split('%')[i-1]+"</ui_y>\n";
					xmlString += "\t\t\t<pos_x>"+player.map_pos_roes[0]+"</pos_x>\n";
					xmlString += "\t\t\t<pos_z>"+player.map_pos_roes[2]+"</pos_z>\n";
					xmlString += "\t\t\t<width>"+MINI_MAP.data[i].width+"</width>\n";
					xmlString += "\t\t\t<height>"+MINI_MAP.data[i].height+"</height>\n";
					xmlString += "\t\t</n__n"+i+">\n";
				}
				xmlString +="\t</data>\n";
				xmlString +="</MINI_MAP>";
				var file_to_write = VFS.Open("/tools/ui/map.xml",VFS.WRITE);
				VFS.WriteFile("/tools/ui/map.xml",xmlString);
				xmlString = "";
				map_index1 = 1;
				FUNCTION_DATA.get_windows("mini_map/south").SetProperty("text_theme","1");
				player.map_enter_Is = false;
				FUNCTION_DATA.get_windows("school_map/btn").SetProperty("Visible","true");
				FUNCTION_DATA.get_windows("school_sand_serch/sand").SetProperty("Visible","true");
				FUNCTION_DATA.get_windows("school_sand_serch/role").SetProperty("Visible","true");
				FUNCTION_DATA.get_windows("school_sand_serch/export").SetProperty("Visible","true");
				FUNCTION_DATA.get_windows("school_sand/360").SetProperty("Visible","True");
				FUNCTION_DATA.get_windows("zhucaidan/mini_map").SetProperty("Visible","false");
				FUNCTION_DATA.get_windows("school_map/notarize_danyi").SetProperty("Visible","false");
			},
			mini_map_sub : function(){
				var map_index2 = MINI_MAP.index;
				if(map_index2>1){
					map_index2 -=1;
					MINI_MAP.index = map_index2;
					FUNCTION_DATA.get_windows("mini_map/south").SetProperty("text_theme",map_index2);
					//player.pcarray['pcmesh'].position = [126.56758117675781,-1.1920928955078125e-7,-323.65545654296875];
					Event.Send({
						name : "pctimer.player.position"
					});	
				}
			},
			view_schoolSand_ui : function(){
				//点击查看，先判断是否输入了值，如果输入了值可以查看，首先进入沙盘视角，动态的创建一个ui图标window
				var sand_text_value = FUNCTION_DATA.get_windows("sand/Editbox").GetProperty("Text");
				
				if(sand_text_value!='' && !player.isSand){
					var button = FUNCTION_DATA.get_windows("sand/table/static_button");
					button.SetProperty("Visible","True");
					button.jointPivot = [player.nonce_position[0],0,player.nonce_position[2]];
					button.jointMethod = 5;
					// alert(player.nonce_position);
					// alert(player.nonce_position[0]);
					// 保存角色沙盘模式之前的位置
			        player.prePosition = iCamera.pcarray['pcmesh'].GetProperty("position");
			        player.preRotation = iCamera.pcarray['pcmesh'].GetProperty("rotation");
					Event.Send({
						name : "player.effect.hoarse"
					});
					player.isSand = true;
					// player.currentIcon = button.name;
				}
			},
			playre_rotateLeft : function(){
				if(player.ui_control_rotate){
					if(player.sex == "nv"){
						var self = woman;
					}else{
						var self = man;
					}
					Event.Send({
						name : "player.rotateleft.ui.control",
						self : self
					});
				}
			},
			playre_rotateLeft_stop : function(){
				if(player.ui_control_rotate){
					if(player.sex == "nv"){
						var self = woman;
					}else{
						var self = man;
					}
					Event.Send({
						name : "player.rotateleft.stop.ui.control",
						self : self
					});
				}
			},
			playre_rotateRight : function(){
				if(player.ui_control_rotate){
					if(player.sex == "nv"){
						var self = woman;
					}else{
						var self = man;
					}
					Event.Send({
						name : "player.rotateright.ui.control",
						self : self
					});
				}
			},
			playre_rotateRight_stop : function(){
				if(player.ui_control_rotate){
					if(player.sex == "nv"){
						var self = woman;
					}else{
						var self = man;
					}
					Event.Send({
						name : "player.rotateright.stop.ui.control",
						self : self
					});
				}
			}
		},
		window : {
			"school_sand/window/close" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_window_close"
				},
				subscribe : {}
			},
			"school_sand_serch/annul" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_window_close"
				},
				subscribe : {}
			},
			"school_sand/notarize" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_notarize",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {
					"ui.send.position" : function(){
						if(player.mouse_click_star == 1){
							if(player.sand_state==true){
								FUNCTION_DATA.get_windows("sand/background").SetProperty("Visible","True");
								FUNCTION_DATA.get_windows("sand/background2").SetProperty("Visible","False");
								if(player.panorama_int == 1){
									FUNCTION_DATA.get_windows("sand/background/text_t").SetProperty("Text","该点的ui名称");
								}else{
									FUNCTION_DATA.get_windows("sand/background/text_t").SetProperty("Text","步骤1--ui位置");
								}
							}else{
								FUNCTION_DATA.get_windows("sand/background2").SetProperty("Visible","True");
								FUNCTION_DATA.get_windows("sand/background").SetProperty("Visible","False");
							}
						}
						if(player.mouse_click_star == 2){
							if(player.sand_state==true){
								FUNCTION_DATA.get_windows("role/background").SetProperty("Visible","True");
								FUNCTION_DATA.get_windows("role/background2").SetProperty("Visible","False");
							}else{
								FUNCTION_DATA.get_windows("role/background2").SetProperty("Visible","True");
								FUNCTION_DATA.get_windows("role/background").SetProperty("Visible","False");
							}
						}
					}
				}
			},
			"school_sand_serch/annul2" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_serch_annul2"
				},
				subscribe : {}
			},
			"school_sand/notarize2" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_notarize2"
				},
				subscribe : {}
			},
			"school_sand/yulan" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_yulan"
				},
				subscribe : {}
			},
			"school_sand_serch/sand" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_sand_view/sand" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_view",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_sand/360" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=["360"];
					}
				},
				event : {
					"Clicked":"school_sand",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_sand_view/export" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_view_export",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_sand_serch/role" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_role",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/preview" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_preview",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/change" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_change",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/notarize" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_notarize",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/annul" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_annul",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/yulan" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_yulan",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/change2" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_change2",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/notarize2" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_notarize2",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/annul2" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_annul2",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_sand_serch/export" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_sand_serch_export",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			//实时地图
			"school_map/btn" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"map_click",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"mini_map/image":{
				property :{
					areaSize : function (obj,propt_name){
						obj.SetProperty("UnifiedMaxSize",MINI_MAP.data[MINI_MAP.index].areaSize);
						obj.SetProperty("UnifiedMinSize",MINI_MAP.data[MINI_MAP.index].areaSize);
						obj[propt_name] = function (area){
							obj.SetProperty("UnifiedAreaRect",area);
						}
					}
				},
				event : {},
				subscribe : {
					"pctimer.player.position" : function (e){
						if(this.GetProperty("UnifiedMaxSize")!=MINI_MAP.data[MINI_MAP.index].areaSize)
						{
							this.SetProperty("UnifiedMaxSize",MINI_MAP.data[MINI_MAP.index].areaSize);
							this.SetProperty("UnifiedMinSize",MINI_MAP.data[MINI_MAP.index].areaSize);
						}
						if(MINI_MAP.index==1){
							var ui_x = -1;
							var ui_y = -1;
						}
						if(MINI_MAP.index==2){
							var ui_x = -2;
							var ui_y = -1.8;
						}
						if(MINI_MAP.index==3){
							var ui_x = -2.5;
							var ui_y = -2.2;
						}
						if(MINI_MAP.index==4){
							var ui_x = -2.9;
							var ui_y = -2.3;
						}
						if(MINI_MAP.index==5){
							var ui_x = -3.5;
							var ui_y = -3;
						}
						var start_x = ui_x;
						var start_y = ui_y;
						var end_x = start_x + MINI_MAP.data[MINI_MAP.index].width;
						var end_y = start_y + MINI_MAP.data[MINI_MAP.index].height;
						var area = "{{" + start_x + ",0},{" + start_y + ",0},{" + end_x +",0},{" + end_y + ",0}}";
						this.areaSize(area);
					},
					"map.go.run.change" :function(){
						// var xrationx = MINI_MAP.data[MINI_MAP.index].xrationx;
						// var zrationy = MINI_MAP.data[MINI_MAP.index].zrationy;
						// var player_z = MINI_MAP.data[MINI_MAP.index].pos_z;
						// var player_x = MINI_MAP.data[MINI_MAP.index].pos_x;
						// var ui_x = MINI_MAP.data[MINI_MAP.index].ui_x;
						// var ui_y = MINI_MAP.data[MINI_MAP.index].ui_y;
						// var start_x = (player.mousex - player_x)/xrationx + ui_x;
						// var start_y = (player.mousey - player_z)/zrationy + ui_y;
						// var end_x = start_x + MINI_MAP.data[MINI_MAP.index].width;
						// var end_y = start_y + MINI_MAP.data[MINI_MAP.index].height;
						if(player.map_p==0){
							var map_AreaRect = FUNCTION_DATA.get_windows("mini_map/image").GetProperty("UnifiedAreaRect").split("},{");
							var map_AreaRect_x1 = parseFloat(map_AreaRect[0].split(",")[0].split('{{')[1]);
							var map_AreaRect_y1 = parseFloat(map_AreaRect[1].split(",")[0]);
							var map_AreaRect_x2 = parseFloat(map_AreaRect[2].split(",")[0]);
							var map_AreaRect_y2 = parseFloat(map_AreaRect[3].split(",")[0]);
							if(player.startX>player.mousex){
								map_AreaRect_x1 -=0.01;
								map_AreaRect_x2 -=0.01;
							}else if(player.startX<player.mousex){
								map_AreaRect_x1 +=0.01;	
								map_AreaRect_x2 +=0.01;
							}
							if(player.startY>player.mousey){
								map_AreaRect_y1 -=0.01;
								map_AreaRect_y2 -=0.01;
							}else if(player.startY<player.mousey){
								map_AreaRect_y1 +=0.01;
								map_AreaRect_y2 +=0.01;
							}
							var area = "{{" + map_AreaRect_x1 + ",0},{" + map_AreaRect_y1 + ",0},{" + map_AreaRect_x2 +",0},{" + map_AreaRect_y2 + ",0}}";
							this.areaSize(area);	
						}
					}
				}
			},
			"mini_map/s_s" : {
				property :{
					areaSize : function (obj,propt_name){
						obj[propt_name] = function (area){
							obj.SetProperty("UnifiedAreaRect",area);
						}
					}
				},
				event : {},
				subscribe : {
					"map_s.go.run.change" :function(){
						if(player.map_p==1){
							var map_AreaRect_s = FUNCTION_DATA.get_windows("mini_map/s_s").GetProperty("UnifiedAreaRect").split("},{");
							var map_AreaRect_x1_s = parseFloat(map_AreaRect_s[0].split(",")[0].split('{{')[1]);
							var map_AreaRect_y1_s = parseFloat(map_AreaRect_s[1].split(",")[0]);
							var map_AreaRect_x2_s = parseFloat(map_AreaRect_s[2].split(",")[0]);
							var map_AreaRect_y2_s = parseFloat(map_AreaRect_s[3].split(",")[0]);
							if(player.startX>player.mousex){
								map_AreaRect_x1_s -=0.01;
								map_AreaRect_x2_s -=0.01;
							}else if(player.startX<player.mousex){
								map_AreaRect_x1_s +=0.01;	
								map_AreaRect_x2_s +=0.01;
							}
							if(player.startY>player.mousey){
								map_AreaRect_y1_s -=0.01;
								map_AreaRect_y2_s -=0.01;
							}else if(player.startY<player.mousey){
								map_AreaRect_y1_s +=0.01;
								map_AreaRect_y2_s +=0.01;
							}
							var area = "{{" + map_AreaRect_x1_s + ",0},{" + map_AreaRect_y1_s + ",0},{" + map_AreaRect_x2_s +",0},{" + map_AreaRect_y2_s + ",0}}";
							this.areaSize(area);	
						}
					}
				}
			},
			"mini_map/add" : {
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"mini_map_add",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"mini_map/sub" : {
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"mini_map_sub",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_map/notarize_danyi" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_map_notarize_danyi",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_map/notarize_diyi" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_map_notarize_diyi",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_map/notarize_dier" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"school_map_notarize_dier",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/notarize_map" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_notarize_map",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_sand_360/export" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"panorama_export",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"role/annul_map" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"role_annul_map",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"school_sand/see" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"Clicked":"view_schoolSand_ui",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"button/zuoxuan" :{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"MouseButtonDown":"playre_rotateLeft",
					"MouseButtonUp":"playre_rotateLeft_stop",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"button/youxuan":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=[];
					}
				},
				event : {
					"MouseButtonDown":"playre_rotateRight",
					"MouseButtonUp":"playre_rotateRight_stop",
					"MouseEnter":"but_enter",
					"MouseLeave":"but_leave"
				},
				subscribe : {}
			},
			"sand/table/static_button":{
				property:{
					init : function (obj,propt_name){
						obj.jointPivot = [0,0,0];
						obj.jointMethod = 5;
						obj.jointVisibleCtrl = false;
						obj.SetProperty("Visible","False");
					}
				},
				event : {},
				subscribe : {}
			}
		}
	}
} catch( e )
{
	alert( e );
}