/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/
/**
	需要缺省参数的支持，以TODO为搜索进行修改
	
	  1、写到函数中的
	  2、暂时没有写到函数中的
*/
try{

	// 该makePerformFunction函数也是正确的，但是为了更明确意思，具体化成下面的makePerformFunction，有兴趣的可以看下该makePerformFunction。
	
	//arguments为JS中function的参数，任意个数，每个function都有对应的arguments
	function makePerformFunction(pc, funcName /*arg1name, arg2name , ...*/){
		var args = arguments; // pc, "Load",'path','file'
		return function(){      //return 为一个 function，该function就是PerformAction
			var actionArgs = [];
			actionArgs[0] = funcName;
			for(var i = 0; i < arguments.length; i++){ //这里的arguments 是 path, file
				if(arguments[i] == "undefined") return false;
				actionArgs[i+1] = [args[i+2], arguments[i]]; //['path', path]
			}
			return pc.PerformAction.apply(pc, actionArgs); //最终的actionArgs:  'Load', ['path', path], ['file', file]
		}
	}
	
	// function makePerformFunction(pc, funcName /*arg1name, arg2name , ...*/) {
		// if(typeof(arguments) != "undefined")
		// {
			// var len = arguments.length;
			// var args = arguments;
			// switch(len){
			// case 2:
				// return function()
				// {
					// return pc.PerformAction(funcName);
				// }
				// break
			// case 3:
				// return function(param1)
				// {
					// return pc.PerformAction(funcName, [args[2], param1]);
				// }
				// break
			// case 4:
				// return function(param1, param2)
				// {
					// return pc.PerformAction(funcName, [args[2], param1], [args[3], param2]);
				// }
				// break
			// case 5:
				// return function(param1, param2, param3)
				// {
					// return pc.PerformAction(funcName, [args[2], param1], [args[3], param2], [args[4], param3]);
				// }
				// break
			// case 6:
				// return function(param1, param2, param3, param4)
				// {
					// return pc.PerformAction(funcName, [args[2], param1], [args[3], param2], [args[4], param3], [args[5], param4]);
				// }
				// break
			// }
		// }
	// }
	
	function makePropertyFunction(pc, funcName /*arg1name, arg2name , ...*/){
		Object.defineProperty(pc, funcName, {
			get: function()
			{
				return pc.GetProperty(funcName);
			},
			set: function(value)
			{
				if(typeof(value) == "undefined")
					return false;
				return pc.SetProperty(funcName, value);
			}
		});
	}

	// @todo 使用的都是全局函数，需要小心函数名称冲突。
	function PCHelper_pczonemanager(pc)
	{
		// 方法帮助。
		pc.Load = makePerformFunction(pc, "Load",'path', 'file');
	}
	
	function PCHelper_pccommandinput(pc)
	{
		pc.Activate = makePerformFunction(pc, "Activate",'activate');
		pc.Bind = makePerformFunction(pc, "Bind",'trigger', 'command');
		pc.RemoveBind = makePerformFunction(pc, "RemoveBind",'trigger', 'command');
		pc.RemoveAllBinds = makePerformFunction(pc, "RemoveAllBinds");
		pc.LoadConfig = makePerformFunction(pc, "LoadConfig",'prefix');
		pc.SaveConfig = makePerformFunction(pc, "SaveConfig",'prefix');
		
		pc.screenspace = makePropertyFunction(pc, "screenspace");
		pc.cooked = makePropertyFunction(pc, "cooked");
		pc.sendtrigger = makePropertyFunction(pc, "sendtrigger");
	}
	
	function PCHelper_pccollisiondetection(pc)
	{
		//关于iPcCollisionDetection类，官方没有提供任何JS层的方法
	}
	
	function PCHelper_pcactormove(pc)
	{
		// 方法
		pc.Forward = makePerformFunction(pc, "Forward",'start');
		pc.Backward = makePerformFunction(pc, "Backward",'start');
		pc.StrafeLeft = makePerformFunction(pc, "StrafeLeft",'start');
		pc.StrafeRight = makePerformFunction(pc, "StrafeRight",'start');
		pc.RotateLeft = makePerformFunction(pc, "RotateLeft",'start');
		pc.RotateRight = makePerformFunction(pc, "RotateRight",'start');
		pc.Jump = makePerformFunction(pc, "Jump");
		pc.AutoRun = makePerformFunction(pc, "AutoRun",'start');
		pc.Run = makePerformFunction(pc, "Run",'start');
		pc.SetSpeed = makePerformFunction(pc, "SetSpeed",'movement','running','rotation','jumping');
		pc.MouseMove = makePerformFunction(pc, "MouseMove",'x', 'y');
		pc.Clear = makePerformFunction(pc, "Clear");
		pc.ToggleCameraMode = makePerformFunction(pc, "ToggleCameraMode");
		pc.SetAnimation = makePerformFunction(pc, "SetAnimation", 'name', 'cycle');
		pc.SetAnimationName = makePerformFunction(pc, "SetAnimationName", 'mapping', 'name');
		pc.RotateTo = makePerformFunction(pc, "RotateTo", 'yrot');
		
		pc.mousemove = makePropertyFunction(pc, "mousemove");
		pc.mousemove_inverted = makePropertyFunction(pc, "mousemove_inverted");
		pc.mousemove_xfactor = makePropertyFunction(pc, "mousemove_xfactor");
		pc.mousemove_yfactor = makePropertyFunction(pc, "mousemove_yfactor");
		pc.mousemove_accelerate = makePropertyFunction(pc, "mousemove_accelerate");
	}
	
	function PCHelper_pcmesh(pc)
	{
		// 方法帮助。
		pc.SetMesh = makePerformFunction(pc, "SetMesh",'name');
		pc.LoadMesh = makePerformFunction(pc, "LoadMesh",'filename', 'factoryname');
		pc.LoadMeshPath = makePerformFunction(pc, "LoadMeshPath",'path', 'filename', 'factoryname');
		pc.MoveMesh = makePerformFunction(pc, "MoveMesh",'position', 'rotation', 'sector');
		pc.SetAnimation = makePerformFunction(pc, "SetAnimation",'animation', 'cycle', 'reset');
		pc.SetVisible = makePerformFunction(pc, "SetVisible",'visible');
		pc.RotateMesh = makePerformFunction(pc, "RotateMesh",'rotation');
		pc.ClearRotation = makePerformFunction(pc, "ClearRotation");
		pc.LookAt = makePerformFunction(pc, "LookAt",'forward', 'up');
		pc.SetMaterial = makePerformFunction(pc, "SetMaterial",'material');
		pc.CreateEmptyThing = makePerformFunction(pc, "CreateEmptyThing",'factoryname');
		pc.SetShaderVar = makePerformFunction(pc, "SetShaderVar",'name', 'type', 'value');
		pc.CreateEmptyGenmesh = makePerformFunction(pc, "CreateEmptyGenmesh",'factoryname');
		pc.CreateNullMesh = makePerformFunction(pc, "CreateNullMesh",'factoryname', 'min', 'max');
		pc.ParentMesh = makePerformFunction(pc, "ParentMesh",'entity', 'tag');
		pc.ClearParent = makePerformFunction(pc, "ClearParent");
		pc.AttachSocketMesh = makePerformFunction(pc, "AttachSocketMesh", 'socket', 'socket', 'object');
		pc.DetachSocketMesh = makePerformFunction(pc, "DetachSocketMesh", 'socket');
		// 属性
		pc.position = makePropertyFunction(pc, "position");
		pc.fullposition = makePropertyFunction(pc, "fullposition");
		pc.rotation = makePropertyFunction(pc, "rotation");
		pc.eulerrotation = makePropertyFunction(pc, "eulerrotation");
		pc.meshname = makePropertyFunction(pc, "meshname");
		pc.sector = makePropertyFunction(pc, "sector");
		pc.path = makePropertyFunction(pc, "path");
		pc.factory = makePropertyFunction(pc, "factory");
		pc.filename = makePropertyFunction(pc, "filename");
		pc.hitbeam = makePropertyFunction(pc, "hitbeam");
	}
	
	function PCHelper_pcdefaultcamera(pc)
	{
		// 方法帮助。
		pc.SetCamera = makePerformFunction(pc, "SetCamera",'modename');
		pc.SetZoneManager = makePerformFunction(pc, "SetZoneManager",'entity', 'region', 'start');
		pc.SetFollowEntity = makePerformFunction(pc, "SetFollowEntity",'entity');
		// 属性处理:
		// pitchvelocity为read/write，所以可以get/set.
		pc.pitchvelocity = makePropertyFunction(pc, "pitchvelocity");
		pc.pitch = makePropertyFunction(pc, "pitch");
		pc.yaw = makePropertyFunction(pc, "yaw");
		pc.distance = makePropertyFunction(pc, "distance");
	}
	
	function PCHelper_pclinearmovement(pc)
	{
		pc.InitCD = makePerformFunction(pc, "InitCD",'offset', 'body', 'legs');
		pc.SetVelocity = makePerformFunction(pc, "SetVelocity",'velocity');
		pc.SetAngularVelocity = makePerformFunction(pc, "SetAngularVelocity",'velocity');
		pc.hug = makePropertyFunction(pc, "hug");
		pc.speed = makePropertyFunction(pc, "speed");
		pc.anchor = makePropertyFunction(pc, "anchor");
		pc.anchor = makePropertyFunction(pc, "gravity");
	}
	
	function PCHelper_pcmeshselect(pc)
	{
		pc.SetCamera = makePerformFunction(pc, "SetCamera",'entity');
		pc.SetMouseButtons = makePerformFunction(pc, "SetMouseButtons",'buttons');
		pc.global = makePropertyFunction(pc, "global");
		pc.follow = makePropertyFunction(pc, "follow");
	}
	
	function PCHelper_pclight(pc)
	{
		pc.SetLight = makePerformFunction(pc, "SetLight",'name');
		pc.CreateLight = makePerformFunction(pc, "CreateLight",'name', 'sector', 'pos', 'radius', 'color');
		pc.ChangeColor = makePerformFunction(pc, "ChangeColor",'color');
		pc.MoveLight = makePerformFunction(pc, "MoveLight",'pos', 'sector');
		pc.ParentMesh = makePerformFunction(pc, "ParentMesh",'entity', 'tag');
		pc.ClearParent = makePerformFunction(pc, "ClearParent");
	}
	
	function PCHelper_pctimer(pc)
	{
		pc.WakeUp = makePerformFunction(pc, "WakeUp",'time', 'repeat', 'name');
		pc.Clear = makePerformFunction(pc, "Clear",'name');
	}
	
	function PCHelper_pcmover(pc)
	{
		pc.MoveTo = makePerformFunction(pc, "MoveTo",'sectorname', 'position', 'sqradius');
		pc.moving = makePropertyFunction(pc, "moving");
	}
	
	function PCHelper_pctrigger(pc)
	{
		pc.SetupTriggerSphere = makePerformFunction(pc, "SetupTriggerSphere",'sector', 'position', 'radius');
		pc.enabled = makePropertyFunction(pc, "enabled");
		pc.monitor = makePropertyFunction(pc, "monitor");
		pc.type = makePropertyFunction(pc, "type");
		pc.follow = makePropertyFunction(pc, "follow");
	}
	
	function PCHelper_pcinventory(pc)
	{
		
	}
	
	function PCHelper_pcnewcamera(pc)
	{
		
	}
	
	function PCHelper_pcsimplecamera(pc)
	{
		pc.SetPosition = makePerformFunction(pc, "SetPosition",'campos', 'lookat');
	}
	
	function PCHelper_pcpathfinder(pc)
	{
		pc.Seek = makePerformFunction(pc, "Seek",'sectorname', 'position');
		pc.Interrupt = makePerformFunction(pc, "Interrupt");
	}
	
	function PCHelper_pcsteer(pc)
	{
		pc.Interrupt = makePerformFunction(pc, "Interrupt");
	}
	
	function PCHelper_pcmechsys(pc)
	{
		pc.SetSystem = makePerformFunction(pc, "SetSystem",'dynsys');
		pc.SetGravity = makePerformFunction(pc, "SetGravity",'plugin');
		pc.SetStepTime = makePerformFunction(pc, "SetStepTime",'time');
	}
	
	function PCHelper_pcmechobject(pc)
	{
		pc.InitPhys = makePerformFunction(pc, "InitPhys",'mass', 'friction', 'elasticity', 'density', 'softness', 'lift', 'drag');
		pc.MakeStatic = makePerformFunction(pc, "MakeStatic",'static');
		pc.SetSystem = makePerformFunction(pc, "SetSystem",'systempcent', 'systempctag');
		pc.SetMesh = makePerformFunction(pc, "SetMesh",'mechpctag');
		pc.SetColliderBoundingSphere = makePerformFunction(pc, "SetColliderBoundingSphere",'radiusadjustment');
		pc.SetColliderSphere = makePerformFunction(pc, "SetColliderSphere",'radius', 'offset');
		pc.SetColliderCylinder = makePerformFunction(pc, "SetColliderCylinder",'length', 'radius', 'axis', 'offset', 'angle');
		pc.SetColliderBoundingBox = makePerformFunction(pc, "SetColliderBoundingBox",'sizeadjustment');
	}
	
	function PCHelper_pcsoundsource(pc)
	{
		pc.Play = makePerformFunction(pc, "Play");
		pc.Stop = makePerformFunction(pc, "Stop");
		pc.Pause = makePerformFunction(pc, "Pause");
		pc.Unpause = makePerformFunction(pc, "Unpause");
		pc.soundname = makePropertyFunction(pc, "soundname");
		pc.mode = makePropertyFunction(pc, "mode");
		pc.volume = makePropertyFunction(pc, "volume");
		pc.loop = makePropertyFunction(pc, "loop");
	}
	
	function PCHelper_pcprojectile(pc)
	{
		pc.Start = makePerformFunction(pc, "Start",'direction', 'speed', 'maxdist', 'maxhits');
		pc.Interrupt = makePerformFunction(pc, "Interrupt");
		pc.moving = makePropertyFunction(pc, "moving");
	}
	
	function PCHelper_pcmechbalancedgroup(pc)
	{
		
	}

	function PCHelper_pcmechjoint(pc)
	{
		
	}

	function PCHelper_pcmechthrustercontroller(pc)
	{
		
	}

	// function PCHelper_pcmechthrusterreactionary(pc)
	// {
		
	// }

} catch(e){
	alert(e);
}
