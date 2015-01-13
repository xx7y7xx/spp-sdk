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
		var Browser = new Object();
		System.Browser = Browser;
		Browser.Publish = function(info) {
			// 调用浏览器中执行的js代码中的一个函数，参数以字符串传递过去。
			System.NotifyEmbed(info);
		}
		Browser.Subscribe = function(callback, name) {
			Event.Subscribe(callback, name);
		}
	})();

} catch(e){
	alert(e);
}