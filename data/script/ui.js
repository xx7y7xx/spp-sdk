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
	// 初始化UI。
	(function() {

		System.Report("[Debug] UI initialize...", 0, "");
		Plugin.Load("spp.script.gui.cegui");
		GUI.Initialize();
		//TODO:切换为硬鼠标后，UI alpha通道会出现异常，之后来处理
		//isEnable:当值为true的时候，允许使用软鼠标，此时硬鼠标设为空，当值为false的时候，禁止使用软鼠标，根据传人的cursor来设置硬鼠标的指针图标
		//GUI.EnableSoftMouse目前不被支持
		GUI.EnableSoftMouse = function(isEnable,cursor)
		{
			alert("EnableSoftMouse current does't support!");
			return false;
			
			if(isEnable)
			{
				GUI.MouseCursor.SetVisible(true);
				if(GUI.MouseCursor.IsVisible() == true)
				{
					var state = C3D.g2d.SetMouseCursor(C3D.g2d.cursor.csmcNone);
					if(state == false)
					{
						System.Report("Failed to SetMouseCursor", 0, "error");
					}
				}
			}
			else
			{
				GUI.MouseCursor.SetVisible(false);
				if(GUI.MouseCursor.IsVisible() == false)
				{
					var state = C3D.g2d.SetMouseCursor(cursor);
					if(state == false)
					{
						System.Report("Failed to SetMouseCursor", 0, "error");
					}
				}
			}
		}
		
		GUI.CreateObjectScheme = function (schemedata,path)
		{
			// 进入UI资源目录。
			VFS.PushDir(path);
			
			if ( typeof(schemedata.scheme) != "undefined" )
			{
				var scheme = GUI.Schemes.Load(schemedata.scheme.filename);
				if(!scheme)
				{
					System.Report("Failed to load " + schemedata.scheme.filename + "", 0, "error");
				}
				// 设置鼠标指针主题
				// schemedata.scheme.mourseImgSet and schemedata.scheme.mourseImgName are deprecated
				if(typeof(schemedata.scheme.mouseImgSet) == "undefined" || typeof(schemedata.scheme.mouseImgName) == "undefined")
				{
					System.Report("'schemedata.scheme.mourseImgSet' is deprecated. Use 'schemedata.scheme.mouseImgSet' instead.\n\
	'schemedata.scheme.mourseImgName' is deprecated. Use 'schemedata.scheme.mouseImgName' instead.\n\
	Call Stack :\n\
	Function Name : GUI.CreateObjectScheme\n\
	Script Name : ui.js\n", 2, "[Warning]");
					GUI.System.SetDefaultMouseCursor(schemedata.scheme.mourseImgSet, schemedata.scheme.mourseImgName);
				}
				else
				{
					GUI.System.SetDefaultMouseCursor(schemedata.scheme.mouseImgSet, schemedata.scheme.mouseImgName);
				}
			}
			if(typeof (schemedata.freeTypeFont) != "undefined")
			{
				for ( var topic in schemedata.freeTypeFont )
				{
					if(typeof (schemedata.freeTypeFont[topic].pointSize) == "undefined")
					{
						System.Report("must specified pointSize! Failed to CreateFont " + topic + "", 0, "error");
					}
					else if(typeof (schemedata.freeTypeFont[topic].filename) == "undefined")
					{
						System.Report("must specified filename! Failed to CreateFont " + topic + "", 0, "error");	 
					}
					else
					{
					    //topic -- 创建的字体的名称 
						//pointSize -- 字体大小
						//filename -- 字体文件的路径 
						//antiAliased -- 是否打开抗锯齿
						//autoScaled -- 是否自动缩放
						//nativeHorzRes -- 本地贴图的宽度
						//nativeVertRes -- 本地贴图的高度

						var font = GUI.Fonts.CreateFont(
							topic,                                        
							schemedata.freeTypeFont[topic].pointSize,     
							schemedata.freeTypeFont[topic].filename,      
							schemedata.freeTypeFont[topic].antiAliased,   
							schemedata.freeTypeFont[topic].autoScaled,    
							schemedata.freeTypeFont[topic].nativeHorzRes, 
							schemedata.freeTypeFont[topic].nativeVertRes
						);
						if(!font)
						{
							System.Report("Failed to CreateFont " + topic + "", 0, "error");	 
						}
					}
				}
			}
			VFS.PopDir();
		}
		GUI.CreateObjectLayout = function (layoutdata,path){
		    VFS.PushDir(path);
		    
		    if ( typeof layoutdata != "undefined" )
			{
				var win = GUI.Windows.LoadWindowLayout(layoutdata.name);
				if(!win)
				{
					System.Report("Failed to LoadWindowLayout " + layoutdata.name + "", 0, "error");	    
				}
				// 设置根窗口
				GUI.System.root = win;
			}
			
			
			for(var id in layoutdata.window) {
				//通过JSON中的id获取窗口的控件类型
                w = GUI.Windows.Get(id); 
				//判断控件对象是否获取成功
                if (!w) {
                    System.Report("Failed to get " + id + "", 0, "warning");
                }
                //给JS对象添加属性
                if (typeof(layoutdata.window[id].property) != "undefined") {
                    var propt = layoutdata.window[id].property;
                    
                    for(var propt_name in propt)
                    {
                        propt[propt_name](w,propt_name);
                    }
                }
                //订阅UI事件
				//支持的JSON格式
				/*
				var funcObj = function(){
					alert("funcObj");
				}
				method : {
					"funcName" : function(){
						alert("funcName");
					}
				}
				event : {
					"MouseClick" : [
						"funcName",
						"funcName"
					],
					"MouseEnter" : [
						funcObj,
						funcObj
					],
					"MouseLeave" : funcObj,
					"MouseWheel" : "funcName"
				}
				*/
                if (typeof(layoutdata.window[id].event) != "undefined") {
                    for(var name in layoutdata.window[id].event) {
						var handler = layoutdata.window[id].event[name];
						if (typeof(handler) == "function") {
							w.Subscribe(name,spp.hitch(w,handler));
						}
						else if (typeof(handler) == "string") {
							var stringHandler = layoutdata.method[handler];
							w.Subscribe(name,spp.hitch(w,stringHandler));
						}
						else if (typeof(handler) == "object") {
							for(var handlerName in handler)
							{
								var objectHandler = handler[handlerName];
								if (typeof(objectHandler) == "string") {
									objectHandler = layoutdata.method[objectHandler];
								}
								w.Subscribe(name,spp.hitch(w,objectHandler));
							}
						}
					}
                }
				//订阅全局事件
			    if(typeof(layoutdata.window[id].subscribe) != "undefined")
			    {
				    for( var topic in layoutdata.window[id].subscribe )
				    {
					    var handler = layoutdata.window[id].subscribe[topic];
						var eventID;
						//由于objlayout.js中对Event.Subscribe进行了拦截，所以我们需要避免将事件保存在objlayout.js的eventmap中
						if(typeof(Event.OldSubscribe) == "undefined")
						{
							eventID = Event.Subscribe(spp.hitch(w,handler), topic);
						}
						else{
							eventID = Event.OldSubscribe(spp.hitch(w,handler), topic);
						}
						w.eventMap = [];
						w.eventMap[topic] = eventID;
				    }
			    }
            }
			//调整窗口布局
			if(typeof(layoutdata.adjustLayout) != "undefined")
			{
				layoutdata.adjustLayout();
			}
            VFS.PopDir();
		}
		
		GUI.UnsubscribeAll = function (layoutdata){
		    for(var id in layoutdata.window) {
				//通过JSON中的id获取窗口
                w = GUI.Windows.Get(id); 
                if (!w) {
					System.Report("Failed to get " + id + "", 0, "warning");
                }
                //订阅全局事件
			    if(typeof(layoutdata.window[id].subscribe) != "undefined")
			    {
				    for( var topic in layoutdata.window[id].subscribe )
				    {
					    var handler = layoutdata.window[id].subscribe[topic];
						eventID = w.eventMap[topic];
					    Event.Unsubscribe(eventID);
				    }
			    }
            }
		}
	})();
}
catch(e)
{
	alert(e);
}