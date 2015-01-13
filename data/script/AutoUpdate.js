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
 * @brief 根据www.spolo.org官网的信息来更新产品。
 **/

var AutoUpdate = null;

(function(){

AutoUpdate = new Object();

/**
 * @brief 如果有更新，则调用IE来下载最新更新
 */
AutoUpdate.Init = function(pname)
{
	var handler = function handler()
	{
		if(this.readyState == this.DONE && this.status == 200)
		{
			var json = eval("(" + this.responseText + ")"); 
			// version: 最大支持到99个更新。第一个发行版是100（ver1.00）
			// 100, 101, 102, 1xx, 199
			if(json.ver > VERSION.current)
			{
				alert("请更新软件！");
				System.Open(json.url);
			}
		}
	}

	try{
		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = handler;
		xhr.open("GET", "http://render001.com/content/spp.update?product=" + pname);
		xhr.send("check update\n");
	}
	catch(err){
		alert("[AutoUpdate.js] catch a error: " + err.message);
	}
}

})();