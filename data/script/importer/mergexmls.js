/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

//
function CopyNodess(dnode, snode){ 
    dnode.value = snode.value;
    var sai = snode.GetAttribute();  //获取snode的所有属性的迭代器
    for(;sai.HasNext();)      //扫描所有属性
    {
        var att = sai.Next();    //获取属性
        dnode.SetAttribute(att.name,att.value);   //为dnode创建相同的属性名
    }
    var sci = snode.GetChildren();   //获取snode的所有子节点的迭代器
    for(;sci.HasNext();)     //扫描所有的子节点
    {
        var tchild = sci.Next();
        if(!CopyNodess(dnode.CreateChild(tchild.type),tchild))  //检查执行是否成功
        {
             System.exitcode = 32;
            //alert("Child Node copy error!");
        }
    }
    return true;
};
function CopyNodes(dnode, snode){
	var itMainNode = snode.GetChildren();
	 while(itMainNode.HasNext())
	{
			var mat = dnode.CreateChild(xmlDocument.NODE_ELEMENT);
			var node = itMainNode.Next();
			//alert("node value="+node.value);
			CopyNodess(mat,node);
	}
    return true;
};
function addTextureNode(texturesnode, texturePath) {
    VFS.Copy("/data/effectextures/"+texturePath,"outputpath/textures/effectextures/"+texturePath);
	var usepath = CmdLine.GetOption("usepath");//修改其中的textures信息
    var texturen = texturesnode.CreateChild(xmlDocument.NODE_ELEMENT);  //在textures节点下创建texture子节点
    texturen.value="texture";
    texturen.SetAttribute("name",texturePath);
    var texturef = texturen.CreateChild(xmlDocument.NODE_ELEMENT);
    texturef.value="file";
    var tfn = texturef.CreateChild(xmlDocument.NODE_TEXT);   //file中的路径信息可以看做是它的子节点，通过contentsValue可以获取到
    tfn.value = usepath+"/textures/effectextures/"+texturePath;    //添加路径信息
    return texturen;
};

//添加普通效果到artbuild生产线上
function mergexml(){
	this.listmat = new Array();
	this.listtex = new Array();
	this.listmesh = new Array();
	var effect_mat_rootc,effect_tex_rootc,effect_xmlt,meshindex,matindex, wtskyflag = false;
	this.listmeshnode = new Array();
	this.listmatnode = new Array();
	this.effectmatlist = new Array();
 }
//获得effect.xml中mat结点下的贴图名字   
mergexml.prototype.gettexlist = function(node){
	var itMainNode = node.GetChildren();
	var i = 0;
	while(itMainNode.HasNext())
	{
		var node = itMainNode.Next();
		var attrs = node.GetAttribute();
		while(attrs.HasNext()){
			var attr = attrs.Next();
			if(attr.value == "texture")
			{
				this.listtex[i] = node.contentsValue;
				i++;
			}
		}
	}
}
//获得effect.xml文件中mat名字
 mergexml.prototype.getmatlist = function(node){
	 var meshchild = node.GetChildren();
	 var i = 0;
	 while(meshchild.HasNext()){
		  var nodes = meshchild.Next();
		  var attrs = nodes.GetAttribute();
		  while(attrs.HasNext()){
			   var attr = attrs.Next();
			   this.listmat[i] = attr.value;//似乎有不妥之处;
			   this.listmatnode[i]= nodes;
			  // alert("listmat i : "+i);
			   i++;
		   } 
	  }
	  /* for(i=0;i<this.listmat.length;i++)
	  alert("this.listmat[i] : "+this.listmat[i]); */
 }
 //获得effect.xml文件中mat名字
mergexml.prototype.getmeshlist = function(){
	if(this.isopenxml == true)
	{
	//alert("1 : ");
		this.effect_tex_rootc= this.effect_xmlt.root.GetChildren();
		liblabel = this.effect_tex_rootc.Next();
		var i = 0;
		var itMainNode = liblabel.GetChildren();
		while(itMainNode.HasNext())
		{
			var node = itMainNode.Next();
		    var attrs = node.GetAttribute();
			while(attrs.HasNext()){
			var attr = attrs.Next();
			this.listmesh[i] = attr.value;
			this.listmeshnode[i] = node;
			//alert("lismesh i : "+this.listmeshnode[i]);
			i++;
			}
		}
	}
	/* for(i = 0;i<this.listmesh.length;i++)
		alert(" listmesh : "+this.listmeshnode[i]); */
	// for(i = 0;i<this.listmesh.length;i++)
		// alert(" listmesh : "+this.listmesh[i]);
}
 //获得effect.xml文件中是否有水的效果,若有为解决黑边添加sky.xml
mergexml.prototype.getskywater = function(){
	if(this.isopenxml == true)
	{
		var liblabel = this.effect_xmlt.root.GetChild("lib");
		var wtskylabel = liblabel.GetChild("watersky");
		if(wtskylabel)
		{
			this.wtskyflag = true;
			return wtskylabel;
		}
	}
		
}
//添加效果到xml树上
mergexml.prototype.addeffect = function(materialnode){
		matname = this.listmat[this.matindex];
		if(!this.CheckMaterial(matname))
		{
			matnode = this.listmatnode[this.matindex];
			CopyNodes(materialnode,matnode);
			this.addtexs(matnode);
		}
		else
		{
			materials.RemoveChildren(materialnode);
		}
}
//打开effect.xml文件
mergexml.prototype.openxml = function(){
	this.effect_xmlt = new xmlDocument();
	var effect_fread = VFS.Open("/effect/effect.xml",VFS.READ);
	if(effect_fread != undefined)
	{
		var parseflag = this.effect_xmlt.Parse(effect_fread);
		if(parseflag)
			this.isopenxml = true;
	}
}
//将贴图添加到xml树上以及textures文件中
mergexml.prototype.addtexs = function(meshfact){
	this.gettexlist(meshfact);
	for(n =0;n<this.listtex.length;n++)
	{
		textRealNames = this.listtex[n]/* .contentsValue */
		// 检测xml文件中是否已经存在该贴图了。
		if(!VFS.Exists("/data/effectextures/"+textRealNames))
		{
			alert("没有" + textRealNames + "效果贴图,请更新spp_sdk");
		}else
		{
			if(!importer.CheckTexture(textures,textRealNames))
			{	
				addTextureNode(textures,textRealNames);
			}
		}
	}
}

mergexml.prototype.IsAddEffect = function(material){
	var strname = material.GetPropertyName(0);
	var findflag =false;			
	if(this.listmat.length > 0)
	{
		for(i=0;i<this.listmat.length;i++)
		{
			if(strname==this.listmat[i])
			{
				findflag = true;
				break;
			}
		}
	}
	return findflag;
}

mergexml.prototype.IsMesh = function(meshname){
	//var strname = material.GetPropertyName(0);
	var findflag =false;	
	//alert("this.listmesh.length :"+this.listmesh.length);
	if(this.listmesh.length > 0)
	{
	//alert(" mesh : ");
		for(i=0;i<this.listmesh.length;i++)
		{
		//alert(" mesh : "+meshname + " : "+this.listmesh[i]);	
			if(meshname==this.listmesh[i])
			{
				/* alert(" mesh : "+meshname + " : "+this.lismesh[i]);	 */
				this.meshindex = i;
			//	alert("meshindex : "+i);
				findflag = true;
				break;
			}
		}
	}
	return findflag;
}

mergexml.prototype.IsMat = function(node,material){
	 //this.getmatlist(node);
	// alert("ismat: "+this.meshindex);
	 this.getmatlist(this.listmeshnode[this.meshindex]);
	 //alert("length: "+this.listmat.length);
	 var strname = material.GetPropertyName(0);
	 var findflag =false;   
	 if(this.listmat.length > 0)
	 {
	  for(i=0;i<this.listmat.length;i++)
	  {
	  //alert("现在list有: "+this.listmat[i]);
	   if(strname==this.listmat[i])
	   {
		findflag = true;
		this.matindex = i;
		//alert("matindex : "+i);
		break;
	   }
	  }
	 }
	 return findflag;
	 
}

mergexml.prototype.isopen = function(){
	if(this.listmesh.length >0)
	{
		this.isopenxml = true;
	}
	else
	{
		this.isopenxml = false;
	}
}
//未实现
mergexml.prototype.CheckMaterial = function (matname) {

	var findflag = false;
	var	cnt = this.effectmatlist.length;
	if(cnt > 0)
	{
		for(i=0;i<cnt;i++)
		{	
			if(matname == this.effectmatlist[i])
			{
				findflag = true;
				break;
			}
		}
	}
	this.effectmatlist[cnt] = matname;
	return findflag;
};
//添加hud树效果到artbuild生产线上
function sprit2dxml(){
 this.listmesh=new Array();
 var effect_xmlt;
 this.isopenxml = false ;
}
//open xml
sprit2dxml.prototype.openxml = function(){
 this.effect_xmlt = new xmlDocument();
 var effect_fread = VFS.Open("/effect/hudmesh.xml",VFS.READ);
 if(effect_fread != undefined)
 {
  var parseflag = this.effect_xmlt.Parse(effect_fread);
  if(parseflag)
   this.isopenxml = true;
 }
/*  else
 {
  //alert("parse xml error");
 } */
}
//get sprit2d mesh
sprit2dxml.prototype.getmeshlist = function(){
	if(this.isopenxml == true)
	{
		this.effect_tex_rootc= this.effect_xmlt.root.GetChildren();
		liblabel = this.effect_tex_rootc.Next();
		var i = 0;
		var hublabel = liblabel.GetChildren("hud");
			var itMainNode = hublabel.Next().GetChildren();
				while(itMainNode.HasNext())
				{
					var node = itMainNode.Next();
					var attrs = node.GetAttribute();
					while(attrs.HasNext()){
					var attr = attrs.Next();
					this.listmesh[i++] = attr.value;
				}
			}
		}
	/* for(i = 0;i<this.listmesh.length;i++)
	alert(" listmesh : "+this.listmesh[i]); */
}
//是否xml文件里有sprit2d的mesh
sprit2dxml.prototype.isgenmesh = function(){
	 if(this.listmesh.length >0)
	 {
	  this.isopenxml = true;
	 }
	 else
	 {
	  this.isopenxml = false;
	 }
	 //alert(" isgenmesh : "+this.isopenxml);
}
//判断是否是要加sprit2d的mesh
sprit2dxml.prototype.IsSprt2dMesh = function(mesh){
	var findflag =false;   
	if(this.listmesh.length > 0)
	{
		for(i=0;i<this.listmesh.length;i++)
		{
			if(mesh==this.listmesh[i])
			{
				findflag = true;
				break;
			}
		}
	}
	return findflag;
}

//添加lod效果到artbuild生产线上
function spplod(){
	this.listmat = new Array();
	this.listtex = new Array();
	this.listfact = new Array();
	var effect_mat_rootc,effect_tex_rootc,effect_xmlt,factindex,matindex,meshobjindex;
	var isopenxml = false ;
	this.listfactnode = new Array();
	this.listmatnode = new Array();
	this.listmeshobj = new Array();
	this.listmeshobjnode = new Array();
	this.listNewMatname = new Array();
  }
//获得effect.xml中mat结点下的贴图名字   
spplod.prototype.gettexlist = function(node){
	var itMainNode = node.GetChildren();
	var i = 0;
	while(itMainNode.HasNext())
	{
		var node = itMainNode.Next();
		var attrs = node.GetAttribute();
		while(attrs.HasNext()){
			var attr = attrs.Next();
			if(attr.value == "texture")
			{
				this.listtex[i] = node.contentsValue;
				i++;
			}
		}
	}
}
//打开lod.xml文件
spplod.prototype.openxml = function(){
	this.effect_xmlt = new xmlDocument();
	var effect_fread = VFS.Open("/effect/lod.xml",VFS.READ);
	if(effect_fread != undefined)
	{
		var parseflag = this.effect_xmlt.Parse(effect_fread);
		if(parseflag)
			this.isopenxml = true;
	}
}
//获得lod.xml文件中meshfactory的名字
spplod.prototype.getfactlist = function(){
	if(this.isopenxml == true)
	{
		this.effect_tex_rootc= this.effect_xmlt.root.GetChildren();
		liblabel = this.effect_tex_rootc.Next();
		var i = 0;
		var itMainNode = liblabel.GetChildren();
		while(itMainNode.HasNext())
		{
			var node = itMainNode.Next();
		    var attrs = node.GetAttribute();
			while(attrs.HasNext()){
			var attr = attrs.Next();
			this.listfact[i] = attr.value;
			this.listfactnode[i] = node;
			i++;
			}
		}
	}
	/*   for(i = 0;i<this.listfact.length;i++)
		 alert(" listfact : "+this.listfact[i]); */
}
//获得effect.xml文件中mat名字
spplod.prototype.getfactmatlist = function(factnode){
	 var factchild = factnode.GetChildren();
	 var i = 0;
	 while(factchild.HasNext()){
		  var nodes = factchild.Next();
		  var attrs = nodes.GetAttribute();
		  while(attrs.HasNext()){
			   var attr = attrs.Next();
			   this.listmat[i] = attr.value;
			   this.listmatnode[i]= nodes;
			   i++;
		   } 
	  }
	  /* for(i=0;i<this.listmat.length;i++)
	  alert("this.listmat[i] : "+this.listmat[i]); */
 }
//查找是否是这个factory要加lod
spplod.prototype.isFact = function(factname){
	var findflag =false;	
	if(this.listfact.length > 0)
	{
		for(i=0;i<this.listfact.length;i++)
		{
			if(factname==this.listfact[i])
			{
				this.factindex = i;
				findflag = true;
				break;
			}
		}
	}
	return findflag;
}
//是否是要添加lod的material
spplod.prototype.IsMat = function(node,material){
		this.getfactmatlist(this.listfactnode[this.factindex]);//得到fact下的material列表
		var strname = material.GetPropertyName(0);
		var findflag =false;   
		if(this.listmat.length > 0)
		{
			for(i=0;i<this.listmat.length;i++)
			{
				// alert("现在list有: "+this.listmat[i]+" : "+strname);
				if(strname==this.listmat[i])
				{
					findflag = true;
					this.matindex = i;
					//alert("matindex : "+i);
					break;
				}
			}
		}
	 return findflag;
}
//添加lod效果到mat树上,这之前需要查找是否已经定义好了.
spplod.prototype.CheckLodMaterial = function (materials, lodmatname) {
    var materialnodes = materials.GetChildren();    //获取所有materials标签下子节点的迭代器
	for(;materialnodes.HasNext();)  //扫描所有子节点
	{
		var materialchild = materialnodes.Next();
		var attrs = materialchild.GetAttribute();
		while(attrs.HasNext()){
				var attr = attrs.Next();
				//alert("attr.name="+attr.name+"\nattr.value="+attr.value);
				if(attr.value == lodmatname)
					return materialchild;
					//return true;
				//attr.name获取属性名称，attr.value获取属性值
		}
	}  
	return false;
};
//添加新的lod material
spplod.prototype.addLodmat = function(materials, matname){
		strname = "lod_"+ matname;
		if(this.CheckLodMaterial(materials, strname) == false)//检查是否已添加
		{	
			var materialnode = materials.CreateChild(xmlDocument.NODE_ELEMENT);
			materialnode.value="material";
			materialnode.SetAttribute("name",strname);
			var oldmat = this.CheckLodMaterial(materials, matname);
			CopyNodes(materialnode,oldmat);
			//需要把原material的结点内容拷下来,但目前水的lod不需要
			var matnode = this.listmatnode[this.matindex];
			var effectnode = matnode.GetChild("effect");//得到效果
			CopyNodes(materialnode,effectnode);
			this.addtexs(effectnode);
		}
		else
			return false;
	}
//添加texture结点
spplod.prototype.addtexs = function(meshfact){
	this.gettexlist(meshfact);
	for(n =0;n<this.listtex.length;n++)
	{
		textRealNames = this.listtex[n]/* .contentsValue */
		// 检测xml文件中是否已经存在该贴图了。
		if(!VFS.Exists("/data/effectextures/"+textRealNames))
		{
			alert("没有" + textRealNames + "效果贴图,请更新spp_sdk");
		}else
		{
			if(!importer.CheckTexture(textures,textRealNames))
			{	
				//this.addTextureNode(textures,textRealNames);
				addTextureNode(textures,textRealNames);
			}
		}
	}
}
spplod.prototype.isopen = function(){
	if(this.listfact.length >0)
	{
		this.isopenxml = true;
	}
	else
	{
		this.isopenxml = false;
	}
}
//get meshobj name
spplod.prototype.getmatmeshobj = function(matnode){
	var meshobjnode = matnode.GetChild("meshobj");
	var meshchild = meshobjnode.GetChildren();
	var i = 0;
	while(meshchild.HasNext()){
		var nodes = meshchild.Next();
		var attrs = nodes.GetAttribute();
		while(attrs.HasNext()){
				var attr = attrs.Next();
				this.listmeshobj[i] = attr.value;
		}
		this.listmeshobjnode[i]= nodes;
		i++;
	 }
 /* 	for(i=0;i<this.listmeshobj.length;i++)
	{
		alert("listmeshobj: "+this.listmeshobj[i]);
	}  */
}
//查找meshobj数据
spplod.prototype.findMeshobj = function(meshobjname){
	//var strname = material.GetPropertyName(0);
	var findflag =false;	
	//alert("this.listfact.length :"+this.listfact.length);
	if(this.listmeshobj.length > 0)
	{
	//alert(" mesh : ");
		for(i=0;i<this.listmeshobj.length;i++)
		{
		//alert(" mesh : "+factname + " : "+this.listfact[i]);	
			if(meshobjname==this.listmeshobj[i])
			{
				/* alert(" mesh : "+factname + " : "+this.listfact[i]);	 */
				this.meshobjindex = i;
			//	alert("factindex : "+i);
				findflag = true;
				break;
			}
		}
	}
	return findflag;
}
//添加staticlod数据结点
spplod.prototype.AddMeshLod = function(meshobj, lodvalue, plgname, factName, matname){
	var meshobj_lod = meshobj.CreateChild(xmlDocument.NODE_ELEMENT);
	meshobj_lod.value = "meshobj";
	meshobj_lod.SetAttribute("name","lod_0"+(lodvalue+1));
	var lodlevel = meshobj_lod.CreateChild(xmlDocument.NODE_ELEMENT);
	lodlevel.value = "lodlevel";
	var lodlevelC = lodlevel.CreateChild(xmlDocument.NODE_TEXT);
	lodlevelC.value = lodvalue;
	var priority = meshobj_lod.CreateChild(xmlDocument.NODE_ELEMENT);
	priority.value = "priority";
	var priorityC = priority.CreateChild(xmlDocument.NODE_TEXT);
	priorityC.value = "object";
	var plugin = meshobj_lod.CreateChild(xmlDocument.NODE_ELEMENT);
	plugin.value = "plugin";
	var pluginC = plugin.CreateChild(xmlDocument.NODE_TEXT);
	pluginC.value = plgname;
	var paramsw = meshobj_lod.CreateChild(xmlDocument.NODE_ELEMENT);
	paramsw.value = "params";
	var factory = paramsw.CreateChild(xmlDocument.NODE_ELEMENT);
	factory.value = "factory";
	var tfan = factory.CreateChild(xmlDocument.NODE_TEXT);
	tfan.value = factName;
	var newmat = paramsw.CreateChild(xmlDocument.NODE_ELEMENT);
	newmat.value = "material";
	var newmat = newmat.CreateChild(xmlDocument.NODE_TEXT);
	newmat.value = matname; 
return true;
}

if(callbacks.Choice["mergexmls"]){
mg = new mergexml();
mg.openxml();
mg.getmeshlist();
mg.getskywater();
sprt = new sprit2dxml();
sprt.openxml();
sprt.getmeshlist();
sprt.isgenmesh();
lod = new spplod();
lod.openxml();
lod.getfactlist();
}