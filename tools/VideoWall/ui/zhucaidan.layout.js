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
			// 底部窗口被点击
			"tool.anywheredoor.ui.editbox.click" : function() {
				player.isClickOnUI = true;
			},
			// 清空JSON中所有数据，重头再点一遍。
			map_click : function(){
				player.isClickOnUI = true;
				
				VideoWallData = {};
				alert("所有数据已经清空！！");
			},
			// 点击“保存”按钮。
			school_quick_position_export : function(){
				player.isClickOnUI = true;
				
				var jsonString = "VideoWallData = " + JSON.stringify(VideoWallData, null, "    ");
				VFS.WriteFile(Config.DataFilePath, jsonString);
				alert("保存成功!");
			},
			"kuaisudingwei_win_close" : function(){
				var quick_pos_win = FUNCTION_DATA.get_windows("zhucaidan/kuaisudingwei");
				quick_pos_win.SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("kuaisudingwei/dingwei_btn").SetProperty("Visible","False");
			},
			"kuaisudingwei_tishi_ok" :function(){
				player.isClickOnUI = true;
				
				// 没有点击任何mesh
				if(player.clickedMesh == "")
				{
					alert("请先点击一个模型！");
					return;
				}
				
				// 获取用户输入的视频文件名。
				var input_box = GUI.Editbox.Get("kuaisudingwei/chinses_name");
				var file_name = input_box.GetProperty("Text");
				if(player.tmpData == "")
				{
					alert("请输入视频文件名称！");
					return;
				}
				
				// 将视频文件名称记录在JSON中。
				VideoWallData[player.clickedMesh] = player.tmpData;
				
				alert("创建视频墙成功 : " + player.clickedMesh + "\n",
					"请指定下一个视频墙！"
				);
			},
			"kuaisudingwei_tishi_cancel" :function(){
				player.isClickOnUI = true;
				FUNCTION_DATA.get_windows("kuaisudingwei/name").SetProperty("Visible", "False");
			},
			serch_ecitbox_Activated :function (){
				player.pcarray["pccommandinput"].PerformAction("Activate", ['activate', false]);//王鑫修改(2012-06-12)
			},
			serch_ecitbox_Deactivated :function (){
				player.pcarray["pccommandinput"].PerformAction("Activate", ['activate', true]);//王鑫修改(2012-06-12)
			},
			school_map_click:function(){
				player.mouseStartX = player.mousex;
				player.mouseStartY = player.mousey;
				var cur_win = this;
				var width = 0;
				var height = 0;
				while(cur_win.name != "root")
				{
					var lt_pos = cur_win.position;
					var parent_width = cur_win.parent.absoluteWidth;
					var parent_height = cur_win.parent.absoluteHeight;
					width += lt_pos.x * parent_width;
					height += lt_pos.y * parent_height;
					cur_win = cur_win.parent;
				}
				var btn_win = GUI.Windows.Get("kuaisudingwei/dingwei_btn");
				
				Event.Send({
					name : "player.effect.create_new_button",
					pos_x : width,
					pos_y : height,
					map_win_width : this.absoluteWidth,
					map_win_height : this.absoluteHeight,
					btn_win_width : btn_win.absoluteWidth,
					btn_win_height : btn_win.absoluteHeight
				});
			},
			//点击--主界面360点  button触发的视角
			full_360point_export_ok:function(){
				for(var index in this.associatedWindow){
					FUNCTION_DATA.get_windows(this.associatedWindow[index]).SetProperty("Visible","False");
				}
				FUNCTION_DATA.get_windows("360point/background").SetProperty("Visible","True");
			},
			//输入name，并输入一个点后按确定
			full_360point_input_name_ok:function(){
				var chinese_name_ed = GUI.Editbox.Get("360point/Editbox");
				var chinese_name = chinese_name_ed.GetProperty("Text");
				var english_name = "test";
				var id = GUI.Editbox.Get("360point/qian/Editbox").GetProperty("Text");
				Event.Send({
					name : "player.effect.get_first_360message" ,
					chinese_name : chinese_name,
					english_name : english_name,
					id : id
				});
				FUNCTION_DATA.get_windows("360point/background").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("360point/other_point/background").SetProperty("Visible","True");
			},
			//输入另外一个点
			full_360point_other_point_input_name_ok:function(){
				var id = GUI.Editbox.Get("360point/other_point/Editbox").GetProperty("Text");
				Event.Send({
					name : "player.effect.get_360point_message" ,
					id : id
				});
				FUNCTION_DATA.get_windows("360point/other_point/background").SetProperty("Visible","False");
				FUNCTION_DATA.get_windows("360point_export/btn").SetProperty("Visible","True");
			},
			//取消输入name
			full_360point_input_name_cancle:function(){
				FUNCTION_DATA.get_windows(this.ondisplayWin[0]).SetProperty("Visible","False");
				for(var index in this.associatedWindow){
					FUNCTION_DATA.get_windows(this.associatedWindow[index]).SetProperty("Visible","True");
				}
			},
			//导出360full point
			full_360point_export:function(){
				xmlString = "<POINT_POSITION_DATA>\n"
				var position_data_string = player.list_360point_position_data;
				var pos_list = position_data_string.split('%'); 
				if(pos_list.length<=1){
					return ; 
				}
				for(var i = 0;i<pos_list.length-1;i++){
					xmlString += "\t<n__n"+i+">\n";
					xmlString += "\t\t<name>\n" ;  
					xmlString += "\t\t\t<chinese_name>"+pos_list[i].split('|')[1]+"</chinese_name>\n";
					xmlString += "\t\t\t<english_name>"+pos_list[i].split('|')[2]+"</english_name>\n";
					xmlString += "\t\t</name>\n" ; 
					xmlString += "\t\t<id_"+pos_list[i].split('|')[3]+">\n" ; 
					xmlString += "\t\t\t<point_position_x>"+pos_list[i].split('|')[4]+"</point_position_x>\n";
					xmlString += "\t\t\t<point_position_y>"+pos_list[i].split('|')[5]+"</point_position_y>\n";
					xmlString += "\t\t\t<point_position_z>"+pos_list[i].split('|')[6]+"</point_position_z>\n";
					xmlString += "\t\t\t<point_rotation_y>"+pos_list[i].split('|')[7]+"</point_rotation_y>\n";
					xmlString += "\t\t</id_"+pos_list[i].split('|')[3]+">\n" ; 
					xmlString += "\t\t<id_"+pos_list[i].split('|')[8]+">\n" ; 
					xmlString += "\t\t\t<point_position_x>"+pos_list[i].split('|')[9]+"</point_position_x>\n";
					xmlString += "\t\t\t<point_position_y>"+pos_list[i].split('|')[10]+"</point_position_y>\n";
					xmlString += "\t\t\t<point_position_z>"+pos_list[i].split('|')[11]+"</point_position_z>\n";
					xmlString += "\t\t\t<point_rotation_y>"+pos_list[i].split('|')[12]+"</point_rotation_y>\n";
					xmlString += "\t\t</id_"+pos_list[i].split('|')[8]+">\n" ; 
					xmlString += "\t</n__n"+i+">\n";
				}
				xmlString +="</POINT_POSITION_DATA>";
				var file_to_write = VFS.Open("/tools/ui/point_position.xml",VFS.WRITE);
				VFS.WriteFile("/tools/ui/point_position.xml",xmlString);
				xmlString = "";
				alert("保存成功!");
				this.SetProperty("Visible","False");
				for(var index in this.associatedWindow){
					FUNCTION_DATA.get_windows(this.associatedWindow[index]).SetProperty("Visible","True");
				}
				//清空编辑框中的信息
				FUNCTION_DATA.get_windows("360point/Editbox").SetProperty("Text","");
				FUNCTION_DATA.get_windows("360point/qian/Editbox").SetProperty("Text","");
				FUNCTION_DATA.get_windows("360point/other_point/Editbox").SetProperty("Text","");
			}
		},
		window : {
			//快速定位编译
			"school_map/btn" :{
				property:{},
				event : {
					"Clicked":"map_click"
				},
				subscribe : {}
			},
			//导出xml文件
			"kuaisudingwei/save" :{
				property:{},
				event : {
					"Clicked":"school_quick_position_export"
				},
				subscribe : {}
			},
			"kuaisudingwei/map_bg" :{
				property:{},
				event : {
					"MouseClick":"school_map_click"
				},
				subscribe : {}
			},
			//快速定位窗体
			"zhucaidan/kuaisudingwei" :{
				property:{},
				event : {
					"MouseClick":"school_map_notarize_danyi"
				},
				subscribe : {
					"ui.move.dingwei_button" : function(e){
						var areaRect = e.areaRect;
						//获取窗口 --- “定位点”button
						var btn_win = FUNCTION_DATA.get_windows("kuaisudingwei/dingwei_btn");
						//设置属性
						btn_win.SetProperty("UnifiedAreaRect",areaRect);
						btn_win.SetProperty("Visible","True");
						//显示编辑框
						var edit_win = FUNCTION_DATA.get_windows("kuaisudingwei/name");
						edit_win.SetProperty("Visible","True");
					},
					"ui.create.dingwei_button" : function(e){
						var index = e.index;
						var btn_name = e.btn_name;
						var btn_pos = e.btn_pos;
						//重新创建button
						var button = GUI.Windows.CreateWindow("General/RadioButton","kuaisudingwei_btn"+index);
						button.SetProperty("UnifiedMaxSize" , "{{1,0},{1,0}}") ;
						button.SetProperty("NormalTextColour","FF000000");
						// button.SetProperty("SelectedTextColour","FF800000");
						button.SetProperty("Visible","True");
						button.SetProperty("font","Yahei8");
						button.SetProperty("text_theme",btn_name);
						button.parent = FUNCTION_DATA.get_windows("kuaisudingwei/map_bg");
						FUNCTION_DATA.get_windows("kuaisudingwei/dingwei_btn").SetProperty("Visible","False");
						//按钮name大于3的时候加长
						if(btn_name.length>3){
							var ui_pos = new Array();
							ui_pos = btn_pos;
							var coor = ui_pos.split("},{");
							coor = coor[2].split(",0");
							coor_x0 = parseFloat(coor[0]);
							var length = coor_x0 + (btn_name.length-3) * 0.015;
						    coor = ui_pos.toString();
							coor = coor.replace("{" + coor_x0 + ",0}","{" + length + ",0}");
							button.SetProperty("UnifiedAreaRect",coor);
						}else{
							button.SetProperty("UnifiedAreaRect",btn_pos);
						}
					}
				}
			},
			"kuaisudingwei/close_button" :{
				property:{},
				event : {
					"Clicked":"kuaisudingwei_win_close"
				},
				subscribe : {}
			},
			// "kuaisudingwei/english_name":{
				// property:{
					// associatedWindow : function (obj,propt_name){
						// obj[propt_name]=['kuaisudingwei/name','kuaisudingwei/english_name','kuaisudingwei/chinses_name','kuaisudingwei/ok'];
					// }
				// },
				// event : {
					// "Activated":"serch_ecitbox_Activated",
					// "Deactivated":"serch_ecitbox_Deactivated"
				// },
				// subscribe : {}
			// },
			"kuaisudingwei/chinses_name":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['kuaisudingwei/name','kuaisudingwei/chinses_name','kuaisudingwei/ok'];
					}
				},
				event : {
					"Activated":"serch_ecitbox_Activated",
					"Deactivated":"serch_ecitbox_Deactivated",
					"MouseClick" : "tool.anywheredoor.ui.editbox.click"
				},
				subscribe : {}
			},
			"kuaisudingwei/ok":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['kuaisudingwei/name','kuaisudingwei/chinses_name','kuaisudingwei/ok'];
					}
				},
				event : {
					"Clicked":"kuaisudingwei_tishi_ok"
				},
				subscribe : {}
			},
			"kuaisudingwei/cancel":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['kuaisudingwei/name','kuaisudingwei/chinses_name','kuaisudingwei/ok'];
					}
				},
				event : {
					"Clicked":"kuaisudingwei_tishi_cancel"
				},
				subscribe : {}
			},
			"360point/btn":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['kuaisudingwei/save','school_map/btn','360point/btn'];
					}
				},
				event : {
					"Clicked":"full_360point_export_ok"
				},
				subscribe : {}
			},
			"360point/input_name/cancle":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['kuaisudingwei/save','school_map/btn','360point/btn'];
					},
					ondisplayWin : function (obj,propt_name){
						obj[propt_name]=['360point/background'];
					}
				},
				event : {
					"Clicked":"full_360point_input_name_cancle"
				},
				subscribe : {}
			},
			"360point/other_point/input_name/cancle":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['kuaisudingwei/save','school_map/btn','360point/btn'];
					},
					ondisplayWin : function (obj,propt_name){
						obj[propt_name]=['360point/other_point/background'];
					}
				},
				event : {
					"Clicked":"full_360point_input_name_cancle"
				},
				subscribe : {}
			},
			//"输入建筑name，如雍和宫:"
			"360point/background/text":{
				property:{},
				event : {
					"Activated":"serch_ecitbox_Activated",
					"Deactivated":"serch_ecitbox_Deactivated"
				},
				subscribe : {}
			},
			//"输入1或2,1代表进360前一点，2代表后一点"
			"360point/background_qian/text":{
				property:{},
				event : {
					"Activated":"serch_ecitbox_Activated",
					"Deactivated":"serch_ecitbox_Deactivated"
				},
				subscribe : {}
			},
			//"输入另一个点，1或2"
			"360point/background/other_point/text":{
				property:{},
				event : {
					"Activated":"serch_ecitbox_Activated",
					"Deactivated":"serch_ecitbox_Deactivated"
				},
				subscribe : {}
			},
			"360point/input_name/ok":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['360point/other_point/background'];
					}
				},
				event : {
					"Clicked":"full_360point_input_name_ok"
				},
				subscribe : {}
			},
			"360point/other_point/input_name/ok":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['360point/other_point/background'];
					}
				},
				event : {
					"Clicked":"full_360point_other_point_input_name_ok"
				},
				subscribe : {}
			},
			"360point_export/btn":{
				property:{
					associatedWindow : function (obj,propt_name){
						obj[propt_name]=['kuaisudingwei/save','school_map/btn','360point/btn'];
					}
				},
				event : {
					"Clicked":"full_360point_export"
				},
				subscribe : {}
			}
		}
	}
} catch( e )
{
	alert( e );
}