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
	
		//获取输入信息
		Event.Subscribe(function(e){
			var xmlString = "";
			//判断目前点击的是哪条路线，给xmlString赋值
			if(e.id == "lishiwenhua"){//历史文化--路线1
				xmlString = player.one_list_position_data ;
			}
			if(e.id == "xinshengruxue"){//新生入学--路线2
				xmlString = player.two_list_position_data ;
			}
			if(e.id == "special_attractions"){//特殊景点--路线3
				xmlString = player.special_list_position_data ;
			}
			//获取当前导游点的位置坐标，并记录到数组中
			var pos = player.pcarray['pcmesh'].GetProperty('position');
			var rot = player.pcarray['pcmesh'].GetProperty('rotation');
			xmlString = player.chinese_name+"|"+player.english_name+
						"|"+pos.x+"|"+pos.y+"|"+pos.z+"|"+rot.y+"%";
			//判断目前点击的路线，记录相应的数组，并给player.list_position_data赋值
			if(e.id == "lishiwenhua"){//历史文化--路线1
				player.one_list_position_data += xmlString ;
			}
			if(e.id == "xinshengruxue"){//新生入学--路线2
				player.two_list_position_data += xmlString ;
			}
			if(e.id == "special_attractions"){//特殊景点--路线3
				player.special_list_position_data += xmlString ;
			}
		},"player.effect.get_message");
		
		//第一个确定按钮，把第一次输入的信息，包括位置信息读出来保存
		Event.Subscribe(function(e){
			player.chinese_name = e.chinese_name;
			player.english_name = e.english_name;
			first_pos = player.pcarray['pcmesh'].GetProperty('position');
			first_rot = player.pcarray['pcmesh'].GetProperty('rotation');
			if(isNaN(first_pos.x) || isNaN(first_pos.y) || isNaN(first_pos.z) || isNaN(first_rot.y)){
				alert("当前点坐标为非数值型，请重新获取！！！");
			}else{
				player.first_pos = first_pos;
				player.first_rot = first_rot;
				player.first_id = e.point_id;
			}
		},"player.effect.regional_guides.fist_point");
		
		//获取区域导游点输入的信息
		Event.Subscribe(function(e){
			var xmlString = player.list_regional_point_position_data ; 
			var other_pos = player.pcarray['pcmesh'].GetProperty('position');
			var other_rot = player.pcarray['pcmesh'].GetProperty('rotation');
			if(isNaN(other_pos.x) || isNaN(other_pos.y) || isNaN(other_pos.z) || isNaN(other_rot.y)){
				alert("当前点坐标为非数值型，请重新获取！！！");
			}else{
				xmlString = "index" + "|" + player.chinese_name + "|"+player.english_name + "|"+player.first_id + 
							"|" + player.first_pos.x + "|" + player.first_pos.y + "|" + player.first_pos.z + "|" + player.first_rot.y +
							"|" + e.point_id + "|" + other_pos.x + "|" + other_pos.y + "|" + other_pos.z + "|" + other_rot.y + "|" + "%";
				player.list_regional_point_position_data += xmlString;
			}
		},"player.effect.regional_guides.other_point");
	})();
} catch(e){
	alert(e);
}