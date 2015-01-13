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
	
		/*	鼠标滚轮向前 摄像机拉近		*/
		Event.Subscribe(function(e){
			var actor = e.player;
			iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
			var range_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
			range_distance = range_distance - 5;
			iCamera.pcarray['pcdefaultcamera'].SetProperty('distance', range_distance);
		},"camera.effect.change.distance.near");
		
		/*	鼠标滚轮向后 摄像机拉远		*/
		Event.Subscribe(function(e){
			var actor = e.player;
			iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
			var range_distance = iCamera.pcarray['pcdefaultcamera'].GetProperty('distance');
			range_distance = range_distance + 5;
			iCamera.pcarray['pcdefaultcamera'].SetProperty('distance', range_distance);
		},"camera.effect.change.distance.far");
	
	})();
} catch(e){
	alert(e);
}