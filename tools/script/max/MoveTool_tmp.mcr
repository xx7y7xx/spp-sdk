macroScript MoveTool_tmp
category:"Superpolo"
ButtonText:"Scene MovieTool_tmp" 
tooltip:"MovieTool_tmp" Icon:#("Maxscript",15)
(

/* 
前提：
1.已经确认max路径为：   D:\p\（项目名称）\src\max
2.已经将物体区分在正确的layer里了 

操作：
0.clean scene（自动）
1.attach（自动） 
	1)by layer 
	2)ID by sameMat
	3)by hide
	4)down pivot
	5）resetxform
2.检查 normal是否反了（手动）
	1）by layer
	2）by hide
3.检查黑边
4.检查ID
	1）处理需要合并或者拆开的ID（手动）
	2）matID数量整理，名字整理
5.导出obj
	1）by layer
*/

--------------------------------------------------------------
	fn get_maxPath_Name = 
	(
		arr = #()
		maxP = maxfilepath
		maxN = maxfilename
		index = findstring maxN "."
		theName = substring maxN 1 (index-1)
		arr[1] = maxP
		arr[2] = theName
		arr 
	)	
	fn make_samePath_folder tarPath srcName=
	(
		
		p_arr = filterString tarPath "\\" 
		cnt = p_arr.count
		sameP = ""
		for i=1 to cnt-1 do
		(
			sameP += p_arr[i]+"\\"
			
		)
		sameP = sameP + srcName + "\\"
		makedir sameP
		sameP
	)
-- 	tarPath = maxfilepath
-- 	srcName = "diffuse"
-- 	make_samePath_folder tarPath srcName
	
	
	fn get_maxName = 
	(
		maxN = maxfilename
		index = findstring maxN "."
		theName = substring maxN 1 (index-1)
		theName
		
	)
--检查路径是否已保存在相应路径下
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
				if ( p_arr[idx] == "src") do
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
	
	
	
	--拷贝文件到制定目录下
	fn cpPicture existFile=
	(
-- 		messagebox (existFile as string)
		newPath = maxFilePath
		arr_N = filterString existFile "\\"
		tmpN = arr_N.count
		nName = arr_N[tmpN]
-- 		p_arr = filterString newPath "\\"
		maxPath = get_maxPath_Name()
		p = make_samePath_folder maxPath[1] "diffuse"
-- 		messagebox p
-- 		p = checkpPath() + "\\src\\"+p_arr[5]+"\\"+p_arr[6]+"\\diffuse\\"
		makeDir p
		newFile = p + nName
		copyFile existFile newFile
	)
	
	
	--将遍历到的贴图拷贝到diffuse文件夹下
	fn cpDiffuse = 
	(
		for i in objects do
		(
			select i
			i=$
			if classof i.mat == Multimaterial then
			(			
				for j=1 to i.mat.materialidlist.count do
				(			
					subMat = i.mat.materiallist[j]				
					if classof subMat == VRayMtl then
					(	
						try(
							if subMat.diffusemap != undefined then
							(
								if classof subMat.diffusemap == falloff then 
								(
									try(cpPicture subMat.diffusemap.map1.filename)catch()
									try(cpPicture subMat.diffusemap.map2.filename)catch()
								)
								else
								(
									try(cpPicture subMat.diffusemap.filename)catch()
								)
							)
						)catch()
					)
					
					if classof subMat == blend then
					(
						try(cpPicture submat.mask.filename)catch()
						try(cpPicture submat.map1.diffusemap.filename)catch()
						try(cpPicture submat.map2.diffusemap.filename)catch()					
					)
					if classof subMat == Standardmaterial then
					(
						if classof subMat.diffusemap == falloff then 
						(
							try(cpPicture subMat.diffusemap.map1.filename)catch()
							try(cpPicture subMat.diffusemap.map2.filename)catch()
						)
						else
						(
							try(cpPicture subMat.diffusemap.filename)catch()
						)
					)				
				)			
			)
			else if classof i.mat == Standardmaterial then 
			(
				subMat = i.mat
				if classof subMat.diffusemap == falloff then
				(
					try(cpPicture subMat.diffusemap.map1.filename)catch()
					try(cpPicture subMat.diffusemap.map2.filename)catch()
				)
				else
				(
					try(cpPicture subMat.diffusemap.filename)catch()
				)
			)
			
		)
	)
	
	
	--为合并后的物体材质重命名
	fn rename_Mat =(
		arr_id = #() 
		arr_name = #()
		for i in geometry do 
		(
			select i
			print (i as string)
			if (classof $.material == Multimaterial) then
			(
				arr_id =$.material.materialIDList
				arr_name =$.material.materialList
				index = arr_id.count
				for j=1 to index do
				(
					arr_name[j].name = "m"+ "1"
				)
			)
			else
			(
				arr_id = 1
				arr_name = $.material.name
				arr_name = "m"+ "1"
			)				
		)
	)
fn chksubMat =
(
	--判断子材质的类型是不是blend
	myIncrement = 0
	maxPath = get_maxPath_Name()
	p = make_samePath_folder maxPath[1] "diffuse"
	for j in objects do
	(
		if (selection.count!=1) then 
		(
			messagebox ("请选择单个模型")
			return false
		)	
		if (classof $.mat ==Multimaterial) then
		(			
			matNum = $.mat.materialidlist.count
			for i=1 to matNum do
			(
				tt = Standardmaterial()
				if classof $.mat.materiallist[i] == blend then
				(
-- 					messagebox ((i as string)+":是blend")
					--有mask
-- 					if($.mat.materiallist[1].mask !=  undefined)then
					try
					(
						pfile =$.mat.materiallist[i].mask.filename
						--判断得到的mask地址下是否存在相应贴图
						if (doesfileexist pfile) then
						(
							tt.diffusemap = Bitmaptexture filename:pfile
						)
						else
						--相当于没有mask
						(	
							--判断map1
							if ($.mat.materiallist[i].map1.texmap_diffuse != undefined ) then 
							(
								txtFlag = false
								--如果map1的贴图是falloff
								if (classof($.mat.materiallist[i].map1.texmap_diffuse)== Falloff)then
								(
										try(pfile = $.mat.materiallist[i].map1.texmap_diffuse.map1.filename)catch()--messagebox (i as string)+":falloff1,无贴图")
										try(pfile2 = $.mat.materiallist[i].map1.texmap_diffuse.map2.filename)catch()--messagebox (i as string)+":falloff1,无贴图")
										if (doesfileexist pfile) then
										(
											tt.diffusemap = Bitmaptexture filename:pfile
										)
										else if (doesfileexist pfile2) then
										(
											tt.diffusemap =Bitmaptexture filename:pfile2
										)
										else(txtFlag =true)
								)
								--如果贴图不是falloff
								else
								(
									pfile = $.mat.materiallist[i].map1.texmap_diffuse.filename
									pfile2 = $.mat.materiallist[i].map2.texmap_diffuse.filename
									if (doesfileexist pfile) then
									(
										tt.diffusemap = Bitmaptexture filename:pfile
									)
									else if(doesfileexist pfile) then
									(
										tt.diffusemap = Bitmaptexture filename:pfile2
									)
									else (txtFlag =true)
								)
								if txtFlag == true then 
								(
									if ($.mat.materiallist[i].map2.texmap_diffuse != undefined ) then 
									(
										--如果贴图是falloff,判断falloff的map2是否存在
										if (classof($.mat.materiallist[i].map2.texmap_diffuse)== Falloff)then
										(
												pfile = $.mat.materiallist[i].map2.texmap_diffuse.map1.filename
												pfile2 = $.mat.materiallist[i].map2.texmap_diffuse.map2.filename
												if (doesfileexist pfile) then
												(
													tt.diffusemap = Bitmaptexture filename:pfile
												)
												else if (doesfileexist pfile2) then
												(
													tt.diffusemap =Bitmaptexture filename:pfile2
												)
												else
												(
													/* messagebox ((i as string) +":当前材质类型:blend. mask有路径无贴图. map2(falloff)有路径无贴图")
													messagebox("todo...(添加色块)") 
													myIncrement += 1
													pfile = (p + "tex" + myIncrement as string + getFilenameType texmap)
													copyfile texmap (pfile)
													tt.diffusemap = Bitmaptexture filename:pfile
													messagebox ("添加成功") */
												)
										)
										--如果贴图不是falloff
										else
										(
											try(pfile = $.mat.materiallist[i].map1.texmap_diffuse.filename)catch()--messagebox (i as string)+":map1,无贴图")
											try(pfile2 = $.mat.materiallist[i].map2.texmap_diffuse.filename)catch()--messagebox (i as string)+":map2,无贴图")
											if (doesfileexist pfile) then
											(
												tt.diffusemap = Bitmaptexture filename:pfile
											)
											else if(doesfileexist pfile) then
											(
												tt.diffusemap = Bitmaptexture filename:pfile2
											)
											else(
												/* messagebox ((i as string) +":当前材质类型:blend. mask有路径无贴图. map2有路径无贴图")
												messagebox ("todo...(添加色块)") */
												myIncrement += 1
												cl =$.mat[i].map1.diffuse
												myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
												texfile =  (p + "tex" + myIncrement as string + ".jpg")
												myBitmap.filename = texfile
												save myBitmap
												tt.diffusemap = Bitmaptexture filename:texfile
-- 												messagebox ("有mask,有路径，无贴图，添加色块")
											)
										)
									)
									else
									(
-- 										messagebox ((i as string) +":当前材质类型:blend. mask有路径无贴图. map2无贴图")
-- 										messagebox ("todo...(添加色块)")\
										myIncrement += 1
										cl =$.mat[i].map1.diffuse
										myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
										texfile =  (p + "tex" + myIncrement as string + ".jpg")
										myBitmap.filename = texfile
										save myBitmap
										tt.diffusemap = Bitmaptexture filename:texfile
									)
								)
							)
							
						)
					)
					--没有mask
-- 					else if($.mat.materiallist[i].mask == undefined ) then
					catch
					(	
-- 						messagebox ("没有mask")
						if ($.mat.materiallist[i].map1.texmap_diffuse != undefined ) then 
						(
							txtFlag == false
							--如果贴图是falloff
							if (classof($.mat.materiallist[i].map1.texmap_diffuse)== Falloff)then
							(
								pfile = $.mat.materiallist[i].map1.texmap_diffuse.map1.filename
								pfile2 = $.mat.materiallist[i].map1.texmap_diffuse.map2.filename
								if (doesfileexist pfile) then
								(
									tt.diffusemap = Bitmaptexture filename:pfile
								)
								else if (doesfileexist pfile2) then
								(
									tt.diffusemap =Bitmaptexture filename:pfile2
								)
								else(txtFlag=true)
							)
							--如果贴图不是falloff
							else
							(
								try(pfile = $.mat.materiallist[i].map1.texmap_diffuse.filename)catch()
								try(pfile2 = $.mat.materiallist[i].map2.texmap_diffuse.filename)catch()
								if (doesfileexist pfile) then
								(
									tt.diffusemap = Bitmaptexture filename:pfile
								)
								else if(doesfileexist pfile) then
								(
									tt.diffusemap = Bitmaptexture filename:pfile2
								)
								else(txtFlag=true)
							)
						)
							
						if flag == true then
						(								
							if ($.mat.materiallist[i].map2.texmap_diffuse != undefined ) then 
							(
								--如果贴图是falloff
								if (classof($.mat.materiallist[i].map2.texmap_diffuse)== Falloff)then
								(
									pfile = $.mat.materiallist[i].map2.texmap_diffuse.map1.filename
									pfile2 = $.mat.materiallist[i].map2.texmap_diffuse.map2.filename
									if (doesfileexist pfile) then
									(
										tt.diffusemap = Bitmaptexture filename:pfile
									)
									else if (doesfileexist pfile2) then
									(
										tt.diffusemap =Bitmaptexture filename:pfile2
									)
									else
									(
-- 										messagebox ((i as string) +":当前材质类型:blend. 没有mask. map2(falloff)有路径无贴图")
-- 										messagebox ("todo...(添加色块)")
									)
								)
								--如果贴图不是falloff
								else
								(
									pfile = $.mat.materiallist[i].map1.texmap_diffuse.filename
									pfile2 = $.mat.materiallist[i].map2.texmap_diffuse.filename
									if (doesfileexist pfile) then
									(
										tt.diffusemap = Bitmaptexture filename:pfile
									)
									else if(doesfileexist pfile) then
									(
										tt.diffusemap = Bitmaptexture filename:pfile2
									)
									else(
-- 										messagebox ((i as string) +":当前材质类型:blend. 没有mask. map2有路径无贴图")
-- 										messagebox ("todo...(添加色块)")
									)
								)
							)
						)
					)
				)
				else if(classof $.mat.materiallist[i]== Standard)then
				(
-- 					messagebox ((i as string)+":是standard")
					if($.mat.materiallist[i].diffusemap!=undefined)then
					(
						if(classof $.mat.materiallist[i].diffusemap == Bitmaptexture) then
						(
							pfile = $.mat.materiallist[i].diffusemap.filename
							if (doesfileexist pfile) then
							(
								tt.diffusemap = Bitmaptexture filename:pfile
							)
							else 
							(
-- 								messagebox (i as string)
-- 								messagebox ("todo...(添加色块)")
								myIncrement += 1
								cl =$.mat[i].diffuse
								myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
								texfile =  (p + "tex" + myIncrement as string + ".jpg")
								myBitmap.filename = texfile
								save myBitmap
								tt.diffusemap = Bitmaptexture filename: texfile
-- 								messagebox ("有路径,无贴图，生成色块")
								)
						)
						else if(classof $.mat.materiallist[i].diffusemap == falloff) then
						(
							try(
								pfile = $.mat.materiallist[i].diffusemap.map1.filename)catch(--messagebox (i as string +":贴图falloff1中没有贴图")
							)
							try(pfile2 = $.mat.materiallist[i].diffusemap.map2.filename)catch(--messagebox (i as string +":贴图falloff2中没有贴图")
							)
							if (doesfileexist pfile) then
							(
								tt.diffusemap = Bitmaptexture filename:pfile
							)
							else if (doesfileexist pfile2) then
							(
								tt.diffusemap =Bitmaptexture filename:pfile2
							)
							else(
-- 								messagebox (i as string)
-- 								messagebox ("todo...(添加色块)")
								myIncrement += 1
								cl =$.mat[i].diffuse
								myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
								texfile =  (p + "tex" + myIncrement as string + ".jpg")
								myBitmap.filename = texfile
								save myBitmap
								tt.diffusemap = Bitmaptexture filename: texfile
-- 								messagebox ("无贴图，生成色块")
							)
						)
					)
					else 
					(
						myIncrement += 1
						cl =$.mat[i].diffuse
						myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
						texfile =  (p + "tex" + myIncrement as string + ".jpg")
						myBitmap.filename = texfile
						save myBitmap
						tt.diffusemap = Bitmaptexture filename: texfile
-- 						messagebox ("无贴图，生成色块")
					)
				)
				else if(classof $.mat.materiallist[i]== vraymtl) then
				(
-- 					messagebox ((i as string)+":是vraymtl")
					try(
						if (classof $.material[i].diffusemap ==bitmaptexture)then
						(
							pfile = $.mat.materiallist[i].diffusemap.filename
							if (doesfileexist pfile) then(tt.diffusemap = bitmaptexture filename:pfile)
							else 
							(
								myIncrement += 1
								cl =$.mat[i].diffuse
								myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
								texfile =  (p + "tex" + myIncrement as string + ".jpg")
								myBitmap.filename = texfile
								save myBitmap
								tt.diffusemap = Bitmaptexture filename: texfile
-- 								messagebox ("vray,有路径无贴图,生成色块")
							)
						)
					)
					catch
					(
-- 						messagebox ((i as string)+":vraymtl没有材质贴图")
						myIncrement += 1
						cl =$.mat[i].diffuse
						myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
						texfile =  (p + "tex" + myIncrement as string + ".jpg")
						myBitmap.filename = texfile
						save myBitmap
						tt.diffusemap = Bitmaptexture filename: texfile
-- 						messagebox ("无贴图，生成色块")
					)
					
				)
				else
				(
					--messagebox ((i as string)+":是非指定类型材质")
					return false
				)
				$.material[i] = tt
				showTextureMap $.material[i] true
			)
			
		)
		else if(classof $.mat == Standardmaterial) then
		(
			tt = Standardmaterial()
			try(pfile = $.mat.diffusemap.filename)catch()
			if (doesfileexist pfile) then(tt.diffusemap = bitmaptexture filename:pfile)
			else 
			(
				myIncrement += 1
				cl =$.mat.diffuse
				myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
				texfile =  (p + "tex" + myIncrement as string + ".jpg")
				myBitmap.filename = texfile
				save myBitmap
				tt.diffusemap = Bitmaptexture filename: texfile
-- 								messagebox ("vray,有路径无贴图,生成色块")
			)
			$.material = tt
			showTextureMap $.material true
		)				
	)
	rename_Mat()
)

---------------------------------------------------------------
fn reset_layout = 
(
	
	-- layout
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
	max tool maximize
)

	fn get_arr theClass =
	(
		/* 
			1: object
			2: geometry
			3: selection
			4: poly
			5: mesh
		*/
		arr = #()
		case theClass of 
		(
			1: arr = for i in objects collect i
			2: arr = for i in geometry collect i
			3: arr = for i in selection collect i
			4:
			(
				for i in objects do
				(
					if (classof i)  == Editable_Poly do
					(
						append arr i
					)
				)					
			)
			5:
			(
				for i in objects do
				(
					if (classof i)  == Editable_Mesh do
					(
						append arr i
					)
				)					
			)
			default:arr = #()
		)	
		arr
	)		
-- 	get_arr 1
	
	fn scene_clean = 
	(
		heapSize += 2000000
	-- scene clean

	-------------------------------------- 清理环境
	-- delete  sort

	--------------------- delete
	-- light camera
	-- Particle_View
	--------------------- ungroup
	-- ungroup
	--------------------- convert to poly
	-- ChamferCyl
	-- Circle
	-- SplineShape
	--------------------- delete
	-- non poly count object 
	--------------------- delete
	-- dummy
	---------------------------------------
	pv = #()
	group_arr = #()
	nonface_arr = #() 
	dummy_arr = #()
		objs = for i in objects collect i
		unhide objs doLayer:true 
	clearlistener()
	for i in objects do
	(
		co = classof i 

	-- 	format "%\n" i.name
	-- 	format "%\n" co
	-- 	format "%\n\n\n" pc
		
		-- Particle_View
		if co == Particle_View do
		(
			append pv i 	
		)
	)

	------------------------------------------- light camera Particle_View
	undo off
	(
	delete cameras
	delete lights
	delete pv
	)

	gc light:false delayed:false


	------------------------------------------- ungroup all 

	for i in objects do
	(
		co = classof i 
		gh = isGroupHead i 
		if gh == true do
		(
			append group_arr i
		)
		
	)
	for i in group_arr do
	(
		ungroup i
		
	)
	gc light:false delayed:false
	-------------------------------------------- convert to poly
	for i in objects do
	(
		undo off
		(
		converttopoly i
		resetxform i
		converttopoly i
		)
		
	)
	gc light:false delayed:false
	-------------------------------------------- delete non poly count object 
	for i in objects do
	(
		pc = getPolygonCount i
		faceN = pc[1]	
		if faceN == 0 do
		(
			append nonface_arr i
		)
	)
	undo off
	(
	delete nonface_arr
	)
	gc light:false delayed:false
	-------------------------------------------- delete dummy
	for i in objects do
	(
		co = classof i
		if co == dummy do
		(
			append dummy_arr i 	
		)
		
	)
	undo off
	(
	delete dummy_arr
	)
	gc light:false delayed:false
	all_obj = for i in objects collect i
	all_obj.count
	)	
	
	
	fn down_pivot arr =
	(
		o = arr
		if o.count != 0 then
		(
			for i = 1 to o.count do
			(
				undo off
				(
					ResetXForm o[i]
					convertToPoly o[i]
					max modify mode
					
					bb = nodeLocalBoundingBox o[i]
					cen = (bb[1]+bb[2])/2
					o[i].pivot = [cen.x,cen.y,bb[1].z]
					
					ResetXForm o[i]
					convertToPoly o[i]
					max modify mode
				)
			)
		)
	)
	

	fn DelVrayMesh expflag delflag=
	(
		errText = ""
		errMesh = #()
		for i in geometry do
		(
			classofi = classof i
			if classofi == VRayFur then
			(
				tmpstr = "模型名:" + i.name + " 类型为:"+ (classofi as string) + "\n"
				errText += tmpstr
				--delete i
				append errMesh i
			)
		)
		if errText == "" then
		(
			return errMesh
		)
		if(delflag) then
		(
			clearSelection()
			select errMesh
			max delete
			clearSelection()
		)
		if(expflag)then
		(	
			wtpath = checkpPath()
			wtpath = wtpath  + "\\plan\\问题"
			filename = wtpath +  "\\B10——场景里存在微软x文件不支持的工具对象，需要清除.txt"
			existFile = (getfiles filename).count != 0
			if existFile then try(deletefile filename)catch()
			outFile = createFile filename	
			format "场景里存在微软x文件不支持的对象有:\n\n" to:outFile
			format "%\n" errText to:outFile
			close outFile
		)
		errMesh
	)

	fn setMeshProperty = 
	(
		max backface
		for i in objects do
		(
			select i
			$.showFrozenInGray = false
		)
	)
	
	fn showMatInV = 
	(
		for i in geometry do
		(
			select i
			if classof i.mat == Standardmaterial then
			(
				showTextureMap i.material true
			)
		)
	)
	
	
	fn attach_geo arr =
	(
		-- attach
		num = arr.count-1
		for i=1 to num do
		(
			undo off
			(
				arr[1].attach arr[2] arr[1]
				deleteitem arr 2
			)
		)
	)

	fn layerContent =
	(
		layers_arr =#()
		-- layers_arr[1]:  layerName
		-- layers_arr[2]:  meshes
		for i = 0 to layerManager.count-1 do
		(
			l_arr = #()
			append layers_arr l_arr
			ilayer = layerManager.getLayer i
			layerName = ilayer.name
			l_arr[1] = layerName
			layer = ILayerManager.getLayerObject i
			layerNodes = refs.dependents layer

			layer.nodes &theNodes
			l_arr[2] = theNodes
			layers_arr[i+1] = l_arr
		)
	/* 	-------------------------------print
		clearlistener()
		for i in layers_arr do
		(
			-- layer
			format"LAYER: % \n" i[1] 
			
			-- mesh
			meshes = i[2]
			m_cnt = i[2].count
			format"MESH: %\n" m_cnt
			for j in meshes do
			(
				format"\t% \n" j
			)
			format"\n\n"

		)
		------------------------------- */
		
		layers_arr

	)
	

	
	fn export theType tarPath objName selected =
	(
		
		makeDir tarPath 				
		filename = tarPath + objName + "." + theType
		sel = selected 
		exportfile filename #noPrompt selectedOnly: sel
	)
	fn setunit =
	(
			units.SystemType = #millimeters
			
			units.DisplayType =  #Metric
			units.MetricType = #Millimeters
	)

	
	
	
	
	----------------------------------------------------------------------
	fn unfreeze_layer = 
	(
		 l = layerContent()
		cnt = l.count
		for i=1 to cnt do
		(
			if l[i][2].count > 0 do
			(
			unfreeze  l[i][2] doLayer: true
			)
		)
		
		
		
		
	)
-- 	unfreeze_layer()
	
	fn attach_by_layer = 
	(
		 l = layerContent()
		cnt = l.count
		for i=1 to cnt do
		(
			select l[i][2]
			the_arr = for i in selection collect i
			for j in the_arr do
			(
				undo off
				(
					converttopoly j
				)
			)
			attach_geo the_arr
			
			down_pivot the_arr
		)
	)
	
	fn rename_layer = 
	(
		for i = 1 to layerManager.count-1 do
		(
			ilayer = layerManager.getLayer i
			ilayer.setname (i as string)
		)
	)
	
	
	-- export
	
	fn export_by_layer = 
	(
		maxPath = get_maxPath_Name()
		export_path = make_samePath_folder maxPath[1] "obj"
		
		 l = layerContent()
		cnt = l.count
		for i=1 to cnt do
		(
			select l[i][2]
			the_arr = for i in selection collect i
			for j in the_arr do
			(
				undo off
				(
					if l[i][2].count > 0 do
					(
						export "obj" export_path l[i][1] true
					)
				)
			)
			
		)
		messagebox ("物体导出成功！")
	)
	
	
		fn checkMeshSingle =
	(		
		try ($.baseobject) catch 
		(
			messagebox "没有选中模型" 
			return false
		)
		if (($.baseobject)!=Editable_Poly) then converttopoly $
		local face_selection = #{}
		local base_obj = $.baseobject
		local num_faces = polyop.getNumFaces base_obj
		local flag = true
		for f = 1 to num_faces do
		(
			local num_face_verts = polyop.getFaceDeg base_obj f
			if num_face_verts > 4 do face_selection[f] = true
			if num_face_verts > 4 then flag = false
		)--end f loop
		polyop.setFaceSelection base_obj face_selection
		max modify mode
		modPanel.setCurrentObject base_obj
		subobjectlevel = 4		
		if selection[1]== undefined then 
		(
			messagebox ("请先选中一个物体")
			return false
		)
		obj = selection[1]
		converttomesh obj
		subObjectLevel = 3
		obj = selection[1] --get selected object
		faceSel = getFaceSelection obj
		edgeSel = meshop.getEdgesUsingFace obj faceSel
		setEdgeSelection obj edgeSel --select the edges
		update obj --update the mesh
		subObjectLevel = 2
-- 		meshOps.visibleEdge obj
-- 		converttopoly obj
		meshOps.startTurn obj
		if flag == true then 
		(
			max modify mode
			modPanel.setCurrentObject base_obj
			subobjectlevel = 0
			messagebox ("此物体已没有大于四边的面")
		)
	)
	
	--*******************************************
  --返回贴图,有可能是falloff或bitmap等
	fn dealmatex tex =
	(
		local texfile;
		case classof tex of
		(
			Falloff:
			(
				texfile = dealmatex tex.map1
				if texfile != false then 
					return texfile
				else 
				(
					return dealmatex tex.map2
				)
			)
			Bitmaptexture:
			(
				texfile = tex.filename
				if (doesfileexist texfile) then
					return texfile
				else
					return false
			)
			UndefinedClass: return false
			default:
			(
				--print ((classof tex) as string + "此贴图类型没有处理,请联系开发人员")
				return false
			)
		)
	)
	--返回material diffuse color
	fn retmatColor mat =
	(
		case classof mat of
		(
			Blend: retmatColor mat.map1
			VRayMtlWrapper: retmatColor mat.BaseMtl
			VRayLightMtl:	
			(	
				return mat.color
			)
			UndefinedClass: return (color 128 128 128)
			default:
				return  mat.diffuse
		)
	)
	--返回material是否有贴图,若无返回fasle
	fn retmatTex mat =
	(
		local texfile;
		case classof mat of
		(
			Blend: 
			(
				if mat.mask != undefined then
				(
					texfile = dealmatex mat.mask
				)
				if texfile != false then
					return texfile
				texfile = retmatTex mat.map1
				if texfile != false then
					return texfile
				texfile = retmatTex mat.map2
				if texfile != false then
					return texfile
				return false
			)
			VRayMtlWrapper: retmatTex mat.BaseMtl
			UndefinedClass: return false
			default:
				try(
					return  dealmatex mat.diffusemap
				)catch(return false)
		)
	)
	
	fn dealv2s obj objmat arrIncrement p arrTexNum arrTexInfo= 
	(
		local tt;
		tt = Standardmaterial ()
		testflag = false
		local texfile
		texfile = retmatTex objmat
		if texfile != false then
		(
			arrIncrement[1] += 1
			local pfile = (p + "tex" + arrIncrement[1] as string + getFilenameType texfile)
			copyfile texfile (pfile)
			tt.diffusemap = Bitmaptexture filename:pfile
		)
		else
		(
			local cl
			cl = retmatColor objmat
			local strname = cl.r as string + cl.g as string  + cl.b as string
			local idx = finditem arrTexNum strname
			local texfiles = ""
			if idx != 0 then 
				texfiles = arrTexInfo[idx]
			else
			(
				arrIncrement[1] += 1
				myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
				texfiles =  (p + "tex" + arrIncrement[1] as string + ".jpg")
				append arrTexInfo texfiles
				append arrTexNum strname
				myBitmap.filename = texfiles
				save myBitmap
				--
			)
			tt.diffusemap = Bitmaptexture filename: texfiles
		)
		return tt
	)

	fn v2s =
	(
		local arrTexInfo = #()
		local arrTexNum = #()
		local arrIncrement = #(0)
		local maxPath = get_maxPath_Name()
		local p = make_samePath_folder maxPath[1] "diffuse"
		--p = "D:\\p\\aaaaa\\src\\diffuse\\"
		--makeDir p
		for o in geometry do 
		(
			if classof o.material == Multimaterial then 
			(
				for m = 1 to o.material.numsubs do
				(
					local omat = o.material[m]
					o.material [m] = dealv2s o omat arrIncrement p arrTexNum arrTexInfo
				)
			)
			else
			(	
				local omat = o.material
				o.material = dealv2s o omat arrIncrement p arrTexNum arrTexInfo
			)
			
		)
		actionMan.executeAction 0 "40807"
	)

		
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
					--submatnum = getNumSubMtls mat
					submatnum = mat.materiallist.count
					
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
	
--*******************************************	
	----------------------------------------------------------------------
--------------------------------------------------------------------------rollout（new）start
	rollout MEdgeRollout "黑边处理工具" width:150 height:98
	(
		button btn_deal "处理黑边" pos:[8,68] width:137 height:23
		GroupBox grp1 "处理方式:" pos:[3,7] width:144 height:57
		radiobuttons rdb_kinds "" pos:[9,29] width:121 height:40 enabled:true labels:#("按选择模型  ", "按全部(geometry)处理")
		local arrMesh = #()
		local state = ""
		fn updateButton = (
			case rdb_kinds.state of (
			1: state = "selection "
			2: state = "all "
			)
		)--end fn


		
		fn addedges iobj=
		(
			--iobj = selection[1]
			--convertToPoly
			--convertto iobj editable_poly
			--setFaceSelection 
			select iobj
			--convertToPoly(iobj)
			macros.run "Modifier Stack" "Convert_to_Poly"
			subobjectLevel = 2
			--update iobj
			aryedge = #{}
			for iedge in iobj.edges do
			(
				try(
					--print (iedge.index)
					aiFaces = #()
					--print (aiFaces)
					--<mesh>.selectedFaces = (<array> | <bitarray>)
					aiFaces = polyOp.getEdgeFaces (iobj) (iedge.index)
					ltmpface = iobj.faces[aiFaces[1]]
					rtmpface = iobj.faces[aiFaces[2]]
					ltmpnor =  (polyop.getFaceNormal iobj ltmpface.index)
					rtmpnor =  (polyop.getFaceNormal iobj rtmpface.index)
					norangle = acos (dot ltmpnor rtmpnor)
					--polyop.getFaceEdges <Poly poly> <int face>
					--print (norangle)		
					if (0<norangle and norangle < 180) then
					(
						--append aryedge  (iedge.index)
						tmpary = #()
						tmpary = polyop.getFaceEdges iobj (ltmpface.index)
						for i in tmpary do appendIfUnique  aryedge	i
						tmpary = polyop.getFaceEdges iobj (rtmpface.index)
						for i in tmpary do appendIfUnique  aryedge	i
					)	
				)catch()
			)
			iobj.edgeChamfer = 0.001
			iobj.edgeChamferSegments = 3
			iobj.EditablePoly.SetSelection #Edge aryedge
			iobj.EditablePoly.buttonOp #Chamfer
			--subobjectLevel = 1
			convertToMesh iobj
			update iobj
		)

		on MEdgeRollout open do
		(	
			state = "selection "
			)
		on btn_deal pressed do
		(
			if state == "selection " then
			(
				if(selection.count < 1)then messagebox "没有选择模型"
				else	arrMesh = selection as array	
			)
			else
			(
				if(geometry.count < 1)then messagebox "场景中没有模型"
				arrMesh = geometry as array
			)
			if( arrMesh.count > 0) then
			(
				for i in arrMesh do 
				(
					--print i.name
					addedges i
				)
				messagebox "处理完成"
			)
		)
		on rdb_kinds changed stat do
		(
			updateButton()
		)
	)
	
	rollout detail_face "处理显示大于四边形的面" width:169 height:60
	(
		button btn_doModify "1.显示大于四边形的面" pos:[3,7] width:157 height:20
		button btn_modifyN "2.修改四边形" pos:[3,29] width:157 height:19
		
		on btn_doModify pressed do
		(
			checkMeshSingle()	
		)
		on btn_modifyN pressed do
		(
			if selection[1]== undefined then 
			(
				messagebox ("请先选中一个物体")
				return false
			)
			obj = selection[1]
			converttomesh obj
			subObjectLevel = 3
			obj = selection[1] --get selected object
			faceSel = getFaceSelection obj
			edgeSel = meshop.getEdgesUsingFace obj faceSel
			setEdgeSelection obj edgeSel --select the edges
			update obj --update the mesh
			subObjectLevel = 2
			meshOps.visibleEdge obj
			converttopoly obj	
		)
	)
	
	rollout check_modify "修改黑边" width:159 height:176
	(
		button btn_addModifier "2.曲面物体细分" pos:[12,50] width:128 height:26		
		button btn_medges "4.自动导角 " pos:[12,130] width:128 height:26
		button btn_checkFace "1.检查大于四边形的面 " pos:[12,13] width:128 height:26
		label lbl1 "3.按照流程指引进行端线的添加" pos:[13,89] width:127 height:30
		
		on btn_addModifier pressed do
		(
			if selection[1]== undefined then 
			(
				messagebox("当前没有选中任何物体！")
				return false
			)
			if selection.count >1 then
			(
				messagebox("选中物体数量过多，请选择单个物体操作!")
				return false
			)
			obj=selection[1]
			addModifier obj (turbosmooth())
				
			converttopoly obj
		)
		on btn_medges pressed do
		(
			try(destroydialog MEdgeRollout)catch()
			createdialog MEdgeRollout
		)
		on btn_checkFace pressed do
		(
			try(destroydialog detail_face)catch()
			createdialog detail_face
		)
	)
	
	
rollout qiantiRollout "前提" width:162 height:300
(
	label lbl1 "1.已经确认max路径为：   D:\p\（项目名称）\src\max" pos:[7,13] width:148 height:60
	label lbl2 "2.已经将物体区分在正确的layer里了" pos:[7,55] width:149 height:37
	label lbl4 "3.把所有贴图全放在一个文件夹并指认好路径" pos:[7,95] width:135 height:46
)

rollout caozuoRollout "操作" width:162 height:362
(
	button cleanScenebtn "清理场景" pos:[14,14] width:130 height:30
	button btn_check_modify "处理黑边--->" pos:[14,45] width:130 height:30 
	button attachbtn2 "attach by layer" pos:[14,76] width:130 height:30
	label lbl3 "检查 normal是否反了（手动）" pos:[14,117] width:127 height:34
	
	button btn_choicemat "1.选择相同的材质" pos:[14,185] width:130 height:30
	button btn_unifyID "2.统一ID" pos:[14,215] width:130 height:30 
	button btn_ClsMat "3.材质整理及清理" pos:[14,245] width:130 height:30
	button btn_chkmatid "4.材质ID检查" pos:[14,275] width:92 height:30
	spinner spn_matid "" pos:[138,283] width:10 height:16 range:[-10,10,0] type:#integer scale:0.1
	edittext edt_matid "" pos:[107,280] width:27 height:19 enabled:false
	GroupBox idgrp1 "定义ID" pos:[7,158] width:145 height:158
	button exp_obj_btn1 "exprt obj by layer" pos:[14,323] width:130 height:30
	
			fn chuli obj flag =
		(

			arrid = obj.mat.materialIDList as array
			tmp  =  (getFaceSelection obj) as array 
			local idx
			if tmp.count > 0 then
			(
				currdid = polyop.getFaceMatID obj tmp[1]
				idx = finditem arrid currdid
			)
			else
			(
				fidx = finditem arrid spn_matid.value
				if fidx == 0 then
				(
					idx = -100
				)
				else idx = fidx
			)
			print idx
			print flag
			
			idx = idx + flag
			if idx < 0 then idx = 1
			else if idx == 0 then idx = arrid.count 
			else if idx > arrid.count then idx = 1	
			
			spn_matid.value = arrid[idx]
			obj.EditablePoly.selectByMaterial arrid[idx]
			edt_matid.text = arrid[idx] as string
			newsel  =  (getFaceSelection obj) as array 
			if(newsel.count < 1 )then messagebox "模型没有使用此材质,请进行材质整理"
			
		)

	on cleanScenebtn pressed do
	(
		setunit()
		reset_layout()
		unfreeze_layer()
		scene_clean()
	)
	on btn_check_modify pressed do
	(
		createDialog check_modify 150 176
	)
	on attachbtn2 pressed do
	(
		attach_by_layer()
		setMeshProperty()
		rename_layer()
-- 		messagebox ("开始考配贴图")
 		--cpDiffuse()
-- 		messagebox ("整理材质")
		--chksubMat()
		v2s()
		rename_materials()
		
		
	/* 		----------------------------
		tarP = maxfilepath
		srcN = "diffuse"
		difPath = make_samePath_folder tarP srcN
		diff_arr = getFiles difPath
		
	-- 		if (arr.count != 0)
	-- 		then 
	-- 		(
	-- 			messagebox ("已经执行过")
	-- 			return false
	-- 		)
	-- 		else
	-- 		(
			v2s()
			showMatInV()	
	-- 		)
		
		------------------------------
		for i in geometry do 
		(
			ResetXForm i
			converttopoly i
		)
		
		DelVrayMesh false true  --DelVrayMesh expflag delflag
		
		--------------------------- deleting missing maps
		print "Deleting missed maps:"
		for i in scenematerials do
		(
			delete_missed_maps i
		)
		 */
		messagebox"处理完成，请进入下一环节！"
	)
	on btn_choicemat pressed do
	(
		if selection[1]== undefined then return false
		max modify mode 
		subObjectLevel = 5 
	-- 			clearSelection()
		$.EditablePoly.SetSelection #Face #{}			
	)
	on btn_unifyID pressed do
	(
		if selection[1]==undefined then (return false)
		arr_id = #()
		arr_N = 0  --合并后的id
		arr_difMap =#() --存储合并后每个id贴图
		arr_ndifMap = #()
		--faceN = polyop.getNumFaces $
		face_sel =$.EditablePoly.getselection #face		
		for i in face_sel do
		(
			try(
				id = polyop.getFaceMatID $ i
				appendIfUnique arr_id id
				appendIfUnique arr_difMap $.mat[id].diffusemap.filename
			)catch()
		)
		
		if (arr_difMap.count == 1) then
		(
			newnums = $.mat.materiallist.count + 1
			$.mat.numsubs = newnums			
			arr_N = $.mat.materialidlist[newnums]
			$.mat[arr_N] = copy $.mat[arr_id[1]]
			polyop.setFaceMatID $ face_sel arr_N
		)
		else
		(
			messagebox ("所选面贴图不一致,不能合并ID ！")
			return false
		)
		
		
		
		/* max modify mode 
		subObjectLevel = 0 */
	)
	on btn_ClsMat pressed do
	(
		/*
		if selection[1]==undefined then return false
		arr_id = #{}
		faceN = polyop.getNumFaces $
		for i=1 to faceN do
		(
			id = polyop.getFaceMatID $ i
			append arr_id id
			--arr_id 合并后的所有id 
		)
	-- 			print arr_id
		
		if ((classof $.mat)==Multimaterial) then
		(
			numId = arr_id.numberset
			mm = multimaterial numsubs:numId
			meditMaterials[1]=mm
			k = 1
			m = 1
			for j in arr_id do 
			(
				--print arr_diffPathN[j]
				print j
				tt = Standardmaterial ()
				pfile = arr_diffPathN[j]
				print arr_diffPathN[j]
				tt.diffusemap = Bitmaptexture filename:pfile				
				mm[k] = tt						
				showTextureMap mm[k] on						
				k=k+1
			)								
			$.mat = meditMaterials[1]
			print $.mat.materialIDlist
			for z in arr_id do 
			(	
				$.material.materialIDList[m]=z
				m=m+1
			)					
		)
		*/
		
		if selection.count > 0 then
		(
			obj = selection[1]
			--converttopoly obj
			if classof obj != Editable_Poly then converttopoly obj
			subobjectLevel = 1
			arrFace = #()
			arrmatid = #()
			arrmatno = #()
			objmat = obj.mat
			if classof objmat == Standardmaterial then continue
			submatnum = objmat.materialList.count
			--得到submat 数量
			for i = 1 to  submatnum do
			(	--matid
				id = objmat.materialIDList[i]
				obj.EditablePoly.selectByMaterial id
				tmp  =  (getFaceSelection obj) as array
				--if(tmp.numberSet > 0 )then
				if(tmp.count > 0 )then
				(
					append arrFace tmp
					append arrmatid id
					append arrmatno i
				)
			)
			
			--设置新的mat
			matcnt = arrmatno.count
			print matcnt
			local mm
			if  matcnt > 1 then
			(
				mm = multimaterial()
				
				mm.numsubs = matcnt
				for j=1 to matcnt do
				(
					local mat = standardMaterial()
					mat =  copy objmat.materialList[arrmatid[j]]
					mm[j] = mat
				)	
	
				for j = 1 to matcnt do
				(
					obj.EditablePoly.selectByMaterial arrmatid[j]
					--obj.EditablePoly.setMaterialIndex j
					polyop.setFaceMatID obj arrFace[j] j
					-- for ij =1 to arrFace[j].count do
					-- (
						-- polyop.setFaceMatID obj arrFace[j][ij] ij
					-- )
				)
			)
			else
			(
				mm = standardMaterial()
				mm =  copy objmat.materialList[arrmatid[1]]
				
			)
			
			meditMaterials[1]= mm
			obj.mat = meditMaterials[1]
			
			if((classof obj.mat) == Multimaterial) do
			(
				local submatnum = obj.mat.materiallist.count
				namepostfix = 1
				for im = 1 to submatnum do
				(
					local id = obj.mat.materialidlist[im]
					if((classof (obj.mat[id])) == Standardmaterial) do
					(
						print namepostfix
						obj.mat[id].name = "ms" + (namepostfix as string)
						namepostfix=namepostfix +1
					)
				)
			)
			--if classof obj != Editable_Poly then converttopoly obj
			subobjectLevel = 5
			messagebox "材质整理完毕"
		)
		else
		(
			messagebox "请选择要合并材质的模型"
		)
		
		
	)
	on btn_chkmatid pressed do
	(
		if selection[1]==undefined then return false
		index = $.getMaterialIndex true 
		$.EditablePoly.selectByMaterial index
		edt_matid.text = index as string
		--$.EditablePoly.SelectElement()
	)
	on spn_matid buttonup do
	(
			if selection.count != 1 then messagebox "请选择一个模型"
		else
		(
			if spn_matid.value < 0 then
				chuli selection[1] -1
			else chuli selection[1]  1
			spn_matid.value = 0
		) 
	)
	on exp_obj_btn1 pressed do
	(
		export_by_layer()
	)
)
gw = newRolloutFloater "影视场景整合临时工具" 170 570
addrollout	qiantiRollout gw --rolledUp:true
addrollout  caozuoRollout gw
--------------------------------------------------------------------------rollout（new）end	
	
)