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
	// 提高环境光亮度ambient
	Event.Subscribe(function(e){
		var val = 0.05; // 步进值
		// 取到sectorlist 每个sector都有一个标签（index）
		var sectorList = engine.sectors;
		var sector = sectorList.Get(0);
		AssertTrue(typeof(sector.ambient) != "undefined", "cant get <ambient> in sector, or there is no <ambient> node in sector");
		sector.ambient = sector.ambient.Add([val, val, val]);
	},"bright.effect.ambient.raise");
	
	// 降低环境光亮度ambient
	Event.Subscribe(function(e){
		var val = -0.05; // 步进值
		// 取到sectorlist 每个sector都有一个标签（index）
		var sectorList = engine.sectors;
		var sector = sectorList.Get(0);
		AssertTrue(typeof(sector.ambient) != "undefined", "cant get <ambient> in sector, or there is no <ambient> node in sector");
		sector.ambient = sector.ambient.Add([val, val, val]);
	},"bright.effect.ambient.reduce");
	
	// 恢复环境光亮度ambient
	Event.Subscribe(function(e){
		// 取到sectorlist 每个sector都有一个标签（index）
		var sectorList = engine.sectors;
		var sector = sectorList.Get(0);
		AssertTrue(typeof(sector.ambient) != "undefined", "cant get <ambient> in sector, or there is no <ambient> node in sector");
		sector.ambient = ([0.5, 0.5, 0.5]);
	},"bright.effect.ambient.recover");
	})();
} catch(e){
	alert(e);
}