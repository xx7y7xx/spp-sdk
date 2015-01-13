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
 * @brief 方便调试。
 **/
var console = null;
(function(){

console = new Object();

var iReporter = Registry.Get("iReporter");

console.error = function(msg)
{
	System.Report(msg,
		iReporter.ERROR/* 1 */, "[Error]");
}

console.warn = function(msg)
{
	System.Report(msg,
		iReporter.WARNING/* 2 */, "[Warn]");
}

console.info = function(msg)
{
	System.Report(msg,
		iReporter.NOTIFY/* 3 */, "[Info]");
}

console.debug = function(msg)
{
	System.Report(msg,
		iReporter.DEBUG/* 4 */, "[Debug]");
}

console.log = function(msg)
{
	System.Report(msg,
		iReporter.LOG/* 5 */, "[LOG]");
}

///@todo 还需要添加如下的，可以模仿firebug。
/// console.log, console.debug, console.info, console.warn, and console.error.

})();