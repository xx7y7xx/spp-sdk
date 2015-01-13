/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

//本文提供了对js语法的一些扩展。
//提供了如下方法:
//spp.mixin:
//spp.hitch:
//spp.isString

var spp = null;
(function(){

spp = new Object();

var _mixin = function(dest, source, copyFunc){
	var name, s, i, empty = {};
	for(name in source){
		s = source[name];
		if(!(name in dest) || (dest[name] !== s && (!(name in empty) || empty[name] !== s))){
			dest[name] = copyFunc ? copyFunc(s) : s;
		}
	}
}
	
//将dest对象的属性合并到sources中。
spp.mixin = function(dest, sources)
{
	if(!dest){ dest = {}; }
	for(var i = 1, l = arguments.length; i < l; i++){
		_mixin(dest, arguments[i]);
	}
	return dest; // Object
}

var _toArray = function(obj, offset, startWith){
	return (startWith||[]).concat(Array.prototype.slice.call(obj, offset||0));
};

var isString = function(it){
	return (typeof it == "string" || it instanceof String); // Boolean
};
spp.isString = isString;

var _hitchGlobalCache = {};
var _hitchArgs = function(scope, method){
	var pre = _toArray(arguments, 2);
	var named = isString(method);
	return function(){
		// arrayify arguments
		var args = _toArray(arguments);
		// locate our method
		var f = named ? (scope||_hitchGlobalCache)[method] : method;
		// invoke with collected args
		return f && f.apply(scope || this, pre.concat(args)); // mixed
	}; // Function
};

//下面这几个函数为辅助函数，借鉴了prototype中的代码。我们应该扔到更基础的包里，例如sys_start.js中或者jsext.js中。
//这些代码解决scope绑定的问题。
spp.hitch = function(scope, method){
	if(arguments.length > 2){
		throw "must 2 param";
	}
	if(!method){
		method = scope;
		scope = null;
	}
	if(isString(method)){
		scope = scope || _hitchGlobalCache;
		if(!scope[method]){ throw(['hitch: scope["', method, '"] is null (scope="', scope, '")'].join('')); }
		return function(){ return scope[method].apply(scope, arguments || []); }; // Function
	}
	return !scope ? method : function(){ return method.apply(scope, arguments || []); }; // Function
}




})();
