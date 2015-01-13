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
		// 必须先加载插件，这个插件中定义了全局对象`Entities`。
		Plugin.Load("spp.behaviourlayer.jscript");
		
		// Fetch和HasParameter是辅助Behaviour处理的函数，负责从传入的参数中获取自己感兴趣的参数。params通常传入arguments(内置对象，参数对象)。name是期望判定的参数名。用法如下:
		// ent.behaviour = function(msgid,pc,p1,p2,p3,p4,p5){
			// pc.PerformAction('cel.action.MouseMove',['x',Entities.Fetch(arguments,'x')],Entities.FetchArray(arguments,'y'));
		
		Entities.Fetch = function(params,name){
			for(var i = 0; i < params.length;)
			{
				if(typeof params[i] == "array" && param[i][0] == name)
				{
					return param[i][1];
				}
			}
			return undefined;
		};
		// 与Fetch不同的是，返回参数数组，这可以用在同名参数的情况下。参考上文注释的例子。
		Entities.FetchArray = function(params,name){
			for(var i = 0; i < params.length;)
			{
				if(typeof params[i] == "array" && param[i][0] == name)
				{
					return param[i];
				}
			}
			return ['',undefined];
		};
		Entities.HasParameter = function(params,name){
			for(var i = 0; i < params.length;)
			{
				if(typeof params[i] == "array" && param[i][0] == name)
				{
					return true;
				}
			}
			return false;
		};
		
		// 我们这里保存旧的CreateEntity方法，重新覆盖支持智能加载。
		var _OldCreateEntityFuncs = Entities.CreateEntity;
		// 这里的参数e就可以传入chenyang写的pclist,扩展pclist对象，可以直接调用performaction....
		
		// 加载一些帮助函数，以简化property class的action调用和property修改。
		require("pchelper.js");
		
		// 在`Entities.CreatePropertyClass`方法上面hook一下，
		// 以支持简写形式的`PerformAction`以及`SetProperty`
		var _oldCreatePropertyClass = Entities.CreatePropertyClass;
		Entities.CreatePropertyClass = function(ent, pcname){
			var argv = [];
			for ( var ids = 0; ids < arguments.length; ids ++ )
			{
				argv[ids] = arguments[ids];
			}
			var pc = _oldCreatePropertyClass.apply(Entities, argv);
			switch(pcname)
			{
			case "pczonemanager":
				PCHelper_pczonemanager(pc);
				break;
			case "pccommandinput":
				PCHelper_pccommandinput(pc);
				break;
			case "pccollisiondetection":
				PCHelper_pccollisiondetection(pc);
				break;
			case "pcactormove":
				PCHelper_pcactormove(pc);
				break;
			case "pcmesh":
				PCHelper_pcmesh(pc);
				break;
			case "pcdefaultcamera":
				PCHelper_pcdefaultcamera(pc);
				break;
			case "pclinearmovement":
				PCHelper_pclinearmovement(pc);
				break;
			case "pcmeshselect":
				PCHelper_pcmeshselect(pc);
				break;
			case "pclight":
				PCHelper_pclight(pc);
				break;
			case "pctimer":
				PCHelper_pctimer(pc);
				break;
			case "pcmover":
				PCHelper_pcmover(pc);
				break;
			case "pctrigger":
				PCHelper_pctrigger(pc);
				break;
			case "pcinventory":
				PCHelper_pcinventory(pc);
				break;
			case "pcnewcamera":
				PCHelper_pcnewcamera(pc);
				break;
			case "pcsimplecamera":
				PCHelper_pcsimplecamera(pc);
				break;
			case "pcmechsys":
				PCHelper_pcmechsys(pc);
				break;
			case "pcmechobject":
				PCHelper_pcmechobject(pc);
				break;
			case "pcsoundsource":
				pc.__oldGetProperty = pc.GetProperty;
				pc.GetProperty = function(){
					if(!pc.__oldGetProperty("soundname") && (arguments[0] == "loop" || arguments[0] == "volume")){
						alert("Can't Call GetProperty( '" + arguments[0] + "' ).\n\npcsoundsource has no soundname, please set it!");
						return false;
					} 
					pc.__oldGetProperty(arguments[0]);
				}
				pc.__oldPerformAction = pc.PerformAction;
				pc.PerformAction = function(){
					if(!pc.__oldGetProperty("soundname")){
						alert("Can't Call " + arguments[0] + "().\n\npcsoundsource has no soundname, please set it!");
						return false;
					} 
					pc.__oldPerformAction(arguments[0]);
				}
				pc.__oldSetProperty = pc.SetProperty;
				pc.SetProperty = function(){
					if(!pc.__oldGetProperty("soundname") && (arguments[0] == "loop" || arguments[0] == "volume")){
						alert("Can't Call SetProperty( '" + arguments[0] + "', " + arguments[1] + " ).\n\npcsoundsource has no soundname, please set it!");
						return false;
					} 
					pc.__oldSetProperty(arguments[0], arguments[1]);
				}
				PCHelper_pcsoundsource(pc);
				break;
			case "pcprojectile":
				PCHelper_pcprojectile(pc);
				break;
			case "pcsteer":
				PCHelper_pcsteer(pc);
				break;
			case "pcpathfinder":
				PCHelper_pcpathfinder(pc);
				break;
			case "pcmechbalancedgroup":
				PCHelper_pcmechbalancedgroup(pc);
				break;
			case "pcmechjoint":
				PCHelper_pcmechjoint(pc);
				break;
			case "pcmechthrustercontroller":
				PCHelper_pcmechthrustercontroller(pc);
				break;
			// case "pcmechthrusterreactionary":
				// PCHelper_pcmechthrusterreactionary(pc);
				// break;
			}
			return pc;
		}
		
		var pcmap = {
			"pczonemanager" : [false,"cel.pcfactory.world.zonemanager"],	//第一个值代表是否加载，第二个值代表需要加载的clsid.
			"pccommandinput" : [false,"cel.pcfactory.input.standard"],
			"pccollisiondetection" : [false,"cel.pcfactory.object.mesh.collisiondetection"],
			"pcactormove" : [false,"cel.pcfactory.move.actor.standard"],
			"pcmesh" : [false,"cel.pcfactory.object.mesh"],
			"pcdefaultcamera" : [false,"cel.pcfactory.camera.old"],
			"pclinearmovement" : [false,"cel.pcfactory.move.linear"],
			"pcmeshselect" : [false,"cel.pcfactory.object.mesh.select"],
			"pclight" : [false,"cel.pcfactory.object.light"],
			"pctimer" : [false,"cel.pcfactory.tools.timer"],
			"pcmover" : [false,"cel.pcfactory.move.mover"],
			"pcmovable" : [false,"cel.pcfactory.move.movable"],
			"pctrigger" : [false,"cel.pcfactory.logic.trigger"],
			"pcinventory" : [false, "cel.pcfactory.tools.inventory"],
			"pcpathfinder" : [false, "cel.pcfactory.move.pathfinder"],
			"pcsteer" : [false, "cel.pcfactory.move.steer"],
			"pcnewcamera" : [false, "cel.pcfactory.camera.standard"],
			"pcsimplecamera" : [false, "cel.pcfactory.camera.simple"],
			"pcmechsys" : [false, "cel.pcfactory.physics.system"],
			"pcmechobject" : [false, "cel.pcfactory.physics.object"],
			"pcsoundsource" : [false, "cel.pcfactory.sound.source"],
			"pcbillboard" : [false, "cel.pcfactory.2d.billboard"],
			"pcprojectile" : [false,"cel.pcfactory.move.projectile"],
			"pcmechbalancedgroup" : [false,"cel.pcfactory.physics.thruster.group"],
			"pcmechjoint" : [false,"cel.pcfactory.physics.joint"],
			"pcmechthrustercontroller" : [false,"cel.pcfactory.physics.thruster.controller"],
			// "pcmechthrusterreactionary" : [false,"cel.pcfactory.physics.thruster.reactionary"]
			"pctooltip" : [false,"cel.pcfactory.2d.tooltip"],
		};
		
		/** 使用方法: (创建一个包含若干propertyclass的Entity.)
		  var ent = Entities.CreateEntity({
			name : "player",
			pc : {
				"pczonemanager" : {
					action : [
						{
							name : "name",
							param : []
						}
					],
					property : [
						{
							name : "name",
							value : value
						}
					]
				},
				"pcactormove" :  {
					action : {
					},
					property : {
					}
				}
			},
		   event : {
		   },
		   // 所有subscribe函数
		   subscribe : {
			"topicname" : function...
		   },
		   // 添加到instance上的属性，使用mixin添加。
		   property : {
		   },
		   behaviour : function... //注意,behaviour与event不能共存。
		  });
		**/
		var Subscribe = function(name,callback){
			this.eventMap[name] = callback;
		}
		
		var Unsubscribe = function(name){
			delete this.eventMap[name];
		}
		
		var DefBehaviour = function(msgid,pc,p1,p2,p3,p4,p5){
			var handler = this.eventMap[msgid];
			if(typeof handler == "function")
			{
				handler.call(this,pc,p1,p2,p3,p4,p5);
			}
		}
		
		var InitPropertyClass = function(pc, param)
		{
			if(typeof param.action != "undefined")
			{
				len = param.action.length;
				for(var i = 0; i < len; i++)
				{
					item = param.action[i];
					// @fixme: 使用eval或者使用动态参数来替换下面这个办法:
					switch(item.param.length)
					{
					case 0:
						pc.PerformAction(item.name);
						break
					case 1:
						pc.PerformAction(item.name,item.param[0]);
						break
					case 2:
						pc.PerformAction(item.name,item.param[0],item.param[1]);
						break
					case 3:
						pc.PerformAction(item.name,item.param[0],item.param[1],item.param[2]);
						break
					case 4:
						pc.PerformAction(item.name,item.param[0],item.param[1],item.param[2],item.param[3]);
						break
					case 5:
						pc.PerformAction(item.name,item.param[0],item.param[1],item.param[2],item.param[3],item.param[4]);
						break
					case 6:
						pc.PerformAction(item.name,item.param[0],item.param[1],item.param[2],item.param[3],item.param[4],item.param[5]);
						break
					case 7:
						pc.PerformAction(item.name,item.param[0],item.param[1],item.param[2],item.param[3],item.param[4],item.param[5],item.param[6]);
						break
					default:
						alert("request action need " + item.param.length + " param");
					}
				}
			}

			if(typeof param.property != "undefined")
			{
				len = param.property.length;
				for(var i = 0; i < len; i++)
				{
					item = param.property[i];
					pc.SetProperty(item.name,item.value);
				}
			}
		}

		// 传入的是一个数组，这个数组指示了请求创建的propertyclass array.
		// performaction请自行调用，本方法只把必须的propertyclass创建了。
		Entities.CreateEntity = function(/*actorsPcfList*/param, position){
			var ret = _OldCreateEntityFuncs.apply(Entities);
			
			// 为新创建的Entity附加一些值。
			ret.pcarray = {};
			ret.eventMap = {};
			ret.Subscribe = Subscribe;
			ret.Unsubscribe = Unsubscribe;
			ret.sync = true;
			// 注意:可以如下方式调用ret.behaviour:
			// ret.behaviour(msgid,pc,p1...);
			
			if( typeof param != "undefined" )
			{
				var SetMeshFlag = false;
				if( param.pc && param.pc.pcmesh && param.pc.pcmesh.action )
				{
					for(var index = 0;index < param.pc.pcmesh.action.length; index ++ )
					{
						if ( param.pc.pcmesh.action[index].name == "SetMesh" )
						{
							SetMeshFlag = true;
						}
					}
					if ( !SetMeshFlag )
					{
						alert("Please SetMesh!!!");
						System.Quit();
					}
				}
			}
			
			// 为新创建的Entity附加名称。
			if(typeof param == "undefined" || typeof param.name == "undefined")
			{
				// 如果是entity template，则没有指定名称
				// 这个时候就需要创建一个随机名称。
				var name;
				var ent;
				do{
					name = "_Rand_" + Math.round(Math.random()*10000);
					// 已经存在该名称的entity，重新起名
					ent = Entities.GetEntity(name);
				}while(ent); //ent is null.
				ret.name = name;
			}else{
				// 如果不是entity template，则在JSON已经指定了名称
				ret.name = param.name;
			}

			// 为新建的Entity附加事件处理。
			if(typeof param == "undefined")
			{
				ret.behaviour = spp.hitch(ret,DefBehaviour);
				return ret;
			}
			
			// 为ret添加属性。前置处理，以便后面的代码可以使用之。
			if(typeof param.property == "object")
			{
				spp.mixin(ret,param.property);
			}
			
			if(typeof param.behaviour == "function")
			{
				ret.behaviour = param.behaviour;
			}else if(typeof param.event != "undefined")
			{
				ret.behaviour = spp.hitch(ret,DefBehaviour);
				ret.eventMap = param.event;
				for(var e in ret.eventMap)
				{
					if(typeof ret.eventMap[e] != "function")
					{
						var handler = ret[ret.eventMap[e]];
						if(typeof handler == "function")
						{
							ret.eventMap[e] = handler;
						}else{
							delete ret.eventMap[e];
						}
					}
				}
			}
			
			// 为新建的Entity附加同步标志.
			if(typeof param.sync != "undefined")
			{
				ret.sync = param.sync ? true : false;
			}
			
			// 为新建的Entity附加调用subscribe.
			if(typeof param.subscribe != "undefined")
			{
				for( var topic in param.subscribe )
				{
					var handler = param.subscribe[topic];
					if(typeof handler == "string")
						handler = ret[handler];
					if(typeof handler == "function")
						Event.Subscribe(spp.hitch(ret,handler),topic);
				}
			}

			// 为新建的Entity附加所需PropertyClass.
			if(typeof param.pc != "undefined")
			{
				for( var pcname in param.pc )
				{
					var loaditem = pcmap[pcname];
					if(typeof loaditem == "undefined")
					{
						alert("require undefined propertyclass " + pcname);
						continue;
					}
					if(!loaditem[0])
					{
						Entities.LoadPropertyClassFactory(loaditem[1]);
						loaditem[0] = true;
					}
					var pc = Entities.CreatePropertyClass(ret,pcname);
					// 初始化PropertyClass.
					InitPropertyClass(pc,param.pc[pcname]);
					ret.pcarray[pcname] = pc;
				}
			}
			
			// 为新建的Entity设定一个mesh
			var addMesh = function(pos, libPath, meshFactName, meshObjName)
			{
				var engine = Registry.Get('iEngine');
				var loader = Registry.Get('iLoader');
				
				// 判断meshfact是否已经存在
				if(!engine.FindMeshFactory(meshFactName))
				{
					loader.LoadLibrary(libPath);
				}
				
				var mf = engine.FindMeshFactory(meshFactName);
				if(mf)
				{
					var eng = C3D.engine;
					var sectorlist = eng.sectors;
					if( sectorlist.count )
					{
						var sector = sectorlist.Get(0);
						var meshwrapper = engine.CreateMeshWrapper(mf, meshObjName, sector, pos, true);
						if(meshwrapper)
						{
							ret.pcarray['pcmesh'].SetMesh(meshObjName); // 绑定meshobj
						}
					}
				} else {
					alert("failed to find meshfact!");
					return;
				}
			}
			
			
			if(typeof param.mesh != "undefined")
			{
			
				// 如果没有给位置信息，则提供一个初始位置。
				if(typeof(position) == "undefined") position = [0, 0, 0];
				
				addMesh(position, param.mesh.libPath, param.mesh.factName, ret.name);
			}

			if(typeof(ret.pcarray['pcmesh']) != "undefined")
			{
				var __OldSetVisible = ret.pcarray['pcmesh'].SetVisible;
				var qpcmesh = ret.pcarray['pcmesh'].QueryInterface("iPcMesh");
				
				ret.pcarray['pcmesh'].SetVisible = function(param){
					var visibleFlag = 0;
					var id = C3D.engine.SubscribeFrame(function(){
						visibleFlag ++ ;
						if(param)
						{ //true  need to show.
							if(!qpcmesh.IsVisible())
							{
								__OldSetVisible(param);
							}
						}
						else
						{ //false  need to hide.
							if(qpcmesh.IsVisible())
							{
								__OldSetVisible(param);
							}
						}
						
						if(visibleFlag == 2)
						{
							C3D.engine.UnsubscribeFrame(id);
						}
					});
				}
			}
			
			if(typeof(ret.pcarray['pcmesh']) != "undefined")
			{
				ret.pcarray['pcmesh'].MoveMeshInstant = function( position, rotation, sector, timer ){
					if( typeof rotation == "undefined" )
					{
						var buffer = ret.pcarray['pcmesh'].rotation;
						rotation = [buffer.x, -buffer.y, buffer.z];
					}
					if( typeof sector == "undefined" )
					{
						var sectorlist = C3D.engine.sectors;
						if( sectorlist.count )
						{
							sector = sectorlist.Get(0);
							if(sector)
							{
								var obj = sector.object;
								if(obj)
								{
									var sectorName = obj.name;
								}
							}
						}
					}
					if( typeof timer == "undefined" )
					{
						timer = 300; // differ timer 300ms.
					}
					
					var id = C3D.engine.SubscribeFrame(function(){
						while(true)
						{
							ret.pcarray['pcmesh'].MoveMesh( position, rotation, sectorName );
							System.Sleep(timer);
							C3D.engine.UnsubscribeFrame(id);
							break;
						}
					});
				}
			}
			
			return ret;
		}
		
		// 本代码负责创建AI对象，并附加到ent上。
		// 这个函数的实现类似Entities.CreateEntity,负责从一个JSON对象中创建AI对象，并添加到ent对象上。
		Entities.CreateAI = function(/*Entity*/ent, /*AI_JSON*/param)
		{
			var ai = new Object();
			// 根据传入事件名称调用相应的事件函数。
			var aiOnEvent = function(name, p1, p2, p3, p4, p5)
			{
				var handler = this.eventTable[name];
				if(handler)
				{
					handler.call(this, p1 ,p2, p3, p4, p5);
				}
			}
			ai.onEvent = spp.hitch(ai, aiOnEvent);
			
			// 将JSON中定义的AI事件列表挂在entity上的。
			ai.eventTable = {};
			if(typeof param.event == "object")
			{
				spp.mixin(ai.eventTable, param.event);
			}
			
			// 将AI挂载到对应的entity上。
			ent.AIObject = ai;
			return ent;
		}
		
		
		// 保存Subscribe的事件ID
		var eventMap = [];
		
		// 我们这里保存旧的Subscribe方法，重新覆盖支持智能加载。
		Event.OldSubscribe = Event.Subscribe;
		
		// 重写Event.Subscribe
		Event.Subscribe = function(handle, name)
		{
			var id = Event.OldSubscribe(handle, name);
			// only test
			if(name != "effect.test")
			{
				eventMap.push(id);
			}
			return id;
		}
		
		// 添加UnsubscribeAll事件
		Event.UnsubscribeAll = function()
		{
			for(var i = 0;i < eventMap.length;i ++)
			{
				if(eventMap[i] != undefined)
				{
					Event.Unsubscribe(eventMap[i]);
				}
			}
		}
		
	})();

} catch(e){
	alert(e);
}