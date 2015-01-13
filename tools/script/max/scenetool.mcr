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

macroScript SPP_sceneTool
category:"Superpolo"
ButtonText:"Scene ToolSet" 
tooltip:"Spp Scene ToolSet" Icon:#("Maxscript", 2)
(
	heapSize += 2000000

	G_ButtonList = List()
	
---####################################################################################################
---########################################   function     #########################################
---####################################################################################################

	/**
	 * @brief disable all the button, but enable the next button of the current button.
	 * @detail this means, you should press button in the correct order.
	 */
	fn enableNextButton current = 
	(
		-- not use under debug mode.
		if SPP_DEBUG == true do return true
		
		local next = current + 1
		for btn in G_ButtonList.getItems() do
		(
			if btn.value == next then
				btn.name.enabled = true
			else
				btn.name.enabled = false
		)
		return true
	)



	
/* 	
	fn checkSameMatObj =
	  (
		mess = ""
		err= 0
		cp = checkpPath()
		  
		mtl = #() ; tmp = #() ; fin = #()
		sel = geometry as array
-- 		format "sel= %\n"sel.count 
	-- 	print sel.count as string	
		sel = for i in sel where canConvertTo i Editable_Poly collect i
		for i in sel do
		(
			--format i.material.name
			if findItem mtl i.material.name == 0 do
				append mtl i.material.name
		)
-- 		print "mtl="
-- 		print mtl.count as string
		 for m in mtl do
		(
			--print m
			tmp = for i in sel where i.material.name == m collect i
			append fin tmp
		)
-- 		print "fin="
-- 		print fin.count as string 
		local k=0
		sameMat_arr = #()
		 for i in fin do
		(
			if i.count > 1 do
			(
	-- 			print i.count
	-- 			print i[1].mat.name
				join sameMat_arr i
			)
		)
		if sameMat_arr.count >10 do
		(
			
			err+=1
			message = stringStream ""
			message = "共用材质的模型数量过多，需要attach相同mesh的模型！ \n"
			mess = mess + message
			
			delete sameMat_arr
		)
	-- 	sameMat_arr.count
	-- 		print k
		wtpath = cp  + "\\plan\\问题"	
		makedir  wtpath	
		filename = wtpath +  "\\共用材质的模型数量过多——需要修改.txt"
		if err >0 then
		(
			outFile = createFile filename	
			format "%\n" mess to:outFile
			close outFile
		)else
		(
			if (existFile filename) then deletefile filename
		)
	)
	
	
	
	 */
	



	

	
--- 2. set path 直接就在rollout里面
 
 
---3.检查mesh mat texture
 









--###################################  本体导出  ###################################
 
-- 主要在rollout中
 
	

/*fn xfile_export =
(
	rename_materials()
	
	renamelightmap()
	
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
)*/	
	
	
	
	
	

	






	 
	 

	
	global errorMsg=""
	fn checkEnvs =   --@zhanghongru 需求1 E8——环境路径拼写错误，请先修改正确再执行下面的操作！
	(
		p =maxFilePath
		p_arr = filterString p "\\"
		realPath = p_arr[4]+ "\\" + p_arr[5]+ "\\" + p_arr[6]+ "\\" +p_arr[7]
		if(realPath)!="src\\art\\scene\\max" then
		(
			messagebox ("E8——环境路径拼写错误，请先修改正确再执行下面的操作！")
			
			errorMsg=errorMsg+"E8——环境路径拼写错误，请先修改正确再执行下面的操作！"
			fileName = thePath()
			if ((openfile fileName) == undefined ) then
			(
				out_name = thePath()
				out_file = createfile out_name
				str=(errorMsg as string)+"\n"
				format str to:out_file
				close out_file
			)
		)
	)
	
	global z_times=0   --@zhanghongru  需求2 E9——art目录下面不能有两个scene目录！
	fn checkScene =
	(
		p =maxFilePath
		p_arr = filterString p "\\"
		realPath = p_arr[1]+ "\\" + p_arr[2]+ "\\" + p_arr[3]+ "\\" + p_arr[4]+ "\\" + p_arr[5]
		dir_array = GetDirectories (realPath+"\\*")
		for i in dir_array do 
		(
			str=filterString i "\\"
			if ( findstring i "scene"!= undefined ) then 
			(
				z_times =z_times + 1
				--print z_times
			)				
		)
		if ( z_times> 1) then
		(
			messagebox ("art目录下面不能有两个包含scene名字的目录!")	
			errorMsg="art目录下面不能有两个包含scene名字的目录！"
			fileName = thePath()
			if ((openfile fileName) == undefined ) then
			(
				out_name =thePath()
				out_file = createfile out_name
				str=(errorMsg as string)+"\n"
				format str to:out_file
				close out_file
			)
			else
			(
				out_name = thePath()
				out_file = openfile out_name mode:"at"
				str=(errorMsg as string)+"\n"				
				format str to:out_file
				close out_file
			)
		)
		
	)
	

	
---####################################################################################################
---########################################   rollout界面     #########################################
---####################################################################################################
	rollout version_rollout "版本Ver1.0.3.4" width:171 height:55
	(
		label version_lbl "Copyright (C) 2012 Sanpolo Co.LTD     http://www.spolo.org" pos:[13,7] width:146 height:45
		-- when open scene tool, begin to logging.
		on version_rollout open do
		(
			spOpenLog()
		)
		-- when close scene tool, end to logging.
		on version_rollout close do
		(
			spCloseLog()
		)
	)
---########################################   重置环境     #########################################
	rollout resetScn_tool "一.重置环境" width:171 height:300
	(
		button sceneRest_btn "1.重置环境 (reset)" pos:[4,4] width:160 height:18
		progressBar doit_prog "" pos:[13,27] width:145 height:14 color:(color 255 0 0)
		label lbl_bitmap "2.用bitmap/photometric paths     指认贴图路径" pos:[13,52] width:146 height:35
		label lbl_saveScene "3.设置完路径，保存，重打开    场景！" pos:[12,85] width:154 height:28
		button checkEnv_btn "2.环境检查(checkEnv)" pos:[4,120] width:160 height:18
		on resetScn_tool open do
		(
			G_ButtonList.addItem sceneRest_btn 1
			G_ButtonList.addItem checkEnv_btn 2
		)
		on sceneRest_btn pressed do
		(
			scene_reset doit_prog
			enableNextButton 1
		)
		on checkEnv_btn pressed do
		(
			filename = thePath()
			if (existFile filename) then 
				try(deletefile filename)catch()
			
			tag = true
			if checkEnvs() !=undefined then tag = false
			if checkScene() !=undefined then tag = false				
			if CheckName() !=undefined then tag = false			
			z_times=0
			errorMsg=""
			
			/* if tag then 
			(
				filename = thePath()
				if (existFile filename) then 
					try(deletefile filename)catch()
			) */
			enableNextButton 2
		)
	)
	
---########################################   素材检查     #########################################
	-- 设置路径
	
	rollout texpath "texpath" width:404 height:94
	(
		edittext edt1 "贴图路径：" pos:[4,58] width:322 height:21
		button btn_chan "处理" pos:[338,55] width:52 height:28
		label texPath_lbl "将scene文件夹下的贴图文件夹路径拷贝到下面！\n如：D:\p\（项目名称）\src\art\scene\diffuse " pos:[9,11] width:325 height:32
		
		on btn_chan pressed do
		(
			local start_timestamp = timestamp()
			
			for iobjt in  geometry do
			(
				tmat = iobjt.material
				tsubmatnumber = getNumSubMtls tmat
				if tsubmatnumber == 0 do
				(
					 tmtexfilename = tmat.diffuseMap.filename
					 texNameArr = filterString tmtexfilename "\\."
					 texname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]
					
					
					 tmat.diffuseMap.filename = (edt1.text)+ "\\"+texname
				)
				if tsubmatnumber >0 do
				(
					for itm = 1 to tsubmatnumber do
					(
						 itsmat = getSubMtl tmat itm
						
						if itsmat == undefined do
						 (
							 --print submatnum
							 --submatnum = submatnum + 1
							 continue
						  )
						 tmtexfilename = itsmat.diffuseMap.filename
						 texNameArr = filterString tmtexfilename "\\."
						 texname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]
						
						
						 itsmat.diffuseMap.filename = (edt1.text)+ "\\" +texname
					)
				)
			)
			
			local end_timestamp = timestamp()
			local process_time = end_timestamp - start_timestamp
				
			messagebox ("贴图路径设置完毕,可以进行下一步！\n" + (timeFormatter process_time))
			DestroyDialog texpath
		)
	)
	----

	


	
	
	
	
	
	---########################################   模型旋转拍照     #########################################
	rollout captureRollout "模型旋转拍照" width:162 height:194
	(
		slider sld_distance "近                           远" pos:[20,20] width:122 height:44 ticks:20
		slider sld_height "低                            高" pos:[21,76] width:124 height:44
		GroupBox grp1 "" pos:[11,5] width:138 height:129
		button btn_capture "拍 照" pos:[56,139] width:44 height:23
		button btn_close "关 闭" pos:[103,139] width:45 height:23
		button btn_reset "重 置" pos:[10,139] width:44 height:23
		progressBar pb_capture "进度:" pos:[43,169] width:104 height:16 enabled:true value:0 color:(color 255 0 0)
		label lbl_progress "进度:" pos:[7,170] width:35 height:18
		local xyz=#(0,0,0),xyzmin=#(0,0,0)
		local xvalue=0,zvalue=0
		local value=0
		local myIncrement=1
		local glbrgpos, oldrenders
		--function rotate z 
		fn RotateViewPort inputAxis inputDegrees = 
		(
		if viewport.getType() != #view_persp_user do viewport.setType #view_persp_user
		ViewPortMatrix = inverse(ViewPort.GetTM())
		RotationMatrix = (quat inputDegrees inputAxis ) as Matrix3
		ViewPortMatrix *= RotationMatrix
		ViewPort.SetTM (inverse ViewPortMatrix)
		global capturecam
		)			
		--adjust camera angle
		fn rotateangle=
		(
			--计算模型在viewport的半径以方便安放camera
			for i in objects do
			(
				temp =#()
				temp=i.max
				tp=#()
				tp=i.min
				for n=1 to 3 do
				(	
					if(temp[n]>xyz[n])do xyz[n]=temp[n]
					if(tp[n]<xyzmin[n]) do xyzmin[n]=tp[n]
				)
				
			)
			value=(xyz[1]+abs(xyzmin[1]))/2
			--create a targetcamera for adjust distance angle
			capturecam=Targetcamera fov:45 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off pos:[value,0,value*tan(30)] isSelected:on target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]))
			max vpt camera
		)
		--capture img
		fn grabViewport =
		(
			try(
				if(myIncrement>4)do myIncrement=1			
				--myBitmap = gw.getViewportDib()
				gc light:true
				myBitmap = bitmap renderWidth renderHeight
				render to:myBitmap vfb:false
				--myJPEG = bitmap myBitmap.width  myBitmap.height
				--copy  myBitmap myJPEG 
				wtpath = checkpPath()
				--JPEG.setQuality 99
				myDir = wtpath  + "\\plan\\问题"		
				makedir  myDir	
				myBitmap.filename = (myDir + "\\"+"cam" + myIncrement as string + ".jpg")
				save myBitmap
				--myJPEG.filename = (myDir + "\\"+"cam" + myIncrement as string + ".jpg")
				--print ("saved as " + myJPEG.filename as string)
				--save myJPEG
				myIncrement += 1
			)catch(messagebox"内存不够，请关闭其他不需要的软件！")
		)
		--init rollout settings
		fn init=
		(
			rotateangle()
			sld_height.range=[1,89,0]
			sld_distance.range=[1,8*value,value]
			xvalue=value
			sld_distance.value=value
			sld_height.value=30
			sld_distance.enabled=true
			sld_height.enabled=true
		)
		on captureRollout open do
		(
			oldrenders = renderers.current
			renderers.current  =Default_Scanline_Renderer()
			objectss = for i in objects where not (matchPattern i.name pattern:("sky*")) collect i
			group objectss name:"group_campture"
			select $group_campture
			glbrgpos = $group_campture.pos
			$group_campture.pos = [0,0,0]
			print glbrgpos
			init()
		)
		on captureRollout close do
		(
			$group_campture.pos = glbrgpos
			renderers.current = oldrenders
			try ungroup $group_campture catch()
			try delete capturecam catch()
		)
		--adjust camera distance
		on sld_distance changed val do
		(
			d=sld_distance.value-xvalue
			if((capturecam.position.x)!=0) do
			move capturecam [d,0,d*tan(sld_height.value)]
			xvalue=sld_distance.value
			--print capturecam.pos
		)
		--adjust camera height
		on sld_height changed val do
		(
			d=sld_height.value
			zvalue=capturecam.position.z
			move capturecam[0,0,value*tan(sld_height.value)-zvalue]
		)
		--capture img
		on btn_capture pressed do
		(
			try delete capturecam catch()
			enableSceneRedraw()
			if(checkpPath()!="")then
			(
				renderWidth=3072
				renderHeight=2304
			   for nloop = 1 to 4 do
			   (
					RotateViewPort [0,0,1] 90
					completeRedraw()
					grabViewport()
					pb_capture.value=100*nloop/4
					nloop+=1
				)
				messagebox "capture success!"
			)
			else messagebox "capture failed!"
			sld_distance.enabled=false
			sld_height.enabled=false
		)
		on btn_close pressed do
		(
			destroydialog captureRollout
		)
		--reset rollout settings
		on btn_reset pressed do
		(
			try delete capturecam catch()
			init()
		)
	)
	---################################贴图尺寸规范 ##################################
	arrTexMap = #()
	arrTexArea = #()
	arrtexObj = #() --test 
	fn getArea meshobj i =
	(
		local uvX=0.0,uvY =0.0,uvWidth =0.0,uvHeight=0.0,uvFaceArea=0.0,objGeomArea=0.0
		temparea = 0.0
		meshobj.modifiers["Unwrap_UVW"].getArea #{i} &uvX &uvY &uvWidth &uvHeight &uvFaceArea &objGeomArea
		facearea=meshop.getFaceArea meshobj #{i}
		try(
			if(objGeomArea > 1.0e+010 or objGeomArea < 0)then
			(
				print meshobj.name
				facearea = 0.0
				return 0
			)	
			if(uvFaceArea>1)then
			(
				temparea =temparea + (float)facearea/uvFaceArea
			)	
			else
				temparea = facearea
			--加进camera计算贴图高度
			xyzpos = meshop.getFaceCenter meshobj i
			zpos = xyzpos.z
			indx = 1.0
			if(zpos > 20)then
			(
				indx = 0.01
			)
			temparea = indx*temparea
		)catch()
		return temparea	
	)
	--get all 
	fn getAllTexArea=
	(
		for iobj in geometry do
		(
			select iobj	
			if(classof iobj.baseobject != Editable_Mesh)then
				convertToMesh iobj
			if getCommandPanelTaskMode() != #modify do setCommandPanelTaskMode #modify
			AddModifier iobj (Unwrap_UVW ())	
			curmat = iobj.mat
			if(classof curmat == Standardmaterial) then
			(
				if((curmat.diffuseMap) != undefined) then
				(
					texname = curmat.diffuseMap.filename
					findindex = finditem arrTexMap texname
					if(findindex == 0) then
					(
						append arrTexMap texname
						tmparea = 0.0
						for facenum = 1 to (iobj.numfaces) do
						(
							tmp = (getArea iobj facenum)
							if(tmp< 1.0e+010 and tmp > 0)then tmparea +=tmp
						)
						append arrTexArea tmparea
						tempobj = #()
						append tempobj (iobj.name)
						append arrtexObj tempobj
					)
					else
					(
						tmparea = 0.0
						for facenum = 1 to (iobj.numfaces) do
						(
							tmp = (getArea iobj facenum)
							if(tmp< 1.0e+010 and tmp > 0)then tmparea +=tmp
						)
						
						arrTexArea[findindex] += tmparea
						--add obj test
						appendIfUnique 	arrtexObj[findindex] (iobj.name)				
					)
				)
			)
			else if((classof curmat) == multimaterial ) then
			(
				for f = 1 to iobj.numfaces do
				(	
					submatid = getFaceMatID iobj f
					CurrentSubMtl = curmat.materialList[submatid]
					try(
						if (CurrentSubMtl.diffuseMap) != undefined  then
						(
							texname = CurrentSubMtl.diffuseMap.filename
							findindex = finditem arrTexMap texname
							if(findindex == 0)then
							(
								append arrTexMap texname	
								tmparea = 0.0
								tmp = (getArea iobj f)
								if(tmp< 1.0e+010 and tmp > 0)then tmparea +=tmp
								--add area 
								append arrTexArea tmparea
								--test obj name
								tempobj = #()
								append tempobj (iobj.name)
								append arrtexObj tempobj
							)
							else
							(
								tmparea = 0.0
								tmp = (getArea iobj f)
								if(tmp< 1.0e+010 and tmp > 0)then tmparea +=tmp
								arrTexArea[findindex] += tmparea
								--add obj test
								appendIfUnique  arrtexObj[findindex] (iobj.name)	
							)
						)
					)catch()	
				)	
			) 
			DeleteModifier iobj 1
		)
	)
	--compute standard size
	fn fourmod nums =
	(
		num = 1
		while(nums>=4)do
		(
			num *=2
			nums/=4
		)
		return num
	)

	fn cmptsize imghw size =
	(
		hei = imghw[1]
		wei = imghw[2]
		texarea = hei*wei
		facearea = size
		l = 8192
		size = l*size
		tmpsize = sqrt(size)
		k = (float)hei/wei
		if(k>1)do k = (float)1/k
		str = ""
		size = k*size
		--若贴图面积小于计算面积,就pass
		if(texarea<size)then return str
		beishu = texarea/size
		if(beishu<4)then return str
		scaleinx = fourmod beishu
		--test
		str = "计算尺寸为:"+ (tmpsize as string)+"*"+(tmpsize as string) +" facearea: "+(facearea as string)+" ,建议尺寸为:"+((hei/scaleinx) as string) +"*"+((wei/scaleinx) as string)+" "
		return str
	)

	fn gettexname tex =
	(
		texname_arr = filterstring arrTexMap[i] "\\"
		texname = texname_arr[texname_arr.count]
		return texname
		bm1 =openBitMap (arrTexMap[i])
		strsizeinfo = (bm1.height  as string) +"*" + (bm1.width as string)
		strsize = #((bm1.height) ,(bm1.width))
	)

	--########################################   素材检查     #########################################
	rollout check_tool "二.素材检查" width:171 height:300
	(
		button capture_btn "1.拍照 (capture)" pos:[4,4] width:160 height:18
		button checkmt_btn "2.检查1 (check1)" pos:[4,25] width:160 height:18
		button checkTexa_btn "3.检查2 (check2)" pos:[4,46] width:160 height:18
		button settpath_btn "4.设置贴图路径 (setpath)" pos:[4,67] width:160 height:18
		on check_tool open do
		(
			G_ButtonList.addItem capture_btn 3
			G_ButtonList.addItem checkmt_btn 4
			G_ButtonList.addItem checkTexa_btn 5
			G_ButtonList.addItem settpath_btn 6
		)
		on capture_btn pressed do
		(
			CreateDialog captureRollout
			enableNextButton 3
		)

		on checkmt_btn pressed do
		(
			local start_timestamp = timestamp()
			
			local delFlag = true -- delete after check.
			local selFlag = false -- auto check all obj in scene, not only selected ones.
			local msgboxFlag = false -- show msgbox after each checking.
			local handle = "delete" -- what to do after find error.
			
			checkMesh delFlag
			checkUnsupportedObject delFlag
			ckHudFaceCross selFlag
			ckSmallMesh delFlag
			-- @fixme -- 2.4min
			checkSameNobj delFlag msgboxFlag
			checkMeshName delFlag msgboxFlag
			checkmattex delFlag
			-- @fixme -- 8.8min
			checkMeshFace selFlag false delFlag msgboxFlag handle
			-- check single model face count
			checkFaceNum delFlag msgboxFlag
			ChkTexMapNums()
			ChkSceneFaceNums()
			
			local end_timestamp = timestamp()
			local process_time = end_timestamp - start_timestamp
			
			messagebox ("[Finish] 检查完毕,请查看问题文件夹！！！\n" + (timeFormatter process_time))
			enableNextButton 4
		)
		
 		on checkTexa_btn pressed do
		(
			local start_timestamp = timestamp()
			
			ChkTexture()
			
			local end_timestamp = timestamp()
			process_time = end_timestamp - start_timestamp
			
			messagebox ("[Finish] 检查完毕,请查看问题文件夹！！！\n" + (timeFormatter process_time))
			
			enableNextButton 5
		)
		on settpath_btn pressed do
		(
			CreateDialog texpath
			enableNextButton 6
		)
	)
/* 	
	rollout createBuildName "创建中文建筑名字" width:259 height:42
	(
		editText chname "" pos:[7,8] width:173 height:22
		button yes "确定" pos:[196,7] width:53 height:25
		on yes pressed  do
		(
			setUserProp $ "cname" chname.text
		)	
	)
	
	 */
	---########################################   本体和场景操作    #########################################
 
	rollout model_tool "三.本体和场景操作" width:171 height:300
	(
		checkbox chk_MgByName "通过名字导meshgen" pos:[4,4] width:146 height:18 checked:true
		button export_btn "1.本体和场景导出 (Export)" pos:[4,22] width:160 height:18
		on model_tool open do
		(
			G_ButtonList.addItem export_btn 7
		)
 		on export_btn pressed do
		(
			export_scene(chk_MgByName.checked)
			enableNextButton 7
		) 
	) 
/*  		rollout model_tool "三.本体和场景操作" width:171 height:300
	(
		button export_btn "1.本体和场景导出 (Export)" pos:[4,4] width:160 height:18
-- 	--label lbl_copy "2.将scene下的贴图文件夹拷      贝到neirong01中，命名为       diffuse" pos:[6,35] width:150 height:43

		on export_btn pressed do
		(
			xfile_export()
		)
	)  */
	


/* 
	--------------给建筑物体创建中文名字的对话框---------------------------------
	rollout createBuildName "创建中文建筑名字" width:259 height:42
	(
		editText chname "" pos:[7,8] width:173 height:22
		button yes "确定" pos:[196,7] width:53 height:25
		on yes pressed  do
		(
			setUserProp $ "cname" chname.text
		)	
	)
	
 */
/* 	rollout prop_tool "物体属性定义和导出" width:171 height:300
	(
		button nolight_btn "标注不需要烘焙的物体" pos:[4,4] width:160 height:18
		button c_ch_btn "给当前物体创建中文标注" pos:[4,48] width:160 height:18
		button ex_ch_btn "输出带中文名字的物体" pos:[4,68] width:160 height:18
		button roleP_btn "创建角色朝向及位置物体" pos:[4,98] width:160 height:18
		
		GroupBox grp2 "给物体标注中文" pos:[2,28] width:167 height:64
		
		on nolight_btn pressed do
		(
			noLightMap()
		)
		on c_ch_btn pressed do
		(
			CreateDialog createBuildName
		)
		on ex_ch_btn pressed do
		(
			buildCHname()
		)
		on roleP_btn pressed do
		(
			v_arr =  #([-0.612091,0,-0.621535], [0.612091,0,-0.621535], [0,3.21875,0], [-0.612091,0,0.621535], [0.612091,0,0.621535])
			f_arr =  #([1,3,2], [4,5,3], [5,4,1], [1,2,5], [2,3,5], [3,1,4])
			mesh vertices:v_arr faces:f_arr
		)
	)
	
	 */
	 ---########################################   引擎查看器    #########################################
	rollout basebuilder "五.质感贴图" width:171 height:133
	(
		button vfact_btn "1.本体查看 (ViewFact)" pos:[4,4] width:160 height:18
		on vfact_btn pressed do
		(
			messagebox"建设中..."
			/*if selection.count == 1 then
			(
				-- 动态灯光build
				cmd = getCmdPath()
				if cmd != "" do
				(
			-- 			DOSCommand (cmd+" & sppbuild")
					
					objName = ""
					o = selection[1].name
					fs=findString o "#"
					if fs == undefined then
					(
						objName = o
					)else
					(
						fs= fs-1
						objName = substring o 1 fs					
					)
					cp = checkpPath()
					srcdir = "\\src\\art\\factory\\neirong01"
					outputPath = cp + srcdir 
					makedir outputPath
					filename = outputPath + "\\" + objName  + ".3ds"
					if (existFile filename) then
					(
					cmdstr = "/C \"" +	cmd+" & sppbuild --viewfact=neirong01/"+objName+"\""
					ShellLaunch "cmd" cmdstr
					)else
					(
						messagebox"请先导出本体！"
					)					
					
				)
			)else
			(
				messagebox"请选择一个物体！"
			)*/
		)
	)
	
	---#########################################  效果处理部分开始   #########################################
	--declare rollout
	MulMatRollout;
	effectRollout;
	showeffectRollout;
	try(DestroyDialog mesheffectRollout)catch()
	try(DestroyDialog showeffectRollout)catch()
	 

	   --------------------------add effect to mesh material ---------------
		fn processeffect =
		(
			--local mesh
			if(selection .count >0)then
				(
					mesh = selection[1]
					currentmesh = mesh
					macros.run "Tools" "Isolate_Selection"
					max zoomext sel all
					if(classof mesh.mat == Standardmaterial)then
					(
						createdialog effectRollout
					)
					else
					(
						--切换线框模式
						--max wire smooth
						if(viewport.isWire() == true) then
						(
							max wire smooth
						)
						macros.run "Modifier Stack" "Convert_to_Poly"
						--mesh.EditablePoly.SetSelection #Face #{1}
						--subobjectLevel = 4
						createdialog MulMatRollout
					)
					
				)
				else
				(
					messagebox "请先选择一个模型"
				)
		)	
		


	/* rollout mesheffectRollout "效果处理:" width:156 height:67
	(
		button btn_do "效果处理工作" pos:[23,8] width:112 height:25
		button btn_expxml "导出效果xml文件" pos:[23,34] width:112 height:25
		

		on btn_do pressed do
		(	
			processeffect()
			)
		on btn_expxml pressed do
		(
			expxml()
			)
	) */
	rollout MulMatRollout "多材质模型处理" width:123 height:86
	(
		button btn_complete "效果设置完成" pos:[13,45] width:100 height:25
		button btn_set "设置效果" pos:[12,11] width:100 height:25
		local mymesh
		local matname
		local modeflag = 0
		local submatid
		/* fn getsubmat =
		(
			Currentmat = mymesh.mat
		   for iSubMtl = 1 to Currentmat.materialList.count do
		   (
				CurrentSubMtl = Currentmat.materialList[iSubMtl]
				iname = CurrentSubMtl.name
		   )
		) */
		
		on MulMatRollout open do
		(
			max select
			subobjectLevel = 4
			mymesh  = selection[1]
			
			)
		on MulMatRollout close do
		(
			--	try(createdialog mesheffectRollout)catch()
			if(viewport.isWire() == false) then
			(
				max wire smooth
			)
			subobjectLevel = 0
		)
		on btn_complete pressed do
		(
			subobjectLevel = 0
			if(viewport.isWire() == false) then
			(
				max wire smooth
			)
			try(DestroyDialog MulMatRollout)catch()
		)
		on btn_set pressed do
		(
			--判断是否选择了一个面
			if classof mymesh ==Editable_Poly then--如果是Polygon物体
			(
				mymesh.EditablePoly.selectByMaterial (mymesh.EditablePoly.getMaterialIndex true) clearCurrentSelection: false
				 try(
						modeflag = 1
						submatid = mymesh.EditablePoly.getMaterialIndex true
						--matname = mymesh.mat.materialList[subid].name
					try(DestroyDialog effectRollout)catch()
						createdialog effectRollout
				 )catch(messagebox "此模型面不能设置效果") 
				
			)
		)
	)
	rollout effectRollout "效果操作" width:135 height:141
	(
		button btn_seteffect "设置效果" pos:[13,60] width:111 height:20
		button btn_delete "删除效果" pos:[12,85] width:111 height:20
		button btn_view "查看效果" pos:[13,112] width:111 height:20
		dropdownList ddl_list "效果列表:" pos:[14,13] width:108 height:41 --items:#("水", "玻璃", "金属")
		local shaderstr =""
		local mymesh,matname
		local tflag ,mutlflag = 0;
		fn addeffect  mymeshs strname =
		(
		--submatid
			str = ""
			--realname = matname
			--fakename = replacenames  realname  " " ")"
			--effecttype = getUserProp mymesh fakename
			if(classof (mymeshs.mat) == Standardmaterial)then
				submatid="submatid0"
			else submatid = "submatid" + (MulMatRollout.submatid) as string
			instancemgr.getinstances mymeshs &instances
			for j in instances do 
			(
				setUserProp j submatid strname
			)
			if(tflag == 0)then
				str = "模型\"" + mymeshs.name + "\"上设置效果成功"
			else if(tflag == 1)then
				str = "模型\"" + mymeshs.name + "\"上删除效果成功"
			messagebox str
		)
		fn vieweffect mymeshs =
		(
			--fakename = replacenames  realname  " " ")"		
			if(classof (mymeshs.mat) == Standardmaterial)then
				submatid="submatid0"
			else submatid = "submatid" + (MulMatRollout.submatid) as string
			effecttype = getUserProp mymeshs submatid
			str = ""
			if effecttype == "" or effecttype == undefined then
			 (
			  str = "没有使用效果\n"
			 --messagebox str
			 )
			 else
			(
				ary = filterString effecttype ")"
				str = "使用了\"" + ary[1] + "\"效果\n"
			)
			messagebox str
		)

		on effectRollout open do
		(
			ddl_list.items = #("水", "玻璃", "金属")
			ddl_list.selection = 0
			try(
				if(MulMatRollout.modeflag ==1)then
				(
					mymesh = MulMatRollout.mymesh
					matname = MulMatRollout.matname
					mutlflag = 1
				)
				else
				(
					mymesh = selection[1]
					matname = mymesh.mat.name
					if(viewport.isWire() == true) then
					(
						max wire smooth
					)
				)
			)catch()
			--matname = mesheffectRollout.matname
			--mymesh = 
			
		)
		on effectRollout close  do
		(
			if(mutlflag == 0)do
			(
				if(viewport.isWire() == false) then
				(
					max wire smooth
				)
			)
		)
		on btn_seteffect pressed do
		(
			i = ddl_list.selection 
			if(i==0)then
			(
				messagebox "请选择一个效果"
			)else
			(
				tflag = 0
				addeffect  mymesh  shaderstr
				try(DestroyDialog effectRollout)catch()
			)
			
			--try(DestroyDialog effectRollout)catch()
		)
		on btn_delete pressed do
		(
			tflag = 1
			addeffect   mymesh ""
			try(DestroyDialog effectRollout)catch()
		)
		on btn_view pressed do
		(
			vieweffect mymesh
		)
		on ddl_list selected sel do
		(
			--<dropdownlist>.selected String
			i = ddl_list.selection 
			--messagebox (i as string)
			case i of
			(
				1: (
					shaderstr = "水)"
					shaderstr = shaderstr + "<shader type=\"base\">reflect_water_plane</shader>)"
					shaderstr = shaderstr + "<shader type=\"diffuse\">reflect_water_plane</shader>)"
					shaderstr = shaderstr +"<shadervar name=\"tex normal\" type=\"texture\">generic_water_001_ani</shadervar>)"
					shaderstr = shaderstr +"<shadervar name=\"tex environment\" type=\"texture\">effectsky.dds</shadervar>)"
					shaderstr = shaderstr +"<shadervar name=\"water fog color\" type=\"vector4\">0.4,0.7,0.9,1</shadervar>)"
					shaderstr = shaderstr +"<shadervar name=\"water perturb scale\" type=\"vector4\">10,10,0,0</shadervar>)"
					shaderstr = shaderstr +"<shadervar name=\"water perturb fade\" type=\"float\">0.1</shadervar>)"
					shaderstr = shaderstr +"<shadervar name=\"specular\" type=\"vector4\">0.4,0.7,0.9,1</shadervar>"
				)
				2: (
						shaderstr = "玻璃)"
						shaderstr = shaderstr + "<shader type=\"diffuse\">reflectsphere</shader>)"
						shaderstr = shaderstr + "<shader type=\"base\">reflectsphere</shader>)"
						shaderstr = shaderstr + "<shadervar type=\"texture\" name=\"tex normal\">bolinormal.jpg</shadervar>)"
						shaderstr = shaderstr + "<shadervar type=\"texture\" name=\"tex reflection\">bolireflection.jpg</shadervar>)"
						shaderstr = shaderstr +"<shadervar type=\"float\" name=\"reflection opacity\">0.8</shadervar>)"
						shaderstr = shaderstr +"<shadervar type=\"vector4\" name=\"specular\">[1.0,1.0,1.0,1.0]</shadervar>)"
				)
				3: (
					 shaderstr = "金属)"
					  shaderstr = shaderstr + "<shader type=\"diffuse\">reflectsphere</shader>)"
					  shaderstr = shaderstr +"<shader type=\"base\">reflectsphere</shader>)"
					  shaderstr = shaderstr +"<shadervar type=\"texture\" name=\"tex reflection\">effectmetal.jpg</shadervar>)"
					  shaderstr = shaderstr +"<shadervar type=\"float\" name=\"reflection opacity\">0.8</shadervar>)"
					  shaderstr = shaderstr +"<shadervar type=\"vector4\" name=\"specular\">1,1,1,1</shadervar>"	
					)
				default: shaderstr = ""
			)
		
		)
	)
	---########################################  效果处理部分结束   #########################################
	rollout HudRollout "Hud属性设置" width:132 height:75
	(
		button btn_addhud "定义Hud属性" pos:[13,9] width:105 height:26
		button btn_delehud "删除hud" pos:[12,39] width:105 height:26
		on btn_addhud pressed do
		(
		 if(selection.count < 1)then
		 (
		  messagebox "请选择一个模型"
		 )
		 else
		 (
		  for iobj in selection do
		  (
		   setUserProp iobj "hudmesh" iobj.name
		  )
		  messagebox "定义HUD成功"
		 )
		)
		on btn_delehud pressed do
		(
		  if(selection.count < 1)then
		  (
		   messagebox "请选择一个模型"
		  )
		  else
		  (
		   for iobj in selection do
		   (
			setUserProp iobj "hudmesh" ""
		   )
		   messagebox "删除HUD成功"
		  )
		 
		 )
	)
	
	---########################################## 小地图位置信息对位 #####################################################
	
	rollout MapPosRollout "小地图对位" width:156 height:326
	(
		listbox lbx1 "" pos:[14,173] width:131 height:7
		button btn_importImg "1.导入底图图片      " pos:[5,5] width:145 height:21
		button btn_addLocation "添加位置" pos:[12,143] width:64 height:24
		button btn_dellocation "删除位置" pos:[80,143] width:64 height:24
		button btn_explocation "4.导出位置信息" pos:[9,293] width:139 height:24
		button btn_scale "缩放" pos:[57,54] width:33 height:18
		button btn_move "移动" pos:[99,55] width:30 height:18
		button btn_lock "锁图" pos:[18,54] width:31 height:20
		label lbl9 "X:" pos:[13,115] width:18 height:18
		local meshobjary = #()
		local meshnameary = #()
		local arraypoint = #()
		/* tool foo
		(
			on mouseMove clickno do 
			(
				try(
					$.pos = worldPoint
				)catch()
			)
		) */
		label lbl10 "Y:" pos:[84,115] width:15 height:19
		edittext edt_x "" pos:[27,115] width:40 height:17
		edittext edt_y "" pos:[98,115] width:41 height:18
		groupBox grp3 "2.调节镜头与底图对齐" pos:[5,32] width:142 height:54
		groupBox grp4 "3.定义位置信息:" pos:[6,94] width:144 height:190
		on MapPosRollout open do
		(
			viewport.setLayout #layout_1
			viewport.setType #view_top
			max select all	
			max zoomext sel all
			max select none
			max panview
			try(
				--LockButtonExt_i.bmp
				iconDir = (getDir #ui) + "icons\\" 
				--moveico = iconDir + "VFB_controls_i.bmp"
				lockico = iconDir + "LockButtonExt_i.bmp"
				scaleico = iconDir + "ViewControls_16i.bmp"
				--con = openBitMap iconDir
				btn_lock.images = #(lockico, undefined, 2, 1, 1, 1, 1)
				btn_scale.images = #(scaleico, undefined, 48, 1, 1, 1, 1)
				btn_move.images = #(scaleico, undefined, 48, 15, 1, 1, 1)
			 )
			catch()
		)
		on MapPosRollout close do
		(
			if(meshobjary.count > 0) do
			(
				for i in meshobjary do
				(
					select i
					max delete $
				)
			)
			try(
			backgroundImageFileName = ""
			)catch()
		)
		on lbx1 selected sel do
		(
			select meshobjary[sel]
			--print ("["  + ($.pos .x) as string + " , " + ($.pos .y) as string +" , " + ($.pos .z) as string +"]")
		)
		/* on lbx1 doubleClicked sel do
		(
			--try(
					select meshobjary[sel]
					startTool foo
			--	)catch()
		) */
		on btn_importImg pressed do
		(
			--max zoomext sel all
			--	max modify mode
			viewport.DispBkgImage = true
			img = getOpenFileName caption:"Open A Image File:"
			--messagebox img
			try(
				enableSceneRedraw()
				backgroundImageFileName = img
				--actionMan.executeAction 0 "40321"
				setBkgImageAspect #bitmap 
				completeredraw()--
			)catch()
			actionMan.executeAction 0 "40321"  -- Views: Update Background Image
		)
		on btn_addLocation pressed do
		(
			--messagebox backgroundImageFileName
			if((lbx1.items.count)<3) then
			(
				if((edt_x.text) != "" and (edt_y.text) != "")then
				(
					p = pickPoint()
					if(p != #rightClick ) then
					(
						breakflag = true
						num = (lbx1.items.count) + 1
						temp_array = lbx1.items
						for i=1 to num while breakflag do
						(
							strname = "MapPoint" + (i as string)
							if (finditem meshnameary strname) == 0 then
							(
								breakflag = false
								mypoint = Point pos:p isSelected:on centermarker:true
								mypoint.size = 300
								mypoint.name = strname
								mypoint.box = true
								appendIfUnique temp_array ("p" + (i as string) + ": ["+edt_x.text + " , "+edt_y.text +"]")
								append meshobjary mypoint 
								append meshnameary mypoint.name
								append arraypoint (edt_x.text + ","+edt_y.text)
								edt_x.text = ""
								edt_y.text = ""
							)
						)
						lbx1.items = temp_array
						lbx1.selection = (lbx1.items.count)
					)
				)
				else
					messagebox "请先输入二维坐标x,y值"
			)
			else
			(
				messagebox "小地图定位所需的点位置信息已够\n请删除添加或直接选中修改点位置信息."
			)
		)
		on btn_dellocation pressed do
		(
			if lbx1.items.count > 0 and lbx1.selection > 0 do
			(
				--select (getNodeByName lbx1.selected )
				select meshobjary[lbx1.selection]
				deleteItem meshobjary lbx1.selection
				deleteItem arraypoint lbx1.selection
				deleteItem meshnameary lbx1.selection
				max delete $
				lbx1.items = deleteItem lbx1.items lbx1.selection
			)
		)		
		on btn_explocation pressed do
		(
			cp = checkpPath()
			srcdir = "\\src\\product\\position"
			outputPath=cp+srcdir
			makeDir outputPath
			fileN  = "\\maxpos.xml"
			filename = (outputPath + fileN )
			if (existFile filename) then 
				try(deletefile filename)catch()
			outFile = createFile filename
			if (lbx1.items.count) == 3 then
			(
				format "<maxposition>\n" to:outFile
				--三点排序
				ypos = #(0,0,0)
				posinfo = #("top_left","right_bottom","roleInitialize")
				for i =1 to  3 do ypos[i] = (meshobjary[i]).pos.y
				for i =1 to  2 do 
				(
					for j = i+1 to 3 do
					(
						if(ypos[i]>ypos[j])do
						(
							tmp = ypos[i]
							ypos[i] = ypos[j]
							ypos[j] = tmp
						)
					)
				)
				/*
				<top_left>
					<point3d>
						<xpos>-271.524</xpos>
						<ypos>0.0</ypos>
						<zpos>307.241</zpos>
					</point3d>
					<point2d>
						<xpos>1</xpos>
						<ypos>1</ypos>
					</point2d>
				</top_left>
				*/
				for i =1 to 3 do
				(
					bkflag = false
					for j = 1 to 3 while bkflag == false do
					(	
						ypoint = (meshobjary[j]).pos.y
						if( ypoint == ypos[i])do
						(
							bkflag = true
							format ("\t<"+posinfo[i]+">\n") to:outFile
							format "\t\t<point3d>\n" to:outFile
							format ("\t\t\t<xpos>"+(meshobjary[i].pos.x) as string+"</xpos>\n") to:outFile
							format ("\t\t\t<ypos>"+(meshobjary[i].pos.z) as string+"</ypos>\n") to:outFile
							format ("\t\t\t<zpos>"+((meshobjary[i]).pos.y) as string+"</zpos>\n") to:outFile
							format "\t\t</point3d>\n" to:outFile
							--background 2d
							xypoint = filterString (arraypoint[i]) ","
							format "\t\t<point2d>\n" to:outFile
							format ("\t\t\t<xpos>"+ xypoint[1] as string+"</xpos>\n") to:outFile
							format ("\t\t\t<ypos>"+ xypoint[2] as string+"</ypos>\n") to:outFile
							format "\t\t</point2d>\n" to:outFile
							format ("\t</"+posinfo[i]+">\n") to:outFile
						)
					)
				)
				format "</maxposition>\n" to:outFile
				messagebox "导出成功"
			)
			else
				messagebox "小地图定位还缺少必需点信息,请添加后再导出!"
		)
		on btn_scale pressed do
		(
			max tool zoom
		)
		on btn_move pressed do
		(
		   max panview
		)
		on btn_lock pressed do
		(
		actionMan.executeAction 0 "343"  -- Tools: Background Lock Toggle
		)
	)
	
	
	---##########################################  #####################################################
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	rollout spp_sdk_position "SPP_SDK数据编辑" width:178 height:111
	(
		-- 通过时间来实时获取选择物体的中文名称
		Timer clock "testClock" pos:[13,497] width:24 height:24 interval:500 --tick once a second
		edittext edt1 "" pos:[28,30] width:118 height:25 enabled:true	-- 输入建筑中文名称的文本框
		button btn10 "导出建筑名称" pos:[26,62] width:120 height:27
		GroupBox grp3 "建筑中文名称" pos:[9,7] width:159 height:93
		GroupBox grp4 "角色的选择和出生位置" pos:[10,112] width:158 height:210
		button btn11 "创建选择角色" pos:[31,134] width:110 height:27
		button btn12 "创建选择摄像机" pos:[31,170] width:110 height:27
		button btn13 "创建出生角色" pos:[32,205] width:110 height:27
		button btn14 "创建出生摄像机" pos:[32,239] width:110 height:27
		button btn15 "导出位置" pos:[22,275] width:133 height:32
		GroupBox grp5 "沙盘信息" pos:[11,333] width:157 height:159
		button btn17 "创建气泡" pos:[32,358] width:110 height:27
		button btn18 "创建角色" pos:[33,395] width:110 height:27
		button btn19 "导出" pos:[30,434] width:118 height:28

---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- 获取当前 max 文件的路径，并判断是否为标准的 \src\art\ 目录
		fn checkProPath = 
		(
			proPath =""
			-- 判断当前项目的路径中是否包含 \src\art
			srcIndex = findString maxFilePath "src\\art\\"
			
			if srcIndex!=undefined then
			(
				proPath = substring maxFilePath 1 (srcIndex-2)
			)
			else
			(
				messagebox "请保存在正确的项目目录下！"
			)
			
			proPath
			
		)
		
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
		-- 判断是否为第一次设置物体名称，防止重复设置
		global first = true, preCname=""
		-- 实时设置所选择物体的中文名称
		
		
		
		

---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------		

		

---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------		


		on clock tick do
		(
			if selection.count < 2 then
			(
				if $ != undefined then
				(
					cname = getUserProp $ "cname"
					cname = cname as string
					if cname == "undefined" then
					(
						edt1.text = ""
						setUserProp $ "cname" ""
						preCname = ""
						cname = ""
					)
					
					if preCname!=cname then
					(
						edt1.text = cname
						preCname = cname
					)
			
				)
				else
				(
					edt1.text = ""
				)
			)
		)
		on edt1 entered text do
		(	-- 在建筑中文名称输入框，输入完毕时触发事件
			--------------------------------------
			------- 输入建筑的中文名称
			--------------------------------------
			if selection.count==0 then
			(
				messageBox "请先选择一个建筑"
			)else(
				setUserProp $ "cname" edt1.text
			)
		)
		on btn10 pressed do
		(	-- 在点击“导出建筑名称”按钮时触发事件
			--------------------------------------
			------- 导出选中的建筑
			--------------------------------------
			max select all
			
			xmlString = ""
			
			for obj in selection do
			(
				cname = getUserProp obj "cname"
				cname = cname as string
				if cname != "undefined" and cname != "" then
				(
					xmlString += "\t\t<meshobj name=\""+obj.name+"\" cname=\""+cname+"\" />\n"
				)
			)
			clearSelection()
			
			if xmlString!="" then
			(
				pathN = checkProPath() + "\\src\\product\\position\\"
				makeDir pathN
				fileN = "build.xml"
				outFile = createFile ( pathN + fileN )
				
				--xmlString = "<world>\n\t<buildiInfo>\n" + xmlString + "\t</buildInfo>\n</world>"
				xmlString = "<world>\n\t<buildInfo>\n" + xmlString + "\t</buildInfo>\n</world>"
				format xmlString to:outFile
				
				close outFile
			)
			
			messagebox "所有带有中文名称的模型已经被导出"
		)
		on btn11 pressed do
		(
			--------------------------------------
			------- 创建 “角色选择”时的角色
			------- 这个模型是一个茶壶，名字是 roleSelect 
			------- 导出时只需要取这个名字就可以
			--------------------------------------
			
			tool roleSelectTool
			(
				on mousePoint clickno do
				(
					if clickno == 2 then
					(
						roleSelectNode = getnodebyname "roleSelect"
						if roleSelectNode==undefined then
						(
							tmpObj = Teapot radius:1.44848 smooth:on segs:4 body:on handle:on spout:on lid:on mapcoords:on pos:[128.684,-310.493,0] isSelected:on
							tmpObj.name = "RoleSelect"
							select (getnodebyname "roleSelect")
							rotate $ (eulerangles 0 0 90)
							resetXForm $
							in coordsys grid ($.pos = gridPoint)
						)
						else
						(
							select $roleSelect
							in coordsys grid ($.pos = gridPoint)
						)
						max move
					)
				)
		
			)
			startTool roleSelectTool
		)
		on btn12 pressed do
		(
			--------------------------------------
			------- 创建“角色选择”时的摄像机
			--------------------------------------
			tool roleSelectCameraTool
			(
				on mousePoint clickno do
				(
					if clickno == 2 then
					(
						roleSelectNode = getnodebyname "RoleSelectCamera"
						if roleSelectNode==undefined then
						(
							tmpObj = Freecamera fov:45 targetDistance:160 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off pos:[130.467,-355.128,0] isSelected:on
							tmpObj.name = "RoleSelectCamera"
							select (getnodebyname "RoleSelectCamera")
							rotate $ (eulerangles 90 0 0)
							resetXForm $
							in coordsys grid ($.pos = gridPoint)
						)
						else
						(
							select $RoleSelectCamera
							in coordsys grid ($.pos = gridPoint)
						)
						max move
					)
				)
		
			)
			startTool roleSelectCameraTool
			
		)
		on btn13 pressed do
		(
			--------------------------------------
			------- 创建角色出生时的角色
			--------------------------------------
			tool roleInitializeTool
			(
				on mousePoint clickno do
				(
					if clickno == 2 then
					(
						roleSelectNode = getnodebyname "RoleInitialize"
						if roleSelectNode==undefined then
						(
							tmpObj = Teapot radius:1.44848 smooth:on segs:4 body:on handle:on spout:on lid:on mapcoords:on pos:[128.684,-310.493,0] isSelected:on
							tmpObj.name = "RoleInitialize"
							select (getnodebyname "RoleInitialize")
							rotate $ (eulerangles 0 0 90)
							resetXForm $
							in coordsys grid ($.pos = gridPoint)
						)
						else
						(
							select $RoleInitialize
							in coordsys grid ($.pos = gridPoint)
						)
						max move
					)
				)
		
			)
			startTool roleInitializeTool
		)
		on btn14 pressed do
		(
			--------------------------------------
			------- 创建角色出生时的摄像机
			--------------------------------------
			tool roleInitializeCameraTool
			(
				on mousePoint clickno do
				(
					if clickno == 2 then
					(
						roleSelectNode = getnodebyname "RoleInitializeCamera"
						if roleSelectNode==undefined then
						(
							tmpObj = Freecamera fov:45 targetDistance:160 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off pos:[130.467,-355.128,0] isSelected:on
							tmpObj.name = "RoleInitializeCamera"
							select (getnodebyname "RoleInitializeCamera")
							rotate $ (eulerangles 90 0 0)
							resetXForm $
							in coordsys grid ($.pos = gridPoint)
						)
						else
						(
							select $RoleInitializeCamera
							in coordsys grid ($.pos = gridPoint)
						)
						max move
					)
				)
		
			)
			startTool roleInitializeCameraTool
		)
		on btn15 pressed do
		(
			--------------------------------------
			------- 导出“角色选择”和角色出生的角色和摄像机的位置和朝向信息
			--------------------------------------
			roleSelectNode = getnodebyname "RoleSelect"
			roleSelectCamera = getnodebyname "RoleSelectCamera"
			roleInitializeNode = getnodebyname "RoleInitialize"
			roleInitializeCamera = getnodebyname "RoleInitializeCamera"
			
			xmlString = ""
			
			if roleSelectNode!=undefined and roleSelectCamera!=undefined and roleInitializeNode!=undefined and roleInitializeCamera!=undefined then
			(
				eularfRoleSelect = (quatToEuler (roleSelectNode.transform as quat))
					
				eularfRoleSelectCamera = (quatToEuler (roleSelectCamera.transform as quat))
					
				eularfRoleInitializeNode = (quatToEuler (roleInitializeNode.transform as quat))
					
				eularfRoleInitializeCamera = (quatToEuler (roleInitializeCamera.transform as quat))
				
				xmlString = "\n\t<roleSelect>"
				xmlString += "\n\t\t<role>"
				xmlString += "\n\t\t\t<position>["+(roleSelectNode.pos.x as string)+","+(roleSelectNode.pos.z as string)+","+(roleSelectNode.pos.y as string)+"]</position>" 
				xmlString += "\n\t\t\t<rotation>["+(eularfRoleSelect.x as string)+","+(eularfRoleSelect.z as string)+","+(eularfRoleSelect.y as string)+"]</rotation>"
				xmlString += "\n\t\t</role>"
				xmlString += "\n\t\t<camrea>"
				xmlString += "\n\t\t\t<position>["+(roleSelectCamera.pos.x as string)+","+(roleSelectCamera.pos.z as string)+","+(roleSelectCamera.pos.y as string)+"]</position>"
				xmlString += "\n\t\t\t<rotation>["+(eularfRoleSelectCamera.x as string)+","+(eularfRoleSelectCamera.z as string)+","+(eularfRoleSelectCamera.y as string)+"]</rotation>"
				xmlString += "\n\t\t</camrea>"
				xmlString += "\n\t</roleSelect>"
				
				xmlString += "\n\t<roleInitialize>"
				xmlString += "\n\t\t<role>"
				xmlString += "\n\t\t\t<position>["+(roleInitializeNode.pos.x as string)+","+(roleInitializeNode.pos.z as string)+","+(roleInitializeNode.pos.y as string)+"]</position>" 
				xmlString += "\n\t\t\t<rotation>["+(eularfRoleInitializeNode.x as string)+","+(eularfRoleInitializeNode.z as string)+","+(eularfRoleInitializeNode.y as string)+"]</rotation>"
				xmlString += "\n\t\t</role>"
				xmlString += "\n\t\t<camrea>"
				xmlString += "\n\t\t\t<position>["+(roleInitializeCamera.pos.x as string)+","+(roleInitializeCamera.pos.z as string)+","+(roleInitializeCamera.pos.y as string)+"]</position>"
				xmlString += "\n\t\t\t<rotation>["+(eularfRoleInitializeCamera.x as string)+","+(eularfRoleInitializeCamera.z as string)+","+(eularfRoleInitializeCamera.y as string)+"]</rotation>"
				xmlString += "\n\t\t</camrea>"
				xmlString += "\n\t</roleInitialize>"
			)
			else
			(
				messagebox "请确认已经在场景中创建了：选择角色、选择摄像机、出生角色、出生摄像机"
			)			
			
			if xmlString!="" then
			(
				pathN = checkProPath() + "\\src\\art\\position\\"
				makeDir pathN
				fileN = "role.xml"
				outFile = createFile ( pathN + fileN )
				
				xmlString = "<application type=\"school\">" + xmlString + "\n</application>"
				format xmlString to:outFile
				
				close outFile
				messagebox "角色和摄像机的信息已经导出"
			)
		)
		on btn17 pressed do
		(
			--------------------------------------
			------- 创建沙盘的气泡，代表气泡的位置
			--------------------------------------
		
		)
		on btn18 pressed do
		(
			--------------------------------------
			------- 创建沙盘模式下，点击某个建筑进入场景时，角色在建筑面前的位置和朝向
			--------------------------------------
			
		)
		on btn19 pressed do
		(
			--------------------------------------
			------- 导出沙盘的气泡和角色的信息
			--------------------------------------
			
		)
	)
	
	
---########################################   临时修正错误模型uv    #########################################
	
	/*
	ticket:1417
	chenyang20120703 : 废弃
	rollout tmprepairUV "六.临时修正错误模型uv" width:171 height:300
	(
		button tmprepairUV_btn "1.修正uv并导出" pos:[4,4] width:160 height:18
		on tmprepairUV_btn pressed do
		(
			if selection.count >0 then
			(
				repUVW()
				basem_export()
			)else
			(
				messagebox"请选择uv有错误的物体！"
			)
		)
	)*/
	
	
	
	/* 添加合并贴图的方法 zhanghongru*/
	local filename = "$scripts\\texatlasgen_configfile.txt"
    local file
	
	local polyop_setmapvert = polyop.setMapVert
	local polyop_getvert = polyop.getVert
	local polyop_slice = polyop.slice
	local polyop_getfaceverts = polyop.getFaceVerts
	local polyop_getfaceedges = polyop.getFaceEdges
	local polyop_getmapvert = polyop.getMapVert
	local polyop_getmapface = polyop.getMapFace
	local polyop_getfacenormal = polyop.getFaceNormal

	---

	fn tag_getEdgeVerts obj face_index edge_index =
	(
		if (classOf obj) == Editable_Poly then
		(
			local verts = (polyop_getfaceverts obj face_index)
			local edges = (polyop_getfaceedges obj face_index)
	 
			edge_index = findItem edges edge_index
			if edge_index == edges.count then
				#(verts[edge_index], verts[1])
			else
				#(verts[edge_index], verts[edge_index+1])
		)
		else
			"ERROR"
	)

	fn tag_getMapVert obj map_channel face_indices index =
	(
		if (classOf obj) == Editable_Poly then
		(
			if (classof face_indices) == integer then face_indices = #(face_indices)
			else face_indices = face_indices as Array
			local mesh_verts = #()
			local text_verts = #()
			for i in face_indices do
			(
				join mesh_verts (polyop_getfaceverts obj i)
				join text_verts (polyop_getmapface obj map_channel i)
			)
			index = findItem mesh_verts index
			(polyop_getmapvert obj map_channel text_verts[index])
		)
		else
			"ERROR"
	)

	fn tag_setMapVert obj map_channel face_indices index vert =
	(
		if (classOf obj) == Editable_Poly then
		(
			if (classof face_indices) == integer then face_indices = #(face_indices)
			else face_indices = face_indices as Array
			local mesh_verts = #()
			local text_verts = #()
			for i in face_indices do
			(
				join mesh_verts (polyop_getfaceverts obj i)
				join text_verts (polyop_getmapface obj map_channel i)
			)
			index = findItem mesh_verts index
			polyop_setmapvert obj map_channel text_verts[index] vert
		)
		else
			"ERROR"
	)
	 
	fn tag_getVertex obj index =
	(
		if (classOf obj) == Editable_Poly then
			(in coordsys world polyop_getvert obj index)
		else
			"ERROR"
	)
	 
	fn tag_slice obj faces normal center =
	(
		if (classOf obj) == Editable_Poly then
		(
			local plane = (ray center normal)
			polyop_slice obj faces plane
		)
		else
			"ERROR"
	)
	 
	-- helper functions
	 
	fn tag_equal_int a b =
	(
		if a-b > 0.001 or a-b < -0.001 then false else true
	)
	 
	---
	 
	fn checkMirror obj map_channel face_index =
	(
		local sum = 0
		
		if (classOf obj) == Editable_Poly then
		(
			local verts = (polyop_getfaceverts obj face_index)
			local edges = (polyop_getfaceverts obj face_index)
			
			for i = 1 to edges.count do
			(
				local edge_verts
				local tv1, tv2, tv3
	 
				if i == edges.count-1 then
				(
					tv1 = (tag_getMapVert obj map_channel face_index verts[i])
					tv2 = (tag_getMapVert obj map_channel face_index verts[i+1])
					tv3 = (tag_getMapVert obj map_channel face_index verts[1])
				)
				else if i == edges.count then
				(
					tv1 = (tag_getMapVert obj map_channel face_index verts[i])
					tv2 = (tag_getMapVert obj map_channel face_index verts[1])
					tv3 = (tag_getMapVert obj map_channel face_index verts[2])
				)
				else
				(
					tv1 = (tag_getMapVert obj map_channel face_index verts[i+0])
					tv2 = (tag_getMapVert obj map_channel face_index verts[i+1])
					tv3 = (tag_getMapVert obj map_channel face_index verts[i+2])
					
				)
				
				local edge1_vect = normalize (tv2 - tv1)
				local edge2_vect = normalize (tv3 - tv1)
		
				-- (cross edge1_vect edge2_vect)
				sum += (cross edge1_vect edge2_vect).z
			)
		)
		
		(sum <= 0)
	)
	 
	---------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------
	 
	fn TAG objs	map_channel:1
				texture_atlas_filename:"C:\\TEMP\\TESTTEXTUREATLAS.tga"
				padding:2
				padding_tresize:true
				do_undo:off
				do_slicing:true
				do_generate_ta:true
				do_msgs:false
				do_break_all:false
				do_force_padding:false
				do_ignore_errors:false
				=						
	(
		if objs.count == 0 do
			return -1
		
		local tag_objs = #()
		for o in objs where (((classOf o == Editable_Poly) or (classOf o == PolyMeshObject)) and ((classOf o.material == Standardmaterial) or (classOf o.material == Multimaterial))) do
			append tag_objs o

		if tag_objs.count == 0 do
		(
			messagebox "Select correct object type, with correct material type!"
			return -1
		)
		
		-- get rid of instanced objects!
		local instances
		for i = 1 to tag_objs.count do with undo do_undo
			if tag_objs[i] != #empty do
				if (InstanceMgr.GetInstances tag_objs[i] &instances) > 1 do
					for i2 = i+1 to tag_objs.count do
						for j in instances do
							if tag_objs[i2] == j do
								tag_objs[i2] = #empty
		local is_too_much = -1
		do
		(
			is_too_much = (findItem tag_objs #empty)
			if is_too_much != 0 do deleteItem tag_objs is_too_much
		) while is_too_much != 0
			
		if do_msgs do format "TAG begins.\n"

		if (objs.count-tag_objs.count) > 0 and do_msgs do format "... % objects won't be manipulated (wrong class or material, or were instances)\n" (objs.count-tag_objs.count)

		local textures = #()
		local cutted_textures = #{} -- special feature: uvmaps don't have padding
									-- no texture will have padding when slicing isn't needed, that's a bug ...
		struct SMaterialInfo
		(
			mats_in_multi_used = #{}, -- materials can have different ids than their position in multimaterial ...
			mmat_ids = #(),
			num_materials_used = 0,
			mmatid_to_texid = #()
		)
		local material_info = #()
		material_info[tag_objs.count] = 0
		
		-------------------------------------------------------------
		-- begin loop		
		local o = 0
		for real_obj in tag_objs do with undo do_undo
		(
			o += 1
			local obj = real_obj

			if do_slicing or do_force_padding do
			(
				-- this is a workaround for max 9, because collapseNodeTo is buggy
				obj = editable_mesh()
				obj.baseobject = copy real_obj.baseobject
				local save_obj = real_obj.baseobject
				hide real_obj
				convertTo obj PolyMeshObject
			)
		
			select obj
			setCommandPanelTaskMode #modify
			
			if do_msgs do format "Analyzing and manipulating % ...\n" real_obj.name
			
			local facecount = obj.faces.count
	 		local is_UVmapped = false
			
			if do_msgs do format "... % has % faces\n" real_obj.name facecount
		 
			material_info[o] = SMaterialInfo()
			
			local faces_cutplanes = #()
			if do_slicing do faces_cutplanes[facecount] = #()
		 
			-------------------------
			-------------------------
			-- Preparation: Test for UV faces - are their areas too small? Does it have a UV map?
			-------------------------
			
			if do_slicing do
			(
				-- look for modifiers ...
				if real_obj.modifiers.count > 0 do
					for mod in real_obj.modifiers do
						if (classOf mod) == Unwrap_UVW or (classOf mod) == Uvwmap do
						(
							if not do_ignore_errors do
							(
								local ss = stringStream ""
								format "% has at least one modifier which manipulates the meshes' UV coordinates. If you want to see TAG's effect, you probably will have to delete/deactivate it." real_obj.name to:ss
								messagebox (ss as string)
							)
							if do_msgs do format "... Warning: % has UVW modifier!\n" real_obj.name
						)
				
				-- map channel doesn't seem to be updated otherwise, hmm ...
				local uvwmod = Unwrap_UVW()
				addModifier obj uvwmod
				uvwmod.setMapChannel map_channel
				uvwmod.setConstantUpdate false
				uvwmod.setShowSelectedVertices false
				uvwmod.updateView()
				uvwmod.setTVSubObjectMode 3

				-- first test: is the object uv mapped?
				local x, y, width, height, areaUVW, areaGeom
				uvwmod.getArea #{1..facecount} &x &y &width &height &areaUVW &areaGeom
				is_UVmapped = ((x >= 0.001) and (x+width <= 0.999) and (y >= 0.001) and (y+height <= 0.999))

				deleteModifier obj uvwmod

				if not is_UVmapped do
				(
					local error_faces = #{}
					local meshmod = Turn_to_Mesh() -- getting area with getArea() only works with mesh, not poly 
					addModifier obj meshmod
					uvwmod = Unwrap_UVW()
					addModifier obj uvwmod
					uvwmod.setMapChannel map_channel
					uvwmod.setConstantUpdate false
					uvwmod.setShowSelectedVertices false
					uvwmod.updateView()
					uvwmod.edit()
					uvwmod.setTVSubObjectMode 3
	
					local polycount = uvwmod.numberPolygons()
					for f = 1 to polycount do
					(
						uvwmod.getArea #{f} &x &y &width &height &areaUVW &areaGeom
						if (width < 0.0001 or height < 0.0001 or areaUVW < 0.0001) and areaGeom > 0.01 do
							append error_faces f
					)
					
					if error_faces.count > 0 then
					(
						local resume_process = true
						if not do_ignore_errors then resume_process = queryBox "Errors in UVWs! Do you want to continue? Press \"No\" to stop the process and check the problematic faces selected in an Unwrap Modifier. Click \"Yes\" to resume anyway, with the risk of a bad result."
						if not resume_process then
						(
							-- from the workaround
							addmodifier real_obj meshmod
							addmodifier real_obj uvwmod
							unhide real_obj
							select real_obj
							
							uvwmod.selectFaces error_faces
							uvwmod.edit()
							uvwmod.setTVSubObjectMode 3
							if do_msgs do format "Stopped because of % errors in %!\n" error_faces.count real_obj.name
							delete obj
							return -1
						)
						if do_msgs do format "Probably % errors in mesh(!) of %, i.e. those map faces are too small/thin!\n" error_faces.count real_obj.name
					)
				
					deleteModifier obj uvwmod
					deleteModifier obj meshmod
				)
			)
			
			------------------------
			------------------------
			-- First step: analyze the model and save the slice planes in an array
			------------------------
			
			setCommandPanelTaskMode #create
			
			if (do_slicing or do_force_padding) and not is_UVmapped then
			(
				local faces_cutplanes_count = 0
				local textures_used = 0
				if do_msgs do format "... analyzing %'s uvs and geometry ...\n" real_obj.name
				
				for f = 1 to facecount do with undo do_undo
				(
					-- it's likely that we need some sliceplanes for some faces
					faces_cutplanes[f] = #()

					local act_edges = (polyop_getfaceedges obj f)					
					if act_edges != undefined do
					(
						local edgecount = act_edges.count
						
						edge_cutpoints_x = #() -- count is same as edgecount at the end
						edge_cutpoints_y = #()
						
						local is_mirrored = checkMirror obj map_channel f
						
						-- build two tables: one with so called x-points, the other one with y-points
						-- e.g. x-points are all at texture uv with y = ...,-1.0,0.0,1.0,2.0,...
						-- so I have to save the min value (e.g. -1.0), in min_y
						--
						-- it has to be guaranteed that the table with the x-points
						-- will be filled correctly (no gaps), so find the right pos (e.g. [3] for 1.0)
						
						-- find the minimum texture coords		
						local absminx = 1000000
						local absminy = 1000000
						
						for i in act_edges do with undo do_undo
						(
							local vertices = (tag_getEdgeVerts obj f i)
				
							local tv1 = (tag_getMapVert obj map_channel f vertices[1])
							local tv2 = (tag_getMapVert obj map_channel f vertices[2])
							
							local minx = if tv1.x < tv2.x then tv1.x else tv2.x
							local miny = if tv1.y < tv2.y then tv1.y else tv2.y
							
							absminx = if absminx < minx then absminx else minx
							absminy = if absminy < miny then absminy else miny
						)
						
						absminx = (ceil(absminx)) as integer
						absminy = (ceil(absminy)) as integer
						
						-- save cutting points for every edge
						-- those cutting points are found at every x/y-axis of texture uvs
						for i in act_edges do with undo do_undo
						(
							local vertices = (tag_getEdgeVerts obj f i)
							
							local tv1 = (tag_getMapVert obj map_channel f vertices[1])
							local tv2 = (tag_getMapVert obj map_channel f vertices[2])
							tv1 = [tv1.x, tv1.y] -- convert to Point2
							tv2 = [tv2.x, tv2.y]
							local dir = tv2-tv1
							
							local minx = if tv1.x < tv2.x then tv1.x else tv2.x
							local maxx = if tv1.x >= tv2.x then tv1.x else tv2.x
							local miny = if tv1.y < tv2.y then tv1.y else tv2.y
							local maxy = if tv1.y >= tv2.y then tv1.y else tv2.y
							
							-- the x-axes ( ... -2, -1, 0, 1, ...)
							local tempx = (ceil(minx)) as float
							while tempx < ceil(maxx) do
							(
								local new_percent = (tempx-tv1.x)/dir.x
								local new_vect = dir*new_percent
								
								-- get the cutpoint in 3d space
								local new_dir = (tag_getVertex obj vertices[2]) - (tag_getVertex obj vertices[1])
								local new_point = (tag_getVertex obj vertices[1]) + (new_dir*new_percent)
								
								if edge_cutpoints_x[tempx-absminx+1] == undefined do
									edge_cutpoints_x[tempx-absminx+1] = #()
									
								append edge_cutpoints_x[tempx-absminx+1] #(i, new_point, tv1.y + new_vect.y, tempx) -- edgenumber, point, texcoords
									
								tempx += 1
							)
							
							-- the y-axes ( ... -2, -1, 0, 1, ...)			
							local tempy = (ceil(miny)) as integer
							while tempy < ceil(maxy) do with undo do_undo
							(
								local new_percent = (tempy-tv1.y)/dir.y
								local new_vect = dir*new_percent
								
								-- get the cutpoint in 3d space
								local new_dir = (tag_getVertex obj vertices[2]) - (tag_getVertex obj vertices[1])
								local new_point = (tag_getVertex obj vertices[1]) + (new_dir*new_percent)
								
								if edge_cutpoints_y[tempy-absminy+1] == undefined do
									edge_cutpoints_y[tempy-absminy+1] = #()
				
								append edge_cutpoints_y[tempy-absminy+1] #(i, new_point, tv1.x + new_vect.x, tempy) -- edgenumber, coord, texcoords
								
								tempy += 1
							)				
						)
						
						-- get the points, get their position in 3d-space, build a sliceplane
						-- we have to check if edges cross (they shouldn't)
						-- first: for y
						for i = 1 to edge_cutpoints_y.count do with undo do_undo
						(
							local allpoints = deepCopy edge_cutpoints_y[i]
							local points = edge_cutpoints_y[i]
							local act_point_i = 0
							
							while points.count > 1 do
							(
								act_point_i += 1
								local act_edge = copy points[1][1]
								local act_point = copy points[1][2]
								local act_TC = copy points[1][3]
								local act_TC2 = copy points[1][4]
								
								-- get the first point (the active one) out of the list
								deleteItem points 1
										
								-- and test it against every other point on the same "line"
								for other_points_i = 1 to points.count do with undo do_undo
								(
									local other_edge = points[other_points_i][1]
									local other_point = points[other_points_i][2]
									local other_TC = copy points[other_points_i][3]
									
									-- find out if other edges are crossing
									local is_near = true
									for test_points_i = 1 to allpoints.count while is_near do
									(
										if test_points_i != act_point_i and test_points_i != (act_point_i+other_points_i) do
										(
											local test_TC = allpoints[test_points_i][3]
											if act_TC < other_TC then
												if test_TC >= act_TC and test_TC <= other_TC do is_near = false
											else
												if test_TC <= act_TC and test_TC >= other_TC do is_near = false
										)
									)
									if is_near do
									(				
										-- angle between edges ...
										local verta = tag_getEdgeVerts obj f act_edge
										local verto = tag_getEdgeVerts obj f other_edge
								
										local tva1 = (tag_getMapVert obj map_channel f verta[1])
										local tva2 = (tag_getMapVert obj map_channel f verta[2])
										local tvo1 = (tag_getMapVert obj map_channel f verto[1])
										local tvo2 = (tag_getMapVert obj map_channel f verto[2])
					
										-- which one is on the left?
										local going_on = true
										if not is_mirrored then
										(
											if act_TC < other_TC then
												if (tva1.y <= tva2.y) do going_on = false
											else
												if (tvo1.y <= tvo2.y) do going_on = false
										)
										else
										(
											if act_TC < other_TC then
												if (tva1.y >= tva2.y) do going_on = false
											else
												if (tvo1.y >= tvo2.y) do going_on = false
										)
										
										if going_on do
										(
											local plane_normal = cross (polyop_getfacenormal obj f) (other_point-act_point)
											plane_normal = normalize plane_normal
																
											append faces_cutplanes[f] #(act_point, plane_normal, false, act_TC2) -- center, normal, is-x-axis, which axis
											faces_cutplanes_count += 1
										)
									)
								)
							)
						)
						
						-- the same for x
						for i = 1 to edge_cutpoints_x.count do with undo do_undo
						(
							local allpoints = deepCopy edge_cutpoints_x[i]
							local points = edge_cutpoints_x[i]
							local act_point_i = 0
							
							while points.count > 1 do
							(
								act_point_i += 1
								local act_edge = copy points[1][1]
								local act_point = copy points[1][2]
								local act_TC = copy points[1][3]
								local act_TC2 = copy points[1][4]
								
								-- get the first point (the active one) out of the list
								deleteItem points 1
										
								-- and test it against every other point on the same "line"
								for other_points_i = 1 to points.count do with undo do_undo
								(
									local other_edge = points[other_points_i][1]
									local other_point = points[other_points_i][2]
									local other_TC = points[other_points_i][3]
									
									-- find out if other edges are crossing
									local is_near = true
									for test_points_i = 1 to allpoints.count while is_near do
									(
										if test_points_i != act_point_i and test_points_i != (act_point_i+other_points_i) do
										(
											local test_TC = allpoints[test_points_i][3]
											if act_TC < other_TC then
												if test_TC >= act_TC and test_TC <= other_TC do is_near = false
											else
												if test_TC <= act_TC and test_TC >= other_TC do is_near = false
										)
									)
									
									if is_near do
									(
										-- angle between edges ...
										local verta = tag_getEdgeVerts obj f act_edge
										local verto = tag_getEdgeVerts obj f other_edge
								
										local tva1 = (tag_getMapVert obj map_channel f verta[1])
										local tva2 = (tag_getMapVert obj map_channel f verta[2])
										local tvo1 = (tag_getMapVert obj map_channel f verto[1])
										local tvo2 = (tag_getMapVert obj map_channel f verto[2])
					
										-- which one is on the left?
										local going_on = true
										if not is_mirrored then
										(
											if act_TC < other_TC then
												if (tva1.x >= tva2.x) do going_on = false
											else
												if (tvo1.x >= tvo2.x) do going_on = false
										)
										else
										(
											if act_TC < other_TC then
												if (tva1.x <= tva2.x) do going_on = false
											else
												if (tvo1.x <= tvo2.x) do going_on = false
										)
							
										if going_on do
										(
											local plane_normal = cross (polyop_getfacenormal obj f) (other_point-act_point)
											plane_normal = normalize plane_normal
											
											append faces_cutplanes[f] #(act_point, plane_normal, true, act_TC2) -- center, normal, is-x-axis, which axis
											faces_cutplanes_count += 1
										)
									)
								)
							)
						)
				
						if (classOf real_obj.material) == Multimaterial do
						(
							-- count materials, for later use
							local real_mat_id = obj.GetFaceMaterial f
							local id_in_mmat = findItem real_obj.material.materialIDList real_mat_id
							
							-- wasn't the material saved before?
							if material_info[o].mats_in_multi_used[id_in_mmat] == false do
							(
								material_info[o].mats_in_multi_used[id_in_mmat] = true
								append material_info[o].mmat_ids id_in_mmat
								local tex_id
								try
								(
									tex_id = findItem textures real_obj.material.materialList[id_in_mmat].diffuseMap.filename
								)
								catch
								(
									-- from the workaround
									select real_obj
									unhide real_obj
									delete obj

									messagebox "Error in materials! Are you really using multi and standard materials only?"
									return -1
								)
								if tex_id == 0 then
								(
									append textures real_obj.material.materialList[id_in_mmat].diffuseMap.filename
									material_info[o].mmatid_to_texid[id_in_mmat] = textures.count
									textures_used += 1
								)
								else
									material_info[o].mmatid_to_texid[id_in_mmat] = tex_id
								
								material_info[o].num_materials_used += 1
							)
						)
					)
				)

				if (classOf real_obj.material) == Multimaterial and do_msgs do format "...... found % materials with % new textures\n" material_info[o].num_materials_used textures_used		 
				if do_msgs do format "...... % slice planes need to be generated\n" faces_cutplanes_count
				
				obj.preserveUVs = true
		 
			)
			else -- if not do_slicing or is_UVmapped then
			(
				if (classOf real_obj.material) == Multimaterial do
				(
					local textures_used = 0
					
					for f = 1 to facecount do with undo do_undo
					(
						-- count materials, for later use
						local real_mat_id = obj.GetFaceMaterial f
						local id_in_mmat = findItem real_obj.material.materialIDList real_mat_id
						
						if id_in_mmat == 0 do
						(
							-- from the workaround
							select real_obj
							unhide real_obj
							delete obj
							
							messagebox "Multimaterial or object with multimaterial has errors!"
							format "Error: Material ID not found!\n"
							return -1
						)
						
						-- wasn't the material saved before?
						if material_info[o].mats_in_multi_used[id_in_mmat] == false do
						(
							material_info[o].mats_in_multi_used[id_in_mmat] = true
							append material_info[o].mmat_ids id_in_mmat
							local tex_id
							try
							(
								tex_id = findItem textures real_obj.material.materialList[id_in_mmat].diffuseMap.filename
							)
							catch
							(
								-- from the workaround
								select real_obj
								unhide real_obj
								delete obj

								messagebox "Error in materials! Are you really using multi and standard materials with bitmaps only?"
								return -1
							)
							if tex_id == 0 then
							(
								append textures real_obj.material.materialList[id_in_mmat].diffuseMap.filename
								material_info[o].mmatid_to_texid[id_in_mmat] = textures.count
								textures_used += 1
							)
							else
								material_info[o].mmatid_to_texid[id_in_mmat] = tex_id
							
							material_info[o].num_materials_used += 1
						)
					)			

					if do_msgs do format "...... % has % materials with % new textures\n" real_obj.name material_info[o].num_materials_used textures_used
				)
			)
			
			if (classOf real_obj.material) == Standardmaterial do
			(
				material_info[o].mats_in_multi_used[1] = true
				material_info[o].mmat_ids[1] = 1
				local tex_id
				try
				(
					tex_id = findItem textures real_obj.material.diffuseMap.filename
				)
				catch
				(
					if do_slicing or do_force_padding do
					(
						select real_obj
						unhide real_obj
						delete obj
					)
					messagebox "Error in materials! Are you really using multi and standard materials with bitmaps only?"
					return -1
				)				
				if tex_id == 0 then
				(
					append textures real_obj.material.diffuseMap.filename
					material_info[o].mmatid_to_texid[1] = textures.count
					if do_msgs do format "...... % has only one material with a new texture\n" real_obj.name
				)
				else
				(
					material_info[o].mmatid_to_texid[1] = tex_id
					if do_msgs do format "...... % has only one material with no new texture\n" real_obj.name
				)
					
				material_info[o].num_materials_used = 1
			)
			
			----------------------------
			----------------------------
			-- Second step: slice the geometry
			----------------------------

			if do_slicing and not is_UVmapped do
			(
				if do_msgs do format "... %: slicing geometry\n" real_obj.name
				
				-- the slicing begins
				for f = 1 to facecount do with undo do_undo
				(
					-- get the material and look if it's cutted ... to find out uvmaps, y'know?
					if faces_cutplanes[f].count > 0 then
					(
						local old_edgecount = obj.edges.count
						
						setFaceSelection obj #(f)
				
						local act_verts = obj.numVerts
						
						for i = 1 to faces_cutplanes[f].count do with undo do_undo
						(
							local active_faces = getFaceSelection obj
							local success = (tag_slice obj active_faces faces_cutplanes[f][i][2] faces_cutplanes[f][i][1])
							
							if success == false do
							(
								local going_on = true
								if not do_ignore_errors do going_on = querybox "A specific face couldn't be sliced, which will result in a incorrect UV map.\nCheck your UVs and Geometry, please. Continue anyway?"
								if not going_on do
								(
									-- from the workaround
									delete obj
									select real_obj
									obj = real_obj
								
									uvwmod = Unwrap_UVW()
									addModifier obj uvwmod
									uvwmod.setMapChannel map_channel
									uvwmod.updateView()
									uvwmod.selectFaces active_faces
									uvwmod.edit()
									uvwmod.setTVSubObjectMode 3
									return -1
								)
							)
								
							local xaxis = faces_cutplanes[f][i][3]
							local tc_val = faces_cutplanes[f][i][4]
							
							for j = act_verts+1 to obj.numVerts do with undo do_undo
							(
								local tv = (tag_getMapVert obj map_channel (getFaceSelection obj) j)
								if xaxis then tv.x = tc_val else tv.y = tc_val
								tag_setMapVert obj map_channel (getFaceSelection obj) j tv
							)			
							
							act_verts = obj.numVerts
						)
					)
				)
			)

			--------------------------
			--------------------------
			-- Intermission! Check if materials are cutted ...
			--------------------------

			setCommandPanelTaskMode #modify

			if do_slicing or (do_generate_ta and do_force_padding) do
			(
				select obj
				uvwmod = Unwrap_UVW()
				addModifier obj uvwmod
				uvwmod.setMapChannel map_channel
				uvwmod.updateView()
				uvwmod.setResetPivotOnSelection true
				uvwmod.setTVSubObjectMode 3
				
				if (classOf real_obj.material) == Multimaterial then
				(
					local x, y, width, height, temp
					-- iterate through all material ids to check if they need padding
					for i = 1 to material_info[o].num_materials_used do with undo do_undo
					(
						local bmp_id = material_info[o].mmatid_to_texid[material_info[o].mmat_ids[i]]
						if not cutted_textures[bmp_id] do
						(
							uvwmod.selectByMatID material_info[o].mmat_ids[i]
							uvwmod.getArea (uvwmod.getSelectedPolygons()) &x &y &width &height &temp &temp
							if not (((x >= 0.001) and (x+width <= 0.999) and (y >= 0.001) and (y+height <= 0.999))) do
								cutted_textures[bmp_id] = true
						)				
					)
				)
				else
				(
					local x, y, width, height, temp
					uvwmod.getArea #{1..facecount} &x &y &width &height &areaUVW &areaGeom
					if not (((x >= 0.001) and (x+width <= 0.999) and (y >= 0.001) and (y+height <= 0.999))) do
						cutted_textures[material_info[o].mmatid_to_texid[1]] = true
				)
						
				deleteModifier obj uvwmod
			)
			
			--------------------------
			--------------------------
			-- Third step: "normalize" the texture coords, i.e. break and move all chunks into the range 0.0..1.0
			--------------------------
			
			if do_slicing and not is_UVmapped do
			(
				select obj
				uvwmod = Unwrap_UVW()
				addModifier obj uvwmod
				uvwmod.setMapChannel map_channel
				uvwmod.updateView()
				uvwmod.setResetPivotOnSelection true
				-- uvwmod.setConstantUpdate false
				uvwmod.setShowSelectedVertices false
				uvwmod.edit()				
				uvwmod.setTVSubObjectMode 1				
				uvwmod.selectVertices #{1..uvwmod.numberVertices()}
				uvwmod.vertToEdgeSelect()
				local num_tedges = (uvwmod.getSelectedEdges()).count				

				if do_break_all then
				(
					uvwmod.setTVSubObjectMode 2
					if do_msgs do format "... %: normalizing tex coords, breaking all % edges\n" real_obj.name num_tedges
					uvwmod.breakSelected()
				)
				else
				(
					if do_msgs do format "... %: normalizing tex coords, analyzing % edges ...\n" real_obj.name num_tedges	
					uvwmod.selectVertices #{}
					uvwmod.setTVSubObjectMode 2
					local edges_to_break = #{}
					local vert_indices
					local vert1, vert2
					local uvwmod_selectedges = uvwmod.selectEdges
					local uvwmod_edgetovertselect = uvwmod.edgeToVertSelect
					local uvwmod_getselectedvertices = uvwmod.getSelectedVertices
					local uvwmod_getvertexposition = uvwmod.getVertexPosition

					-- find the edges to break
					-- this little piece of code is the (extreme) bottleneck in big meshes ...
					local start = timeStamp()
					for i = 1 to num_tedges do with undo do_undo
					(
						uvwmod_selectedges #{i}
						uvwmod_edgetovertselect()
						local vert_indices = uvwmod_getselectedvertices() as Array
						vert1 = (uvwmod_getvertexposition 0 vert_indices[1])
						vert2 = (uvwmod_getvertexposition 0 vert_indices[2])
						if (tag_equal_int (floor (vert1.x+0.5)) vert1.x) and (tag_equal_int vert1.x vert2.x) then
							edges_to_break[i] = true
						else if (tag_equal_int (floor (vert1.y+0.5)) vert1.y) and (tag_equal_int vert1.y vert2.y) do
							edges_to_break[i] = true
					)
					local end = timeStamp()
					
					uvwmod_selectedges edges_to_break
					uvwmod.breakSelected()
					
					if do_msgs do format "...... broke % of % texture edges in % secs\n" edges_to_break.numberSet num_tedges ((end - start)/1000)
				)

				convertTo obj PolyMeshObject
				-- maxOps.CollapseNodeTo obj 1 off
				
				uvwmod = Unwrap_UVW()
				addModifier obj uvwmod
				uvwmod.setMapChannel map_channel
				uvwmod.setResetPivotOnSelection true
				uvwmod.setConstantUpdate false
				uvwmod.setShowSelectedVertices false
				uvwmod.setTVSubObjectMode 3

				-- moving all the chunks
				local num_polys = uvwmod.numberPolygons()
				local x, y, temp
				if do_break_all then
				(
					for i = 1 to num_polys do with undo do_undo
					(
						uvwmod.selectFaces #{i}
						local x_move = 0.0
						local y_move = 0.0
						uvwmod.getArea #{i} &x &y &temp &temp &temp &temp
						while x < 0.0 do (x += 1.0; x_move += 1.0)
						while x >= 0.999 do (x -= 1.0; x_move -= 1.0)
						while y < 0.0 do (y += 1.0; y_move += 1.0)
						while y >= 0.999 do (y -= 1.0; y_move -= 1.0)
						uvwmod.moveSelected [x_move, y_move, 0.0]
					)
				)
				else
				(
					local poly_is_edited = #{}
					for i = 1 to num_polys do with undo do_undo
					(
						if not poly_is_edited[i] do
						(						
							uvwmod.selectFaces #{i}
							
							local do_expand = true
							local old_selected_number
							local selected_polys = #{}
							do
							(
								old_selected_number = (uvwmod.getSelectedPolygons()).numberSet
								uvwmod.expandSelection()
								selected_polys = uvwmod.getSelectedPolygons()
								if selected_polys.numberSet == old_selected_number do do_expand = false
							) while do_expand
							uvwmod.breakSelected() --- cleaning up - some vertices may have "survived" the breaking before
							
							join poly_is_edited selected_polys
							
							local x_move = 0.0
							local y_move = 0.0
							uvwmod.getArea selected_polys &x &y &temp &temp &temp &temp
							while x < 0.0 do (x += 1.0; x_move += 1.0)
							while x >= 0.999 do (x -= 1.0; x_move -= 1.0)
							while y < 0.0 do (y += 1.0; y_move += 1.0)
							while y >= 0.999 do (y -= 1.0; y_move -= 1.0)
							uvwmod.moveSelected [x_move, y_move, 0.0]
						)
					)
				)
				
				convertTo obj PolyMeshObject
				-- maxOps.CollapseNodeTo obj 1 off
			)
			
			if real_obj != obj do
			(
				-- continue the workaround, *sigh*
				real_obj.baseobject = obj.baseobject
				for geo in geometry do if geo.baseobject == save_obj then geo.baseobject = obj.baseobject
				delete obj
				unhide real_obj
			)
		)
			
		if do_msgs and (do_slicing or do_generate_ta) do format "TAG will make a texture atlas now.\n"

		--------------------------
		--------------------------
		-- Fourth step: rendering a texture atlas
		--------------------------
		
		local area_of_all_textures = 0	
		local num_textures = textures.count 
		struct SBitmap
		(
			bmp,
			filename,
			rotated = false, -- counterclockwise 90 degrees, or not
			area,
			height,
			width,
			x = -100,
			y = -100,
			is_cutted,
			fn rotate = ( (swap height width); rotated = not rotated )
		)
		bitmaps = #()
		bitmaps[num_textures] = undefined -- pre-size the array
		
		if do_slicing or do_generate_ta do
		(
			if do_msgs and do_generate_ta do format "Packing % textures\n" num_textures
		
			-- iterate through all material ids
			for i = 1 to num_textures do with undo do_undo
			(
				-- prepare the textures
				sbmp = SBitmap()
				try
				(
					sbmp.bmp = openBitmap textures[i]
				)
				catch
				(
					messagebox "One of the textures couldn't be found! (Probably wrong path.)\n Please select the correct one."
					local new_bmp = getOpenFileName caption:"Select Texture" filename:textures[i]
					if new_bmp == undefined then
					(
						if do_msgs do format "Aborted texture packing!\nError: % wasn't found.\n" textures[i]
						return -1
					)
					else
						sbmp.bmp = openBitmap new_bmp
				)
				
				sbmp.filename = textures[i]
				sbmp.width = sbmp.bmp.width
				sbmp.height = sbmp.bmp.height
				sbmp.is_cutted = cutted_textures[i]
				if sbmp.is_cutted do
				(
					sbmp.width += if not padding_tresize then (2*padding) else 0
					sbmp.height += if not padding_tresize then (2*padding) else 0
				)
				sbmp.area = sbmp.width * sbmp.height
				bitmaps[i] = sbmp
				
				area_of_all_textures += sbmp.area
			)
			
			-- sort the textures, biggest first
			fn compareSBMP v1 v2 =
			(
				if v1.area < v2.area then 1
				else if v1.area == v2.area then 0
				else -1
			)
			
			-- get the size of the texture atlas
			local size_of_texatlas_x = (sqrt area_of_all_textures)
			local size_of_texatlas_y
			local i = 0
			while size_of_texatlas_x > 0 do
			(
				size_of_texatlas_x = bit.shift size_of_texatlas_x -1
				i += 1
			)
			size_of_texatlas_y = size_of_texatlas_x = bit.shift 1 (i-1)
		
			-- manage the trunks and the textures
			fn add_to_trunk trunks_array trunk_index bitmaps_array bitmap_index =
			(
				-- bitmap fits exactly:
				if bitmaps_array[bitmap_index].width == trunks_array[trunk_index][3] and bitmaps_array[bitmap_index].height == trunks_array[trunk_index][4] then
				(
					bitmaps_array[bitmap_index].x = trunks_array[trunk_index][1]
					bitmaps_array[bitmap_index].y = trunks_array[trunk_index][2]
					deleteItem bitmaps_array bitmap_index
					deleteItem trunks_array trunk_index
				)
				else -- it's smaller
				(
					bitmaps_array[bitmap_index].x = trunks_array[trunk_index][1]
					bitmaps_array[bitmap_index].y = trunks_array[trunk_index][2]
					
					-- create a new trunk
					append trunks_array #(	trunks_array[trunk_index][1]+bitmaps_array[bitmap_index].width,
											trunks_array[trunk_index][2],
											trunks_array[trunk_index][3]-bitmaps_array[bitmap_index].width,
											bitmaps_array[bitmap_index].height)
					-- make the old one smaller
					trunks_array[trunk_index][2] += bitmaps_array[bitmap_index].height
					trunks_array[trunk_index][4] -= bitmaps_array[bitmap_index].height
		
					deleteItem bitmaps_array bitmap_index
				)
				
				-- sort the trunks
				fn compareTRUNKS v1 v2 =
				(
					if v1[3]*v1[4] > v2[3]*v2[4] then  1
					else if v1[3]*v1[4] == v2[3]*v2[4] then 0
					else -1
				)
				qsort trunks_array compareTRUNKS
			)
			
			-- fill the texture atlas, virtually
			local act_trk = 1
			local done_packing
			local resize_switch = true
			do with undo do_undo -- the packing
			(
				local free_trunks = #(#(0, 0, size_of_texatlas_x, size_of_texatlas_y)) -- x,y,w,h
				local rest_bitmaps = copy bitmaps #noMap
				qsort rest_bitmaps compareSBMP
			
				while true do
				(
					if rest_bitmaps.count == 0 do
					(
						done_packing = true
						exit
					)
					if free_trunks.count == 0 do
					(
						-- texture too small ...
						done_packing = false
						exit
					)
			
					local found_fitting_bitmap = false
					for act_bmp = 1 to rest_bitmaps.count while not found_fitting_bitmap do
					(
						-- get the smallest trunk & the biggest texture which fit
						if rest_bitmaps[act_bmp].width <= free_trunks[act_trk][3] and rest_bitmaps[act_bmp].height <= free_trunks[act_trk][4] then
						(
							add_to_trunk free_trunks act_trk rest_bitmaps act_bmp
							found_fitting_bitmap = true
						)
						else if rest_bitmaps[act_bmp].width <= free_trunks[act_trk][4] and rest_bitmaps[act_bmp].height <= free_trunks[act_trk][3] then
						(
							rest_bitmaps[act_bmp].rotate()
							add_to_trunk free_trunks act_trk rest_bitmaps act_bmp
							found_fitting_bitmap = true
						)
					)
					-- the trunk is too small (or slim) for any remaining texture
					if not found_fitting_bitmap do
						deleteItem free_trunks act_trk
				)
				if not done_packing do -- resize the tex texture
				(
					 if resize_switch then size_of_texatlas_y = 2*size_of_texatlas_y
					 else size_of_texatlas_x = 2*size_of_texatlas_x
						
					 resize_switch = not resize_switch
					 
					 for sbmp in bitmaps where sbmp.rotated do sbmp.rotate()					 	
				)
			) while done_packing == false
		)
		
		if do_generate_ta do
		(	
			-- create the texture atlas, at last
			local texture_atlas
			try
			(
				texture_atlas = Bitmap size_of_texatlas_x size_of_texatlas_y
			)
			catch
			(
				messagebox "The texture atlas couldn't be generated because Max ran out of Memory.\nTry restarting max, wireframe view and/or a renderfarm ..."
				format "Error! Couldn't generate bitmap for texture atlas with size %*%!\n" size_of_texatlas_x size_of_texatlas_y
				return -1
			)
			texture_atlas.filename = texture_atlas_filename
			
			if do_msgs do format "Drawing the texture atlas with size %*% ...\n" size_of_texatlas_x size_of_texatlas_y
			
			-- draw the textures into the atlas
			for sbmp in bitmaps do with undo do_undo
			(
				if do_msgs do format "... adding %\n" sbmp.filename
		
				if sbmp.x < 0 do continue -- should not happen, y'know?!
				
				-- no padding for uv mapped objects, right?
				local tp = padding
				if not sbmp.is_cutted do tp = 0
				
				-- but don't forget the padding!
				local temp_bitmap = sbmp.bmp
				if tp > 0 and padding_tresize then
				(
					if sbmp.bmp.width <= (tp*2) or sbmp.bmp.height <= (tp*2) do
					(
						messagebox "Padding number too big! Check your texture sizes!"
						return -1
					)
					temp_bitmap = Bitmap (sbmp.bmp.width-(tp*2)) (sbmp.bmp.height-(tp*2))
					copy sbmp.bmp temp_bitmap
				)
				local pixels
				
				if not sbmp.rotated then
				(
					for i = 0 to temp_bitmap.height-1 do
					(
						pixels = getPixels temp_bitmap [0, i] temp_bitmap.width
						setPixels texture_atlas [tp+sbmp.x, tp+sbmp.y+i] pixels
					)
				)
				else -- rotate the texture CCW
				(
					for i = 0 to temp_bitmap.height-1 do
					(
						local pixels = getPixels temp_bitmap [0, i] temp_bitmap.width
						for j = 0 to temp_bitmap.width-1 do
							setPixels texture_atlas [tp+sbmp.x+i, tp+sbmp.y+temp_bitmap.width-(j+1)] #(pixels[j+1])
					)			
				)
				close temp_bitmap
				
				-- the frame (padding)
				if tp > 0 do
				(
					local ox, oy, nw, nh
					ox = sbmp.x+tp -- origin x, y
					oy = sbmp.y+tp
					nw = sbmp.width-(tp*2) -- new width, height
					nh = sbmp.height-(tp*2)
					
					-- top
					pixels = getPixels texture_atlas [ox, oy] nw
					for i = 0 to tp-1 do
						setPixels texture_atlas [ox, sbmp.y+i] pixels
					-- bottom
					pixels = getPixels texture_atlas [ox, oy+nh-1] nw
					for i = 0 to tp-1 do
						setPixels texture_atlas [ox, oy+nh+i] pixels
					for i = 0 to nh-1 do
					(
						-- left
						pixels = getPixels texture_atlas [ox, oy+i] 1
						for j = 0 to tp-2 do append pixels pixels[1]
						setPixels texture_atlas [sbmp.x, oy+i] pixels
						-- right
						pixels = getPixels texture_atlas [ox+nw-1, oy+i] 1
						for j = 0 to tp-2 do append pixels pixels[1]
						setPixels texture_atlas [ox+nw, oy+i] pixels
					)
					-- the corners
					local pixels_lt = getPixels texture_atlas [ox, oy] 1
					local pixels_rt = getPixels texture_atlas [ox+nw-1, oy] 1
					local pixels_lb = getPixels texture_atlas [ox, oy+nh-1] 1
					local pixels_rb = getPixels texture_atlas [ox+nw-1, oy+nh-1] 1
					for j = 0 to tp-2 do
					(
						append pixels_lt pixels_lt[1]
						append pixels_rt pixels_rt[1]
						append pixels_lb pixels_lb[1]
						append pixels_rb pixels_rb[1]
					)
					for i = 0 to tp-1 do
					(
						setPixels texture_atlas [sbmp.x, sbmp.y+i] pixels_lt
						setPixels texture_atlas [ox+nw, sbmp.y+i] pixels_rt
						setPixels texture_atlas [sbmp.x, oy+nh+i] pixels_lb
						setPixels texture_atlas [ox+nw, oy+nh+i] pixels_rb
					)
				)
			)
			
			try
			(
				save texture_atlas quiet:true
			)
			catch
			(
				if not do_ignore_errors do messagebox "Could not save texture atlas!"
				if do_msgs do format "Error: texture atlas was not saved to any file.\n"
			)
			display texture_atlas
		)
		
		
		
		--------------------------
		--------------------------
		-- Fifth step: scale and position uvs
		--------------------------
		
		if do_slicing and do_msgs do format "TAG makes new UV coordinates.\n"
		
		if do_slicing do
		(
			local o = 0
			for real_obj in tag_objs do with undo do_undo
			(
				o += 1

				-- this is a workaround for max 9, because collapseNodeTo is buggy
				local obj = editable_mesh()
				obj.baseobject = copy real_obj.baseobject
				local save_obj = real_obj.baseobject
				hide real_obj

				if do_msgs do format "Rearrange %'s UVs\n" real_obj.name
				
				select obj
				uvwmod = Unwrap_UVW()
				addModifier obj uvwmod
				uvwmod.setMapChannel map_channel
				uvwmod.updateView()
				uvwmod.setResetPivotOnSelection true
				uvwmod.setTVSubObjectMode 3
				--uvwmod.edit()

				-- every chunk must be scaled, oriented and translated ...
				-- thus, iterate through all material ids
				for i = 1 to material_info[o].num_materials_used do with undo do_undo
				(
					local bmp_id = material_info[o].mmatid_to_texid[material_info[o].mmat_ids[i]]
					
					local cwidth = bitmaps[bmp_id].bmp.width
					local cheight = bitmaps[bmp_id].bmp.height
					local scale_factor_x
					local scale_factor_y
			
					local tp = padding
					-- no padding for uvmaps, eh
					if not cutted_textures[bmp_id] do tp = 0
					
					if padding_tresize do
					(
						cwidth -= (tp*2)
						cheight -= (tp*2)
					)
			
					if not bitmaps[bmp_id].rotated then
					(
						scale_factor_x = (cwidth as float) / (size_of_texatlas_x as float)
						scale_factor_y = (cheight as float) / (size_of_texatlas_y as float)
					)
					else
					(
						scale_factor_x = (cwidth as float) / (size_of_texatlas_y as float)
						scale_factor_y = (cheight as float) / (size_of_texatlas_x as float)
					)
		 
					if (classOf real_obj.material) == Multimaterial then
						uvwmod.selectByMatID real_obj.material.materialIDList[material_info[o].mmat_ids[i]]
					else if (classOf real_obj.material) == Standardmaterial then
						uvwmod.selectPolygons #{1..uvwmod.numberPolygons()}
					uvwmod.updateView()
					uvwmod.unwrap.breakSelected() -- cleaning up!
					uvwmod.detachEdgeVertices()

					local x, y, width, height, temp

					local new_selection = #{}
					local sel_polys = (uvwmod.getSelectedPolygons()) as Array
					for f in sel_polys do
					(
						uvwmod.getArea #{f} &x &y &width &height &temp &temp
						if ((x >= -0.001) and (x+width <= 1.002) and (y >= -0.001) and (y+height <= 1.002)) do
							new_selection[f] = true
					)
					uvwmod.selectPolygons new_selection
					
					-- scale the uvs
					uvwmod.scaleSelectedCenter scale_factor_x 1
					uvwmod.scaleSelectedCenter scale_factor_y 2
			
					-- rotate uvs (if needed)
					if bitmaps[bmp_id].rotated do
					(
						swap scale_factor_x scale_factor_y
						uvwmod.rotateSelectedCenter (pi/2.0)
					)
			
					-- the position should be absolutely centered now, because we move it relatively
					uvwmod.getArea (uvwmod.getSelectedFaces()) &x &y &width &height &temp &temp
					local tar_x = 0.5 - (width*0.5)
					local tar_y = 0.5 - (height*0.5)
					uvwmod.moveSelected [tar_x - x, tar_y - y, 0.0]
				
					-- move uvs	
					local move_x = ((bitmaps[bmp_id].x+tp) as float) / (size_of_texatlas_x as float) - 0.5 + (scale_factor_x * 0.5)
					local move_y = ((bitmaps[bmp_id].y+tp) as float) / (size_of_texatlas_y as float) - 0.5 + (scale_factor_y * 0.5)
					uvwmod.moveSelected [move_x, -move_y, 0.0]
				)
				
				--------------------------
				--------------------------
				-- Last step: finish the model
				--------------------------
			 
				convertTo obj PolyMeshObject
				
				-- continue the workaround, *sigh*
				real_obj.baseobject = obj.baseobject
				for geo in geometry do if geo.baseobject == save_obj then geo.baseobject = obj.baseobject
				delete obj
				unhide real_obj
			)		
		)
		
		select tag_objs
	 
		if do_msgs do format "TAG ended.\n"
	 
		return 1
	)

	--------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------

	rollout ro_tag "TexAtlasGen 1.0.3"
	(
		label lb_warning "WARNING: Save your work!"
		checkbox cb_do_undo "Disable Undo" checked:true
		checkbox cb_do_messages "Generate Messages" checked:true
		checkbox cb_do_auto_resume "Ignore Warnings" checked:false
		group "Object"
		(
			checkbox cb_ob_slicing "Slice Geometry and" checked:true
			label lb_ob_slicing "Generate UVs" pos:[31,119]
			checkbox cb_ob_breakall "Break all Edges" checked:false
			
			spinner sp_ob_map_channel "Map Channel:" range:[1,99,1] type:#integer
		)
		group "Texture Atlas"
		(
			checkbox cb_ta_create "Create" checked:true
			checkbox cb_ta_force_padding "No Padding" checked:false enabled:false
			edittext et_ta_filename ""
			button bn_ta_filename "Choose Path & Filename"
		)
		group "Textures"
		(
			spinner sp_tx_padding "Padding:" range:[0, 32, 2] type:#integer
			checkbox cb_tx_resize "Shrink in Atlas" checked:true
		)
		button bn_do_it "Generate Texture Atlas" height:25
		
		label lb_3d_io "2009 (c) 3d-io" pos:[43,394]
		
		------
			
		on cb_ob_slicing changed arg do
		(
			cb_ob_breakall.enabled = arg
			if cb_ta_create.checked do
			(
				cb_ta_force_padding.enabled = not arg
			)
			if cb_ta_force_padding.enabled do
			(
				sp_tx_padding.enabled = not cb_ta_force_padding.checked
				cb_tx_resize.enabled = not cb_ta_force_padding.checked
			)
		)
		
		on cb_ta_create changed arg do
		(
			et_ta_filename.enabled = arg
			bn_ta_filename.enabled = arg
			if not arg or (arg and not cb_ob_slicing.checked) do
			(
				cb_ta_force_padding.enabled = arg
			)
		)
		
		on cb_ta_force_padding changed arg do
		(
			sp_tx_padding.enabled = not arg
			cb_tx_resize.enabled = not arg
		)
		
		on bn_ta_filename pressed do
		(
			local output_name = getSaveFileName caption:"Image File" \
												types:"Targa (*.tga)|*.tga|BMP (*.bmp)|*.bmp|JPEG (*.jpg)|*.jpg|All Files (*.*)|*.*|" \
												initialDir:"$images"
			if output_name != undefined do
			(
				et_ta_filename.text = output_name
			)
		)
		
		on bn_do_it pressed do
		(
			if selection.count > 0 do
			(
				TAG  selection  map_channel:sp_ob_map_channel.value \
								padding:sp_tx_padding.value \
								padding_tresize:cb_tx_resize.checked \
								texture_atlas_filename:et_ta_filename.text \
								do_undo:(not cb_do_undo.checked) \
								do_slicing:cb_ob_slicing.checked \
								do_generate_ta:cb_ta_create.checked \
								do_break_all:cb_ob_breakall.checked \
								do_msgs:cb_do_messages.checked \
								do_force_padding:(not cb_ta_force_padding.checked) \
								do_ignore_errors:cb_do_auto_resume.checked
			)
		)
		
		on ro_tag open do
		(
			file = openFile filename mode:"rt"
			
			if file == undefined then
			(
				-- create a new ini file because it doesn't exist
				file = createFile filename

				format "%\n%\n%\n" true true false
				format "%\n%\n%\n" true false true
				format "1\n"
				format "%\n%\n%\n" true false false
				format "C:\\TEMP\\TEXTUREATLAS.tga\n"
				format "%\n%\n"  true true
				format "2\n%\n%\n%\n" true true true
				
				--
				
				cb_do_undo.checked = true
				cb_do_messages.checked = true
				cb_do_auto_resume.checked = false

				cb_ob_slicing.checked = true
				cb_ob_breakall.checked = false
				cb_ob_breakall.enabled = true
				
				sp_ob_map_channel.value = 1

				cb_ta_create.checked = true
				cb_ta_force_padding.checked = false
				cb_ta_force_padding.enabled = false
				et_ta_filename.text = "C:\\TEMP\\TEXTUREATLAS.tga"
				et_ta_filename.enabled = true
				bn_ta_filename.enabled = true
				
				sp_tx_padding.value = 2
				sp_tx_padding.enabled = true
				cb_tx_resize.checked = true
				cb_tx_resize.enabled = true
			)
			else
			(
				cb_do_undo.checked = execute (readLine file)
				cb_do_messages.checked = execute (readLine file)
				cb_do_auto_resume.checked = execute (readLine file)

				cb_ob_slicing.checked = execute (readLine file)
				cb_ob_breakall.checked = execute (readLine file)
				cb_ob_breakall.enabled = execute (readLine file)
				
				sp_ob_map_channel.value = (readLine file) as integer

				cb_ta_create.checked = execute (readLine file)
				cb_ta_force_padding.checked = execute (readLine file)
				cb_ta_force_padding.enabled = execute (readLine file)
				et_ta_filename.text = readLine file
				et_ta_filename.enabled = execute (readLine file)
				bn_ta_filename.enabled = execute (readLine file)
				
				sp_tx_padding.value = (readLine file) as integer
				sp_tx_padding.enabled = execute (readLine file)
				cb_tx_resize.checked = execute (readLine file)
				cb_tx_resize.enabled = execute (readLine file)
			) 
		)
		on ro_tag  close do
		(
			if file != undefined then
				close file
			deleteFile filename
			file = createFile filename
			
			format "%\n" cb_do_undo.checked to:file
			format "%\n" cb_do_messages.checked to:file
			format "%\n" cb_do_auto_resume.checked to:file
			
			format "%\n" cb_ob_slicing.checked to:file
			format "%\n" cb_ob_breakall.checked to:file
			format "%\n" cb_ob_breakall.enabled to:file
			
			format "%\n" sp_ob_map_channel.value to:file
			
			format "%\n" cb_ta_create.checked to:file
			format "%\n" cb_ta_force_padding.checked to:file
			format "%\n" cb_ta_force_padding.enabled to:file
			format "%\n" et_ta_filename.text to:file
			format "%\n" et_ta_filename.enabled to:file
			format "%\n" bn_ta_filename.enabled to:file
			
			format "%\n" sp_tx_padding.value to:file
			format "%\n" sp_tx_padding.enabled to:file
			format "%\n" cb_tx_resize.checked to:file
			format "%\n" cb_tx_resize.enabled to:file
			
			close file
		)
	)
	
	--zhanghongru 添加diffuseCo
	fn getFirstNode =
	(
		clearlistener()
		name_arr = #()
		for i in geometry do
		(
			s = i.name
			mpp = matchPattern s pattern:"plant*"
			if mpp == true do
			(
				mp = findString s "#"
				mp = mp - 1
			-- 	format"%\n" mp
				sameN = substring s 1 mp 
		-- 		format "%\n"   sameN
				append name_arr sameN
			)
		)
		new_name_arr = makeUniqueArray name_arr
		firstNode_arr = #()
		try(
			for i in new_name_arr do
			(
				nm =  i + "#1"
				firstNode = getNodeByName nm
				append firstNode_arr firstNode
			)
			-- 如果找不到 #1 的mesh，说明模型人员操作有问题。需要重新按照命名规范命名。
		)catch(messagebox"模型命名有问题，请重新规范命名！")
		firstNode_arr
	)
-- getFirstNode()

	fn diffuseCo_correct = 
	(
		ambientColor = color 0 0 0
		
		-- diffuse color to [0,0,0]
		fnode_arr = getFirstNode()
		for i in fnode_arr do
		(
			if i != undefined do
			(
				if i.mat != undefined do
				(
					mat = i.mat
					if (classof mat) == standard do
					(
						mat.diffuseColor = [0,0,0]
					)
					if (classof mat) == multimaterial do
					(
						submatnum = getNumSubMtls mat
						for im = 1 to submatnum do
						(
							if (classof mat[im]) == standard do
							(
								mat[im].diffuseColor = [0,0,0]
							)
						)
					)
				)
			)			
		)
		-- plant illumcolor
		-- plant opacity
		for i in fnode_arr do
		(
			if i != undefined do
			(
				mat = i.mat
				if (classof mat) == standard do
				(
					mat.useSelfIllumColor = on
					mat.selfIllumColor = color 30 30 30
					
					-- texpath
					texname = mat.diffuseMap.filename
					
					-- diffuse
					mat.diffuseMap.monoOutput = 0
					mat.diffuseMap.alphaSource = 2
					
					-- plant opacity
					mat.opacityMap = Bitmaptexture fileName:texname
					mat.opacityMap.monoOutput = 1
					mat.opacityMap.alphaSource = 0
				)
				if (classof mat) == multimaterial do
				(
					submatnum = getNumSubMtls mat
					for im = 1 to submatnum do
					(
						if (classof mat[im]) == standard do
						(
							mat[im].useSelfIllumColor = on
							mat[im].selfIllumColor = color 30 30 30
							
							-- texpath
							texname = mat[im].diffuseMap.filename
							
							-- diffuse
							mat[im].diffuseMap.monoOutput = 0
							mat[im].diffuseMap.alphaSource = 2
							
							-- plant opacity
							mat[im].opacityMap = Bitmaptexture fileName:texname
							mat[im].opacityMap.monoOutput = 1
							mat[im].opacityMap.alphaSource = 0
						)
					)
				)
			)
		)
	)
	
	
	-----------------------------------------------------------------------------------------------------------
	rollout fixTexture "一.贴图" width:171 height:300
	(
		button fixTexture_btn "1.裁剪贴图 (Cuttexture)" pos:[4,4] width:160 height:18
		button dataEdit_btn "2.输出标建贴图名 (Bldg Name)" pos:[4,25] width:160 height:18
		button detail_btn "3.处理加载页树白边" pos:[4,46] width:160 height:18
		button mtex_btn "4.合并贴图(MTex)" pos:[4,67] width:160 height:18
		on fixTexture_btn pressed do
		(
			param = "--dir " + getProjectPath() + "\\src\\art\\scene\\diffuse  --log " + getProjectPath() + "\\plan\\问题\\裁剪贴图.txt"
			startSppTool "autoCutImage" param
		)
		on dataEdit_btn pressed do
		(
			exporttexname()
		)
		on detail_btn pressed do
		(
			diffuseCo_correct()
		)
		on mtex_btn pressed do
		(			
			createDialog ro_tag 150 415	
		)
	)
	--检查lod效果是否添加到单材质上,并输出信息
	fn checkEffectLod =
	(
		arrErrLod = #()
		for i in geometry do
		(
			Currentmat = i.mat
			if( classof Currentmat == multimaterial ) then
			(		  
				bkflag = false
				for iSubMtl = 1 to Currentmat.materialList.count while bkflag == false do
				(
				   try(
						CurrentSubMtl = Currentmat.materialList[iSubMtl]
						subidname = "submatid" + (iSubMtl as string)				
						iname = CurrentSubMtl.name --当前子材质名字
						effecttype = getUserProp i subidname --查找是否属性定义内有效果
					  
						if effecttype != "" and effecttype != undefined then
						(
							
							str = effecttype as string
							ary = filterString str ")"
							if(ary[1] == "水") then
							(
								append arrErrLod i.name
								bkflag = true
							)
						)		
					)catch()
				)
			)
		)
		--print arrErrLod.count
		if(arrErrLod.count > 0)then
		(
			cp = checkpPath()
			srcdir = "\\plan\\问题"
			outputPath=cp+srcdir
			makeDir outputPath
			fileN  = "\\属性定义错误报告.txt"
			filename = (outputPath + fileN )
			--outFile = createFile filename
			if (existFile filename) then 
				try(deletefile filename)catch()
			outFile = createFile filename	
			for ilodname in arrErrLod do
				format "A16--物体：%的材质应该是单一材质standard材质，不应是多维材质\n" (ilodname) to:outFile
			close outFile
		)
	)
	fn checkEffectHud =
	(
		arrErrLod = #()
		strerror = ""
		for iobj in geometry do
		(
			effecttype = getUserProp iobj "hudmesh"
			if effecttype == "" or effecttype == undefined do
			(
				continue
			)
			
			try(
				if(iobj.numverts != 4) or (iobj.numfaces > 2) then
				(
					strerror = strerror + iobj.name as string +"这个mesh不是个面片植物，不能定义HUD属性\n"
					continue
				)
			)catch()
			if not (matchPattern iobj.name pattern:("plant*") ignoreCase:false) then 
			(
				strerror = strerror + iobj.name as string +"这个mesh不是植物，需要重新命名成plant\n"
			)
		)
		if(strerror != "")then
		(
			cp = checkpPath()
			srcdir = "\\plan\\问题"
			outputPath=cp+srcdir
			makeDir outputPath
			fileN  = "\\A18——HUD属性定义错误.txt"
			filename = (outputPath + fileN )
			if (existFile filename) then 
				try(deletefile filename)catch()
			outFile = createFile filename	
			format strerror to:outFile
			close outFile
		)
	)
	rollout CollisionRollout "Col属性定义" width:124 height:92
	(
		button btn_defcollision "定义无碰撞属性" pos:[4,6] width:116 height:22
		button btn_delcollision "删除无碰撞属性" pos:[6,31] width:116 height:22
		button btn_expcollision "属性信息输出" pos:[5,58] width:116 height:22
		fn defCollision flag =
		(
			strinfo = ""
			if flag then
			(
				if selection.count < 1 then
				(
					messagebox "请至少选择一个模型"
					return false
				)
				for iobj in selection do
				(
					setUserProp iobj "nocollision" iobj.name
				)
				strinfo = "定义无碰撞成功"
			)
			else
			(
				if selection.count < 1 then
				(
					messagebox "请至少选择一个模型"
					return false
				)
				for iobj in selection do
				(
					effecttype = getUserProp iobj "nocollision"
					if effecttype != undefined then
						setUserProp iobj "nocollision" ""
				)
				strinfo = "删除无碰撞定义成功"
			)
			messagebox strinfo
		)
		fn expCollision =
		(
			cp = checkpPath()
			srcdir = "\\src\\product\\position\\"
			outputPath=cp+srcdir
			makeDir outputPath
			fileN  = "nocollision.txt"
			filename = (outputPath + fileN )
			--try delete existed file
			if (existFile filename) then 
				try(deletefile filename)catch()
			
			outFile = createFile filename

			strinfo = ""
			for i in geometry do
			(
				effecttype = getUserProp i "nocollision"
				if effecttype != "" and effecttype != undefined then
				(
					strinfo += (i.name + "\n")
				)
			)
			format strinfo to:outFile
			close outFile 
			messagebox "属性信息导出成功"
		)
		
		
		on btn_defcollision pressed  do
		(
			defCollision true
		)
		on btn_delcollision pressed  do
		(
		defCollision false
		)
		on btn_expcollision pressed  do
		(
			expCollision()
		)
	)
	rollout setMaterialProperty "二.属性定义" width:171 height:300
	(
		button setMaterialProperty_btn "1.材质定义 (Shader)" pos:[4,4] width:160 height:18
		button setHUD_btn "2.HUD定义 (HUD)" pos:[4,25] width:160 height:18
		button btn_DefCollision "3. 定义无碰撞物体(Col)" pos:[4,46] width:160 height:18
		button btn_chkeffect "4. 属性效果检查 (Check)" pos:[6,68] width:160 height:18
		on setMaterialProperty_btn pressed do
		(
			processeffect()
		)
		on setHUD_btn pressed do
		(
			try(destroyDialog HudRollout)catch()
			createdialog HudRollout
		)
		on btn_DefCollision pressed do
		(
			try(destroyDialog CollisionRollout)catch()
			createdialog CollisionRollout
		)
		on btn_chkeffect pressed do
		(
			checkEffectLod()
			checkEffectHud()
			messagebox "检查完毕,请查看问题文件夹"
		)
	)
	
	
	fn SPP_Tools  strinfo=
	(
		/*projPath = getProjectPath()
		cmdstr = "/C \""
		cmdstr += "cd /d " + projPath + "\\target "
		cmdstr += " & spp " + strinfo
		*/		
		cmd =getProjectPath()
		if cmd != "" do
		(
			--DOSCommand (cmd+" & sppbuild")
			cmdstr = "/C \""
			cmdstr += "cd /d " + cmd + "\\target "		
			cmdstr += " & spp " + strinfo
			ShellLaunch "cmd" cmdstr			
		)
	)

	--zhanghongru
	rollout exprot_meshtex "三.数据编辑" width:171 height:300
	(
		button export_btn "1.建筑中文" pos:[4,4] width:160 height:18
		button exportSequence_btn "2.摄像机路径导出 (Camera)" pos:[4,25] width:160 height:18
		button btn_mappos "3.小地图对位" pos:[7,45] width:158 height:18
		button btn_quick "4.快速定位(quick)" width:160 height:18
		button btn_role "5.人物初始位置数据导出(role)" width:160 height:18
		button btn_sand "6.沙盘数据导出(sand)" width:160 height:18
		button btn_copy "7.拷贝数据(copy)" width:160 height:18
		on btn_copy pressed do
		(
			fname=sceneName2

			arr_p =filterString maxfilepath "\\"			
			sceneName  ="D:\\p\\"+arr_p[3]+"\\src\\product\\position\\quick_position.xml"		
			sceneName2 ="D:\\p\\"+arr_p[3]+"\\src\\product\\position\\role.xml"
			sceneName3 ="D:\\p\\"+arr_p[3]+"\\src\\product\\position\\sand.xml"
			sceneName4 ="D:\\p\\"+arr_p[3]+"\\src\\product\\position\\sand_view.xml"
			
			allName = #(sceneName,sceneName2,sceneName3,sceneName4)
			for f in allname do 
			(
				if (getFiles f).count!=0 then deletefile f
			)
			
			a = 0
			b = 0
			c = 0
			d = 0
			
			if ((copyfile "D:\\spp_sdk\\tools\\edit2Position\\ui\\quick_position.xml" sceneName) ==false) then
			messagebox("“快速定位”操作失败！！！！")
			else
			a = 1
			if ((copyfile "D:\\spp_sdk\\tools\\editSand_RolePosition\ui\\role.xml" sceneName2) ==false) then
			messagebox("“人物初始位置数据导出”操作失败！！！！")
			else
			b = 1
			if ((copyfile "D:\\spp_sdk\\tools\\editSand_RolePosition\\ui\\sand.xml" sceneName3) ==false) then
			messagebox("“沙盘数据导出”操作失败！！！！")
			else
			c = 1
			if ((copyfile "D:\\spp_sdk\\tools\\editSand_RolePosition\\ui\\sand_view.xml" sceneName4) ==false) then
			messagebox("“沙盘数据导出”操作失败！！！！")
			else
			d = 1
			
			if(a == 1) then
				if(b == 1) then
					if(c == 1) then
						if(d == 1) then
			(
				messagebox("数据拷贝完毕")
			)
			
		)
		on export_btn pressed do
		(
			try(destroyDialog builder)catch()
			CreateDialog spp_sdk_position
		)
		on exportSequence_btn pressed do
		(
			export_camera_path()
		)
		on btn_mappos pressed  do
		(
			try(destroyDialog MapPosRollout)catch()
			CreateDialog MapPosRollout
		)
		on btn_quick pressed do	
		(
			opt = "--tools=edit2Position --debug --thread --meshgen --proj="
			opt = opt + getProjectPath()
			SPP_Tools opt
		)
		on btn_sand pressed do
		(
			SPP_Tools "--tools=editSand_RolePosition --debug --thread --meshgen"			
		)
		on btn_role pressed do
		(
			SPP_Tools "--tools=editSand_RolePosition --debug --thread --meshgen"			
		)
	)
	rollout WenAn_Tools "六.文案修改" width:171 height:300
	(
		button WenAn_Tools_btn "1.文案修改工具 (Modify)" pos:[4,4] width:160 height:18
		on WenAn_Tools open do
		(
			-- disable all button , except the top (reset) button.
			enableNextButton 0
		)
		on WenAn_Tools_btn pressed do
		(
			wa_toolset = newrolloutfloater "文案修改工具" 185 400
			addrollout  fixTexture wa_toolset
			addrollout  setMaterialProperty wa_toolset
			addrollout  exprot_meshtex wa_toolset
		)
	)
---########################################   输出标志性建筑物贴图名称    #########################################


---########################################   物体属性定义和导出    #########################################


	--bake()
---########################################   烘焙环节调节太阳位置信息及导出模块    #########################################
	--导出太阳位置信息
	/* fn expSunPosXml =
	(
		cp = checkpPath()
		srcdir = "\\src\\product\\position"
		outputPath=cp+srcdir
		makeDir outputPath
		fileN  = "\\sunposition.xml"
		filename = (outputPath + fileN )
		if (existFile filename) then 
			try(deletefile filename)catch()
		outFile = createFile filename
		varysun = getNodeByName "VRaySun01"
		select varysun
		format "<sunpos>\n" to:outFile
		format ("\t<xpos>"+ (varysun.pos.x) as string + "</xpos>\n") to:outFile
		format ("\t<ypos>"+ (varysun.pos.z) as string + "</ypos>\n") to:outFile
		format ("\t<zpos>"+ (varysun.pos.y) as string + "</zpos>\n") to:outFile
		format "</sunpos>" to:outFile
		
	)

	rollout RLLigthPos "调整太阳位置" width:161 height:195
	(
		button btn_lockSunPos "1.确定太阳位置" pos:[7,8] width:143 height:27
		button btn_view "预览" pos:[17,155] width:127 height:28
		GroupBox grp2 "摄像机位置定义窗口" pos:[8,38] width:145 height:152
		slider sld_distance "近              远" pos:[16,56] width:128 height:44 enabled:true range:[0,100,10]
		slider sld_height "低              高" pos:[16,103] width:128 height:44 enabled:true range:[0,100,10]
		local yvalue=0,zvalue=0
		local Suncapturecam
		local value=0
		--------------------------
		--get skybox radius
		fn skyradius =
		(
			local tmp = 0
			xyz =#(0, 0, 0)
			xyzmin = #(0, 0, 0)
			for i in geometry do
			(
				temp =#()
				temp=i.max
				tp=#()
				tp=i.min
				for n=1 to 3 do
				(	
					if(temp[n]>xyz[n]) do xyz[n]=temp[n]
					if(tp[n]<xyzmin[n]) do xyzmin[n]=tp[n]
				)
			)
			for i = 1 to 3 do
			(
				if(xyz[i] >tmp) do tmp =xyz[i]
				k = abs(xyzmin[i])
				if(k >tmp) do tmp = k
			)
			return tmp
		)
		--计算圆到实际场景中的比例关系 bili 
		fn bili pos pviot lengths =
		(
		   --计算差值长度,pos为小圆位置,lengths为圆半径
			local Linelen = pos - pviot
			local bili = (float)((float)linelen / (float)lengths)
			return (float)bili
		)
		--画vraysun到circle
		fn drawcircle =
		(
			local length = skyradius()
			--print length
			--get varysun pos,
			--circle
			ReginCircle = Circle radius:1000 pos:[10000,10000,0] isSelected:on name: "ReginCircle"
			suncircle = Circle radius:20 pos:[500,-500,0] isSelected:on name: "suncircle"
			
			select ReginCircle
			max zoomext sel all
			select suncircle
			--
			sunarry = getNodeByName "VRaySun01" all:true
			if(sunarry.count < 1) then
				messagebox "请进行烘焙准备工作"
			else
			(
				meshobj = sunarry[1]
				x = (meshobj.pos.x)
				y = (meshobj.pos.y)
				xpos = bili x 0 length
				ypos = bili y 0 length
				virx = xpos * 1000 + 10000
				viry = ypos * 1000 + 10000
				suncircle.pos = [virx, viry, 0]
			)
			max move
		)
		--得到vraysun的高度
		fn cptheight x y lengths =
		(
			local sqrd = lengths*lengths - (x * x + y * y)
			local lengths = sqrt sqrd
			lengths
		)
		--移动max场景中的vraysun
		fn moveVraySun =
		(
			sunarry = getNodeByName "suncircle" all:true
			local length = skyradius()
			if(sunarry.count < 1) then
				messagebox "请准备好烘焙环境"
			else
			(
				suncir = sunarry[1]		
				x = suncir.pos.x
				y = suncir.pos.y
				bianjieflag = (x - 10000) * (x - 10000) + (y - 10000) * (y - 10000)
				if( (sqrt bianjieflag) >1000) then
					messagebox "灯光位置超过大圆边界,请移到大圆内"
				else
				(
					xpos = bili x 10000 1000
					ypos = bili y 10000 1000
					factxpos = length * xpos
					factypos = length * ypos
					factzpos = cptheight factypos factxpos length
					anglevalue = (float)(factzpos / length)
					if( anglevalue< (sin 10) )then
						messagebox "灯光角度太低,请调大灯光高度"
					else
					(
						varysun = getNodeByName "VRaySun01"
						select varysun
						varysun.pos = [factxpos, factypos, factzpos]
					)
				)
			)
		)
		--开始准备工作环境
		on RLLigthPos open do
		(
			--设置viewport类型
			viewport.ResetAllViews()
			viewport.setLayout #layout_2v
			viewport.setGridVisibility #all false
			viewport.SetRenderLevel #wireFrame
			enableSceneRedraw()
			max zoomext sel all
			viewport.activeViewport = 1
			viewport.setType #view_top
			--画圆
			drawcircle()
			--右边
			viewport.activeViewport = 2
			value = skyradius()
			--设置摄像机
			Suncapturecam=Targetcamera fov:45 nearclip:1 farclip:value nearrange:0 farrange:value mpassEnabled:off mpassRenderPerPass:off pos:[0,(-1)*value,value*tan(30)] isSelected:on target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]))
			Suncapturecam.name = "locationcamera"
			viewport.setType #view_camera
			max vpt camera
			--
			sld_height.range=[1,89,0]
			sld_distance.range=[1,8*value,value]
			yvalue=(-1) * value
			sld_distance.value=value
			sld_height.value=30
			sld_distance.enabled=true
			sld_height.enabled=true
			local varysun = getNodeByName "suncircle" all:true
			select varysun[1]
		)
		on RLLigthPos close do
		(
			x = getNodeByName "ReginCircle" all:true
			select x
			max delete 
			y=getNodeByName "suncircle" all:true
			select y
			max delete 
			z=getNodeByName "locationcamera" all:true
			select z
			max delete 
			--还需要导出xml
			expSunPosXml()
		)
		on btn_lockSunPos pressed do
		(
			moveVraySun()
		)
		on btn_view pressed do
		(
			gc light:true
			viewport.activeViewport = 2
			render camera:$locationcamera outputwidth:1024 outputheight:800 vfb:on
		)
		on sld_distance changed val do
		(
			d=(-1)*sld_distance.value-yvalue
			if((Suncapturecam.position.y)!=0) do
				move Suncapturecam [0,d,(-1)*d*tan(sld_height.value)]
			yvalue=(-1)*sld_distance.value
		)
		on sld_height changed val do
		(
			d=sld_height.value
			zvalue=Suncapturecam.position.z
			move Suncapturecam[0,0,value*tan(sld_height.value)-zvalue]
		)
	) */
		
------------

	gj = newrolloutfloater "Superpolo Scene ToolSet" 185 670

	addrollout	version_rollout gj rolledUp:true
	addrollout  resetScn_tool gj
	addrollout  check_tool gj
	addrollout  model_tool gj
	addrollout	basebuilder gj
	addrollout	WenAn_Tools gj
-- 	addrollout  prop_tool gj

)