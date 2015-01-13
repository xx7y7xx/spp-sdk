try{
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
	})();

}catch(e){
	alert(e);
}