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

var SppLod = null;

(function(){

	SppLod = new Object();

	var waterlod = false;
	SppLod.waterLod = function(prop_actor, prop_pm)
	{
		if(!load("/art/water_lod.js"))
		{
			alert("load '/art/water_lod.js' failed")
		}
		
		// --waterlod 开关meshgen效果.
		waterlodOpt = CmdLine.GetOption("waterlod");
		
		if(!waterlodOpt)
		{
			// now have no waterlod.
			console.debug("have no waterlod.\n");
			for ( var ids = 0; ids < WATER_LOD.length; ids ++ )
			{
				// 动态读取贴图数据
				var materialwater = C3D.engine.FindMaterial(WATER_LOD[ids].material.water);
				if(materialwater)
				{
					// 动态读取MeshOjb数据
					C3D.engine.FindMeshObject(WATER_LOD[ids].meshobjName).meshObject.matWrap = materialwater;
				}
			}
			return;
		}
		
		var actor = prop_actor.QueryInterface('iPcActorMove');
		var id = C3D.engine.SubscribeFrame(function(){
			//根据当前pos和需要显示水的位置进行距离的判断，在需要的距离内和外切换贴图，进行不同的显示，自己实现lod的效果。
			if (!actor.IsMoving())
				return;
			// 取actor当前位置。 ==> curpos;
			var curpos = prop_pm.GetProperty("position");
			for ( var ids = 0; ids < WATER_LOD.length; ids ++ )
			{
				// 动态读取贴图数据
				var materialwater = C3D.engine.FindMaterial(WATER_LOD[ids].material.water);
				var materialground = C3D.engine.FindMaterial(WATER_LOD[ids].material.normal);
				
				// 计算length
				var len = (WATER_LOD[ids].position.x - curpos.x)*(WATER_LOD[ids].position.x - curpos.x)
						+ (WATER_LOD[ids].position.z - curpos.z)*(WATER_LOD[ids].position.z - curpos.z);
				var diff = Math.sqrt(len);
				if(diff > WATER_LOD[ids].distance && materialwater && materialground)
				{
					// 动态读取MeshOjb数据
					C3D.engine.FindMeshObject(WATER_LOD[ids].meshobjName).meshObject.matWrap = materialground;
				}else{
					// 动态读取MeshOjb数据
					C3D.engine.FindMeshObject(WATER_LOD[ids].meshobjName).meshObject.matWrap = materialwater;
				}
			}
		});
	}
	
})();

}catch(e){
	alert(e);
}