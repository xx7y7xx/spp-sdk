/*----------------------------------------------------------
--
-- Copyright (C) 2012 Sanpolo Co.LTD
-- http://www.spolo.org
--
--  This file is part of the UGE(Uniform Game Engine).
--  Copyright (C) by SanPolo Co.Ltd. 
--  All rights reserved.
--
--  See http://uge.spolo.org/ for more information.
--
--  SanPolo Co.Ltd
--  http://uge.spolo.org/  sales@spolo.org uge-support@spolo.org

--
------------------------------------------------------------
*/

 /**
 * @brief convert timestamp to format time
 * @details give me 12345678, give you "03:25:45:678"
 * from : http://area.autodesk.com/forum/autodesk-3ds-max/maxscript/help-format-timestamp-into-hhmm-
 */
fn timeFormatter balance =
(
	
	local hrs = ( (balance / 1000) / 3600 ) as integer
	balance = balance - (hrs * 3600 * 1000)
	
	local mins = ( (balance / 1000) / 60) as integer
	balance = balance - (mins * 60 * 1000)
	
	local secs = (balance / 1000) as integer
	balance = balance - (secs * 1000)
	
	local ms = balance
	
	(formattedPrint hrs format:"02i") + ":" + \
		(formattedPrint mins format:"02i") + ":" + \
		(formattedPrint secs format:"02i") + ":" + \
		(formattedPrint ms format:"03i")
)

fn getCurrentTime =
(
	local ct = timeStamp()
	(timeFormatter ct)
)

/**
 * debug function 
 */
fn logtimer str =
(
	print ("[" + getCurrentTime() + "] "+ str)
)

/**
 * @brief check if directory(not file) is exist
 */
fn doesDirExist dir =
(
	return (doesFileExist dir) and (getfileattribute dir #directory)
)

fn existFile fname =
(
	(getfiles fname).count != 0
)

/**
 * @brief 运行SPP SDK提供的工具
 */
fn startSppTool toolname param =
(
	if cmd != "" do
	(
		--chenyang: replace `ShellLaunch`, `DOSCommand` can wait to execute end.
		DOSCommand (toolname + " " + param)
	)
)

/**
 * @brief 得到项目的路径 
 * 比如`D:\p\duiwaijingmaodaxue`
 */
fn getProjectPath = 
(
	local p = maxFilePath
	p = tolower p
	local thisProjectPath = ""
	if p == "" then -- 判断是否保存文件
	(
		messagebox "请保存场景！"
		return false
	)
	else
	(
		p_arr = filterString p "\\"
		allProjectsPath = p_arr[1] + "\\" + p_arr[2]
		if p_arr.count>3 and allProjectsPath == "d:\p" then 
		(
			thisProjectPath = p_arr[1] + "\\" + p_arr[2] + "\\" + p_arr[3]
		)
		else
		(
			messagebox "请保存在正确的项目目录下！\n(Make sure this project is in [D:\\p\\] path)"
			return false
		)
	)
	return thisProjectPath
)


/**
 * @brief 得到项目的路径 
 */
fn getCmdPath = 
(

	p =maxFilePath
	p = tolower p
	cmd_p = ""
	cmd = ""
	if p != "" then 
	(-- 判断是否保存文件
		p_arr = filterString p "\\"
		projectPath = p_arr[1] + "\\" + p_arr[2]
		if p_arr.count>3 and projectPath == "d:\p" then 
		(
			cmd_p = p_arr[1] + "\\" + p_arr[2] + "\\" + p_arr[3]
			cmd = "cd /d " +cmd_p
		)else
		(
			messagebox "请保存在正确的项目目录下！\n(Make sure this project is in [D:\\p\\] path)"
		)
		
	)else
	(
		messagebox "请保存场景！"
	)
	cmd

)
--check spp-sdk是否在电脑上注册
fn checksdk =
(
	sppenv = systemTools.getEnvVariable "SPP_HOME" 
	if sppenv != undefined then
		return true
	else
		return false
)
--######################################## mesh's effect export to effect.xml ###########################################

fn checkpPath = 
(--get project path

	p =maxFilePath
	p = tolower p
	cmd = ""
	if p != "" then 
	(
		p_arr = filterString p "\\"
		local len = (p_arr.count)
		local bfound = false
		local artidx
		for idx = 2 to len - 1 do (
			if ( p_arr[idx] == "src" and  p_arr[idx + 1] == "art" ) do
			(
				bfound = true
				artidx = idx - 1
				break
			)
		)
		if(bfound) then(
			for ppidx = 1 to artidx do(
				if (cmd != "") then(
					cmd = cmd + "\\"
				)
				cmd = cmd + p_arr[ppidx] as string ;
			)
		)else
		(
			messagebox "请保存在正确的项目目录下！"
		)
	)else
	(
		messagebox "请保存场景！"
	)
	cmd

)


/**
 * @brief Call ArtBuild tool to build all the 3ds to xml files
 * SPP will use these xml files.
 * @details there is 3 section:
 *  1.build factory/*.3ds
 *  2.build scene/*.3ds
 *  3.build uv_lightmap/*.3ds
 */
fn sppbuild =
(
	-- 动态灯光build
	cmd = getCmdPath()
	if cmd != "" do
	(
		--DOSCommand (cmd+" & sppbuild")
		cmdstr = "/C \"" +	cmd+" & sppbuild"
		ShellLaunch "cmd" cmdstr	
		
	)
)

/**
 * @brief 判断该贴图是否应该忽略材质检查。
 * @param filepath 接受的参数应该是绝对路径。
 * @details 如果应该忽略，则返回true。
 */
fn isTextureIgnoreChecking filepath =
(
	for ignoreItem in G_IgnoreTextureList do
	(
		if matchPattern filepath pattern:("*\\"+ignoreItem) do
			return true
	)
	return false
)

/**
 * logger
 */
fn spOpenLog =
(
	openLog G_SCENELOGFILE mode:"w" outputOnly:true
)
fn spCloseLog =
(
	closeLog()
)

/**
 * @brief mesh name rule
 * 1. must below 16 chars.
 * 2. must contains "#", and only one "#"
 * 3. must have chars on both left side and right side of "#"
 * 4. on the right side of "#" must number.
 */
fn nameruleChecker meshname =
(
	if meshname.count > 16 do
		return false
	if (matchPattern meshname pattern:"*#*") == false do
		return false
	if (matchPattern meshname pattern:"*#*#*") == true do
		return false
	if (filterString meshname "#").count != 2 do
		return false
	if ((filterString meshname "#")[2] as integer) == undefined do
		return false
	true
)

/**
 * check if meshname is prefixed with the given prefix string.
 */
fn namerulePrefixChecker prefix meshname =
(
	-- must begin with prefix.
	if (matchPattern meshname pattern:(prefix+"*")) == false do
		return false
	-- next of prefix is a number.
	if (filterString meshname prefix)[1] as integer == undefined do
		return false
	return true
)

fn removeErrorLogFile filename =
(
	local dir = getProjectPath()+"\\plan\\问题"
	local fullpath = dir + "\\" + filename
	
	if (existFile fullpath) then 
		try(deletefile fullpath)catch()
)

fn createErrorLogFile filename content =
(
	local dir = getProjectPath()+"\\plan\\问题"
	makeDir dir
	
	local fullpath = dir + "\\" + filename
	-- make sure old log not exist.
	try(deletefile fullpath)catch()
	
	local outFile = createFile fullpath
	format (content as String) to:outfile
	close outfile
)

fn createLevelB num content =
(
	createErrorLogFile (G_LevelBError[num] + ".txt") content
)

fn removeLevelB num =
(
	removeErrorLogFile (G_LevelBError[num] + ".txt")
)

--exclude lod
fn excludemeshgen imesh =
(
	effecttype = getUserProp imesh "submatid0"
	if effecttype != "" and effecttype != undefined then
	(
		str = effecttype as string
		ary = filterString str ")"
		if ary[1] == "水" then
		(
			return true
		)
	)
	return false
)

--自定义排序方法
fn compareFN v1 v2 =
(
	local d = (v1.len)-(v2.len)
	case of
	(
	(d < 0.): -1

	(d > 0.): 1
	default: 0
	)
)

--find meshgen xiaopin
fn selectMeshgen =
(
	struct stMesh (len,name)
	arrMesh =#()
	for i in geometry do
	(
		if((excludemeshgen i) == false)then
		(
			minpos = i.min
			maxpos = i.max
			lenline = distance minpos maxpos
			s1 = stMesh len:lenline name:i--.name
			append arrMesh 	s1
		)
	)
	arrselect = #()
	if(arrMesh.count > 1)do
	(
		qsort arrMesh compareFN 
		--经验参数,设置比例
		indx = 0.005
		count = arrMesh.count
		bizhi = indx*(arrMesh[count].len)
		--
		findflag = stMesh len:bizhi name:"findflag"
		append arrMesh findflag
		qsort arrMesh compareFN 
		--arrselect = #()
		bkflag = false
		for i in arrMesh while bkflag == false do
		(
			if(i.len == bizhi and i.name == "findflag")then
				bkflag =true
			else
				append arrselect (i.name)
		)
	)
	/* for p in arrMesh do print p
	print (arrMesh.count)
	for ip in arrselect do print ip
	print (arrselect.count) */
	arrselect
)

---- check hud plant cross
fn computeRadius obj1 obj2 =
(
	lengths = distance obj1.center obj2.center
	plen = obj1.radius + obj2.radius
	if plen > lengths then 
		return false
	else 
		return true
)

-- 生成一个txt文件，包含该max中所有模型引用的材质
-- 解决多人合作的问题。比如一个学校分了三个区（max文件），如果只是打开并检查其中一个max文件，则
-- 不需要对整个diffuse目录下的所有texture进行检查。
-- 而且还需要忽略一些从材质库copy过来的文件。
fn exptexInfo =
(
	arrALLTexMap = #()
	for obj in geometry do
	(
		--texname = ""
		mat = obj.material
		submatnum = getNumSubMtls mat
		if submatnum == 0 then
		(
			 --texname = texname + (mat.diffuseMap.filename) + "\n"
			texname = mat.diffuseMap.filename
			if (finditem arrALLTexMap texname) == 0 then
				append arrALLTexMap texname
		)
		--add
		else if submatnum > 0 then
		(
			if(classof obj.baseobject != Editable_Mesh)then convertToMesh obj
			arrTexMap = #()
			objfaces = obj.numfaces
			bkflag = false
			matcount = 0
			for f = 1 to objfaces while bkflag == false do
			(	--此处或者直接先按材质算
				submatid = getFaceMatID obj f
				CurrentSubMtl = mat.materialList[submatid]
				try(
					if (CurrentSubMtl.diffuseMap) != undefined  then
					(
						tmptexname = CurrentSubMtl.diffuseMap.filename
						findindex = finditem arrTexMap tmptexname
						if(findindex == 0)then
						(
							append arrTexMap tmptexname
							matcount += 1
							if(finditem arrALLTexMap tmptexname) == 0 then
								append arrALLTexMap tmptexname
						)
					)
				)catch()
				if matcount == submatnum then bkflag = true
			)
		)
		--for istr in arrTexMap do texname += istr + "\n"
	)
	
	cp = checkpPath()
	srcdir = "\\src\\art\\scene\\effect"
	outputPath=cp+srcdir
	makeDir outputPath
	fileN  = "\\texInfo.txt"
	filename = (outputPath + fileN )
	
	if (existFile filename) then
		try(deleteFile filename)catch()
	
	outFile = createFile filename
	
	-- 需要排除如下贴图，因为这些贴图是素材库提供的，不用进行检测。
	-- water1.jpg, sky.jpg
	if arrALLTexMap.count > 0 then
	(
		cnt = arrALLTexMap.count
		for i = 1 to (cnt-1) do
		(
			if isTextureIgnoreChecking(arrALLTexMap[i]) do
				continue
			format (arrALLTexMap[i] + "\n") to:outFile
		)
		-- txt最后一行不要输出换行符。
		if not isTextureIgnoreChecking(arrALLTexMap[cnt]) do
			format arrALLTexMap[cnt] to:outFile
	)
	close outFile
	filename
)

/**
 * @brief 导出3ds文件
 */
fn export_3ds =
(
	expInstancMesh()
	exportTempbb()
	messagebox"本体和场景导出完毕！！！"
)

/**
 * @brief 导出x文件
 */
fn export_camera_path =
(
	camera_path_export()
	messagebox"摄像机路径导出完毕！！！"
)

/**
 * @brief 从x或者3ds文件构建场景。
 */
fn build_scene =
(
	sppbuild()
)

-------------------------x文件以及材质信息导出--------------------------------------
fn xfile_export =
(
	rename_materials()
	
	for iobj in objects do
	(
		if(classof iobj) != Editable_Poly do
		(
			converttopoly iobj
		)
		if(classof iobj) == Editable_Poly do
		(
			mapchannel = polyop.getNumMaps  iobj
			if(mapchannel > 3) do
			(
				for ic = 0 to  mapchannel-4 do
				(
					channelInfo.ClearChannel iobj (mapchannel-1-ic)
					converttopoly iobj
				)

			)
		)
	)
	
	for i in objects do
	(
		if(i.mat == undefined) do
		(
			continue
		)
		if((classof i.mat) == Standardmaterial) then			
		(
			if(i.mat.diffusemap != undefined)do
			(
				i.mat.diffuseMapEnable = on
				--i.mat.Diffuse = color 155 155 155
			)
		)
		else
		(
			if((classof i.mat) == Multimaterial) do
			(
				submatnum = getNumSubMtls i.mat
				for im = 1 to submatnum do
				(
					if(((classof (i.mat[im])) == Standardmaterial) and (i.mat[im].diffusemap != undefined)) do
					(
						i.mat[im].diffuseMapEnable = on
						--i.mat[im].Diffuse = color 155 155 155
					)
				)
			)
		)
	)
	
	
	xfilepath = checkpPath() +"\src\art\scene\\" + "scene.x"
	exportfile xfilepath #noPrompt selectedOnly:false
	
	matpropath = checkpPath() +"\src\art\scene\\" + "matpro.xml"

	matfileN_arr = filterString matpropath "\\"
	matdir = ""
	for i = 1 to (matfileN_arr.count-1) do
	(
		matdir += matfileN_arr[i] + "\\"
	)
	matdir = substring matdir 1  (matdir.count-1)
	makeDir  matdir  
	matoutFile = createFile matpropath
	exprotmat matoutFile
	close matoutFile
)

fn exprotmat outFile = 
(
	format "<materials>\n" to:outFile

	for mat in scenematerials do
	(
		if((classof mat) == Standardmaterial) then
		(
			matname = mat.name 	
			format "\t<% type = \"%\" twoSided = \"%\"/>\n" matname "Standardmaterial" mat.twoSided to:outFile
		)
		else
		(
			if((classof mat) == Multimaterial) do
			(
				--format "\t<material name = \"%\" type = \"%\">\n" mat.name "Multimaterial" to:outFile
				
				submatnum = getNumSubMtls mat
				
				matname = mat.name 
				
				for im = 1 to submatnum do
				(
					if((classof (mat[im])) == Standardmaterial) do
					(
						submatname = mat[im].name
						for i=1 to submatname.count do
						(
							if(submatname[i] == " ") or (submatname[i] == "#") or (submatname[i] == ".")  do
							(
								submatname[i] = "_"
							)
						)
						format "\t<% ftype = \"%\" type = \"%\" twoSided = \"%\"/>\n" (matname + "_" + submatname + "Sub" + ((im-1) as string)) "Multimaterial" "Standardmaterial" mat[im].twoSided to:outFile
					)
				)
				
				--format "\t</material>\n" to:outFile
			)
		)

	)

	format "</materials>\n" to:outFile

)

----------------------------输出一个boundingbox来代替场景复杂的模型------------------------------------
fn exportTempbb = 
(
	disableSceneRedraw()
	l = LayerManager.getLayer 0
	l.current = true
	
	sceneN = 0
	emptyLayers =#()
	cp = checkpPath()    -- 检查路径
	srcdir0 = "\\src\\art\\scene"    -- 定义scene路径
	outputPath = cp + srcdir0  -- 定义最终输出路径
	oldfiles=outputPath + "\\" +  "*.3ds"
	try(
		for oldfile in getFiles oldfiles do deleteFile oldfile
	)catch()

	for il = 0 to layerManager.count-1 do
	(
		ilayer = layerManager.getLayer il
		layerName = ilayer.name 
		layer = ILayerManager.getLayerObject il
		layer.nodes &theNodes
		layerNodeCnt = theNodes.count
		--format"layer:%  %\n"il theNodes.count
		--空层跳过
		if layerNodeCnt == 0 then
		(
			append emptyLayers (layerName as string)
			
		)else 
		(
			exportBox = #()
			for i in theNodes do
			(
				if ((classof i) != Editable_mesh) and ((classof i) != Editable_Poly)do
				(
					continue
				)
				b = box()  -- 创建盒子
				converttopoly b  -- 变成polygon
				b.transform = i.transform  --读取物体的transform
				b.name = i.name   -- 读取物体的名字
				append exportBox b  -- 加入到输出盒子数组
			)
			cp = checkpPath()    -- 检查路径
			srcdir = "\\src\\art\\scene"    -- 定义scene路径
			outputPath = cp + srcdir  -- 定义最终输出路径
			--exportBox数组是否为空,空不导,不空才导
			flag = exportBox.count
			if (flag>0) do
			(
			sceneN  += 1    -- scene号加1
			filename = outputPath + "\\" + "scene"+ (sceneN as string) + ".3ds"  -- 定义输出文件路径及文件名称
			select exportBox  -- 选择输出的盒子
			exportfile filename #noPrompt selectedOnly:TRUE  -- 直接输出
			delete exportBox -- 删除盒子
			)
-- 				clearSelection()	-- 清除选择
		)
	)
	for il = 1 to emptyLayers.count do ( layermanager.deleteLayerByName emptyLayers[il])
-- 		if LayerManager.isDialogOpen() ==true then (LayerManager.closeDialog();layermanager.editlayerbyname "") else(layermanager.editlayerbyname "")
-- 		messagebox"场景导出完毕！"
	enableSceneRedraw() 
)

--instance本体导出功能
fn expInstancMesh =
(
	/* try(
			heatsize = 600000000-heapsize
		)catch() */
	disableSceneRedraw()
	--删除已有的3ds文件
	cp = checkpPath()
	--geo =geometry as array
	--delete 
	srcdir = "\\src\\art\\factory\\neirong01"
	outputPath=cp+srcdir
	makedir outputPath
	try(
		oldfiles=outputPath + "\\" +  "*.3ds"
		for oldfile in getFiles oldfiles do deleteFile oldfile
	)catch()
	--
	myobj = #()
	arryname =#()
	for obj = geometry do
	(
		--objname = obj.name
		--if(matchPattern objname pattern:"*#1")then
		--	append myobj obj
		--采用#号前名字不同就导出,而不采用符合"*#1"才导出这一方法
		fsindex=findString (obj.name) "#"
		objname = (substring (obj.name) 1 (fsindex-1))
		if((finditem arryname objname) ==0)do
		(
			append myobj obj
			append arryname objname
		)
	)
	for i in myobj do
	(
		oldname = i.name
		fsindex=findString (i.name) "#"
		objname = (substring (i.name) 1 (fsindex-1))
		i.name = objname
		filename=outputPath+"\\"+objname+".3ds"
		select i
		instancemgr.getinstances i &instances
		subobjectLevel = 0
		max modify mode
		ResetXForm i
		convertToPoly i
		scene_pos = i.transform
		i.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
		try(
			ResetXForm i
			convertToPoly i
		)catch()
		exportfile filename #noPrompt selectedOnly:TRUE
		i.name = oldname
			--print filename
		i.transform = scene_pos
	)
	enableSceneRedraw()
	--export help
)

--效果effect.xml导出
fn expxml =
(
  cp = checkpPath()
  --srcdir = "\\src\\art\\scene\\effect"
	--"D:\p\duiwaijingmaodaxue\src\art\scene\effect\effect.xml"
  srcdir = "\\src\\art\\scene\\effect"
  outputPath=cp+srcdir
  --oldfiles=outputPath + "\\" +  "*.3ds"
  makeDir outputPath
  fileN  = "\\effect.xml"
  filename = (outputPath + fileN)

	--try delete existed file
	if (existFile filename) then 
		try(deleteFile filename)catch()
	
  outFile = createFile filename
  --artbuild
 /*  makeDir	(cp +"\\src\\art\\factory\\neirong01\\effect")
  artfilename = cp + "\\src\\art\\factory\\neirong01\\effect\\effect.xml"
  try(
	  deletefile artfilename
	  outartFile = createFile artfilename
  )catch()	 */	
  --sppbuild
  format "<lib>\n" to:outFile
  --artbuild
  --format "<lib>\n" to:outartFile
  temparry = #()--用来判断一个mesh是否已经被导出xml效果
  wtskyflag = false --判断是否有水的效果,有时加sky meshobj解决黑边问题
  for i = geometry do
	(
		index = 0
		--if(classof (i.mat) == Standardmaterial) then
		--(
		fdstr = findString (i.name) "#"
		--flag = 0
		if fdstr != undefined then
		(
				subname = substring (i.name) 1 (fdstr-1) --mesh去掉#号后的名字
				if(finditem temparry subname ==0)then
				(
					append temparry subname
					Currentmat = i.mat
					
					tmp = #()
					tmpname = #()	
					--tmpartname = #() --artbuild 使用,
					
					if( classof Currentmat == multimaterial ) then
					(		  
						
					   for iSubMtl = 1 to Currentmat.materialList.count do
					   (
						   try(
							CurrentSubMtl = Currentmat.materialList[iSubMtl]
							id = Currentmat.materialIDList[iSubMtl]
							subidname = "submatid" + (id as string)				
							iname = CurrentSubMtl.name --当前子材质名字
							effecttype = getUserProp i subidname --查找是否属性定义内有效果
							if effecttype != "" and effecttype != undefined then
							 (
								 --messagebox iname
								 imatname = Currentmat.name
								 imatname = imatname + "_" + iname + "Sub" +((id - 1) as string) --sppbuild时为x文件assimp解析后材质改名
								-- messagebox imatname
								 append tmpname imatname --sppbuild, material's name
								 append tmp effecttype  --shader 内容
								-- append tmpartname iname --artbuild, material's name
							)		
							)catch()
					   )
					)else --单个材质
					(
					   iname = Currentmat.name
						--x文件与3ds文件没差
					   subidname = "submatid0"
					   --fakename = replacenames  iname  " " ")"
					   effecttype = getUserProp i subidname
						if effecttype != "" and effecttype != undefined then
						 (
							str = effecttype as string
							ary = filterString str ")"
							if(ary[1] != "水") then
							(
								append tmpname iname
								append tmp effecttype
							)
							else
							(
								wtskyflag = true
								-- 不加水lod start
								append tmpname iname
								append tmp effecttype
								--end
							)
							--append tmpartname iname --artbuild, material's name
						 )
						 
				   )	
				   --sppbuild 
				   if(tmpname.count>0)do
				   (
					   format "\t<meshname name = \"%\">\n" subname to:outFile
					   for i =1 to tmpname.count do
					   (
						  -- print tmp[i]
						   str = tmp[i] as string
							ary = filterString str ")"
						   -- messagebox  tmpname[i]
						   if(ary[1] == "水") then
							(
								wtskyflag = true
							)
							format "\t\t<materialname name = \"%\">\n" tmpname[i] to:outFile
							for ii=2 to ary.count do
							(  
								format "\t\t\t" to:outFile
								format ary[ii] to:outFile
								format "\n" to:outFile
							)
							format "\t\t</materialname>\n" to:outFile
					   )
					   format "\t</meshname>\n" to:outFile
				   )
				   
				   --artbuild export xml
				  /*  if(tmpartname.count>0)do
				   (
					   format "\t<meshname name = \"%\">\n" subname to:outartFile
					   for i =1 to tmpartname.count do
					   (
						  -- print tmp[i]
						   str = tmp[i] as string
							ary = filterString str ")"
						   -- messagebox  tmpname[i]
						   
							format "\t\t<materialname name = \"%\">\n" tmpartname[i] to:outartFile
							for ii=2 to ary.count do
							(  
								format "\t\t\t" to:outartFile
								format ary[ii] to:outartFile
								format "\n" to:outartFile
							)
							format "\t\t</materialname>\n" to:outartFile
					   )
					   format "\t</meshname>\n" to:outartFile
				   ) */
				   

				)
			--)
		)
	)
	if(wtskyflag)then
	(
		  format "\t<watersky>\n" to:outFile
		  format "\t\t<material name=\"sky_001\">\n" to:outFile
		  format "\t\t\t<texture>effectsky.dds</texture>\n" to:outFile
		  format "\t\t\t<shader type=\"base\">lighting_fullbright_fixed</shader>\n" to:outFile
		  format "\t\t\t<shader type=\"diffuse\">*null</shader>\n" to:outFile
		  format "\t\t</material>\n" to:outFile
		  format "\t\t<meshobj name=\"skydome_frankieisland_SkyDome\">\n" to:outFile
		  format "\t\t\t<plugin>crystalspace.mesh.loader.genmesh</plugin>\n" to:outFile
		  format "\t\t\t<params>\n" to:outFile
		  format "\t\t\t\t<factory>skydome_frankieisland_SkyDome</factory>\n" to:outFile
		  format "\t\t\t</params>\n" to:outFile
		  format "\t\t\t<trimesh>\n" to:outFile
		  format "\t\t\t\t<id>shadows</id>\n" to:outFile
		  format "\t\t\t</trimesh>\n" to:outFile
		  format "\t\t\t<zuse />\n" to:outFile
		  format "\t\t\t<noshadows />\n" to:outFile
		  format "\t\t\t<move>\n" to:outFile
		  format "\t\t\t\t<v x=\"5000\" y=\"0\" z=\"5000\" />\n" to:outFile
		  format "\t\t\t</move>\n" to:outFile
		  format "\t\t\t<priority>sky</priority>\n" to:outFile
		  format "\t\t</meshobj>\n" to:outFile
		  format "\t</watersky>\n" to:outFile
	)
	--sppbuild
	format "</lib>" to:outFile
	close outFile 
	
	--artbuild
	--format "</lib>" to:outartFile
	--close outartFile
)

---#####export lod xml
--效果effect.xml导出
fn explodxml =
(
	clearSelection()
	cp = checkpPath()
	srcdir = "\\src\\art\\scene"
	outputPath=cp+srcdir
	makeDir outputPath
	fileN  = "\\effect\\lod.xml"
	filename = (outputPath + fileN )
	
	jsfile = "\\water_lod.js"
	jsonfname = (outputPath + jsfile )
	
	--try delete existed file
	if (existFile filename) then 
		try(deleteFile filename)catch()
	
	try(deletefile jsonfname)catch() 
	outFile = createFile filename
	
	jsonFile = createFile jsonfname
	--sppbuild
	format "<lod>\n" to:outFile
	format "WATER_LOD = [\n" to:jsonFile
	temparry = #()--用来判断一个mesh是否已经被导出xml效果
	for i = geometry do
	(
		index = 0
		--使用lod的模型暂时设为只能是单材质的模型
		if(classof (i.mat) == Standardmaterial) then
		(
			fdstr = findString (i.name) "#"
			--flag = 0
			if fdstr != undefined then
			(
				subname = substring (i.name) 1 (fdstr-1) --mesh去掉#号后的名字
				if(finditem temparry subname ==0)then
				(
					append temparry subname
					Currentmat = i.mat
					
					tmp = #()
					tmpname = #()	
					if( classof Currentmat == Standardmaterial) then
					(
					   iname = Currentmat.name
						--x文件与3ds文件没差
					   --subidname = "submatid0"
					   --更改不加lod
					   subidname = "submatid0000"
					   --fakename = replacenames  iname  " " ")"
					   effecttype = getUserProp i subidname
						if effecttype != "" and effecttype != undefined then
						 (
							str = effecttype as string
							ary = filterString str ")"
							if ary[1] == "水" then
							(
								format "\t<factname name = \"%\">\n" subname to:outFile
								format "\t\t<materialname name = \"%\">\n" iname to:outFile
								format "\t\t\t<effect>\n" to:outFile
								for ii=2 to ary.count do
								(  
									format "\t\t\t\t" to:outFile
									format ary[ii] to:outFile
									format "\n" to:outFile
								)
								format "\t\t\t</effect>\n" to:outFile
								
								--json
								--format "\t{\n" to:jsonFile
								
								--format "\t\t\t<meshobj>\n" to:outFile
								tmpobj = for i in geometry where matchPattern i.name pattern:(subname+"#*") ignoreCase:false collect i
								for itmpobj in tmpobj do
								(
									format "\t{\n" to:jsonFile
		
									format "\t\t\"meshobjName\" : \"%\", \n" itmpobj.name to:jsonFile
									format "\t\t\"material\" : {\n" to:jsonFile
									format "\t\t\t\"water\" : \"%\",\n" ("lod_"+iname) to:jsonFile
									format "\t\t\t\"normal\" : \"%\",\n" iname to:jsonFile
									format "\t\t},\n" to:jsonFile
									format "\t\t\"position\" : {\n" to:jsonFile
									format "\t\t\t\"x\" : %,\n" itmpobj.pos.x to:jsonFile
									format "\t\t\t\"y\" : %,\n" itmpobj.pos.z to:jsonFile
									format "\t\t\t\"z\" : %,\n" itmpobj.pos.y to:jsonFile
									format "\t\t},\n" to:jsonFile
									rmin = [-1,-1,-1]
									rmax = [1,1,1]
									tempmin = itmpobj.min - itmpobj.center
									tempmax = itmpobj.max - itmpobj.center
									if (tempmin.x<rmin.x) then rmin.x=tempmin.x
									if (tempmin.y<rmin.y) then rmin.y=tempmin.y
									if (tempmin.z<rmin.z) then rmin.z=tempmin.z
									if (tempmax.x>rmax.x) then rmax.x=tempmax.x
									if (tempmax.y>rmax.y) then rmax.y=tempmax.y
									if (tempmax.z>rmax.z) then rmax.z=tempmax.z
									distanline = 1.5*(distance (itmpobj.min) (itmpobj.max))
									format "\t\t\"distance\" : \"%\"\n" distanline to:jsonFile	
									format "\t},\n" to:jsonFile
								)
								format "\t\t</materialname>\n" to:outFile
								format "\t</factname>\n" to:outFile
								
							)
						 )
						 
				   )	
				)
			)
		)
	)
	--sppbuild
	format "]\n" to:jsonFile
	format "</lod>\n" to:outFile
	close jsonFile 
	close outFile 
	enablesceneredraw()
)

--######################################## export HUD's Mesh to hudmesh.xml ###########################################
fn expHudxml =
(
	cp = checkpPath()
	--srcdir = "\\src\\art\\scene\\effect"
	--"D:\p\duiwaijingmaodaxue\src\art\scene\effect\effect.xml"
	srcdir = "\\src\\art\\scene\\effect"
	outputPath=cp+srcdir
	--oldfiles=outputPath + "\\" +  "*.3ds"
	makeDir outputPath
	fileN  = "\\hudmesh.xml"
	filename = (outputPath + fileN )
	
	--try delete existed file
	if (existFile filename) then 
		try(deletefile filename)catch()
	
	outFile = createFile filename
	format "<lib>\n" to:outFile
	format "\t<hud name =\"sprit2d\">\n" to:outFile
	for iobj in objects do
	(
		effecttype = getUserProp iobj "hudmesh"
		if effecttype == "" or effecttype == undefined do
		(
			continue
		)
		fdstr=findString iobj.name "#"
		--objname = 
		--fdstr = findString (i.name) "#"
		if fdstr != undefined do
		(
			objname = substring (iobj.name) 1 (fdstr-1)
		)
		--<meshname name = "Plane01"/>
		hudstr = "\t\t<meshname name = \"" + objname + "\"/>\n"
		format hudstr to:outFile
	)
	format "\t</hud>\n" to:outFile
	format "</lib>" to:outFile
	close outFile 
	--方便artbuild使用
	/*artdir  = "\\src\\art\\factory\\neirong01\\effect"
	arthudfilename = cp + artdir + fileN
	try(
		deletefile arthudfilename
		copyfile filename arthudfilename
	)catch()*/
)

---################################### meshgen 工具 ################################################

--yangxiuwu export json function
fn exportMeshgenJson outFile xpitch zpitch arrymesh= 
(
-- 		need the max and min
-- 		Init the var
	xMinPos=0
	zMinPos=0
	xMaxPos=0
	zMaxPos=0
	xStep=-1
	zStep=-1
-- 		xpitch=20
-- 		zpitch=30

	for iobj in arrymesh do
	(
		pos = iobj.pos
		if pos.x <= xMinPos then
		(
			xMinPos = pos.x
		)
				
		if pos.y <= zMinPos	then	
		(
			zMinPos = pos.y
		)
		
		if pos.x >= xMaxPos then
		(
			xMaxPos = pos.x
		)
				
		if pos.y >= zMaxPos	then	
		(
			zMaxPos = pos.y
		)
	)
-- 		get the max and min : xMinPos zMinPos xMaxPos zMaxPos
	if (mod (xMaxPos-xMinPos) xpitch)==0.0 then xStep=0 else xStep=1
	if (mod (zMaxPos-zMinPos) zpitch)==0.0 then zStep=0 else zStep=1
--  x Direction
	m=((xMaxPos-xMinPos) as integer)/xpitch+xStep
--  z Direction
	n=((zMaxPos-zMinPos) as integer)/zpitch+zStep
	
	format "//  array[%][%]\n" (m) (n) to: outFile
	format "MESHNAME = {\n" to: outFile
	format "\txpitch : %,\n" xpitch to: outFile
	format "\tzpitch : %,\n" zpitch to: outFile
	format "\tmin : [%, %],\n" (xMinPos) (zMinPos) to: outFile
	format "\tmax : [%, %],\n" (xMaxPos) (zMaxPos) to: outFile
	format "\tarrayx  : %,\n" (m) to: outFile
	format "\tarrayy  : %,\n" (n) to: outFile
	format "\tdata : {\n" to: outFile
	
	index=-1
	--	m is x
	for i=0 to (m-1) do
		--	n is z
		for j=0 to (n-1) do
		(
-- 				m==x  n==y
			index = index +1
			format "\t\t\"x_%_z_%\" : [\n" (i) (j) to: outFile
			for iobj in arrymesh do
			(
				if (iobj.pos.x <= (xMinPos+(i+1)*xpitch) and iobj.pos.x >= (xMinPos+i*xpitch) and iobj.pos.y <= (zMinPos+(j+1)*zpitch) and iobj.pos.y >= (zMinPos+j*zpitch))
					then format "\t\t\t\"%\",\n" (iobj.name) to: outFile
			)
			format "\t\t],\n" to: outFile
		)
	format "\t}\n" to: outFile
	format "}\n" to: outFile
)

/**
 * @brief create meshgen data
 * @param mgtype true to meshgen by name, false to meshgen by mesh size.
 */
fn fnmeshgen mgtype =
(
	--可调参数
	xpitch = 25
	zpitch = 50
	cp = checkpPath()
	srcdir = "\\src\\art\\scene"
	outputPath=cp+srcdir
	makeDir outputPath
	fileN  = "\\meshgen_names.js"
	filename = (outputPath + fileN )
	
	--try delete existed file
	if (existFile filename) then 
		try(deleteFile filename)catch()
	
	outFile = createFile filename
	
	arrymesh = #()
	if(mgtype) then
	(			
		for i in geometry do
		(
			objname = i.name
			if(matchPattern objname pattern:"plant*")then
			(
				append arrymesh i
			)
		)
	)
	else
	(
		--得到meshgen模型名
		arrymesh = selectMeshgen()
	)
	
	--
	exportMeshgenJson outFile xpitch zpitch arrymesh
)

--######################################## mesh's effect export to effect.xml ###########################################
fn rename_materials =
(
	namepostfix = 0;
	
	--先遍历matrial名称，全部修改名称，并保存。
	 for mat in scenematerials do
	 (
		if((classof mat) == Standardmaterial) then
		(
			--matname = mat.name
			mat.name = "m" + (namepostfix as string)
			namepostfix=namepostfix +1
		)
		else
		(
			if((classof mat) == Multimaterial) do
			(
				submatnum = getNumSubMtls mat
				
				mat.name = "m" + (namepostfix as string)
				namepostfix =namepostfix +1
--				matname = mat.name 
						
				for im = 1 to submatnum do
				(
					if((classof (mat[im])) == Standardmaterial) do
					(
--						submatname = mat[im].name
						mat[im].name = "ms" + (namepostfix as string)
						namepostfix=namepostfix +1
					)
				)
			)
		)
	 )
	 --save,not needed.
)


fn moveToo =
(
	--------------------------------------------
	-- 检查整体的bbox
	local objectss = for i in objects  collect i
		
	group objectss name:"group_groupall"
	local bbox = #()
	select $group_groupall
	local minb = $group_groupall.min
	local maxb = $group_groupall.max
	local zb = $group_groupall.pos.z
	bbox[1] = minb[1]
	bbox[2] = minb[2]
	bbox[3] = minb[3]

	bbox[4] = maxb[1]
	bbox[5] = maxb[2]
	bbox[6] = maxb[3]
	local bbox_error =0
	for n in bbox do 
	(
		if n > 50000 do
		(
			bbox_error = bbox_error +1
		)
		if n < -50000 do
		(
			bbox_error = bbox_error +1
		)
	)
	if bbox_error >1 do
	(
		$group_groupall.pos = [0,0,zb]
		
	)
	ungroup $group_groupall
	--------------------------------------------

	max zoomext sel all	 
	 
)

fn del_dummy =
(
	print "del_dummy()"
	local dummy_arr = #()
	for i in objects do
	(
		if (classof i) == Dummy do
		(
			append dummy_arr i
		)
	)
	delete dummy_arr
)

fn scene_reset doit_prog=
(
	del_dummy()
	moveToo()
	-- ungroup
	local objs = for i in geometry collect i
	select objs
	unhide objs doLayer:true 
	max group ungroup
	clearSelection()
	
	-- set scanline render 
	renderers.current = RendererClass.classes[1]()
	
	--layer hidden
	for il = 0 to layerManager.count-1 do
	(
		ilayer = layerManager.getLayer il
		layerName = ilayer.name 
		layer = ILayerManager.getLayerObject il
		layer.ishidden = false 
		layer.isfrozen = false 
	)

	-- ambient color setting
	ambientColor = color 255 255 255

-- 		-- render preset
-- 		theRenderPreset = renderPresetMRUList[1][2] 
-- 		renderpresets.Load 0 theRenderPreset #{32}

	-- layout setting
	viewport.ResetAllViews()
	viewport.setLayout #layout_2v
	viewport.setGridVisibility #all false
	viewport.SetRenderLevel #wireFrame
	enableSceneRedraw() 
	max zoomext sel all

	viewport.activeViewport = 1
	viewport.setType #view_front
	viewport.activeViewport = 2
	viewport.setType #view_top
	
	for o=1 to objs.count do 
	(
		if classof objs[o] == Editable_mesh or classof objs[o] == Editable_poly do
		(
			objs[o].showFrozenInGray = on
			objs[o].backfacecull = on
			-- unwrap_UVW
			addModifier objs[o] (Unwrap_UVW ())
			converttomesh objs[o]
			doit_prog.value = 100.*o/objs.count
		)
	)
	
	--convertToPoly
	for i in geometry do convertToPoly i
	for i in shapes do 
	(
		if(i.render_displayRenderMesh == true) then convertToPoly i
	)
	
	enableSceneRedraw() 
	max zoomext sel all
	max tool maximize
	messagebox"环境重置完毕，请进入下一步操作！"
)

