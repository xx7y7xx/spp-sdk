try{
	(function(){
		
		//��߻���������ambient
		Event.Subscribe(function(e){
		var actor = e.player;
		// ȡ��sectorlist ÿ��sector����һ����ǩ��index��
		var sectorList = engine.sectors;
		var sector = sectorList.Get(0);
		sector.ambient = sector.ambient.Add([0.05, 0.05, 0.05]);
		}, "bright.effect.brilliance");
		
		//���ͻ���������ambient
		Event.Subscribe(function(e){
		var actor = e.player;
		// ȡ��sectorlist ÿ��sector����һ����ǩ��index��
		var sectorList = engine.sectors;
		var sector = sectorList.Get(0);
		sector.ambient = sector.ambient.Add([-0.05, -0.05, -0.05]);
		}, "bright.effect.darkness");
		
		//�ָ�����������ambient
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