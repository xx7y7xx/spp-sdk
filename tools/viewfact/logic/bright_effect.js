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

/* ==========================================================================================================
	以下对该文件进行说明：
		该文件主要管理有光灯光的事件响应，如：
			1. + : 提高场景整体亮度（按住不放，持续执行）；
			2. - : 降低场景整体亮度（按住不放，持续执行）；
			3. Home : 恢复场景亮度；
			4. L : 控制灯光移动---按住L键不放，移动模型即可使灯光移动；
 ==========================================================================================================*/

	(function(){
		
		//提高环境光亮度ambient
		Event.Subscribe(function(e){
			var actor = e.player;
			// 取到sectorlist 每个sector都有一个标签（index）
			var sectorList = engine.sectors;
			var sector = sectorList.Get(0);
			sector.ambient = sector.ambient.Add([0.05, 0.05, 0.05]);
		}, "bright.effect.brilliance");
		
		//降低环境光亮度ambient
		Event.Subscribe(function(e){
			var actor = e.player;
			// 取到sectorlist 每个sector都有一个标签（index）
			var sectorList = engine.sectors;
			var sector = sectorList.Get(0);
			sector.ambient = sector.ambient.Add([-0.05, -0.05, -0.05]);
		}, "bright.effect.darkness");
		
		//恢复环境光亮度ambient
		Event.Subscribe(function(e){
			var actor = e.player
			var sectorList = engine.sectors; 
			var sector = sectorList.Get(0);
			sector.ambient = ([0.5, 0.5, 0.5]);
		}, "bright.effect.revert");
		
		/*	L键按下 事件触发 ---控制灯光移动	*/
		Event.Subscribe(function(e){
			//设置为第三人称视角
			iCamera.pcarray['pcdefaultcamera'].SetCamera('thirdperson');
			//订阅frame事件
			player.id = C3D.engine.SubscribeFrame(function(){
				//获取iCamera对象
				var iPcCamera = iCamera.pcarray['pcdefaultcamera'].QueryInterface('iPcCamera');
				var cameraobj = iPcCamera.GetCamera();
				//获得camera的transform变换关系
				var camTransform = cameraobj.GetTransform();
				//为light设置变换关系 与摄像机同步
				light.movable.SetTransform(camTransform);
				//将light的node的父设置为0
				light.node.parent = 0;
				//更新当前的light
				light.movable.Update();
			});
		}, "change.light.position");
		
		/*	L键抬起 事件触发	*/
		Event.Subscribe(function(e){
			//取消frame事件的订阅 
			C3D.engine.UnsubscribeFrame(player.id);
		},"change.light.position.stop");
	})();
}catch(e){
	alert(e);
}