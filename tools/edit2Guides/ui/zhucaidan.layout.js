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
			//打开初始点导出窗口
			open_guides_init_window : function(){
				// alert(111);
				//隐藏主菜单ui按钮
				var hide_window = FUNCTION_DATA.get_windows(this.hideWindows[0]);
				if(hide_window.GetProperty("Visible")=="True"){
					FUNCTION_DATA.set_hide(this.hideWindows);
				}
				//显示初始点ui窗口
				FUNCTION_DATA.set_show(this.showWindows);
			},
			//打开路线导游导出窗口
			open_guides_road_window : function(){
				//隐藏主菜单ui按钮
				var hide_window = FUNCTION_DATA.get_windows(this.hideWindows[0]);
				if(hide_window.GetProperty("Visible")=="True"){
					FUNCTION_DATA.set_hide(this.hideWindows);
				}
				//显示路线导游ui窗口
				FUNCTION_DATA.set_show(this.showWindows);
			},
			//打开区域导游导出窗口
			open_guides_regional_window : function(){
				//隐藏主菜单ui按钮
				var hide_window = FUNCTION_DATA.get_windows(this.hideWindows[0]);
				if(hide_window.GetProperty("Visible")=="True"){
					FUNCTION_DATA.set_hide(this.hideWindows);
				}
				//显示区域导游ui窗口
				FUNCTION_DATA.set_show(this.showWindows);
			},
			//不同导游路线的信息，并生成xml文件
			road_guides_message_export : function(){
				xmlString = "" ; 
				var route_name = player.guides_choice ; 
				switch(route_name) {
					case  	"lishiwenhua" :
						xmlString = "<LiShiWenHua_DATA>\n"
					    break ;
					case 	"xinshengruxue" :
						xmlString = "<XinShengRuXue_DATA>\n"
						break ;
					case	"special_attractions" :
						xmlString = "<TeShuJingDian_DATA>\n"
						break ;
					default :
						break ; 
				}
				if(player.guides_choice == "lishiwenhua"){//历史文化--路线1
					player.list_position_data = player.one_list_position_data ;
				}
				if(player.guides_choice == "xinshengruxue"){//新生入学--路线2
					player.list_position_data = player.two_list_position_data ;
				}
				if(player.guides_choice == "special_attractions"){//特殊景点--路线3
					player.list_position_data = player.special_list_position_data ;
				}
				var position_data_string = player.list_position_data;
				var pos_list = position_data_string.split('%'); 
				if(pos_list.length <= 1){
					return ; 
				}
				for(var i = 0;i < pos_list.length - 1;i++){
					xmlString += "\t<n__n" + i + ">\n";
					//文字信息
					xmlString += "\t\t<text>\n";
					xmlString += "\t\t\t<chinese>" + "我是导游...." + "</chinese>\n";
					xmlString += "\t\t\t<english>" + "Hello , I am a Guide ....... " + "</english>\n";
					xmlString += "\t\t</text>\n" ;
					//播放录音--引用导游点名称作为录音名称
					xmlString += "\t\t<SoundUrl>" + pos_list[i].split('|')[0] + ".ogg" + "</SoundUrl>\n";
					//名称 中文和英文
					xmlString += "\t\t<name>\n";
					xmlString += "\t\t\t<chinese>" + pos_list[i].split('|')[0] + "</chinese>\n";
					xmlString += "\t\t\t<english>" + pos_list[i].split('|')[1] + "</english>\n";
					xmlString += "\t\t</name>\n";
					//位置坐标
					xmlString += "\t\t<position>\n";
					xmlString += "\t\t\t<x>" + pos_list[i].split('|')[2] + "</x>\n";
					xmlString += "\t\t\t<y>" + pos_list[i].split('|')[3] + "</y>\n";
					xmlString += "\t\t\t<z>" + pos_list[i].split('|')[4] + "</z>\n";
					xmlString += "\t\t</position>\n"; 
					xmlString += "\t\t<rotationy>" + +pos_list[i].split('|')[5] + "</rotationy>\n";
					xmlString += "\t</n__n" + i + ">\n";
				}
				switch(route_name) {
					case	"lishiwenhua" : 
						xmlString += "</LiShiWenHua_DATA>"
						break ;
					case	"xinshengruxue" :
						xmlString += "</XinShengRuXue_DATA>"
						break ;
					case	"special_attractions" :
						xmlString += "</TeShuJingDian_DATA>"
						break ;
					default :
						break ; 
				}
				//生成xml文件
				var file_to_write = VFS.Open("/tools/ui/" + player.filename + ".xml",VFS.WRITE);
				VFS.WriteFile("/tools/ui/" + player.filename + ".xml",xmlString);
				xmlString = "";
				alert("保存成功!");
				//获取编辑框
				var chinese_name_text = GUI.Editbox.Get("guides_point/chinese_name");
				var english_name_text = GUI.Editbox.Get("guides_point/english_name");
				//清空编辑框内容
				chinese_name_text.SetProperty("Text","");
				english_name_text.SetProperty("Text","");
				//隐藏当前窗口
				FUNCTION_DATA.set_hide(this.hideWindows);
				//显示主菜单按钮
				var show_window = FUNCTION_DATA.get_windows(this.showWindows[0]);
				if(show_window.GetProperty("Visible") == "False"){
					FUNCTION_DATA.set_show(this.showWindows);
				}
			},
			//点击路线取消（guides/road/cancel）时，关闭编辑框
			no_save_information : function(){
				//关闭编辑框
				var win_name = FUNCTION_DATA.get_windows("guides_point/name");
				win_name.SetProperty("Visible","False");
				//失去编辑框输入焦点
				player.is_mouse_Activated = false;
			},
			//导游路线1
			road_one : function(){
				player.guides_choice = "lishiwenhua" ;
				//生成的xml文件名
				player.filename = "json_lishiwenhua";
				//获取编辑框输入焦点
				player.is_mouse_Activated = true;
				//设置路线按钮被选中
				player.road_Selected = true;
				//打开编辑框
				var win_name = FUNCTION_DATA.get_windows("guides_point/name");
				win_name.SetProperty("Visible","True");
			},
			//导游路线2
			road_two : function(){
				player.guides_choice = "xinshengruxue" ;
				//生成的xml文件名
				player.filename = "json_xinshengruxue";
				//获取编辑框输入焦点
				player.is_mouse_Activated = true;
				//设置路线按钮被选中
				player.road_Selected = true;
				//打开编辑框
				var win_name = FUNCTION_DATA.get_windows("guides_point/name");
				win_name.SetProperty("Visible","True");
			},
			//定点导游
			special_guides : function(){
				player.guides_choice = "special_attractions" ;
				//生成的xml文件名
				player.filename = "json_specialAttractions";
				//获取编辑框输入焦点
				player.is_mouse_Activated = true;
				//设置路线按钮被选中
				player.road_Selected = true;
				//打开编辑框
				var win_name = FUNCTION_DATA.get_windows("guides_point/name");
				win_name.SetProperty("Visible","True");
			},
			//获取并保存导游初始位置信息
			get_guides_init_position : function(){
				var init_pos = player.init_position_data;
				//获取导游初始位置的position和rotation坐标
				var pos = player.pcarray['pcmesh'].GetProperty('position');
				var rot = player.pcarray['pcmesh'].GetProperty('rotation');
				init_pos = pos.x+"|"+pos.y+"|"+pos.z+"|"+rot.x+"|"+rot.y+"|"+rot.z+"%";
				player.init_position_data = init_pos;
			},
			//确定导游初始位置,并生成xml文件
			guides_init_position_export : function(){
				xmlString = "<GUIDES_DATA>\n";
				var init_data_string = player.init_position_data;
				var init_list = init_data_string.split('%'); 
				if(init_list.length <= 1){
					return ; 
				}
				for(var i = 0;i < init_list.length - 1;i++){
					//位置坐标 position
					xmlString += "\t<initPosition>\n" ; 
					xmlString += "\t\t<x>" + init_list[i].split('|')[0] + "</x>\n";
					xmlString += "\t\t<y>" + init_list[i].split('|')[1] + "</y>\n";
					xmlString += "\t\t<z>" + init_list[i].split('|')[2] + "</z>\n";
					xmlString += "\t</initPosition>\n" ; 
					//位置坐标 rotation
					xmlString += "\t<initRotation>\n" ; 
					xmlString += "\t\t<x>" + init_list[i].split('|')[3] + "</x>\n";
					xmlString += "\t\t<y>" + init_list[i].split('|')[4] + "</y>\n";
					xmlString += "\t\t<z>" + init_list[i].split('|')[5] + "</z>\n";
					xmlString += "\t</initRotation>\n" ; 
				}
				xmlString += "</GUIDES_DATA>\n" ;
				//生成xml文件
				var file_to_write = VFS.Open("/tools/ui/json_guides_init.xml",VFS.WRITE);
				VFS.WriteFile("/tools/ui/json_guides_init.xml",xmlString);
				xmlString = "";
				alert("保存成功!");
				//隐藏当前窗口
				FUNCTION_DATA.set_hide(this.hideWindows);
				//显示主菜单ui按钮
				var show_window = FUNCTION_DATA.get_windows(this.showWindows[0]);
				if(show_window.GetProperty("Visible") == "False"){
					FUNCTION_DATA.set_show(this.showWindows);
				}
				//清空导游点初始位置信息数组
				player.init_position_data = "";
			},
			//记录导游路线的位置信息--将导游点的信息记录到数组中
			guides_route_position_export : function(){
				if(player.road_Selected){
					//获取输入值--中英文名称
					var chinese_name_text = GUI.Editbox.Get("guides_point/chinese_name");
					// var english_name_text = GUI.Editbox.Get("guides_point/english_name");
					var chinese_name_value = chinese_name_text.GetProperty("Text");
					// var english_name_value = english_name_text.GetProperty("Text");
					var english_name_value = "test";
					if(chinese_name_value == ""){
						alert("未输入建筑名称，请检查！！！");
					}else{
						player.chinese_name = chinese_name_value ; 
						player.english_name = english_name_value ;
						//当中英文名称都不为空时发送消息
						// if((player.chinese_name != "" && player.english_name != "")){
							Event.Send({
								name : "player.effect.get_message",
								id : player.guides_choice
							});
						// }
					}
				}
				//关闭编辑框
				var win_name = FUNCTION_DATA.get_windows("guides_point/name");
				win_name.SetProperty("Visible","False");
				//失去编辑框输入焦点
				player.is_mouse_Activated = false;
				//点击一次确定后，设置路线按钮为不被选中状态
				player.road_Selected = false;
			},
			//输入建筑名称，并输入一个点后点击确定按钮
			regional_guides_point_ok : function(){
				var name_win = GUI.Editbox.Get("regional_guides/name/Editbox");
				var chinese_name = name_win.GetProperty("Text");
				var english_name = "test";
				var id_win = GUI.Editbox.Get("regional_guides/point/Editbox");
				var point_id = id_win.GetProperty("Text");
				if(point_id == "" || chinese_name == ""){
					if(chinese_name == ""){
						alert("未输入建筑名称，请检查！！！");
					}else{
						alert("未输入代表前门/后门的数字，请检查！！！");
					}
				}else{
					Event.Send({
						name : "player.effect.regional_guides.fist_point",
						chinese_name : chinese_name,
						english_name : english_name,
						point_id : point_id
					});
					FUNCTION_DATA.get_windows(this.showWindows).SetProperty("Visible","True");
					FUNCTION_DATA.get_windows(this.hideWindows).SetProperty("Visible","False");
				}
			},
			//取消
			regional_guides_point_cancle : function(){
				//隐藏当前窗口
				FUNCTION_DATA.set_hide(this.hideWindows);
				//显示主菜单按钮
				var show_window = FUNCTION_DATA.get_windows(this.showWindows[0]);
				if(show_window.GetProperty("Visible") == "False"){
					FUNCTION_DATA.set_show(this.showWindows);
				}
				//清空编辑框中的信息
				FUNCTION_DATA.get_windows("regional_guides/name/Editbox").SetProperty("Text","");
				FUNCTION_DATA.get_windows("regional_guides/point/Editbox").SetProperty("Text","");
				FUNCTION_DATA.get_windows("regional_guides/other_point/Editbox").SetProperty("Text","");
			},
			//输入另一个点
			regional_guides_other_point_ok : function(){
				var id_win = GUI.Editbox.Get("regional_guides/other_point/Editbox");
				var point_id = id_win.GetProperty("Text");
				if(point_id == ""){
					alert("未输入代表前门/后门的数字，请检查！！！");
				}else{
					if(player.first_id == point_id){
						alert("输入的数字和前一个点相同，请修改！\n\ps：前一个点ID为 " + player.first_id);
					}else{
						Event.Send({
							name : "player.effect.regional_guides.other_point",
							point_id : point_id
						});
						FUNCTION_DATA.get_windows(this.showWindows).SetProperty("Visible","True");
						FUNCTION_DATA.get_windows(this.hideWindows).SetProperty("Visible","False");
					}
				}
			},
			//导出
			regional_guides_point_export : function(){
				xmlString = "<REGIONAL_GUIDES_DATA>\n"
				var position_data_string = player.list_regional_point_position_data;
				var pos_list = position_data_string.split('%'); 
				if(pos_list.length <= 1){
					return ; 
				}
				for(var i = 0;i < pos_list.length - 1;i++){
					xmlString += "\t<n__n" + i + ">\n";
					xmlString += "\t\t<name>\n" ;  
					xmlString += "\t\t\t<chinese_name>" + pos_list[i].split('|')[1] + "</chinese_name>\n";
					xmlString += "\t\t\t<english_name>"+ pos_list[i].split('|')[2] + "</english_name>\n";
					xmlString += "\t\t</name>\n" ; 
					xmlString += "\t\t<id_" + pos_list[i].split('|')[3] + ">\n" ; 
					xmlString += "\t\t\t<point_position_x>" + pos_list[i].split('|')[4] + "</point_position_x>\n";
					xmlString += "\t\t\t<point_position_y>" + pos_list[i].split('|')[5] + "</point_position_y>\n";
					xmlString += "\t\t\t<point_position_z>" + pos_list[i].split('|')[6] + "</point_position_z>\n";
					xmlString += "\t\t\t<point_rotation_y>" + pos_list[i].split('|')[7] + "</point_rotation_y>\n";
					xmlString += "\t\t</id_" +pos_list[i].split('|')[3]+">\n" ; 
					xmlString += "\t\t<id_" +pos_list[i].split('|')[8]+">\n" ; 
					xmlString += "\t\t\t<point_position_x>" + pos_list[i].split('|')[9] + "</point_position_x>\n";
					xmlString += "\t\t\t<point_position_y>" + pos_list[i].split('|')[10] + "</point_position_y>\n";
					xmlString += "\t\t\t<point_position_z>" + pos_list[i].split('|')[11] + "</point_position_z>\n";
					xmlString += "\t\t\t<point_rotation_y>" + pos_list[i].split('|')[12] + "</point_rotation_y>\n";
					xmlString += "\t\t</id_" + pos_list[i].split('|')[8] + ">\n" ; 
					xmlString += "\t</n__n" + i + ">\n";
				}
				xmlString +="</REGIONAL_GUIDES_DATA>";
				var file_to_write = VFS.Open("/tools/ui/json_regional_guides.xml",VFS.WRITE);
				VFS.WriteFile("/tools/ui/json_regional_guides.xml",xmlString);
				xmlString = "";
				alert("保存成功!");
				//隐藏当前窗口
				FUNCTION_DATA.set_hide(this.hideWindows);
				//显示主菜单按钮
				var show_window = FUNCTION_DATA.get_windows(this.showWindows[0]);
				if(show_window.GetProperty("Visible") == "False"){
					FUNCTION_DATA.set_show(this.showWindows);
				}
				//清空编辑框中的信息
				FUNCTION_DATA.get_windows("regional_guides/name/Editbox").SetProperty("Text","");
				FUNCTION_DATA.get_windows("regional_guides/point/Editbox").SetProperty("Text","");
				FUNCTION_DATA.get_windows("regional_guides/other_point/Editbox").SetProperty("Text","");
			}
		},
		window : {
			//初始点---按钮
			"guidies/init/button" : {
				property:{
					showWindows : function(obj,propt_name){
						obj[propt_name] = ["guides/init/window"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name] = ["guidies/init/button","guides/road/button","guides/regional/button"];
					}
				},
				event : {
					"MouseClick":"open_guides_init_window"
				},
				subscribe : {}
			},
			//路线导游 --- 按钮
			"guides/road/button" : {
				property:{
					showWindows : function(obj,propt_name){
						obj[propt_name] = ["guides/road/window"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name] = ["guidies/init/button","guides/road/button","guides/regional/button"];
					}
				},
				event : {
					"MouseClick":"open_guides_road_window"
				},
				subscribe : {}
			},
			//区域导游 --- 按钮
			"guides/regional/button" : {
				property:{
					showWindows : function(obj,propt_name){
						obj[propt_name] = ["guides/regional_guides/window"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name] = ["guidies/init/button","guides/road/button","guides/regional/button"];
					}
				},
				event : {
					"MouseClick":"open_guides_regional_window"
				},
				subscribe : {}
			},
			//获取并保存导游初始位置信息
			"guides/init/getPosition" :{
				property:{},
				event : {
					"MouseClick":"get_guides_init_position"
				},
				subscribe : {}
			},
			//导出导游初始位置的xml文件
			"guides/init/save" :{
				property:{
					showWindows : function(obj,propt_name){
						obj[propt_name] = ["guidies/init/button","guides/road/button","guides/regional/button"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name] = ["guides/init/window"];
					}
				},
				event : {
					"MouseClick":"guides_init_position_export"
				},
				subscribe : {}
			},
			//导游路线1
			"guides/road_one/btn" :{
				property:{},
				event : {
					"MouseClick":"road_one"
				},
				subscribe : {}
			},
			//导游路线2
			"guides/road_two/btn" :{
				property:{},
				event : {
					"MouseClick":"road_two"
				},
				subscribe : {}
			},
			//定点导游
			"guides/special_guides" :{
				property:{},
				event : {
					"MouseClick": "special_guides"
				},
				subscribe : {}
			},
			//导游路线上导游点确认
			"guides/road/ok" :{
				property:{},
				event : {
					"MouseClick":"guides_route_position_export"
				},
				subscribe : {}
			},
			//导游路线--取消按钮
			"guides/road/cancel" :{
				property:{},
				event : {
					"MouseClick":"no_save_information"
				},
				subscribe : {}
			},
			//导游路线--保存按钮
			"guides/road/save" :{
				property:{
					showWindows : function(obj,propt_name){
						obj[propt_name] = ["guidies/init/button","guides/road/button","guides/regional/button"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name] = ["guides/road/window"];
					}
				},
				event : {
					"MouseClick":"road_guides_message_export"
				},
				subscribe : {}
			},
			/*	区域导游功能	*/
			//确定 - 1
			"regional_guides/point/ok" : {
				property:{
					showWindows : function (obj,propt_name){
						obj[propt_name]=["regional_guides/other_point/window"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name]=["guides/regional_guides/window"]
					}
				},
				event : {
					"MouseClick":"regional_guides_point_ok"
				},
				subscribe : {}
			},
			//取消 - 1
			"regional_guides/point/cancle" : {
				property:{
					showWindows : function(obj,propt_name){
						obj[propt_name] = ["guidies/init/button","guides/road/button","guides/regional/button"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name] = ["guides/regional_guides/window"]
					}
				},
				event : {
					"MouseClick":"regional_guides_point_cancle"
				},
				subscribe : {}
			},
			//确定 - 2
			"regional_guides/other_point/ok":{
				property:{
					showWindows : function (obj,propt_name){
						obj[propt_name] = ["guides_point/export/btn"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name]=["regional_guides/other_point/window"]
					}
				},
				event : {
					"MouseClick":"regional_guides_other_point_ok"
				},
				subscribe : {}
			},
			//取消 - 2
			"regional_guides/other_point/cancle":{
				property:{
					showWindows : function (obj,propt_name){
						obj[propt_name] = ["guidies/init/button","guides/road/button","guides/regional/button"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name] = ["regional_guides/other_point/window"]
					}
				},
				event : {
					"MouseClick":"regional_guides_point_cancle"
				},
				subscribe : {}
			},
			//导出
			"guides_point/export/btn":{
				property:{
					showWindows : function(obj,propt_name){
						obj[propt_name] = ["guidies/init/button","guides/road/button","guides/regional/button"];
					},
					hideWindows : function(obj,propt_name){
						obj[propt_name] = ["guides_point/export/btn"]
					}
				},
				event : {
					"MouseClick":"regional_guides_point_export"
				},
				subscribe : {}
			}
		}
	}
} catch( e )
{
	alert( e );
}