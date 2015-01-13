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
 * 处理已经废弃的接口，为了系统可以向前兼容旧接口（不至于SPP崩溃）
 * 需要为旧接口显示一个提示信息，以提示开发人员使用最新的接口。
 * 
 * 目前提供如下两种提示方式：
 *   1. alert窗口。
 *   2. 在调试窗口打印出来。
 * 
 * @detail 开发人员在开发阶段需要调试运行（添加`--debug`参数）App，
 * 所以会显示alert窗口强制替换废弃的API。
 * 对于已经交付给用户的App，即使用户升级了我们的App，但是用户运行的时候不会
 * 使用`--debug`参数，所以在最终用户那里是看不到alert窗口的。
 **/

(function(){

/**
 * 打印警告信息，使用推荐的API来替换已经废弃的API
 * 并且将调用该API的函数以及所在脚本打印出来。
 * @param Object, 当前堆栈
 * @param String, 废弃的API名称
 * @param String, 推荐使用的API名称
 **/
var DeprecatedWarning = function(stack, deprecatedAPI, recommandedAPI)
{
	var lastStack = stack[1];
	var output = "[Warning] " + deprecatedAPI + " is deprecated. Use " + recommandedAPI + " instead.\n\n";
	output += "Call Stack :\n";
	output += "\tFunction Name : " + lastStack.functionName + "\n";
	output += "\tLine : " + lastStack.line + "\n";
	output += "\tColumn : " + lastStack.column + "\n";
	output += "\tScript Name : " + lastStack.scriptName + "\n";
	
	// 通常开发人员才会使用debug参数运行程序。
	if(CmdLine.GetOption('debug',0))
	{
		// 粗暴的弹出窗口，催促开发人员不要忘记更新已经废弃的API
		alert(output);
	}
	else
	{
		var iReporter = Registry.Get("iReporter");
		System.Report(output, iReporter.WARNING, "废弃： ");
	}
	
};

/**
 * @todo add description
 * @deprecated Sys global object is deprecated. Use System global object instead.
 */
Sys.NotifyEmbed = function(p1, p2, p3, p4, p5)
{
	DeprecatedWarning(System.GetStackTrace(), "Sys", "System");
	System.NotifyEmbed(p1, p2, p3, p4, p5);
}

/**
 * @todo add description
 * @deprecated Norm method is deprecated. Use Length method instead.
 **/
Math3.Vector2.prototype.Norm = function()
{
	DeprecatedWarning(System.GetStackTrace(), "Norm", "Length");
	return this.Length();
}
/**
 * @todo add description
 * @deprecated SquaredNorm method is deprecated. Use SquaredLength method instead.
 **/
Math3.Vector2.prototype.SquaredNorm = function()
{
	DeprecatedWarning(System.GetStackTrace(), "SquaredNorm", "SquaredLength");
	return this.SquaredLength();
}
/**
 * @todo add description
 * @deprecated Norm method is deprecated. Use Length method instead.
 **/
Math3.Vector3.prototype.Norm = function()
{

	DeprecatedWarning(System.GetStackTrace(), "Norm", "Length");
	return this.Length();
}
/**
 * @todo add description
 * @deprecated SquaredNorm method is deprecated. Use SquaredLength method instead.
 **/
Math3.Vector3.prototype.SquaredNorm = function()
{

	DeprecatedWarning(System.GetStackTrace(), "SquaredNorm", "SquaredLength");
	return this.SquaredLength();
}
/**
 * @todo add description
 * @deprecated Norm method is deprecated. Use Length method instead.
 **/
Math3.Vector4.prototype.Norm = function()
{

	DeprecatedWarning(System.GetStackTrace(), "Norm", "Length");
	return this.Length();
}
/**
 * @todo add description
 * @deprecated SquaredNorm method is deprecated. Use SquaredLength method instead.
 **/
Math3.Vector4.prototype.SquaredNorm = function()
{

	DeprecatedWarning(System.GetStackTrace(), "SquaredNorm", "SquaredLength");
	return this.SquaredLength();
}
/**
 * @todo add description
 * @deprecated Add2 method is deprecated. Use Add method instead.
 **/
Math3.Color.prototype.Add2 = function(p1)
{

	DeprecatedWarning(System.GetStackTrace(), "Add2", "Add");
	return this.Add(p1);
}
/**
 * @todo add description
 * @deprecated Subtract2 method is deprecated. Use Subtract method instead.
 **/
Math3.Color.prototype.Subtract2 = function(p1)
{

	DeprecatedWarning(System.GetStackTrace(), "Subtract2", "Subtract");
	return this.Subtract(p1);
}
/**
 * @todo add description
 * @deprecated Mulscalar method is deprecated. Use Multiply method instead.
 **/
Math3.Color.prototype.Mulscalar = function(p1)
{

	DeprecatedWarning(System.GetStackTrace(), "Mulscalar", "Multiply");
	return this.Multiply(p1);
}
/**
 * @todo add description
 * @deprecated Mulscalar method is deprecated. Use Multiply method instead.
 **/
Math3.Color4.prototype.Mulscalar = function(p1)
{

	DeprecatedWarning(System.GetStackTrace(), "Mulscalar", "Multiply");
	return this.Multiply(p1);
}
/**
 * Get OS name
 * @deprecated Sys global object is deprecated. Use System global object instead.
 */
Object.defineProperty(Sys, "osName", {
	get: function()
	{
		DeprecatedWarning(System.GetStackTrace(), "Sys", "System");
		return System.osName;
	}
});

})();