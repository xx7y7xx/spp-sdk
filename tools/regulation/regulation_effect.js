try{
	(function(){
		
		var appendRGB = 0.1;
	
		Event.Subscribe(function(e){
		var actor = e.player;
		var sectorList = engine.sectors;  // ȡ��sectorlist ÿ��sector����һ����ǩ��index�� 
		var sector = sectorList.Get(0);
		var ruesl = sector.ambient['r'];
		if(ruesl<=1){
		CONSOLE.WriteLine("ambient.r = "+ruesl);
		sector.ambient = sector.ambient.Add2([0.05, 0.05, 0.05]);
		}
		}, "bra.effect.brilliance");
		
		Event.Subscribe(function(e){
		var actor = e.player;
		var sectorList = engine.sectors;  // ȡ��sectorlist ÿ��sector����һ����ǩ��index�� 
		var sector = sectorList.Get(0);
		var ruesl = sector.ambient['r'];
		
		if(ruesl>=0){
		CONSOLE.WriteLine("ambient.r = "+ruesl);
		sector.ambient = sector.ambient.Add2([-0.05, -0.05, -0.05]);
		}
		
		}, "bra.effect.darkness");
		/*
		Event.Subscribe(function(e){
			// alert("123456+brilliance");
			
			// engine.ambient[0]=1;
			var actor = e.player;
		}, "bra.effect.brilliance.stop");
		
		Event.Subscribe(function(e){
			alert("123456+darkness");
			var actor = e.player;
		}, "bra.effect.darkness.stop");
		*/
	})();

}catch(e){
	alert(e);
}