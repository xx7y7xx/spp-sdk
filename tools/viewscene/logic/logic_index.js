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
	
	//����--�ӽǿ����¼���Ӧ
	load('/tools/logic/camera_effect.js');
	
	//����--�����ƶ��¼���Ӧ
	load('/tools/logic/player_effect.js');
	
	//����--��̬�ƹ⣨Lamp���������⣨ambient���¼���Ӧ
	load('/tools/logic/bright_effect.js');
	
	//����--�����ק�������¼���Ӧ
	load('/tools/logic/mouse_effect.js');

}catch(e){
	alert(e);
}