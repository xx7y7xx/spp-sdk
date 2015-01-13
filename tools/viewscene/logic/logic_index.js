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
try{
	
	load('/tools/logic/keycontrol.js');
	
	load('/tools/logic/camera_entity.js');
	
	load('/tools/logic/player_entity.js');
	
	//管理--视角控制事件响应
	load('/tools/logic/camera_effect.js');
	
	//管理--基本移动事件响应
	load('/tools/logic/player_effect.js');
	
	//管理--动态灯光（Lamp）、环境光（ambient）事件响应
	load('/tools/logic/bright_effect.js');
	
	//管理--鼠标拖拽、滚轮事件响应
	load('/tools/logic/mouse_effect.js');

}catch(e){
	alert(e);
}