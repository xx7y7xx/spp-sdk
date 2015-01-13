/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

//========================================================================
  //  该文件主要管理以下事件的响应 --- Event.Subscribe({});
  //  1、控制动态灯光（Lamp）的移动 --- "bright.effect.Lamp.move"
  //  2、提高动态灯光（Lamp）的亮度 --- "bright.effect.Lamp_raise"
  //  3、降低动态灯光（Lamp）的亮度 --- "bright.effect.Lamp_reduce"
  //  4、恢复动态灯光（Lamp）的亮度 --- "bright.effect.Lamp_recover"
  //  5、提高环境光（ambient）亮度 --- "bright.effect.ambient_lightup"
  //  6、降低环境光（ambient）亮度 --- "bright.effect.ambient_lightdown"
  //  7、恢复环境光（ambient）亮度 --- "bright.effect.ambient_revert"
  //  8、提高屏幕gamma值 --- "bright.effect.screen_gammaUp"
  //  9、降低屏幕gamma值 --- "bright.effect.screen_gammaDown"
//========================================================================
try{
	(function(){
		//灯光跟随人物移动事件触发
		Event.Subscribe(function(e){
			var actor = e.player;
			var position = e.position;
			//计算灯光的y坐标
			var height = position.y + actor.current_height;
			//将人物的位置信息赋值给灯光，使灯光跟随人物移动
			var iMeshWrapper = C3D.engine.FindMeshObject('cube#01');
			if(iMeshWrapper){
				var meshTransform = iMeshWrapper.movable.GetTransform();
			}
			if(meshTransform){
				var v0 = meshTransform.GetFront();
				var v1 = meshTransform.GetO2TTranslation();
			}
			if(v0 && v1){
				var x = Number(-10*v0[0].toFixed(3))/Number(v0.Length().toFixed(3));
				var z = Number(-10*v0[2].toFixed(3))/Number(v0.Length().toFixed(3));
				x = Number(x) + Number(v1[0]);
				z = Number(z) + Number(v1[2]);
				player.light.center = [x , height + 15 , z];
			}
		},"bright.effect.Lamp.move");
		
		//Lamp灯光亮度---提高
		Event.Subscribe(function(e){
			var actor = e.player;
			player.light.color = player.light.color.Add([0.05,0.05,0.05]);
		},"bright.effect.Lamp_raise");
		
		//Lamp灯光亮度---降低
		Event.Subscribe(function(e){
			var actor = e.player;
			player.light.color = player.light.color.Add([-0.05,-0.05,-0.05]);
		},"bright.effect.Lamp_reduce");
		
		//Lamp灯光亮度---恢复
		Event.Subscribe(function(e){
			var actor = e.player;
			player.light.color = player.color;
		},"bright.effect.Lamp_recover");
		
		//提高环境光亮度ambient
		Event.Subscribe(function(e){
			var val = 0.05; // 步进值
			var sector = SceneTree.getFirstSector();
			AssertTrue(typeof(sector.ambient) != "undefined", "cant get <ambient> in sector, or there is no <ambient> node in sector");
			sector.ambient = sector.ambient.Add([val, val, val]);
			console.info("Ambient color : [R:" + sector.ambient.r + ",G:" + sector.ambient.g + ",B:" + sector.ambient.b + "]");
		}, "bright.effect.ambient_lightup");
		
		//降低环境光亮度ambient
		Event.Subscribe(function(e){
			var val = -0.05; // 步进值
			var sector = SceneTree.getFirstSector();
			AssertTrue(typeof(sector.ambient) != "undefined", "cant get <ambient> in sector, or there is no <ambient> node in sector");
			sector.ambient = sector.ambient.Add([val, val, val]);
			console.info("Ambient color : [R:" + sector.ambient.r + ",G:" + sector.ambient.g + ",B:" + sector.ambient.b + "]");
		}, "bright.effect.ambient_lightdown");
		
		//还原环境光亮度ambient
		Event.Subscribe(function(e){
			var actor = e.player
			var sectorList = engine.sectors; 
			var sector = sectorList.Get(0);
			sector.ambient = ([0.5, 0.5, 0.5]);
		}, "bright.effect.ambient_revert");
		
		//提高屏幕gamma值
		Event.Subscribe(function(e){
			C3D.g2d.gamma += 0.1;
			var rep = Registry.Get("iReporter");
			System.Report("Gamma value : " + C3D.g2d.gamma, rep.DEBUG, "spp.tools.viewscene");
		}, "bright.effect.screen_gammaUp");
		
		//降低屏幕gamma值
		Event.Subscribe(function(e){
			C3D.g2d.gamma -= 0.1;
			var rep = Registry.Get("iReporter");
			System.Report("Gamma value : " + C3D.g2d.gamma, rep.DEBUG, "spp.tools.viewscene");
		}, "bright.effect.screen_gammaDown");
	})();
} catch(e){
	alert(e);
}