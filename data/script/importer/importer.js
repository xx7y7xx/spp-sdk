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

// 插件加载
Plugin.Load("spp.loader.3d");

// 全局对象，用来保存当前正在读取的3ds文件等信息。
var Ctx = new Object();
//创建解析器
var importer = new Importer();

(function(){

// -----------------------------------------------------------------------------
// Object Ctx;
// -----------------------------------------------------------------------------

/**
 * @brief 保存输入的源文件，比如3ds文件。
 **/
Ctx.inputfile = "None";

/**
 * @brief 将Context信息组装成readable的string并返回。
 **/
Ctx.ContextInfo = function () {
	var info = "";
	info += "Input : " + Ctx.inputfile + "\n";
	return info;
};

// -----------------------------------------------------------------------------
// Importer importer;
// -----------------------------------------------------------------------------

/**
 * @brief 传入`<material>`节点，与3ds中的一个`aiMaterial`节点中
 * 保存的diffuse贴图（的fullpath）进行比较，判断是否相同。
 * @param materialsnode -- iDocumentNode对象
 * @param aimaterial -- aimaterial对象
 * @return 如果相同返回true，否则false。
 **/
importer.CheckMaterial = function (materialsnode, aimaterial) {
	// 获取3ds文件中aimaterial的diffusetext对象
	var aimat = aimaterial.GetTexture(aimaterial.DIFFUSE,0);
	if(typeof(aimat) == "undefined")
	{
		alert("[Error 37] Cant find diffuse texture in material[" +
			aimaterial.GetPropertyName(0) + "] !!\n\n", Ctx.ContextInfo());
		System.exitcode = 37;
		exit();
	}
	
	
	///@fixme 虽然texture重复了，但是需要将material返回出去
	/// 否则viewscene的时候就会找不到对应的material了
	
    var materialnodes = materialsnode.GetChildren();    //获取所有materials标签下子节点的迭代器
	for(;materialnodes.HasNext();)  //扫描所有子节点
	{
		var materialchild = materialnodes.Next();
		//获取到material子节点的所有孩子的迭代器（texture，shader，shadervar标签）
		var materialchildrens = materialchild.GetChildren();   
		var materialchildren = materialchildrens.Next();        //获取material下的texture子节点
		
		// 比较texture的节点信息是否一致，3ds中的此信息为大写，需用toLocaleLowerCase()转化为小写再比较
		if(materialchildren.contentsValue == aimat.path.toLocaleLowerCase())
		{
		
		   var rematerial = materialchild.GetAttribute("name").value;
		   return rematerial;
		}
	}  
	
	return false;
};

/**
 * @brief 该material节点(3ds的scene tree中)中是否存在贴图。
 * 如果存在多余一张贴图，仍然报错，因为目前暂时不支持这个特性。
 */
importer.aiMaterialValidation = function (aiMaterial) {
	// 是否一张贴图都没有
	if (aiMaterial.GetTextureCount() == 0) {
		alert("[Error 37] Cant find any textures in material[" +
			aiMaterial.GetPropertyName(0) + "] !!\n\n", Ctx.ContextInfo());
		System.exitcode = 37;
		exit();
	}
	
	// 是否有多余一张贴图。
	// @fixme 以后可能会支持多张贴图，那么就不用做这个validation了。
	if (aiMaterial.GetTextureCount() > 1) {
		alert("[Error 38] Until now, we not support a material with ",
			"multi texture, material name : [" +
			aiMaterial.GetPropertyName(0) + "] !!\n\n", Ctx.ContextInfo());
		System.exitcode = 38;
		exit();
	}
}

/**
 * @brief 在<materials>节点中寻找给定名称的材质。
 * @param materials -- <code><materials></code>节点对象。
 * @param materialname -- 节点名称字符串。
 * @details 如果找到，则返回<code><material></code>节点对象
 * 如果没有找到则返回<code>undefined</code>
 */
importer.FindMaterial = function (materials, materialname) {
	var materialit = materials.GetChildren();  //获取materials的所有子节点的迭代器
	for(;materialit.HasNext();)
	{
		materialnode = materialit.Next();
		if(materialnode.GetAttribute("name").value == materialname)   //如果material子节点的名字和指定的名字相同
		{
			return materialnode;  //返回这个子节点
		}
	}
	return undefined;
};

/**
 * @brief 检测<textures>中是否有给定名称的贴图。
 * @param texturesnode -- <code><textures></code>节点对象。
 * @param texturename -- 节点名称字符串。
 * @details 如果找到，则返回<code>true</code>
 * 如果没有找到则返回<code>false</code>
 */
importer.CheckTexture = function (texturesnode, texturename) {
	var texturenodes = texturesnode.GetChildren();    //获取texturenode下所有子节点的迭代器
	for(;texturenodes.HasNext();)   //扫描所有子节点
	{
		var texturechild = texturenodes.Next();
		if(texturechild.GetAttribute("name").value == texturename)  //判断子节点的名字是否和指定的名字相同
		{
			return true;  //子节点中有一个名字相同则返回true
		}
	}
	return false;
}

/**
 * @brief 检查材质是否双面。
 * @param {String} 材质名称
 * @param {iDocumentNode} XML文件的<materials>节点（根节点）
 * @details 从D:\p\sample\src\art\scene\matpro.xml读取
 */
importer.matIsTwoSide = function (matname, matprort)
{
	var mat;
	mat = matprort.GetChild(matname);
	if(mat == undefined)
	{
		alert(matname + " cannot found in matpro.xml");
		return false;
	}
	return (mat.GetAttribute("twoSided").value === "true");
};

/**
 * @brief 在一个3ds的场景树中寻找所有名字叫做meshname的mesh
 * 将符合条件的mesh的index保存在一个js array中并返回。
 * @param aiscene -- 3ds文件构成的scene tree。
 * @param meshname -- mesh名称字符串。
 * @details 如果没有找到则返回一个空数组。
 */
importer.FindMeshName = function (aiscene, meshname) {
	var mai = new Array();
	
	// 循环所有的aiNode
	for(var jr = 0; jr < aiscene.rootNode.numChildren; jr++)
	{
		var ainode = aiscene.rootNode.GetChildren(jr)   //获取到ainode
		
		// 如果当前aiNode下没有mesh，跳过
		if(ainode.GetMeshIndex() == undefined)
		{
			continue;
		}
		
		// GetMeshIndex是一个int array，length来获取其长度
		for(var mci = 0; mci < ainode.GetMeshIndex().length; mci++)
		{
			var meshIndex = ainode.GetMeshIndex(mci);
			var mesh = aiscene.GetMeshes(meshIndex);
			if(mesh.GetName() == meshname)  //判断3ds中mesh的名字和指定的名字是否相同
			{
				mai.push(meshIndex);   //将meshindex存到mai数组中
			}
		}
	}
	return mai;   //返回数组，存储的是所有相同的名字的index
}

/**
 * @brief 在<code><textures></code>节点上创建一个子节点，给定贴图路径。
 * 将创建的子节点<code><texture></code>返回。
 * @param texturesnode -- <code><textures></code>根节点。
 * @param texturePath -- 需要添加的贴图路径。
 */
importer.addTextureNode = function (texturesnode, texturePath) {
    VFS.Copy(texturePath,"outputpath/textures/"+texturePath);
    //修改其中的textures信息
    var texturen = texturesnode.CreateChild(xmlDocument.NODE_ELEMENT);  //在textures节点下创建texture子节点
    texturen.value="texture";
    texturen.SetAttribute("name",texturePath);
    var texturef = texturen.CreateChild(xmlDocument.NODE_ELEMENT);
    texturef.value="file";
    var tfn = texturef.CreateChild(xmlDocument.NODE_TEXT);   //file中的路径信息可以看做是它的子节点，通过contentsValue可以获取到
    tfn.value = usepath+"/textures/"+texturePath;    //添加路径信息
    
    return texturen;
};

/**
 * @brief 获取本体名称
 * @param {aiNode} -- 来自spp.loader.3d插件。
 * @details 一般的，如果一个实例（mesh）的名称为“abc#001”，或者“abc_001”
 * 那么他的本体名称就是 “abc”。
 * 如果分隔符在名称的第一个位置，比如“_abc001”，那么返回false
 * 如果没有出现分隔符，那么返回false
 */
importer.GetFactName = function (ainode, sep) {
	var meshName = ainode.GetName();
    var pos = meshName.indexOf(sep);
	if(pos <= 0)
		return false;
	else
		return meshName.substring(0, pos);
};

/**
 * @brief 获取mesh名称
 * @param {aiNode} -- 来自spp.loader.3d插件。
 * @details 在max文件中，所有的mesh名称都是类似“abc#123”，转换成x文件的时候，
 * 为了程序的兼容性，mesh名称完成了一次转换“abc_123”。所以在将x文件构建为xml文件的时候，
 * 需要将“_”再次替换为“#”。
 */
importer.GetMeshName = function (ainode) {
    return ainode.GetName().replace("_", "#");
};

/**
 * @brief 该mesh是地面吗？
 * @param {String} -- mesh名称
 * @details 美术规范至少应该将地面命名为gnd1#1这样格式。
 */
importer.IsGroundMesh = function (meshname) {
	return meshname.startsWith("gnd");
};

/**
 * @brief 该mesh是天空球吗？
 * @param {String} -- mesh名称
 * @details 美术规范至少应该将天空球命名为sky1#1这样格式。
 */
importer.IsSkyMesh = function (meshname) {
	return meshname.startsWith("sky");
};

importer.IsPlanningBuilding = function (meshname) {
	return meshname.startsWith("guihua");
};

importer.IsPropMesh = function (meshname) {
	return meshname.startsWith("prop");
};

/**
 * @brief 从保存所有文件路径的数组中找到指定名称的文件。
 * @param afn -- 保存了所有（贴图）文件的路径。
 * @param fn -- 需要寻找的文件名称。
 * @details 如果找到该文件，则返回文件名称，如果没有找到，则返回一个字符串"null"。
 */ 
importer.FindRealName = function (afn, fn)
{
    for(var fni = 0; fni < afn.length; fni++)
    {
        // filename iterate.
        var filePath = afn[fni];
        
        if(filePath == undefined)
        {
            continue;
        }
        
        // "/abc.png" => "abc.png"
        var filename = filePath.substr(1, filePath.length);   //取到每个字符串
        if(filename.toLocaleLowerCase() == fn.toLocaleLowerCase())   //转化为小写，如果相等
        {
            return filename;   //返回数组中的这个元素，也是传入的指定的字符串
        }
    }
    return "null";
}

/**
 * @brief 请添加
 * @param {Object} dnode
 * @param {Object} snode
 */
importer.CopyNode = function (dnode, snode)   //参数均为iDocumentNode对象
{   
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
        
        if(!CopyNode(dnode.CreateChild(tchild.type),tchild))  //检查执行是否成功
        {
             System.exitcode = 32;
            //alert("Child Node copy error!");
        }
    }
    return true;
};


/**
 * @brief 
 * @details 生成facpro.xml文件中的<material>节点时候使用的函数
 * <code>
 * <root>
 *   <meshfactory name="bu_001">
 *     <submesh name="bu_001">
 *       <material name="bu001fb">
 *         <diffusetexture>/art/textures/bu_001fb.jpg</diffusetexture>
 *       </material>
 *     </submesh>
 *     <submesh name="bu_001">
 *       <material name1="bu001fd">
 *         <diffusetexture>/art/textures/bu_001fd.jpg</diffusetexture>
 *       </material>
 * [...]
 * </code>
 * @param material -- 3ds的scene中的material节点。
 * @param materialpronode -- `<material>`节点，在facpro.xml文件中。
 * @param allfilenames -- 一个数组，根路径下所有文件的全路径。
 * @param texture -- 贴图的文件名称。
 * @fixme 需要将全局变量usepath替换为Ctx.usepath类似的。
 */
importer.addMatetialPro = function (material, materialpronode, allfilenames, texture)
{
    // 在3ds文件中定义的材质名称。
    var matname = material.GetPropertyName(0);
    
    var iReporter = Registry.Get("iReporter");
    System.Report("Material name is : " + matname, iReporter.DEBUG/* 4 */, "");
    
    materialpronode.SetAttribute("name", matname);  //设置material的名字
    
    var textRealName = importer.FindRealName(allfilenames,texture.path);
    
    // diffuse map
    if(VFS.Exists(textRealName))
    {
        texturepro = materialpronode.CreateChild(xmlDocument.NODE_ELEMENT);    //创建节点
        texturepro.value="diffusetexture";
        tprof = texturepro.CreateChild(xmlDocument.NODE_TEXT);
        tprof.value = usepath+"/textures/"+textRealName;
    }
    
    // normal map
    if(VFS.Exists("n"+textRealName))
    {
        
        texturepro = materialpronode.CreateChild(xmlDocument.NODE_ELEMENT);
        texturepro.value="normaltexture";
        tprof = texturepro.CreateChild(xmlDocument.NODE_TEXT);
        tprof.value = usepath+"/textures/"+"n"+textRealName;
    }
    
    // specular map
    if(VFS.Exists("s"+textRealName))
    {
        texturepro = materialpronode.CreateChild(xmlDocument.NODE_ELEMENT);
        texturepro.value="speculartexture";
        tprof = texturepro.CreateChild(xmlDocument.NODE_TEXT);
        tprof.value = usepath+"/textures/"+"s"+textRealName;
    }
    
    // height map
    if(VFS.Exists("h"+textRealName))
    {
        texturepro = materialpronode.CreateChild(xmlDocument.NODE_ELEMENT);
        texturepro.value="heighttexture";
        tprof = texturepro.CreateChild(xmlDocument.NODE_TEXT);
        tprof.value = usepath+"/textures/"+"h"+textRealName;
    }
}

/**
 * @brief 创建XML节点
 * @param {Object} 父节点
 * @param {String} 子节点名
 * @param {Array} 参数数组
 */
var AppendChild = function(parent, nodename, property)
{
	var child = parent.CreateChild(xmlDocument.NODE_ELEMENT);
	child.value = nodename;
	for(idx in property)
	{
		child.SetAttribute(property[idx][0], property[idx][1]);
	}
};


/**
 * @brief 创建<minrenderdist>和<maxrenderdist>节点
 */
importer.SetRenderDistance = function(meshobjnode, maxdist)
{
	AppendChild(meshobjnode,
		"minrenderdist",
		[
			["value", "0.01"]
		]
	);
	AppendChild(meshobjnode,
		"maxrenderdist",
		[
			["value", maxdist]
		]
	);
};

/**
 * @brief 从完整路径中获取文件名称，包括扩展名
 **/
importer.GetFileName = function (fullPath) {
	var splitPath = fullPath.split("\\");
	AssertTrue(splitPath.length > 1, "Full path of 3ds file is not correct.");
	return splitPath[splitPath.length - 1];
};

/**
 * @brief 从文件名中获取不包含扩展名的部分。
 * 支持的格式：
 * a.3ds
 * a.b.3ds
 * a.b.c.3ds
 **/
importer.GetOnlyFileName = function (fileName) {
	var splitName = fileName.split(".");
	splitName.pop();
	return splitName.join(".");
};

/**
 * @brief 从场景3ds文件名称中获得序号。
 * 比如输出“scene2.3ds”则输出为“2”
 **/
importer.getSceneNumber = function (sceneFileName) {
	return sceneFileName.split("scene")[1];
};

})();