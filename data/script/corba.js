/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

Plugin.Load("spp.net.corba");
Corba.localObjMap = {};

// class Delivery
function Delivery(url)
{
	this.userMap = {};
	this.url = url;
	Corba._oldRegisterObject(this, url);
};

Delivery.prototype.alreadyReg = function(objRegName){ 
	console.log("server alreadyReg, objRegName:" + objRegName);
	console.log("server alreadyReg, this.userMap[objRegName]:" + this.userMap[objRegName]);
	if(this.userMap[objRegName])
	{
		return true;
	}
	else
		return false;
};

Delivery.prototype.getID = function(userName){ 
	return userName;
};

Delivery.prototype.setInvoke = function(obj, funName)
{

	return true;
};

Delivery.prototype.register = function(handler, id){
	//console.log("register id:" + id);
	this.userMap[id] = handler;
};

Delivery.prototype.removeUser = function(id){
	//console.log("register id:" + id);
	delete this.userMap[id];
};

Delivery.prototype.sendMsg = function(target, name)
{
	var args = [];
	for(i = 1; i < arguments.length; i++)
	{
		args.push(arguments[i]);
	}
	try
	{
		this.userMap[target].apply(this.userMap,args);
	}
	catch(err)
	{
		//用户断开连接or退出程序
		this.removeUser(target);
		//向其他client发送该玩家断开连接/退出程序的消息?
		//console.log("玩家断开连接/退出程序 ");
	}
}

Delivery.prototype.onDataComing = function(target,args){
	//console.log("onDataComing called, target:" + target + " args:" + JSON.stringify(args));
	// console.log("onDataComing, args[args.length - 1]:" + args[args.length - 1]);
	if(this.userMap[target] != undefined)
	{
		//this.userMap[target].apply(this.userMap,args);
		try
		{
			if(args[args.length - 1] == "invoke")
			{
				//Server端的defaultNameService不可改变
				var fullUrl = Corba.defaultNameService + "#" + this.url + "#" + target;
				// console.log("onDataComing, fullUrl:" + fullUrl);
				// console.log("onDataComing, Corba.localObjMap[fullUrl]:" + Corba.localObjMap[fullUrl]);
				if(Corba.localObjMap[fullUrl])
				{
					var obj = Corba.localObjMap[fullUrl];
					if(args.length == 1)
					{
						//console.log("funName is null, target:" + target);
						return "funName is null";
					}
					else
					{
						var funName = args.shift();
						var ret = obj[funName].apply(obj, args);
						//console.log("onDataComing funName:" + funName + " ret:" + ret + "\n");
						return ret;
					}
				}
				else
				{
					
					var ret = this.userMap[target].apply(this.userMap, args);
					//console.log("onDataComing invoke client fun:" + " ret:" + ret + "\n");
					return ret;
				}
			}
			else
				this.userMap[target].apply(this.userMap,args);
		}
		catch(err)
		{
			this.removeUser(target);
			//向其他client发送该玩家断开连接/退出程序的消息?
		}
	}
	else
	{
		//向client发送"发送失败"的消息？
		return;
	}
	//console.log("onDataComing end");
};

// class DeliveryProxy
function DeliveryProxy(deliveryUrl)
{
	this.remoteObj = {};
    this.userID = "";
	this.defaulttarget = undefined;
    this.formathandler = {};
    this.post = {};
    this.defPost = {};
	this.regObj = {};
	//console.log("deliveryUrl:" + deliveryUrl);
	this.remoteObj = Corba._oldGetObject(deliveryUrl);
};
/*
DeliveryProxy.prototype.init = function(userName)
{
	this.userID = this.remoteObj.getID(userName);
	//invoke方式
	//this.remoteObj.register(this.onRecieve, this.userID);
	//oneway方式
	Corba.SetOneway(this.remoteObj,"register");
	this.remoteObj.register(spp.hitch(this,this.onRecieve), this.userID);
};*/

DeliveryProxy.prototype.postData = function(target, args)
{
	//console.log("this.remoteObj:" + this.remoteObj + " target:" + target + " name:" + name + " arguments:" +args);
	//invoke方式
	//this.remoteObj.onDataComing(target,this.userID,name,args);
	//oneway方式
	// console.log("postData, args[args.length - 1]:" + args[args.length - 1]);
	if(args[args.length - 1] == "invoke")
	{
		Corba.SetInvoke(this.remoteObj,"onDataComing");
		try
		{
			var ret = this.remoteObj.onDataComing(target,args);
			return ret;
		}
		catch(e)
		{
			alert(e);
		}
		//console.log("postData ret:" + ret);
	}
	else
	{
		Corba.SetOneway(this.remoteObj,"onDataComing");
		this.remoteObj.onDataComing(target,args);
	}
};

DeliveryProxy.prototype.setDefaultTarget = function(target){
	this.defaulttarget = target;
};

DeliveryProxy.prototype.alreadyReg = function(name){
	var ret = this.remoteObj.alreadyReg(name);
	//console.log("DeliveryProxy alreadyReg, ret:" + ret);
	return ret;
};
/*
DeliveryProxy.prototype.setRegObj = function(obj){
	this.regObj = obj;
	//this.defPost.enterNotify();
	for(i in this.regObj)
	{
		this.initPost(i);
	}
};

DeliveryProxy.prototype.initPost = function(name)
{
	var deliveryProxy = this;
	this.post[name] = function()
	{
		var target = arguments[0];
		//var data = pack.apply(arguments[2]);
		deliveryProxy.postData(target, name, arguments[1]);
	}
	this.defPost[name] = function()
	{	
		//var data = pack.apply(arguments[1]);
		deliveryProxy.postData(deliveryProxy.defaulttarget, name, arguments[0]);
	}
};

DeliveryProxy.prototype.onRecieve = function(sender, name, args)
{
	if(typeof(this.regObj[name]) == "function")
		this.regObj[name](sender, args);
	//else
	//	Console.WriteLine(name + "not a function");
};*/


(function(){

Corba._oldGetObject = Corba.GetObject;
Corba._oldRegisterObject = Corba.RegisterObject;
Corba._oldSetDefaultNameService = Corba.SetDefaultNameService;
Corba.curNameService = null;

Corba.SetDefaultNameService = function(url)
{
	Corba.defaultNameService = url;
	Corba.curNameService = url;
	var ret = Corba._oldSetDefaultNameService(url);
	return ret;
}


var deliveryProxyCache = {};

function RegisterAgent(deliveryUrl)
{
	this.remoteObj = {};
	this.regObj = {};
	var id;
	this.remoteObj = Corba._oldGetObject(deliveryUrl);
}

RegisterAgent.prototype.setRegObj = function(obj){
	this.regObj = obj;
	//this.defPost.enterNotify();
	/*for(i in this.regObj)
	{
		this.initPost(i);
	}*/
};

RegisterAgent.prototype.init = function(userName)
{
	this.userID = this.remoteObj.getID(userName);
	//invoke方式
	//this.remoteObj.register(this.onRecieve, this.userID);
	//oneway方式
	Corba.SetOneway(this.remoteObj,"register");
	this.remoteObj.register(spp.hitch(this,this.onRecieve), this.userID);
};

RegisterAgent.prototype.onRecieve = function()
{
	var args = [];
	for(i in arguments)
	{
		args.push(arguments[i]);
	}
	var name = args.shift();
	if(typeof(this.regObj[name]) == "function")
	{
		/*for(i in args)
		{
			console.log("args[" + i +"]:" + args[i]);
		}*/
		if(args[args.length - 1] == "invoke")
		{
			var ret = this.regObj[name].apply(this.regObj, args);
			//console.log("onRecieve ret:" + ret);
			return ret;
		}
		else
			this.regObj[name].apply(this.regObj, args);
	}
	//else
	//	Console.WriteLine(name + "not a function");
};


Corba.RegisterObject = function(url, obj)
{
	var a = url.split('#');
	var nameServiceUrl;
	var deliveryUrl;
	var userName;
	// set "delUrl"
	if(a[0].indexOf("corbaloc", 0) == 0)
	{
		if((Corba.defaultNameService != a[0])
			&&(Corba.curNameService != a[0]))
			Corba._oldSetDefaultNameService(a[0]);
		nameServiceUrl = a[0];
	}
	else
	{
		nameServiceUrl = Corba.defaultNameService;
	}
	//set "userName" and "deliveryUrl"
	if(a.length == 3)
	{
		Corba.DeliveryUrl = a[1];
		deliveryUrl = a[1];
		userName = a[2];
	}
	else if(a.length == 2)
	{
		deliveryUrl = Corba.DeliveryUrl;
		userName = a[1];
	}
	// init registerAgent
	var registerAgent = new RegisterAgent(deliveryUrl);
	registerAgent.setRegObj(obj);
	registerAgent.init(userName);
	// store local register Object
	var fullUrl = nameServiceUrl + "#" + deliveryUrl + "#" + userName;
	//console.log("fullUrl:" + fullUrl);
	Corba.localObjMap[fullUrl] = obj;
};

// var ObjectCache = {};

Corba.GetObject = function(url)
{
	var deliveryProxy;
	var target;
	var delUrl;
	var objUrl;
	var nameServiceUrl;
	/*if(Corba.localObjMap[url])
	{
		console.log("url:" + url);
		return Corba.localObjMap[url];
	}
	else if(typeof ObjectCache[url] != "undefined")
	{
		return ObjectCache[url];
	}*/
	var a = url.split('#');
	if(a[0].indexOf("corbaloc", 0) == 0)
	{
		if((Corba.defaultNameService != a[0])
			&&(Corba.curNameService != a[0]))
			Corba._oldSetDefaultNameService(a[0]);
		nameServiceUrl = a[0];
	}
	else
	{
		nameServiceUrl = Corba.defaultNameService;
	}
	//set "target" and "delUrl"
	if(a.length == 3)
	{
		target = a[2];
		objUrl = a[1];
		delUrl = nameServiceUrl + "#" + a[1];
	}
	else if(a.length == 2)
	{
		target = a[1];
		objUrl = Corba.DeliveryUrl;
		delUrl = nameServiceUrl + "#" + a[0];
	}
	else
	{
		//error 字符串中没有#，格式错误
		return;
	}
	// 是否为本地对象
	var fullUrl = delUrl + "#" + target;
	if(Corba.localObjMap[fullUrl])
	{
		//console.log("local object");
		return Corba.localObjMap[fullUrl];
	}
	// 不可以使用缓存的对象，因为有可能该对象已经被重新注册，被注册为另一个Object
	// else if(typeof ObjectCache[fullUrl] != "undefined")
	// {
		// //是否已缓存到本地
		// return ObjectCache[fullUrl];
	// }
	// get deliveryProxy
	if(typeof deliveryProxyCache[delUrl] != "undefined")
	{
		deliveryProxy = deliveryProxyCache[delUrl];
	}
	else
	{
		deliveryProxy = new DeliveryProxy(objUrl);
		deliveryProxyCache[delUrl] = deliveryProxy;
	}
	//检查获取的objcet是否已被注册
	// if(!deliveryProxy.alreadyReg(target))
	// {
		// console.log("object is not register, objectName:" + target);
		// //该对象在并没有被注册
		// return;
	// }
	//else
	//{
		// 创建bareObject
		var ret = Corba.CreateBareObject();
		
		
		ret._setProperty = function(name, value){
			//不能通过proxy为远程对象增添属性/设置属性值，对proxy的这些操作都仅是对本地proxy对象操作
			//alert("_setProperty called, value:" + value);
			this._nativeObj[name] = value;
			return;
			//console.log("_setProperty called");
		};
		ret._getProperty = function(name){
			//name == say.
			//需要判断name的类型，是function还是variable
			if(typeof(ret._nativeObj[name]) != "undefined")
			{
				return ret._nativeObj[name];
			}
			// {
				var result = function(){
					//console.log("call get Property");
					//console.log("name:" + name);
					var args = [];
					args.push(name);
					//console.log(arguments.length );
					for(i=0; i < arguments.length ; i++)
					{
						//console.log("arguments[" + i + "]:" + arguments[i]);
						args.push(arguments[i]);
						//console.log("i:" + i);
					}
					//console.log("target:" + target + " name:" + name + " args:" + args[0]);
					//deliveryProxy.post[name](target, args);
					//console.log("target:" + target + " name:" + name + " args:" + args);
					if(this.isInvoke(name))
					{
						//alert("invoke, name:" + name);
						args.push("invoke");
						//console.log("args[length-1]:" + args[args.length - 1]);
						var ret = deliveryProxy.postData(target, args);
						//console.log("_getProperty, name:" + name + " ret:" + ret + "\n");
						return ret;
					}
					else
					{
						//alert("oneway, name:" + name);
						args.push("");
						deliveryProxy.postData(target, args);
					}
				}
				//ret.nativeProperty[name] = result;
				return result;
			// } 
		};
		ret._nativeObj = {};
		ret._invokeArray = {};
		ret.setInvoke = function(name){
			this._invokeArray[name] = 1;
		};
		ret.isInvoke = function(name){
			if(typeof(this._invokeArray[name]) != "undefined")
				return true;
			else 
				return false;
		};
		//ret.nativeProperty = {};
		//缓存到本地 
		// ObjectCache[fullUrl] = ret;
		return ret;
	//}
	//}
};


})();

