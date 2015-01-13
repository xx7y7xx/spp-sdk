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
		System.Report("[Debug] wxui initialize...", 0, "");
		Plugin.Load("spp.gui.wxwidget");
		EVENT_MAP = {
			"onCommandButtonClicked"       : WGUI.EventID.onCommandButtonClicked		,
			"onCommandCheckboxClicked"     : WGUI.EventID.onCommandCheckboxClicked      ,
			"onCommandChoiceSelected"      : WGUI.EventID.onCommandChoiceSelected       ,
			"onCommandListboxSelected"     : WGUI.EventID.onCommandListboxSelected      ,
			"onCommandListboxDoubleclicked": WGUI.EventID.onCommandListboxDoubleclicked ,
			"onCommandChecklistboxToggled" : WGUI.EventID.onCommandChecklistboxToggled  ,
			"onCommandMenuSelected"        : WGUI.EventID.onCommandMenuSelected         ,
			"onCommandSliderUpdated"       : WGUI.EventID.onCommandSliderUpdated        ,
			"onCommandRadioboxSelected"    : WGUI.EventID.onCommandRadioboxSelected     ,
			"onCommandRadiobuttonSelected" : WGUI.EventID.onCommandRadiobuttonSelected  ,
			"onCommandScrollbarUpdated"    : WGUI.EventID.onCommandScrollbarUpdated     ,
			"onCommandVlboxSelected"       : WGUI.EventID.onCommandVlboxSelected        ,
			"onCommandComboboxSelected"    : WGUI.EventID.onCommandComboboxSelected     ,
			"onCommandToolRclicked"        : WGUI.EventID.onCommandToolRclicked         ,
			"onCommandToolEnter"           : WGUI.EventID.onCommandToolEnter            ,
			"onCommandSpinctrlUpdated"     : WGUI.EventID.onCommandSpinctrlUpdated      ,
			"onCommandSpinctrldoubleUpdate": WGUI.EventID.onCommandSpinctrldoubleUpdate ,
			"onCommandToolDropdownClicked" : WGUI.EventID.onCommandToolDropdownClicked  ,
			"onCommandComboboxDropdown"    : WGUI.EventID.onCommandComboboxDropdown     ,
			"onCommandComboboxCloseup"     : WGUI.EventID.onCommandComboboxCloseup      ,
			"onLeftDown"                   : WGUI.EventID.onLeftDown                    ,
			"onLeftUp"                     : WGUI.EventID.onLeftUp                      ,
			"onMiddleDown"                 : WGUI.EventID.onMiddleDown                  ,
			"onMiddleUp"                   : WGUI.EventID.onMiddleUp                    ,
			"onRightDown"                  : WGUI.EventID.onRightDown                   ,
			"onRightUp"                    : WGUI.EventID.onRightUp                     ,
			"onMotion"                     : WGUI.EventID.onMotion                      ,
			"onEnterWindow"                : WGUI.EventID.onEnterWindow                 ,
			"onLeaveWindow"                : WGUI.EventID.onLeaveWindow                 ,
			"onLeftDclick"                 : WGUI.EventID.onLeftDclick                  ,
			"onMightDclick"                : WGUI.EventID.onMightDclick                 ,
			"onRightDclick"                : WGUI.EventID.onRightDclick                 ,
			"onSetFocus"                   : WGUI.EventID.onSetFocus                    ,
			"onKillFocus"                  : WGUI.EventID.onKillFocus                   ,
			"onChildFocus"                 : WGUI.EventID.onChildFocus                  ,
			"onMousewhell"                 : WGUI.EventID.onMousewhell                  ,
			"onAux1Down"                   : WGUI.EventID.onAux1Down                    ,
			"onAux1Up"                     : WGUI.EventID.onAux1Up                      ,
			"onAux1Dclick"                 : WGUI.EventID.onAux1Dclick                  ,
			"onAux2Down"                   : WGUI.EventID.onAux2Down                    ,
			"onAux2Up"                     : WGUI.EventID.onAux2Up                      ,
			"onAux2Dclick"                 : WGUI.EventID.onAux2Dclick                  ,
			"onChar"                       : WGUI.EventID.onChar                        ,
			"onAfterChar"                  : WGUI.EventID.onAfterChar                   ,
			"onCharHook"                   : WGUI.EventID.onCharHook                    ,
			"onNavigationKey"              : WGUI.EventID.onNavigationKey               ,
			"onKeyDown"                    : WGUI.EventID.onKeyDown                     ,
			"onKeyUp"                      : WGUI.EventID.onKeyUp                       ,
			"onHotkey"                     : WGUI.EventID.onHotkey                      ,
			"onSetCursor"                  : WGUI.EventID.onSetCursor                   ,
			"onScrollTop"                  : WGUI.EventID.onScrollTop                   ,
			"onScrollBottom"               : WGUI.EventID.onScrollBottom                ,
			"onScrollLineup"               : WGUI.EventID.onScrollLineup                ,
			"onScrollLinedown"             : WGUI.EventID.onScrollLinedown              ,
			"onScrollPageup"               : WGUI.EventID.onScrollPageup                ,
			"onScrollPagedown"             : WGUI.EventID.onScrollPagedown              ,
			"onScrollThumbtrack"           : WGUI.EventID.onScrollThumbtrack            ,
			"onScrollThumbrelease"         : WGUI.EventID.onScrollThumbrelease          ,
			"onScrollChanged"              : WGUI.EventID.onScrollChanged               ,
			"onSpinUp"                     : WGUI.EventID.onSpinUp                      ,
			"onSpinDown"                   : WGUI.EventID.onSpinDown                    ,
			"onSpin"                       : WGUI.EventID.onSpin                        ,
			"onScrollwinTop"               : WGUI.EventID.onScrollwinTop                ,
			"onScrollwinBottom"            : WGUI.EventID.onScrollwinBottom             ,
			"onScrollwinLineup"            : WGUI.EventID.onScrollwinLineup             ,
			"onScrollwinLinedown"          : WGUI.EventID.onScrollwinLinedown           ,
			"onScrollwinPageup"            : WGUI.EventID.onScrollwinPageup             ,
			"onScrollwinPagedown"          : WGUI.EventID.onScrollwinPagedown           ,
			"onScrollwinThumbtrack"        : WGUI.EventID.onScrollwinThumbtrack         ,
			"onScrollwinThumbrelease"      : WGUI.EventID.onScrollwinThumbrelease       ,
			"onSize"                       : WGUI.EventID.onSize                        ,
			"onSizing"                     : WGUI.EventID.onSizing                      ,
			"onMove"                       : WGUI.EventID.onMove                        ,
			"onMoving"                     : WGUI.EventID.onMoving                      ,
			"onMoveStart"                  : WGUI.EventID.onMoveStart                   ,
			"onMoveEnd"                    : WGUI.EventID.onMoveEnd                     ,
			"onCloseWindow"                : WGUI.EventID.onCloseWindow                 ,
			"onEndSession"                 : WGUI.EventID.onEndSession                  ,
			"onQueryEndSession"            : WGUI.EventID.onQueryEndSession             ,
			"onHibernate"                  : WGUI.EventID.onHibernate                   ,
			"onActivateApp"                : WGUI.EventID.onActivateApp                 ,
			"onActivate"                   : WGUI.EventID.onActivate                    ,
			"onCreate"                     : WGUI.EventID.onCreate                      ,
			"onDestroy"                    : WGUI.EventID.onDestroy                     ,
			"onShow"                       : WGUI.EventID.onShow                        ,
			"onIconize"                    : WGUI.EventID.onIconize                     ,
			"onMaximize"                   : WGUI.EventID.onMaximize                    ,
			"onMouseCaptureChanged"        : WGUI.EventID.onMouseCaptureChanged         ,
			"onMouseCaptureLost"           : WGUI.EventID.onMouseCaptureLost            ,
			"onPaint"                      : WGUI.EventID.onPaint                       ,
			"onEraseBackground"            : WGUI.EventID.onEraseBackground             ,
			"onNcPaint"                    : WGUI.EventID.onNcPaint                     ,
			"onMenuOpen"                   : WGUI.EventID.onMenuOpen                    ,
			"onMenuCLose"                  : WGUI.EventID.onMenuCLose                   ,
			"onMenuHighlight"              : WGUI.EventID.onMenuHighlight               ,
			"onContextMenu"                : WGUI.EventID.onContextMenu                 ,
			"onSysColourChanged"           : WGUI.EventID.onSysColourChanged            ,
			"onDisplayChanged"             : WGUI.EventID.onDisplayChanged              ,
			"onQueryNewPalette"            : WGUI.EventID.onQueryNewPalette             ,
			"onPaletteChanged"             : WGUI.EventID.onPaletteChanged              ,
			"onJoyButtonDown"              : WGUI.EventID.onJoyButtonDown               ,
			"onJoyButtonUp"                : WGUI.EventID.onJoyButtonUp                 ,
			"onJoyMove"                    : WGUI.EventID.onJoyMove                     ,
			"onJoyZmove"                   : WGUI.EventID.onJoyZmove                    ,
			"onDropFiles"                  : WGUI.EventID.onDropFiles                   ,
			"onInitDialog"                 : WGUI.EventID.onInitDialog                  ,
			"onUpdateUi"                   : WGUI.EventID.onUpdateUi                    ,
			"onCommandTextCopy"            : WGUI.EventID.onCommandTextCopy             ,
			"onCommandTextCut"             : WGUI.EventID.onCommandTextCut              ,
			"onCommandTextPaste"           : WGUI.EventID.onCommandTextPaste            ,
			"onCommandLeftClick"           : WGUI.EventID.onCommandLeftClick            ,
			"onCommandLeftDclick"          : WGUI.EventID.onCommandLeftDclick           ,
			"onCommandRightClick"          : WGUI.EventID.onCommandRightClick           ,
			"onCommandRightDclick"         : WGUI.EventID.onCommandRightDclick          ,
			"onCommandSetFocus"            : WGUI.EventID.onCommandSetFocus             ,
			"onCommandKillFocus"           : WGUI.EventID.onCommandKillFocus            ,
			"onCommandEnter"               : WGUI.EventID.onCommandEnter                ,
			"onHelp"                       : WGUI.EventID.onHelp                        ,
			"onDetailedHelp"               : WGUI.EventID.onDetailedHelp                ,
		}
		
		WGUI.CreateObjectLayout = function (layoutdata,path){
			VFS.PushDir(path);
			
			//初始化xml resource并加载xrc文件
			if ( typeof(layoutdata.xrc) != "undefined" )
			{
				WGUI.Xrc.InitAllHandlers();
				
				var ret = WGUI.Xrc.Load(path+"/"+layoutdata.xrc);
				if(ret == false)
				{
					System.Report("Load "+layoutdata.xrc+" failed!", 0, "");
				}
			}
			var tlw;
			if ( typeof(layoutdata.tlw) != "undefined" )
			{
				for(var name in layoutdata.tlw)
				{
					var object = layoutdata.tlw[name];
					var parent = 0;
					if(typeof(object.parent) != undefined)
					{
						parent = WGUI.Window.Get(object.parent);
					}
					switch(object.type)
					{
						case "frame" : 
							tlw = WGUI.Xrc.LoadFrame(parent, name);
							if(!tlw)
							{
								System.Report("LoadFrame failed!", 0, "");
							}
							break;
						case "dialog" : 
							tlw = WGUI.Xrc.LoadDialog(parent, name);
							if(!tlw)
							{
								System.Report("LoadDialog failed!", 0, "");
							}
							break;
						default: 
							System.Report("no tlw type is specified!", 0, "");
					}
					
					for(var id in object.window) {
						//通过JSON中的id获取窗口的控件类型
						w = WGUI.Window.Get(id); 
						//判断控件对象是否获取成功
						if (!w) {
							System.Report("Failed to get " + id + "", 0, "warning");
						}
						//给JS对象添加属性
						if (typeof(object.window[id].property) != "undefined") {
							var propt = object.window[id].property;
							
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
							"onCommandButtonClicked" : [
								"funcName",
								"funcName"
							],
							"onMotion" : [
								funcObj,
								funcObj
							],
							"onRightUp" : funcObj,
							"onRightDown" : "funcName"
						}
						*/
						if (typeof(object.window[id].event) != "undefined") {
							for(var name in object.window[id].event) {
								var handler = object.window[id].event[name];
								var evt_id = EVENT_MAP[name];
								if (typeof(handler) == "function") {
									w.Subscribe(evt_id,spp.hitch(w,handler));
								}
								else if (typeof(handler) == "string") {
									var stringHandler = layoutdata.method[handler];
									w.Subscribe(evt_id,spp.hitch(w,stringHandler));
								}
								else if (typeof(handler) == "object") {
									for(var handlerName in handler)
									{
										var objectHandler = handler[handlerName];
										if (typeof(objectHandler) == "string") {
											objectHandler = layoutdata.method[objectHandler];
										}
										w.Subscribe(evt_id,spp.hitch(w,objectHandler));
									}
								}
							}
						}
						//订阅全局事件
						if(typeof(object.window[id].subscribe) != "undefined")
						{
							for( var topic in object.window[id].subscribe )
							{
								var handler = object.window[id].subscribe[topic];
								eventID = Event.Subscribe(spp.hitch(w,handler), topic);
								w.eventMap = [];
								w.eventMap[topic] = eventID;
							}
						}
					}
					
					if(object.isVisible)
					{
						tlw.visible = true;
					}
					if(object.isRoot)
					{
						WGUI.App.root = tlw;
					}
				}
			}
			
			VFS.PopDir();
		}
		

	})();
}
catch(e)
{
	alert(e);
}