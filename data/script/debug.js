/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

try {

(function(){
	var con = Registry.Get("iConsole");
	var rep = Registry.Get("iReporter");
	var debug = new Object();
	var written = false;
	rep.AddListener(function(sev,id,ctx){
		con.foreground = con.WHITE;
		con.Write(id);
		con.WriteLine(":");
		con.Write('\t');
		written = true;
		switch(sev)
		{
		case rep.EMERG:
			con.foreground = con.MAGENTA;
			break;
		case rep.ERROR:
			con.foreground = con.RED;
			break;
		case rep.WARNING:
			con.foreground = con.CYAN;
			break;
		case rep.NOTIFY:
			con.foreground = con.GREEN;
			break;
		case rep.DEBUG:
			con.foreground = con.BLUE;
			break;
		}
		con.WriteLine(ctx);
	});
	Event.Subscribe(function(){
		if(written){
			if(!CmdLine.GetOption("nowait", 0))
			{
				con.foreground = con.RED;
				con.Write("\tPress any key to quit...");
				con.ReadKey();
			}

			written = false;
		}
	},"crystalspace.application.quit");
})();

/* use a function for the exact format desired... */
// ref : https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference:Global_Objects:Date#section_11
function ISODateString(d){
  function pad(n){return n<10 ? '0'+n : n}
  return d.getUTCFullYear()+'-'
      + pad(d.getUTCMonth()+1)+'-'
      + pad(d.getUTCDate())+'T'
      + pad(d.getUTCHours())+':'
      + pad(d.getUTCMinutes())+':'
      + pad(d.getUTCSeconds())//+'Z'
}

function getIsoDateTime()
{
	var now = new Date();
	
	var yyyy = now.getFullYear();
	var m = now.getMonth() + 1;
	var mm = (m < 10) ? '0' + m : m;
	var d = now.getDate();
	var dd = (d < 10) ? '0' + d : d;
	
	var HH = now.getHours();
	var MM = now.getMinutes();
	var ss = now.getSeconds();
	
	var date = yyyy + "-" + mm + "-" + dd;
	var time = HH + ":" + MM + ":" + ss;
	
	// 2011-11-16T19:45:44
	return date + "T" + time;
}

/**
 * @brief 获取主节点的最后一个child的id值。
 * 如果该主节点没有child，则返回id为1（表示这是第一个child节点）。
 **/
var getNextTestId = function (mainNode)
{
	var lastId = 0;
	var itMainNode = mainNode.GetChildren();
	while(itMainNode.HasNext())
	{
		var node = itMainNode.Next();
		lastId = node.GetAttributeValue("id");
	}
	return ++lastId;
}

function CreateReportFile(filename)
{
	var document = new xmlDocument();
	var root = document.CreateRoot();
	
	var declnode = root.CreateChild(xmlDocument.NODE_DECLARATION);
	declnode.SetAttribute("version", "1.0");
	declnode.SetAttribute("encoding", "UTF-8");
	declnode.SetAttribute("standalone", "yes");
	
	var mainnode = root.CreateChild(xmlDocument.NODE_ELEMENT);
	mainnode.value = "testsuites";
	
	var fwrite = VFS.Open(filename, VFS.WRITE);
	document.WritetoFile(fwrite);
	fwrite.Flush();
	
}

/**
 * @brief Support a exist file with correct decl header.
 **/
function InitReportFile(filename)
{
	var document = new xmlDocument();

	var fread = VFS.Open(filename);
	document.Parse(fread);
	
	// Remove main node.
	//document.root.RemoveChildren(document.root.GetChild("testsuites"));

	//var suitesnode = document.root.CreateChild(xmlDocument.NODE_ELEMENT);
	//suitesnode.value = "testsuites";
	var suitesnode = document.root.GetChild("testsuites");
	
	if(!suitesnode)
	{
		var root = document.CreateRoot();
		var declnode = root.CreateChild(xmlDocument.NODE_DECLARATION);
		declnode.SetAttribute("version", "1.0");
		declnode.SetAttribute("encoding", "UTF-8");
		declnode.SetAttribute("standalone", "yes");
		
		var mainnode = root.CreateChild(xmlDocument.NODE_ELEMENT);
		mainnode.value = "testsuites";

		suitesnode = document.root.GetChild("testsuites");
	}
	
	//<testsuites time="0.0000" timestamp="2011-11-25T21:26:06" errors="0" failures="0" tests="1" hostname="localhost" name="unit_test">
	suitesnode.SetAttribute("time", "0.0000");
	suitesnode.SetAttribute("timestamp", getIsoDateTime());
	// suitesnode.SetAttribute("timestamp", ISODateString(new Date()));
	suitesnode.SetAttribute("errors", "0");
	suitesnode.SetAttribute("failures", "0");
	suitesnode.SetAttribute("tests", "0");
	suitesnode.SetAttribute("hostname", "localhost");
	suitesnode.SetAttribute("name", "unit_test");
	
	//suitenode = suitesnode.CreateChild(xmlDocument.NODE_ELEMENT);
	//suitenode.value = "testsuite";
	var suitenode = suitesnode.GetChild("testsuite");
	if(!suitenode)
	{
		suitenode = suitesnode.CreateChild(xmlDocument.NODE_ELEMENT);
		suitenode.value = "testsuite";
		suitenode = suitesnode.GetChild("testsuite");
	}
	
	//<testsuite time="0.0000" timestamp="2011-11-25T21:26:06" tests="1" hostname="localhost" name="XmlTest" errors="0" failures="0">
	suitenode.SetAttribute("time", "0.0000");
	suitenode.SetAttribute("timestamp", getIsoDateTime());
	// suitenode.SetAttribute("timestamp", ISODateString(new Date()));
	suitenode.SetAttribute("tests", "0");
	suitenode.SetAttribute("hostname", "localhost");
	suitenode.SetAttribute("name", "unit_test");
	suitenode.SetAttribute("errors", "0");
	suitenode.SetAttribute("failures", "0");
	
	var fwrite = VFS.Open(filename, VFS.WRITE);
	document.WritetoFile(fwrite);
	fwrite.Flush();
}

/**
 * @brief 全局函数，类似于C中的assert。
 **/
function AssertTrue(expr)
{
	// 断言是正确的。
	if(expr) return;
	
	// 处理描述信息部分（组合成为一个字符串）。
	var desc = "";
	if(arguments.length <= 1)
	{
		desc += expr;
	}else{
		for(var i = 0; i < arguments.length;i++)
			desc += arguments[i];
	}
	
	// 在Console中抛出assert失败信息。
	var iReporter = Registry.Get("iReporter");
	System.Report(desc, iReporter.ERROR, "Assert Failed");
	
	if(CmdLine.GetOption('autotest',0))
	{
		// 如果带有`--autotest`参数，则输出XML格式的自动测试报告。
		WritetoXMLReport(desc);
		
		// FIXME : 应该在`sys_start.js`中包含一个`autotest.js`，并在根据是否有`--autotest`参数判断是否重置alert。
		alert = function() {};
	}
	else
	{
		// 以弹出窗口提示用户。
		alert("Assert Failed: ", desc);
	}
	
	// 直接退出了，这里模仿了C中的`abort`函数。
	exit(1);
}

/**
 * @brief 将描述信息写入XML文件。
 **/
var WritetoXMLReport = function (desc)
{
	var report_filename = "/report/test_result.xml";
	var mount_real_path = System.InstallPath() + "\\..\\..\\generatedJUnitFiles\\";

	// 获得函数名称，堆栈信息，组成错误描述信息。
	{
		var errStr = "ERROR: ";
		var fname = "Unknown function name";
		var className = "Unknown class name";
		var o = System.GetStackTrace();
		
		if(desc)
			errStr += desc;
		
		if(o.length > 2)
		{
			errStr += " \nAt funtion '";
			errStr += o[2].functionName;
			fname = GetFunctionName(o[2].scriptName);
			className = GetClassName(o[2].scriptName);
			errStr += ("' in line::column " + o[2].line + "::" + o[2].column + " of file '" + o[2].scriptName+ "'\n");
		}
	}
	
	if(!VFS.Mount("/report", mount_real_path))
	{
		alert("fail to mount dir.");
		return false;
	}
	
	if(!VFS.Exists(report_filename))
	{
		CreateReportFile(report_filename);
		InitReportFile(report_filename);
	}
	else
	{
		// 如果不存在XML文件（report），则创建之，并初始化最基本的XML结构。
		InitReportFile(report_filename);
	}
	
	var fread = VFS.Open(report_filename);
	if(!fread)
	{
		alert("fail to read file.");
		return false;
	}
	
	var document = new xmlDocument();
	if(!document.Parse(fread))
	{
		alert("fail to parse file.");
		return false;
	}
	
	// <testsuites>根节点。
	var suitesNode = document.root.GetChild("testsuites");
	
	// 根据class name判断<testsuites>节点中是否已经存在该class的测试节点，
	// 如果不存在则创建之。
	var suiteNode = GetSuiteNode(suitesNode, className);
	
	// current test count.
	var currentClassTestCount = suiteNode.GetAttributeValue("tests");
	var currentAllTestCount = suitesNode.GetAttributeValue("tests");
	var currentClassErrorCount = suiteNode.GetAttributeValue("errors");
	var currentAllErrorCount = suitesNode.GetAttributeValue("errors");
	var currentClassFailureCount = suiteNode.GetAttributeValue("failures");
	var currentAllFailureCount = suitesNode.GetAttributeValue("failures");
	
	// update test number
	suitesNode.SetAttribute("tests", ++currentAllTestCount);
	suiteNode.SetAttribute("tests", ++currentClassTestCount);
	
	// update error and failure count.
	suitesNode.SetAttribute("errors", ++currentAllErrorCount);
	suitesNode.SetAttribute("failures", ++currentAllFailureCount);
	suiteNode.SetAttribute("errors", ++currentClassErrorCount);
	suiteNode.SetAttribute("failures", ++currentClassFailureCount);
	
	// update timestamp
	suitesNode.SetAttribute("timestamp", getIsoDateTime());
	suiteNode.SetAttribute("timestamp", getIsoDateTime());
	// suitesNode.SetAttribute("timestamp", ISODateString(new Date()));
	// suiteNode.SetAttribute("timestamp", ISODateString(new Date()));
	
	// 往叶子节点写入属性
	{
		//<testcase id="1" class="XmlTest" name="test_create_ast" time="0.0000"></testcase>
		var caseProp = [
			["id", getNextTestId(suiteNode)],
			["class", className],
			["name", fname],
			["time", "0.0000"]
		];
		
		var caseNode = suiteNode.CreateChild(xmlDocument.NODE_ELEMENT);
		caseNode.value = "testcase";
		AppendProperty(caseNode, caseProp);
	}
	
	{
		//<failure type="NotEnoughFoo"> details about failure </failure>
		var failNode = caseNode.CreateChild(xmlDocument.NODE_ELEMENT);
		failNode.value = "failure";
		failNode.SetAttribute("type", "AssertTrue");
		var textNode = failNode.CreateChild(xmlDocument.NODE_TEXT);
		textNode.value = errStr;
	}
	
	var fwrite = VFS.Open(report_filename, VFS.WRITE);
	document.WritetoFile(fwrite);
	fwrite.Flush();
}

/**
 * @brief 从脚本的真实路径（绝对地址），获得脚本当前的Class名称。
 * 当然这个要求测试脚本的目录结构必须按照`Class/Function`来创建。
 **/
var GetClassName = function (filename)
{
	// filename = "vector2_add.js"
	var className = "";
	
	// realPath = "D:\source\spp\test\auto\Math3D\Vector2\vector2_add.js"
	var realPath = VFS.GetRealPath(filename);
	
	if(realPath.split("auto\\").length < 2)
		return filename;
	
	// relatedPath = "Math3D\Vector2\vector2_add.js"
	var relatedPath = realPath.split("auto\\")[1];
	
	// tmpPath = "Math3D\Vector2"
	var from = 0;
	var to = (relatedPath.length - filename.length) - 1;
	var tmpPath = relatedPath.substring(from, to);
	
	// className = "Math3D.Vector2"
	className = tmpPath.split("\\").join(".");
	
	return className;
}

/**
 * @brief 从脚本的真实路径（绝对地址），获得脚本当前Class的成员函数名称。
 * 当然这个要求测试脚本的目录结构必须按照`Class/Function`来创建。
 **/
var GetFunctionName = function (filename)
{
	// filename = "/Add.js"
	return filename.substring(1).split(".")[0];
}

/**
 * @brief 从<testsuites>节点中获得需要写入的子节点，如果不存在则创建之。
 **/
var GetSuiteNode = function (suitesNode, className)
{
	var suiteNode = -1;
	
	// <testsuites>中是否存在属性`name`为`className`的节点。
	var itMainNode = suitesNode.GetChildren();
	while(itMainNode.HasNext())
	{
		var node = itMainNode.Next();
		if(className == node.GetAttributeValue("name"))
		{
			suiteNode = node;
		}
	}
	
	// 不存在上述节点，创建之。
	if(suiteNode == -1)
		suiteNode = CreateNewSuiteNode(suitesNode, className);
	
	return suiteNode;
}

/**
 * @brief 创建一个标准的suite node。
 * @param name -- <testsuite name="">属性值。
 **/
var CreateNewSuiteNode = function(suitesNode, className)
{
	var suiteNode = suitesNode.CreateChild(xmlDocument.NODE_ELEMENT);
	suiteNode.value = "testsuite";
	suiteNode.SetAttribute("time", "0.0000");
	suiteNode.SetAttribute("timestamp", getIsoDateTime());
	// suiteNode.SetAttribute("timestamp", ISODateString(new Date()));
	suiteNode.SetAttribute("tests", "0");
	suiteNode.SetAttribute("hostname", "localhost");
	suiteNode.SetAttribute("name", className);
	suiteNode.SetAttribute("errors", "0");
	suiteNode.SetAttribute("failures", "0");
	
	return suiteNode;
}

/**
 * @brief Append property in an array to a node.
 **/
function AppendProperty(node, propArray)
{
	var idx = 0;
	for(var idx = 0; idx < propArray.length; idx++)
	{
		//alert(propArray[idx][0], propArray[idx][1]);
		node.SetAttribute(propArray[idx][0], propArray[idx][1]);
	}
}

function AssertEquals(expr1,expr2,desc){ //测试两个参数是否相等
	if(expr1 != expr2){
		var errStr = "ERROR: ";
		if(desc)
			errStr += desc;
		o = System.GetStackTrace();
		if(o.length > 1)
		{
			errStr += " \nAt funtion '";
			errStr += o[1].functionName ;
			errStr += ("' in line::column " + o[1].line + "::" + o[1].column + " of file '" + o[1].scriptName+ "'\n");
		}
		file = VFS.ReadFile("Error.txt");//假设工作目录下有文件Error.txt，读取该文件内容
		datilFile = file.GetString();//按字符串获取该文件内容
		VFS.WriteFile("good.txt", datilFile + errStr, datilFile.length + errStr.length);//将字符串errStr写入文件Error.txt
	}
}

} catch(e) {
	alert(e);
}