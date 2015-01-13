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

var MeshGen = null;
require("console.js");

(function(){

	MeshGen = new Object();
	
	var meshgenOpt = false;
	MeshGen.SetMeshGenerate = function(prop_actor, prop_pm, distance)
	{
		if(!load("/art/meshgen_names.js"))
		{
			alert("load '/art/meshgen_names.js' failed");
			return false;
		}
		
		// sector.
		var sectorlist = C3D.engine.sectors;
		if(sectorlist.count < 0)
		{
			console.warn("sectorlist have no sector.\n");
			return false;
		}
		
		// get "x_0_z_0".
		for(var a = 0; a < MESHNAME.arrayx; a++)
		{
			for(var b = 0; b < MESHNAME.arrayy; b++)
			{
				ids = "x_" + (a) + "_z_" + (b);
				// please look at "/art/meshgen_names.js".
				for(var idsSon = 0; idsSon < MESHNAME.data[ids].length; idsSon ++)
				{
					var allMeshObjAdd = C3D.engine.FindMeshObject(MESHNAME.data[ids][idsSon]);
					if(!allMeshObjAdd)
					{
						console.warn( MESHNAME.data[ids][idsSon] + " 命名有问题，请检查！！！" + "\n" );
					}
					else
					{
						// --meshgen 开关meshgen效果.
						meshgenOpt = CmdLine.GetOption("meshgen");
						if( meshgenOpt )
						{
							allMeshObjAdd.minDistance = 0;
							allMeshObjAdd.maxDistance = distance;
						}
					}
				}
			}
		}
		return;
	}
})();

}catch(e){
	alert(e);
}