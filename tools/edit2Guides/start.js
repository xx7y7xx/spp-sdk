/**************************************************************************
 *
 *  This file is part of the UGE(Uniform Game Engine).
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *
 *  See http://uge.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://uge.spolo.org/  sales@spolo.org uge-support@spolo.org
 *
**************************************************************************/

try {

	// 方便调试。
	var iReporter = Registry.Get("iReporter");
	require("console.js");

	//为路径末尾添加一个路径分割符——如果不是以分隔符结尾。
	function  AppendSeperator(path)
	{
		if(path.length == 0)
			return ((System.osName == "win32") ? "\\" : "/");

		var lastchar = path.charAt(path.length-1);
		if(lastchar != '/' && lastchar != '\\')
		{
			return path + ((System.osName == "win32") ? "\\" : "/");
		}
		return path;
	}
	
	function GetFullPath(path)
	{
		var fullpath;
		if(System.osName == "win32")
		{
			if(path.length > 2 && path[1] == ':')
			{
				fullpath = path;
			}else{
				fullpath = System.StartupPath()　+ "\\";
				fullpath += path;
			}
		}else{
			if(path[0] == '/')
			{
				fullpath = path;
			}else{
				fullpath = System.StartupPath() + "/";
				fullpath += path;
			}
		}
		return fullpath;
	}
	
	// billboard必须一个font server的支持。"crystalspace.font.server.default","iFontServer"
	var fntserver = Registry.Get("iFontServer","crystalspace.font.server.default");
	
	Plugin.Load("spp.script.cspace.core");
	
	// 加载 GUI 插件
	Plugin.Load("spp.script.gui.cegui");
	
	// 打开应用程序窗口
	Event.Send("application.open", true);
	
	// 加载系统中的 js 库
	require("loader.js");	// 加载场景使用的库
	require("cursesui.js"); 	// 在CUI上画图用的

	//Mount Root路径。
	//第一个选项是从命令行的rootdir获取。
	var rootdir = CmdLine.GetOption("rootdir");
	if(rootdir)
	{
		VFS.Mount("/",AppendSeperator(GetFullPath(rootdir)));
	}else
	{//否则以当前路径为root路径。
		VFS.Mount("/",AppendSeperator(System.StartupPath()));
	}

	// 动态创建场景文件，从命令行获取
	var scenefile = "/art/world.xml";
	if(CmdLine.GetOption("scene"))
	{
		scenefile = CmdLine.GetOption("scene");
	}
	
	//判断是否为多线程加载
	var isThreadedLoader = false;
	if(CmdLine.GetOption("thread")){
		var isThreadedLoader = true;
	}
	if(isThreadedLoader){
		console.info("多线程加载开始！！！");
		// 多线程加载开始
		Loader.Load({
			stages : [
				{
					name : "shader",
					weighing : 2, // 加载时间权重
					filename : "/art/shaderlib.xml"
				},
				// {
					// name : "sound",
					// weighing : 10,
					// filename : "/art/soundlib.xml"
				// },
				{
					name : "texture",
					weighing : 40,
					filename : "/art/materials.xml"
				},
				{
					name : "material",
					weighing : 2,
					filename : "/art/materials.xml"
				},
				{
					name : "meshfact",
					weighing : 40,
					filename : "/art/factorylib.xml"
				},
				{
					name : "meshobj",
					weighing : 2,
					filename : "/art/world.xml"
				}
			],
			onprocessWorldNode : onprocessWorldNode,
			onloadend : onloadend,
			onprogress : onprogress
		});
	}else{
		console.info("单线程加载开始！！！");
		var bProcSuc = false;
		do{
			//场景文件不存在。
			if(!VFS.Exists(scenefile))
			{
				System.exitcode = 10;
				System.exitmsg = "world not found!!";
				break;
			}
				
			var xml_mainworld = new xmlDocument();
			var worldfile = VFS.Open(scenefile);
			if(!worldfile)
			{
				System.exitcode = 11;
				System.exitmsg = "cant open world!!";
				break;
			}
			
			if(!xml_mainworld.Parse(worldfile))
			{//分析错误
				System.exitcode = 12;
				System.exitmsg = "world parse error!!";
				break;
			}
			
			var node_world = xml_mainworld.root.GetChild("world");
			if(!node_world)
			{
				alert('world file no world tag');
				break;
			}
			
			// 在加载world之前，添加woman，camera, star等mesh
			onprocessWorldNode(node_world);
			
			// 加载场景文件。
			if(!C3D.loader.LoadMap(node_world))
			{
				System.exitcode = 16;
				System.exitmsg = "failed to load world node!!";
				break;
			}
			
			// 释放内存
			C3D.engine.Prepare();
			
			//场景加载完毕
			onloadend();
				
			bProcSuc = true;
		}while(false);
		
		if(!bProcSuc)
		{
			if(System.exitcode != 0)
				alert("Error Code ", System.exitcode, " : ", System.exitmsg);
			else
				alert("proc failed");
			System.Quit();
		}
	}
	
	/**
	 * @brief 通过这个回调函数来往world中添加新的元素。
	 */
	//@brief 可以往`<world>`节点中添加新的节点。
	//方便edit2Position工具处理。
	function onprocessWorldNode(node_world)
	{
		var sector_world = node_world.GetChild("sector");
		
		var meshobjSet = sector_world.GetChildren("meshobj");
		if(!meshobjSet)
		{//没有任何meshObjs需要显示，报错退出！
			System.exitcode = 15;
			System.exitmsg = "no meshobjs in world!!";
			return false;
		}
		
		var has_mesh_camera = false;
		while(!has_mesh_camera && meshobjSet.HasNext())
		{
			var node = meshobjSet.Next();
			//FIXME: 不能用mesh_camera作为名称，采用一个超过12个字符的名称作为名称，以规避美术重复命名！
			// fixed : mesh_camera 修改为  mesh___camera
			if(node.GetAttributeValue("name") == "mesh___camera")
			{
				has_mesh_camera = true;
				break;
			}
		}
		
		//增加camera meshobj
		if(!has_mesh_camera)
		{
			// 未发现场景中包含一个名为mesh_camera的meshobj.从/tools/template/加载之，
			// 并加入到sector_world标签中。还需要把工厂加入到world里。
			
			System.Report("There is no mesh_camera meshobj in world.xml,",
				iReporter.DEBUG/* 4 */, "");
			System.Report("Use /tools/template instead.",
				iReporter.DEBUG/* 4 */, "");
			
			// addMeshFact2SceneTree([0,0,0], "/tools/mesh_camera/mesh_camera.xml", "genCube__camera", "mesh___camera");
			
			sector = node_world.GetChild("sector");
			
			library = node_world.CreateChild( xmlDocument.NODE_ELEMENT, sector);
			library.value = "library";
			libraryText = library.CreateChild( xmlDocument.NODE_TEXT);
			libraryText.value = "/tools/mesh_camera/mesh_camera.xml";
			
			meshobj = sector.CreateChild(xmlDocument.NODE_ELEMENT);
			meshobj.value = "meshobj";
			meshobj.SetAttribute("name", "mesh___camera");
			plugin = meshobj.CreateChild(xmlDocument.NODE_ELEMENT);
			plugin.value = "plugin";
			tplg = plugin.CreateChild(xmlDocument.NODE_TEXT);
			tplg.value = "crystalspace.mesh.loader.genmesh";
			paramsw = meshobj.CreateChild(xmlDocument.NODE_ELEMENT);
			paramsw.value = "params";
			factory = paramsw.CreateChild(xmlDocument.NODE_ELEMENT);
			factory.value = "factory";
			tfan = factory.CreateChild(xmlDocument.NODE_TEXT);
			tfan.value = "genCubeCamera";
			movew = meshobj.CreateChild(xmlDocument.NODE_ELEMENT);
			movew.value = "move";
			movecv = movew.CreateChild(xmlDocument.NODE_ELEMENT);
			movecv.value = "v";
			movecv.SetAttribute("x",0);
			movecv.SetAttribute("y",0);
			movecv.SetAttribute("z",0);
		}
		
		//增加 woman meshobj
		var has_mesh_woman = false;
		while(!has_mesh_woman && meshobjSet.HasNext())
		{
			var node3 = meshobjSet.Next();
			if(node3.GetAttributeValue("name") == "woman")
			{
				has_mesh_woman = true;
				break;
			}
		}
		if(!has_mesh_woman)
		{
			System.Report("There is no woman meshobj in world.xml,",
				iReporter.DEBUG/* 4 */, "");
			System.Report("Use /tools/template instead.",
				iReporter.DEBUG/* 4 */, "");
			
			sector3 = node_world.GetChild("sector");
			
			library3 = node_world.CreateChild( xmlDocument.NODE_ELEMENT, sector3);
			library3.value = "library";
			libraryText3 = library3.CreateChild( xmlDocument.NODE_TEXT);
			libraryText3.value = "/tools/mesh_woman/world_woman.xml";
			
			meshobj3 = sector3.CreateChild(xmlDocument.NODE_ELEMENT);
			meshobj3.value = "meshobj";
			meshobj3.SetAttribute("name", "woman");
			plugin3 = meshobj3.CreateChild(xmlDocument.NODE_ELEMENT);
			plugin3.value = "plugin";
			tplg3 = plugin3.CreateChild(xmlDocument.NODE_TEXT);
			tplg3.value = "crystalspace.mesh.loader.sprite.cal3d";
			paramsw3 = meshobj3.CreateChild(xmlDocument.NODE_ELEMENT);
			paramsw3.value = "params";
			factory3 = paramsw3.CreateChild(xmlDocument.NODE_ELEMENT);
			factory3.value = "factory";
			tfan3 = factory3.CreateChild(xmlDocument.NODE_TEXT);
			tfan3.value = "woman";
			movew3 = meshobj3.CreateChild(xmlDocument.NODE_ELEMENT);
			movew3.value = "move";
			movecv3 = movew3.CreateChild(xmlDocument.NODE_ELEMENT);
			movecv3.value = "v";
			movecv3.SetAttribute("x",0);
			movecv3.SetAttribute("y",0);
			movecv3.SetAttribute("z",0);
		}
		
		var sector_world = node_world.GetChild("sector");
		if(!sector_world)
		{
			System.exitcode = 14;
			System.exitmsg = "no sectors in world!!";
			return false;
		}
		var meshobjSet = sector_world.GetChildren("meshobj");
		if(!meshobjSet)
		{//没有任何meshObjs需要显示，报错退出！
			System.exitcode = 15;
			System.exitmsg = "no meshobjs in world!!";
			return false;
		}
	}
	
	//@brief 通过这个函数可以获得进度信息
	function onprogress(pe)
	{
		//以滚动条方式显示进度。
		CursesUI.ProgressBar(pe.total, pe.loaded);
	}
	
	//@brief 场景加载结束之后调用这些处理
	function onloadend()
	{
		// 这里自定义一个文件加载函数，方便使用
		var iload = function(file){
			if(!load(file)){
				alert("could not to load the file '"+file+"'!!");
			}
		}
		
		// 加载逻辑相关的文件
		iload('/tools/logic/logic_index.js');
		
		// 加载系统中的 js 库
		require("objlayout.js");	// 这里是加载 Entity 支持库
		require("ui.js");	// 这里加载 GUI 支持库
		
		// 加载UI相关的文件
		iload('/tools/ui/ui.scheme.js');
		iload('/tools/ui/zhucaidan.layout.js');
		// 创建GUI所需要的scheme和字体，通常文件名为 ui.scheme.js ，其中的对象名为 UIDATA;
		GUI.CreateObjectScheme(UIDATA,"/tools/ui/data"); 
		GUI.CreateObjectLayout(ZHUCAIDAN_LAYOUT,"/tools/ui/data");
		iload('/tools/ui/ui_function.js');
		
		if(!FUNCTION_DATA){
			alert("ui_function.js is not found ！");
			return ;
		}
		
		//下面这个方式，通过传入一个对象来初始化。这里我们以JSON格式来定义这个初始化对象。（比如`PLAYER`）
		//这个对象可以被保存在文件中，可以动态加载，加载进来就可以定义若干entity.
		//这里的entity你可以随意添加属性，就是普通的js对象！
		//我们的编辑器将会编辑产生一个entity def json，加载进来就是Entities.CreateEntity中的参数。
		
		iCamera = Entities.CreateEntity(CAMERA);
		player = Entities.CreateEntity(PLAYER);
		
		iCamera.pcarray["pcdefaultcamera"].PerformAction("SetFollowEntity",['entity','player']);
		iCamera.pcarray["pccommandinput"].PerformAction("Activate", ['activate', false]);
		iCamera.pcarray["pcdefaultcamera"].PerformAction("SetCamera",['modename','thirdperson']);
		iCamera.pcarray["pcdefaultcamera"].SetProperty("distance", 3.2);
		iCamera.pcarray["pcdefaultcamera"].SetProperty("pitch", -0.069999957);
		player.pcarray['pclinearmovement'].SetProperty('gravity', 19.6);
		iCamera.pcarray['pclinearmovement'].SetProperty('gravity', 0);
		player.pcarray['pcmesh'].PerformAction(
			'MoveMesh', [
				'position', [
					0,0,0
				]
			]
		);
		// 获得 3D 支持，渲染场景。
		engine = Registry.Get('iEngine');
		g3d = Registry.Get('iGraphics3D');
		var count = Event.InstallHelper('3d','frame');
		
		//添加碰撞检测
		var sec = engine.sectors.Get(0);
		if(sec)
		{
			var max = sec.meshes.count;
			for(var i = 0; i < max;i++)
			{
				var meshwrapper = sec.meshes.Get(i);
				if(meshwrapper)
				{
					// alert('begin mesh ',meshwrapper.object.name);
					var ok = C3D.colsys.InitializeCollision(meshwrapper);
					// alert('end ',ok);
				}
			}
		}
		
		console.info('\n' + '工具操作说明 : ');
		console.info('键盘操作 : ');
		console.info('W/↑ S/↓ : 前进 后退');
		console.info('A/← D/→ : 左转 右转');
		console.info('Q E : 左平移 右平移');
		console.info('T Y : 上平移 下平移');
		console.info('R F : 抬头 低头');
		console.info('小键盘+ : 提高场景整体亮度（按住不放，持续执行）');
		console.info('小键盘- : 降低场景整体亮度（按住不放，持续执行）');
		console.info('Home : 恢复场景亮度');
		console.info('1 2 3 4 5 : 改变移动速度');
		console.info('Z : 打印坐标');
		console.info('Esc : 退出程序');
		console.info('鼠标操作 : ');
		console.info('滚轮向前 ： 拉近摄像机距离');
		console.info('滚轮向后 ： 拉远摄像机距离');
	}
}catch(e){
	alert('error:',e);
}
