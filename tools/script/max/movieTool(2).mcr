macroScript MoveTool2
category:"Superpolo"
ButtonText:"Scene MovieTool2" 
tooltip:"MovieTool2" Icon:#("Maxscript",7)
(
	/**
	 * @brief 得到项目的路径 
	 * 比如`D:\p\duiwaijingmaodaxue`
	 */
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
	delete cameras
	delete lights
	delete pv

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
		converttopoly i
		resetxform i
		converttopoly i
		
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
	delete nonface_arr
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
	delete dummy_arr
	gc light:false delayed:false
	all_obj = for i in objects collect i
	all_obj.count
	)
	
	fn move_pivot =
	(
		for obj in geometry do
			(
				select obj
				CenterPivot obj
				obj.pivot.z = obj.min.z
				ResetXForm obj
				pos_o =obj.pos		
				print pos_o
				obj.pos = [0,0,0]
				if ((classof obj)!="Editable_Poly") then converttopoly obj
			)
	)
	
	fn getProjectPath = 
	(
		p = maxFilePath
		p = tolower p
		thisProjectPath = ""
		if p == "" then -- 判断是否保存文件
		(
			messagebox "请保存场景！"
			return false
		)
		else
		(
			p_arr = filterString p "\\"
			allProjectsPath = p_arr[1] + "\\" + p_arr[2]
			if p_arr.count>=6 and allProjectsPath == "d:\p" then 
			(
				thisProjectPath = p_arr[1] + "\\" + p_arr[2] + "\\" + p_arr[3]+ "\\" + p_arr[4]+ "\\" + p_arr[5]+ "\\" + p_arr[6]
			)
			else
			(
				messagebox "请保存在正确的项目目录下！\n(Make sure this project is in [D:\\p\\] path)"
				return false
			)
		)
		return thisProjectPath
	)
	
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
	fn v2s =
	(
		arrTexInfo = #()
		arrTexNum = #()
		myIncrement = 0
		newPath = maxFilePath
		p_arr = filterString newPath "\\"
		
		p = checkpPath() + "\\src\\"+p_arr[5]+"\\"+p_arr[6]+"\\diffuse\\"
		makeDir p
		for o in geometry do 
		(
		if classof o.material == VRayMtl \
			or classof o.material == VRay2SidedMtl \
			or classof o.material == VRayBlendMtl \
			or classof o.material == VRayCarPaintMtl \
			or classof o.material == VRayFastSSS \
			or classof o.material == VRayFastSSS2 \
			or classof o.material == VRayLightMtl \
			or classof o.material == VRayMtlWrapper \
			or classof o.material == VRayOverrideMtl \
			or classof o.material == VRayVectorDisplBake \
			or classof o.material == VRaySimbiontMtl  \							
			or classof o.material == Standardmaterial do 
			(
				--tryif o.material.diffusemap != undefined then
				tt = Standardmaterial ()
				testflag = false
				try(
					local omatimg
					if ( classof o.material == VRayMtlWrapper) then
						omatimg = o.material.BaseMtl.diffusemap
					else
						omatimg = o.material.diffusemap
					if omatimg != undefined then
					(
						texmap = omatimg.filename
						if(doesFileExist texmap) then
						(
							myIncrement += 1
							pfile = (p + "tex" + myIncrement as string + getFilenameType texmap)
							copyfile texmap (pfile)
							tt.diffusemap = Bitmaptexture filename:pfile
						)
						else
						(
							testflag = true
						)
					)
					else
						testflag = true
				)
				catch
				(
					
					testflag = true	
				)
				if testflag then
				(
					local cl
					if (classof o.material == VRayMtlWrapper) then
						cl = o.material.BaseMtl.diffuse
					else if (classof o.material == VRayLightMtl) then
						cl = o.material.color
					else			
						cl = o.material.diffuse
					strname = cl.r as string + cl.g as string  + cl.b as string
					idx = finditem arrTexNum strname
					texfile = ""
					if idx != 0 then 
						texfile = arrTexInfo[idx]
					else
					(
						
						myIncrement += 1
						myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
						texfile =  (p + "tex" + myIncrement as string + ".jpg")
						append arrTexInfo texfile
						append arrTexNum strname
						myBitmap.filename = texfile
						save myBitmap
						--
					)
					tt.diffusemap = Bitmaptexture filename: texfile
					--print texfile
				)
				o.material = tt
			)
			if classof o.material == Multimaterial then 
			for m = 1 to o.material.numsubs do
			(
			
				if classof o.material [m] == VRay2SidedMtl \
				or classof o.material [m] == VRayBlendMtl \
				or classof o.material [m] == VRayFastSSS \
				or classof o.material [m] == VRayCarPaintMtl \
				or classof o.material [m] == VRayFastSSS2 \
				or classof o.material [m] == VRayLightMtl \
				or classof o.material [m] == VRayMtlWrapper \
				or classof o.material [m] == VRayOverrideMtl \
				or classof o.material [m] == VRayVectorDisplBake \
				or classof o.material [m] == VRaySimbiontMtl \ 
				or classof o.material [m] == VRayMtl \ 
				or classof o.material [m] == Standardmaterial do 
				(
					tt = Standardmaterial ()
					testflag = false
					try(
						local omatimg
						if (classof o.material[m] == VRayMtlWrapper) then
							omatimg = o.material [m].BaseMtl.diffusemap
						else
							omatimg = o.material [m].diffusemap
						if omatimg != undefined then
						(
							texmap = omatimg.filename
							if(doesFileExist texmap) then
							(
								myIncrement += 1
								pfile = (p + "tex" + myIncrement as string + getFilenameType texmap)
								copyfile texmap (pfile)
								tt.diffusemap = Bitmaptexture filename:pfile
							)
							else
							(
								testflag = true
							)
						)
						else
						(
							testflag = true
						)
					)
					catch
					(
						testflag = true	
					)
					if testflag then
					(
					
						local cl
						if (classof o.material == VRayMtlWrapper) then
							cl = o.material[m].BaseMtl.diffuse
						else if (classof o.material == VRayLightMtl) then
							cl = o.material[m].color
						else			
							cl = o.material[m].diffuse
	
						strname = cl.r as string + cl.g as string  + cl.b as string
						idx = finditem arrTexNum strname
						texfile = ""
						if idx != 0 then 
							texfile = arrTexInfo[idx]
						else
						(
							myIncrement += 1
							myBitmap = bitmap 32 32 color:[cl.r, cl.g,cl.b]
							texfile =  (p + "tex" + myIncrement as string + ".jpg")
							append arrTexInfo texfile
							append arrTexNum strname
							myBitmap.filename = texfile
						
							save myBitmap
							--print texfile
						)
						--diffusemap = Bitmaptexture filename: texfile
						tt.diffusemap = Bitmaptexture filename: texfile
					)
					o.material [m] = tt
				)
			)
			
		)
		actionMan.executeAction 0 "40807"
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
		
	fn exportMesh =
	(
		for obj in geometry do
			(
				select obj			
				if ((classof obj)!="Editable_Poly") then converttopoly obj
				/* try
				(
					fsindex=findString (obj.name) "#"
					obj_name = (substring (obj.name) 1 (fsindex-1))
				)
				catch
				(
					messagebox ("命名规范有问题！")
					return false
				)  */
				obj_name =	obj.name
				try(filepath = getprojectpath()+"\\obj\\")catch(return false)
				makeDir filepath --在当前处理的max路径下建立以对象物体为名的文件夹
				--输出这个文件成一个.obj文件，并保存为以物体为名的文件夹内。
				obj_name=obj_name + ".obj"
				filename=filepath + obj_name
				exportfile filename #noPrompt selectedOnly:TRUE
				--exportfile filename #noProm	pt selectedOnly:TRUE
			)
	)
	fn emptyList =
	(
		selMeshTab =#()
		flag = true
		arr_diffPath=#()
		diffPath =""
	)
	
	
	
	
	fn down_pivot =(
		o = getcurrentselection()
		if o.count != 0 then
		(
			for i = 1 to o.count do
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
	
	fn checkMeshSingle =
	(		
		arr_BadFace= #()
		try ($.baseobject) catch 
		(
			messagebox "没有选中模型" 
			return false
		)
		if (($.baseobject)!=Editable_Poly) then converttopoly $
		face_selection = #{}
		base_obj = $.baseobject
		num_faces = polyop.getNumFaces base_obj
		flag = true
		arr_BadFace = #()
		for f = 1 to num_faces do
		(
			try(
			local num_face_verts = polyop.getFaceDeg base_obj f
			if num_face_verts > 4 do face_selection[f] = true
			if num_face_verts > 4 then flag = false)
			catch(
				append arr_BadFace f
				print f
			)
		)--end f loop
		/* arr_delFace =arr_BadFace
		$.EditablePoly.SetSelection #Face arr_delFace */
		polyop.deleteFaces $ arr_BadFace
		
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
	
	rollout check_modify "检查及修改物体" width:159 height:176
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
	
	--为合并后的物体材质重命名
	fn rename_Mat =(
		arr_id = #() 
		arr_name = #()
		for i in geometry do 
		(
			select i
			arr_id =$.material.materialIDList
			arr_name =$.material.materialList
			index = arr_id.count
			for i=1 to index do
			(
				arr_name[i].name = "m"+ (arr_id[i] as string)
			)			
		)
	)	
	
	
	--合并物体
	fn attach_geo =
	(
		arr =#()
		for i in geometry do
		(
			converttopoly (i)
			append arr i
		)
		num = arr.count-1
		for i=1 to num do
		(
			undo off
			(
				arr[1].attach arr[2] arr[1]
				deleteitem arr 2
			)
		)
		for obj in geometry do
		(
			/* select obj
			CenterPivot obj
			obj.pivot.z = obj.min.z
			ResetXForm obj
			pos_o =obj.pos		
			print pos_o
			obj.pos = [0,0,0] */
			try(
			index = findstring maxfilename "."
			obj.name =	substring maxfilename 1 (index-1)
			)catch(messagebox ("文件命名有问题"))
			if ((classof obj)!="Editable_Poly") then converttopoly obj
		)
-- 		move_pivot()
		
		rename_Mat()
	

	)
	
	
	
	
	
	
	
	
	
	fn planar_map =
	(
		i =selection[1]
		subobjectLevel = 3
		polyCount = i.numfaces
		i.Unwrap_UVW.unwrap.selectPolygons #{1..polyCount}
		uv =$.modifiers[#unwrap_uvw]
		uv.quickPlanarMap() 
	)
	
	
	fn break_uv =
	(
		uv = $.modifiers[#unwrap_uvw] ----- == $.modifiers[#unwrap_uvw]  == modPanel.getCurrentObject();
		
		-- edge to pelt seam
		uv.setPeltEditSeamsMode true
		uv.peltEdgeSelToSeam  true
		uv.peltSeamToEdgeSel true
		uv.setPeltEditSeamsMode false
		uv.breakSelected()
	)
	
	fn flatten_sel = 
	(
		--add uvw
		uv = $.modifiers[#unwrap_uvw] ----- == $.modifiers[#unwrap_uvw]  == modPanel.getCurrentObject();
		if uv == undefined then 
		(
			messagebox "flatten_sel失败，请按顺序操作！"	
			return false
		)
		numPseamSelected = (uv.getPeltSelectedSeams()).numberSet
		numFacesSelected = (uv.getSelectedFacesByNode $).numberSet
	
			
		if (numFacesSelected > 0)then(
			local var_a = uv.unwrap3.getRelaxIteration();
			if (numPseamSelected > 0)then
			( -- to edit and break pelt seam to uv seam
				uv.setTVSubObjectMode 2
				uv.setSelectedGeomEdges (uv.getPeltSelectedSeams())
				uv.syncTVSelection()
				uv.edit()
				uv.setTVSubObjectMode 2
				$.Unwrap_UVW.setPeltSelectedSeams #{}
			)
			-- relax 
			uv.edit()
			uv.setTVSubObjectMode 3
			uv.unwrap3.setRelaxIteration 1000;
			uv.unwrap3.setRelaxAmount 1
			uv.relax2();
			uv.relaxByFaceAngle 1000 0 1 false;
			
			---restore previous settings
			uv.setRelaxIteration var_a;
			
		)
		
	)
	
	fn open_uv_editor = (
	try(
		i=selection[1]
		converttopoly i
		disableSceneRedraw()
		
		modPanel.addModToSelection (Unwrap_UVW ()) ui:on
		
		$.modifiers[#unwrap_uvw].unwrap5.setShowMapSeams on
		$.modifiers[#unwrap_uvw].unwrap5.setPeltAlwaysShowSeams off
		
		subobjectLevel = 3;
		modPanel.setCurrentObject $.modifiers[#Unwrap_UVW]
		
		$.modifiers[#unwrap_uvw].unwrap2.setFreeFormMode on
		$.modifiers[#unwrap_uvw].unwrap.edit ()
		
		subobjectLevel = 3
		$.modifiers[#unwrap_uvw].unwrap.DisplayMap off
		$.modifiers[#unwrap_uvw].unwrap.edit ()-- to maximize
		$.modifiers[#unwrap_uvw].unwrap.edit ()-- to maximize
		
		$.unwrap_uvw.unwrap2.setGeomSelectElementMode(false); -- select viewport 
		$.unwrap_uvw.unwrap2.setIgnoreBackFaceCull(false)
		--$.unwrap_uvw.unwrap2.setTVElementMode(true);--select element UV view
		$.unwrap_uvw.unwrap2.setTVSubObjectMode(3);--face selection more
		$.unwrap_uvw.unwrap2.setShowMap(false);--disable tex view
		
		--$.modifiers[#unwrap_uvw].unwrap2.renderuv_seamColor = color ;
		--
		$.modifiers[#unwrap_uvw].unwrap2.setOpenEdgeColor [256-190,256-230,256-119];
		$.modifiers[#unwrap_uvw].unwrap2.setSharedColor [256-255,256-132,256-255];
		$.modifiers[#unwrap_uvw].unwrap.setLineColor [256-255,256-132,256-0];
		
		$.modifiers[#unwrap_uvw].unwrap.setSelectionColor [256-255, 256-108, 256-0];

		-- new stuff
		$.modifiers[#unwrap_uvw].unwrap2.setFillMode 2;
		$.modifiers[#unwrap_uvw].unwrap2.setBackgroundColor [256-44,256-52,256-43];

		--grid colors
		$.modifiers[#unwrap_uvw].unwrap2.setGridVisible true;
		$.modifiers[#unwrap_uvw].unwrap2.setGridSize 1;
		$.modifiers[#unwrap_uvw].unwrap2.setGridColor [195,195,195];	 
		--fl_textureHelper.pos = point2 96 64;
		--clearlistener();		 		
		
		$.modifiers[#unwrap_uvw].unwrap5.setWindowXOffset 640;
		
		print("pos x "+5 as string);
		
		--$.modifiers[#unwrap_uvw].unwrap5.setWindowYOffset _y;
		--setWindowXOffset
		enableSceneRedraw();
		completeRedraw();
		print("any?"+2 as string);--$.modifiers[#unwrap_uvw].unwrap.pos
-- 		planar_map()
-- 		subobjectLevel = 2
		
		)catch(
		
			enableSceneRedraw()
			completeRedraw();
		)
	)
	
	fn sort_uv useXaxis texSizeW texSizeH texPad =(
		clearListener();
		if (selection.count > 0)then(
			undo on(
				
				

				function sortRow obj uv useXaxis texSizeW texSizeH texPad=(
					
					if (uv != undefined) then(
						local _mode =uv.unwrap2.getTVSubObjectMode();
						
						if (classOf obj.baseObject == Editable_Poly ) then (
								
							--local uv = obj.modifiers[ #unwrap_uvw ];
							uv.unwrap2.selectElement();	

							local _mode = uv.unwrap2.getTVSubObjectMode();
							if (_mode == 2)then(
								uv.unwrap2.edgeToVertSelect();
							)else if (_mode == 3)then(
								uv.unwrap2.faceToVertSelect();
							)
							
							if ((maxVersion())[1] >= 10000 )then(--Max 2008+
								local original_vertex_selection = uv.unwrap6.getSelectedVerticesByNode obj;
								local numVertexSelected = #{1..(uv.unwrap6.numberVerticesByNode obj)};
							)else(
								local original_vertex_selection = uv.unwrap.getSelectedVertices();
								local numVertexSelected = #{1..(uv.unwrap.NumberVertices())};
							)
							
							/*
							local numVertexSelected = #{1..(polyop.getNumMapVerts obj 1)};
							
							--local numVertexSelected = #{1..(uv.unwrap.NumberVertices())};
							local numVertexSelected = #{1..(uv.unwrap6.numberVerticesByNode obj)};
							
							*/
							
						--		numberVerticesByNode 
								
							--NumberVertices()
	-->.

							
							/*
							uv.unwrap2.setTVSubObjectMode 1;--vert mode
							actionMan.executeAction 0 "40021";--select all
							numVertexSelected = uv.unwrap6.getSelectedVerticesByNode obj;
							uv.unwrap6.selectVerticesByNode original_vertex_selection obj;
	*/
							
							
							
							
							
							
							
							
							local vertElemArray = #();
							for v in numVertexSelected do (
								vertElemArray[ v ] = 0;
							)
							local elementsCount = 0;
							local elemVerts = #{};

							uv.unwrap2.setTVSubObjectMode 1;
							
							local elem = #();
							with redraw off;
							for v in original_vertex_selection do (
								if vertElemArray[ v ] == 0 then (
									if ((maxVersion())[1] >= 10000 )then(--Max 2008+
										uv.unwrap6.selectVerticesByNode #{ v } obj;
									)else(
										uv.selectVertices #{ v }
									)
									uv.unwrap2.selectElement();
									if ((maxVersion())[1] >= 10000 )then(--Max 2008+
										elemVerts = (uv.unwrap6.getSelectedVerticesByNode obj) as array;
									)else(
										elemVerts = uv.unwrap.getselectedvertices() as array;
									)
									
									if elemVerts.count > 2 then (-- Ignore elements with less than 3 UV vertices.
										elementsCount += 1;
										
										
										
										if ((maxVersion())[1] >= 10000 )then(--Max 2008+
											elem[elementsCount] = (uv.unwrap6.getSelectedVerticesByNode obj);
										)else(
											elem[elementsCount] = uv.unwrap.getselectedvertices();--elemVerts;
										)
										
										for i in elemVerts do (
											vertElemArray[ i ] = elementsCount; -- Mark these vertices with their element number in vertElemArray.
										)
									)
								)
							)


							if ( elementsCount > 0)then(--only continue if more than one elements are catched
								--continue

								function compress_rotate _obj uv usexflow = (
								--	local uv = _obj.modifiers[ #unwrap_uvw ];
									local uv1 = uv.unwrap;
									local uv2 = uv.unwrap2;
									function getBBox uv _obj=(
										if ((maxVersion())[1] >= 10000 )then(--Max 2008+
											local _verts = (uv.unwrap6.getSelectedVerticesByNode _obj) as array;
										)else(
											local _verts = uv.unwrap.getSelectedVertices() as array;
										)
										local minx;
										local maxx;
										local miny;
										local maxy;
										local cnt = 0;
										for i in _verts do (
											local _pt = uv.unwrap.getVertexPosition 1 i;
											if (cnt == 0)then(
												minx = _pt.x;
												miny = _pt.y;
												maxx = _pt.x;
												maxy = _pt.y;
												cnt+=1;
											)else(
												minx = amin #(_pt.x, minx) as float;
												miny = amin #(_pt.y, miny) as float;
												maxx = amax #(_pt.x, maxx) as float;
												maxy = amax #(_pt.y, maxy) as float;
											)
										)
										return #((maxx - minx),(maxy - miny),minx,maxy);
									)
									
									--settings
									local sweepSteps = 8;
									local iterations = 4;
									local sweepRange = 90 as float;
									local sweepAngle = (sweepRange/ sweepSteps) as float;
									
									local dia_old;--diameter of the bounding box ( w +h);
									local dia_new;
									local bestAngle;
									local correctionAngle;
									local bbox;
									
									for i= 1 to iterations do (
										bbox = getBBox uv _obj;
										dia_old = amin #( bbox[1] , bbox[2] );
										bestAngle = 0;
										with redraw off(
											for n = 1 to (sweepSteps-1) do (--rotate sweepRange
												uv1.rotateSelectedVerticesCenter (sweepAngle* PI/180);
												
												bbox = getBBox uv _obj;
												dia_new = amin #( bbox[1] , bbox[2] );
												
												if (dia_new < dia_old) then(
													dia_old = dia_new;
													bestAngle = ((n) * sweepAngle);
												)
											)
										)
										correctionAngle = bestAngle - sweepAngle*(sweepSteps - 1);
										if (i != iterations)then(
											sweepRange = sweepAngle;
											sweepAngle = sweepRange/sweepSteps;
											correctionAngle -= sweepRange * 0.5;
										)
										uv1.rotateSelectedVerticesCenter (correctionAngle* PI/180);
									)
									--make sure its always horizontal!!!
									bbox = getBBox uv _obj;
									if (usexflow== false)then(
										if (bbox[2] > bbox[1])then(
											uv1.rotateSelectedVerticesCenter (90* PI/180);
											bbox = getBBox uv _obj;
										)
									)else(
										if (bbox[2] < bbox[1])then(
											uv1.rotateSelectedVerticesCenter (90* PI/180);
											bbox = getBBox uv _obj;
										)
									)
									return bbox;
								)

								
								
								local min_x;
								local min_y;
								local max_x;
								local max_y;
								
								local widths = #();--used to sort later
								local bbox = #();
								for e = 1 to elementsCount do (
									
									if ((maxVersion())[1] >= 10000 )then(--Max 2008+
										uv.unwrap6.selectVerticesByNode elem[e] obj;
									)else(
										uv.selectVertices elem[e];
									)	
									
									bbox[e] = compress_rotate obj uv useXaxis;
									
									if (useXaxis == true)then(
										widths[e] = bbox[e][2];
									)else(
										widths[e] = bbox[e][1];
									)
									
									if (e == 1)then(--first loop
										min_x = bbox[e][3];
										min_y = bbox[e][4];
										max_x = bbox[e][3];
										max_y = bbox[e][4];
									)else(
										min_x = amin #( min_x , bbox[e][3] );
										min_y = amin #( min_y , bbox[e][4] );
										max_x = amax #( min_x , bbox[e][3] );
										max_y = amax #( min_y , bbox[e][4] );
									)
								)
								
								--sort on their widths or heights
								sort_array = deepCopy widths;
								sort sort_array;
								
								
								local stepper;
								if (useXaxis == true)then(
									stepper = min_x;
								)else(
									stepper = max_y;--start at the top of the former selection
								)
								with redraw off(
									for i = 1 to elementsCount do(
										local idx = findItem (widths) (sort_array[elementsCount-i+1]);
										--idx = elementsCount  - idx+1;			
										if (idx > 0)then(
											local sx;
											local sy;
											if (useXaxis)then(
												--sx = stepper - bbox[idx][3];
												sx = (stepper - bbox[idx][3]) as float;
												sy = (max_y - bbox[idx][4]) as float;
												stepper+= bbox[idx][1]+(texPad as Float / texSizeW as Float);
											)else(
												sx = min_x - bbox[idx][3];
												sy = stepper - bbox[idx][4];
												stepper-=bbox[idx][2]+(texPad as Float / texSizeH as Float);
											)
											
											
											if ((maxVersion())[1] >= 10000 )then(--Max 2008+
												uv.unwrap6.selectVerticesByNode elem[idx] obj;
											)else(
												uv.selectVertices elem[idx];
											)
											
											uv.moveSelectedVertices [sx,sy, 0];
										)
									)
								)
							)
							uv.unwrap2.setTVSubObjectMode 3;
						)
					)
				)
				
				
				local uv = modPanel.getCurrentObject();
				if( classof(uv) == Unwrap_UVW)then(
					if ((maxVersion())[1] >= 10000 )then(
						local orgFaceSel = #();
						for i = 1 to selection.count do(--go through multiple objects
							orgFaceSel[i] = uv.unwrap6.getSelectedFacesByNode selection[i];
						)
						for i = 1 to selection.count do(--go through multiple objects
							uv.unwrap6.selectFacesByNode orgFaceSel[i] selection[i];--put back origininal selection
							sortRow selection[i] uv useXaxis texSizeW texSizeH texPad;
						)
					)else(
						sortRow selection[1] uv useXaxis texSizeW texSizeH texPad;--only do this with the first object in the selection
					)
				)
			)--end undo
		)
	)
	
	
	
	fn normalize_uv = (
	undo on(
	--original script PAUL GREVESON
	--http://www.greveson.co.uk/scripts/normalizeUvScale.ms
		if selection.count == 1 then (
			local obj = selection[ 1 ];
			local hadUnwrap = true
			local success = true
			local normalizeAll = true
			if classOf obj.baseObject == Editable_Poly then (
				max modify mode
				if obj.modifiers[ #unwrap_uvw ] == undefined then (
					hadUnwrap = false
					addModifier obj ( unwrap_uvw() )
				)
				
				local uv = obj.modifiers[ #unwrap_uvw ]
				-- Store current selection, and check if the edit window is open or not.
				local origLevel = 0
				for i = 0 to 3 do (
					if subObjectLevel == i then origLevel = i
				)
				local windowOpen = false
				local uvWndH = uv.getWindowH()
				if uvWndH > 0 and uvWndH < 5000 then windowOpen = true
				local origVerts = uv.getSelectedVertices()
				local origEdges = uv.getSelectedEdges()
				local origFaces = uv.getSelectedFaces()
				local alwaysEdit = uv.getAlwaysEdit()
				
				uv.setAlwaysEdit false
				
				-- Check what the original selection was for each mode.
				subObjectLevel = 1
				local sel = #{}
				if origLevel == 0 then (
					max select all
					sel = uv.getSelectedVertices()
				)
				else if origLevel == 1 then (
					if ( origVerts as array ).count == 0 then (
						max select all
						sel = uv.getSelectedVertices()
					)
					else (
						sel = origVerts
						normalizeAll = false
					)
				)
				else if origLevel == 2 then (
					if ( origEdges as array ).count == 0 then (
						max select all
						sel = uv.getSelectedVertices()
					)
					else (
						uv.edgeToVertSelect()
						sel = uv.getSelectedVertices()
						normalizeAll = false
					)
				)
				else (
					if ( origFaces as array ).count == 0 then (
						max select all
						sel = uv.getSelectedVertices()
					)
					else (
						uv.faceToVertSelect()
						sel = uv.getSelectedVertices()
						normalizeAll = false
					)
				)
				
				-- Determine the amount of elements and store the vertex index of all vertices in each element.
				local numVerts = uv.numberVertices()
				local vertElemArray = #()
				for i = 1 to numVerts do ( vertElemArray[ i ] = 0 )
				local elements = 0
				local elemVerts = #{}
				
				with redraw off
				for v = 1 to numVerts do (
					-- If vertex has no element assigned yet, create a new element.
					if vertElemArray[ v ] == 0 then (
						uv.selectVertices #{ v }
						uv.selectElement()
						elemVerts = uv.getSelectedVertices()
						-- Ignore elements with less than 3 UV vertices.
						if ( elemVerts as array ).count > 2 then (
							elements += 1
							for i in elemVerts do (
								vertElemArray[ i ] = elements -- Mark these vertices with their element number in vertElemArray.
							)
						)
					)
				)
			
				local elementArray = #()
				-- Get the first vertex index for each element.
				for e = 1 to elements do (
					for v = 1 to vertElemArray.count do (
						if vertElemArray[ v ] == e then (
							elementArray[ e ] = v
							exit
						)
					)
					e += 1
				)
				
				local workObj = obj
				-- Check if we need to snapshot or not.
				if obj.modifiers.count > 1 then ( 	
					-- Snapshot to work with.
					objSnap = copy obj
					collapseStack objSnap

					workObj = objSnap
				)
				
				if success and elements > 0 then (
					-- Check how many polys in the object, only show progress bar for dense meshes.
					local showProgress = false
					if polyop.getNumFaces workObj > 2000 then showProgress = true
					
					local uvAreas = #()
					local geoAreas = #()
					local uvRatios = #()
					uvRatios[ elements ] = 0;
					
					with redraw off
					for i = 1 to elements do (
						
						local uvArea = 0.0
						local geoArea = 0.0
						
						subObjectLevel = 1
						uv.selectVertices #{ elementArray[ i ] }
						uv.selectElement()
						uv.vertToFaceSelect()
						subObjectLevel = 3
						local polySel = uv.getSelectedPolygons() as array
						
						-- Start a progress bar.
						local progString = "" as stringStream
						format "Normalizing element %/%..." i elements to:progString
						if showProgress then progressStart ( progString as string )
						
						-- Work through all the faces in the element to get its UV verts and face area.
						for p = 1 to polySel.count do (
							local vCount = ( uv.numberPointsInFace polySel[ p ] )
							local faceVerts = #()
							local uvPos = #()
							local thisUvArea = 0.0
							faceVerts[ vCount ] = 0
							uvPos[ vCount ] = 0
							
							for v = 1 to vCount do (
								faceVerts[ v ] = ( uv.getVertexIndexFromFace polySel[ p ] v )
							)
							
							local temp = 1
							for f in faceVerts do (
								uvPos[ temp ] = ( uv.getVertexPosition 0 f )
								temp += 1
							)
							
							-- Cheap hack to avoid more complicated maths later! :)
							append uvPos uvPos[ 1 ]
							
							-- Add up each UV face area for this element.
							for u = 1 to vCount do (
								local self = uvPos[ u ]
								local next = uvPos[ u+1 ]
								thisUvArea += ( ( self.x * next.y ) - ( next.x * self.y ) )
							)
							-- Make sure our UV area amount is +ive and do the final calculation.
							thisUvArea = abs thisUvArea
							thisUvArea *= 0.5
							
							-- Add up all the UV and geometric face areas of this element.
							geoArea += ( polyOp.getFaceArea workObj polySel[ p ] )
							uvArea += thisUvArea
		
							-- Update the progress bar for this element.
							if showProgress then progressUpdate ( 100.0 * p / polySel.count )
						)
						if showProgress then progressEnd()
		
						-- Find the surface ratio for this element.
						uvRatios[ i ] = ( sqrt ( uvArea / geoArea ) )
					)
					
					-- Find which elements correspond to original selections.
					local selElements = #()
					selElements[ elements ] = 2
					if normalizeAll then (
						for i = 1 to elements do (
							selElements[ i ] = 1
						)
					)
					else (
						for i = 1 to elements do (
							subObjectLevel = 1
							uv.selectVertices #{ elementArray[ i ] }
							uv.selectElement()
							local tempSel = uv.getSelectedVertices()
							for e in sel do (
								for t in tempSel do (
									if e == t then (
										selElements[ i ] = 1
										exit
									)
								)
							)
							if selElements[ i ] != 1 then (
								selElements[ i ] = 0
							)
						)
					)
				
					-- Scale each element relative to the first.
					local scaleFactor = 1.0
					local avgFactor = 0.0
					with redraw off
					for i = 1 to elements do (
						if selElements[ i ] == 1 then (
							scaleFactor = ( uvRatios[ 1 ] / uvRatios[ i ] )
							subObjectLevel = 1
							uv.selectVertices #{ elementArray[ i ] }
							uv.selectElement()
							uv.scaleSelectedVerticesCenter scaleFactor 0
						)
						avgFactor += ( 1 / scaleFactor )
					)
					
					avgFactor = avgFactor / elements
					
					-- Average 'em all.
					with redraw off
					for i = 1 to elements do (
						if selElements[ i ] == 1 then (
							subObjectLevel = 1
							uv.selectVertices #{ elementArray[ i ] }
							uv.selectElement()
							uv.scaleSelectedVerticesCenter avgFactor 0
						)
					)
				)
								
				-- Delete the temporary object if necessary.
				if obj.modifiers.count > 1 then (
					delete objSnap
				)
				
				-- Reset the selections to the originals.
				uv.selectVertices origVerts
				uv.selectEdges origEdges
				uv.selectFaces origFaces
				uv.setAlwaysEdit alwaysEdit
				-- Also open the Edit UVWs window if it was already open.
				if windowOpen then uv.edit()
				-- Go back to original subObjectLevel.
				subObjectLevel = origLevel
				-- Remove the Unwrap UVW modifier if necessary after the script failed.
				if not hadUnwrap and not success then deleteModifier obj uv
			)
		)
	)
	)
	
--zhanghongru add remove_missed_maps
	(		
		mf = #() -- collected pathnames with enumeratefiles
		ms = #() -- missed map subanims
		sel_ms = #() -- selected missed maps
		--parent_array = #() -- materials with missed



		--------- bitmap for refresh button

		barr = #(192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,195.0,198.0,194.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,195.0,198.0,170.0,147.0,178.0,202.0,201.0,198.0,193.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,196.0,179.0,79.0,75.0,101.0,169.0,58.0,58.0,100.0,180.0,194.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,194.0,181.0,59.0,136.0,193.0,197.0,195.0,48.0,41.0,100.0,192.0,193.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,199.0,87.0,129.0,201.0,192.0,192.0,191.0,70.0,166.0,70.0,184.0,194.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,194.0,184.0,69.0,187.0,193.0,192.0,192.0,192.0,153.0,201.0,82.0,147.0,197.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,196.0,169.0,89.0,191.0,194.0,193.0,192.0,192.0,196.0,201.0,105.0,130.0,197.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,193.0,184.0,74.0,188.0,180.0,187.0,193.0,192.0,192.0,203.0,86.0,143.0,197.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,200.0,87.0,142.0,121.0,144.0,198.0,193.0,199.0,177.0,63.0,182.0,194.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,195.0,179.0,65.0,49.0,141.0,205.0,200.0,161.0,57.0,142.0,198.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,194.0,179.0,95.0,66.0,11.0,139.0,158.0,63.0,59.0,144.0,199.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,193.0,188.0,170.0,171.0,175.0,187.0,177.0,156.0,188.0,198.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,193.0,195.0,195.0,196.0,193.0,194.0,196.0,194.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0,192.0)
		size = 24

		bm1 = bitmap size size color:gray


		for i = 1 to size do
		(
			for ii = 1 to size do
			(
				c = barr[((i-1)*size+ii)]
				cc = color c c c
				setPixels bm1 [i,ii] #(cc)
			)
		)



		------------ deleting all missed maps
		fn delete_missed_maps mat =
		(
			if mat != undefined then
			(
				for i = 1 to mat.numsubs do
				(
					if iskindof mat[i] texturemap == true then 
					(
						for ii in ms do
						(
							if mat[i] == ii then 
							(
								try
								(
									print mat[i].filename
									mat[i].filename = ""
								)
								catch()
							)
						)
					)
					delete_missed_maps mat[i]
				)
			)
		)
		
		----------------------- fn for enumeratefiles
		fn enum name mat =  
		(
			if finditem mf name == 0 then append mf name
			--if finditem parent_array mat == 0 then append parent_array mat
		)

		------------ fn for finding subanims with missing paths
		fn rec mat =
		(
			if mat != undefined then
			(
				for i = 1 to mat.numsubs do
				(
					if iskindof mat[i] texturemap == true then 
					(
						for ii in mf do
						(
							try (if mat[i].filename == ii then append ms mat[i]) catch ()
						)
					)
					rec mat[i]
				)
			)
		)

		fn scan_missed_maps =
		(
			
			----------------------- enumerating missing paths
			for m in scenematerials do
			(
				enumerateFiles m enum m  #missing 
			)

			--------- dedermining missing maps subanims
			for i in scenematerials do
			(
				rec i
			)
			
			--print mf
			--print parent_array
			--print ms

		) 
		
		scan_missed_maps()

	)
	
	--检查uv
	global selMeshTab =#()
	global flag = true
	global arr_diffPath=#()
	global diffPath =""
		fn v_check_30 = (
		node_list = getCurrentSelection()
		counts = node_list.count
		for i = 1 to counts do
		(
			if ((classof $.mat)==Standardmaterial) then 
			(
				global matcolor = $.mat.diffusecolor
				try(diffPath = $.mat.diffusemap.filename)catch( print "no diffusemap")	
				mp1 = checker color1:[0,200,255] color2:[255,255,200]
				mp1.coords.U_Tiling = 30
				mp1.coords.V_Tiling = 30
				node_list[i].material = standard diffusecolor:white diffusemap:mp1
				showTextureMap node_list[i].material mp1 true
				flag = false
			)
			else if ((classof $.mat)==Multimaterial) then
			(
				mm = multimaterial()	
				mm.count = $.mat.count
				currentMatNum = $.mat.count
				for j=1 to currentMatNum do
				(
-- 					if (($.mat[30].diffusemap) != undefined )
					if (($.mat[j]) != undefined )
					then(
						try(arr_diffPath[j] = $.mat[j].diffusemap.filename
							
							print arr_diffPath[j]
							
						)catch()
					
					)	
				)
				for j=1 to currentMatNum do
				(
-- 					if (($.mat[30].diffusemap) != undefined )
					/* if (($.mat[j]) != undefined )
					then(
						try(arr_diffPath[j] = $.mat[j].diffusemap.filename
							
							print arr_diffPath[j]
							
						)catch()
					
					)	 */ 
					tm = checker color1:[0,200,255] color2:[255,255,200]
					tm.coords.U_Tiling = 30
					tm.coords.V_Tiling = 30
					mat = standardMaterial diffuseMap:tm					
					mm[j] = mat
					$.material = mm
					showTextureMap mm[j] tm on
				)				
				flag = false 
			)				
		)
	)
	--v_check_30()
	fn v_uncheck_30= 
	(
		node_list = getCurrentSelection()
		counts = node_list.count
		for i = 1 to counts do
		(			
			if ((classof $.mat)==Standardmaterial) then 
			(
				pfile=diffPath
				tt = Standardmaterial ()
				tt.diffusemap = Bitmaptexture filename:pfile
				$.mat= tt
				showTextureMap node_list[i].material true
				$.mat.diffusecolor = matcolor				
			)
			else if ((classof $.mat)==Multimaterial) then
			(
				currentMatNum = node_list[1].mat.numsubs
				for j=1 to currentMatNum do
				(
					if ((arr_diffPath[j]) != undefined )
					then(
						tt = Standardmaterial ()
						pfile = arr_diffPath[j]
						tt.diffusemap = Bitmaptexture filename:pfile						
						$.material [j] = tt						
						showTextureMap node_list[i].material[j] on	
					)
					else
					(
						node_list[i].material[j].diffusemap =undefined
						showTextureMap node_list[i].material[j] on	
					)
				)							
			)				
		)
		flag =true
	)
	--v_uncheck_30()
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

	fn pack_uv =
	(
		uv = $.modifiers[#unwrap_uvw] ----- == $.modifiers[#unwrap_uvw]  == modPanel.getCurrentObject();
		if uv == undefined then 
		(
			messagebox "pack失败，请按顺序操作"	
			return false
		)
		uv.pack 1 0.02 true false true
		
	)
	
	--调整物体属性
	fn setMashPro = 
	(
		max backface
		for i in objects do
		(
			select i
			$.showFrozenInGray = false
		)
	)

	rollout regulation_UV "调整uv" width:163 height:164
	(
		button btn_uveditor "1.打开uvEditor" pos:[16,16] width:129 height:19
		button btn_seam "4.创建接缝" pos:[16,102] width:128 height:17
		button btn_unfolduv "5.展开uv" pos:[17,129] width:128 height:17
		
		button btn_clnseam "2.清除边缝" pos:[16,44] width:129 height:19
		button btn_edgloop "3.edge loop" pos:[16,71] width:127 height:21

		
		on btn_uveditor pressed do
		(
			open_uv_editor()
		)
		on btn_seam pressed do
		(
			break_uv()
		)
		on btn_unfolduv pressed do
		(
			flatten_sel()
			sort_uv true 512 512 4
			pack_uv()
		-- 			converttopoly selection[1]
		)
		on btn_clnseam pressed do
		(
			planar_map()
			subobjectLevel = 2
		)
		on btn_edgloop pressed do
		(
			$.modifiers[#unwrap_uvw].unwrap5.geomEdgeLoopSelection()
		)
	)
	
	fn emptyList =
	(
		selMeshTab =#()
		flag = true
		arr_diffPath=#()
		diffPath =""
		print "callbacks"
	)
	
	fn exportObj =
	(
			index = findstring maxfilename "."
				obj_name = substring maxfilename 1 (index-1)
				try(filepath = getprojectpath()+"\\obj\\")catch(return false)
				makeDir filepath 				
				obj_name=obj_name + ".obj"
				filename=filepath + obj_name
				exportfile filename #noPrompt 
			
			messagebox ("物体导出成功！")
	)

	rollout choice "选择另存" width:193 height:37
	(
		editText edt1 "" pos:[84,7] width:34 height:20
		label lbl1 "输入数字：" pos:[3,10] width:85 height:22
		button btn_enter "确定" pos:[145,7] width:41 height:22
		
		/* on edt1 entered text do
		(
			fName = edt1.text			
			arr_p = filterString maxfilepath "\\"
			outPutPath =arr_p[1]+"\\"+arr_p[2]+"\\"+arr_p[3]+"\\src\\"+arr_p[6]+"\\"+fName+"\\"
			makedir outPutPath		
			if(selection == undefined)
			then
			(
				return false
			)
			exPath = arr_p[1]+"\\"+arr_p[2]+"\\"+arr_p[3]+"\\src\\"+arr_p[6]+"\\"+fName+"\\max\\"
			nName = exPath + fName +".max"
			try(saveNodes selection nName
			messagebox "保存成功"
			)catch(messagebox "保存失败")
		) */
		 on btn_enter pressed  do
		(
			fName = edt1.text	
			arr_p = filterString maxfilepath "\\"
			outPutPath =arr_p[1]+"\\"+arr_p[2]+"\\"+arr_p[3]+"\\src\\"+arr_p[6]+"\\"+fName+"\\max\\"			
			makedir outPutPath	
			if(selection == undefined)
			then
			(
				return false
			)
			exPath = arr_p[1]+"\\"+arr_p[2]+"\\"+arr_p[3]+"\\src\\"+arr_p[6]+"\\"+fName+"\\max\\"
			nName = exPath + fName +".max"
			try(saveNodes selection nName	
			messagebox "保存成功"
			)catch(messagebox "保存失败")
			
		) 
	)
	rollout PickMesh "影视工具(二)" width:202 height:538
	(
		button btn_clear "1.清理环境" pos:[30,61] width:150 height:21 
		button btn_selSave "2.选择另存" pos:[30,87] width:150 height:21 
		button btn_pointCenter "重置环境" pos:[44,171] width:128 height:21 
		button btn_check_modify "检查及修改物体" pos:[44,199] width:128 height:21 
		button btn_attach_geo "3.合并物体" pos:[30,333] width:155 height:21 
		button btn_modelEp "导出" pos:[13,507] width:185 height:21 
		button btn_creatUV "创建UV" pos:[44,266] width:128 height:21 
		button btn_chkuv "检查uv" pos:[44,292] width:128 height:21 
		button setUnit "设置场景单位" pos:[14,11] width:185 height:21
		GroupBox grp1 "1.模型处理" pos:[30,150] width:155 height:83 
		GroupBox grp4 "2.UV处理" pos:[30,243] width:155 height:81 
		button btn_choicemat "1.选择相同的材质" pos:[32,387] width:150 height:21
		button btn_unifyID "2.统一ID" pos:[31,413] width:150 height:21 
		button btn_chkmatid "3.材质ID检查" pos:[33,439] width:101 height:21
		button btn_ClsMat "4.材质整理及清理" pos:[35,465] width:150 height:21
		GroupBox grp21 "一.提取物体" pos:[14,41] width:185 height:79
		GroupBox grp22 "二.处理提取物体" pos:[12,128] width:185 height:373
		GroupBox grp23 "3.定义材质" pos:[26,366] width:161 height:128
		spinner spn_matid "" pos:[169,442] width:10 height:16 range:[-10,10,0] type:#integer scale:0.1
		edittext edt_matid "" pos:[136,440] width:29 height:19 enabled:false
		
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
		
		
		on btn_clear pressed do
		(
			scene_clean()
			delete cameras
			delete lights
		)
		on btn_selSave pressed do
		(
			createDialog choice
		)
		on btn_pointCenter pressed do
		(
			setMashPro()
			--emptyList()
			--callbacks.addscript #selectionSetChanged "emptyList()"
			--1.把物体放到世界坐标中心点
			group $* name:"models"
			ungroup $models
			
			
			----------------------------
			
			findDif = maxfilepath
			p_arr = filterString findDif "\\"
			difPath = p_arr[1]+"\\"+p_arr[2]+"\\"+p_arr[3]+"\\"+p_arr[4]+"\\"+p_arr[5]+"\\"+p_arr[6]+"\\"+"diffuse\\*"
			
			arr = getFiles difPath
			if (arr.count != 0)
			then 
			(
				messagebox ("已经执行过")
				return false
			)
			else
			(
				v2s()
				showMatInV()	
			)
			
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
			-----------------------------
			--exportObj()
			--messagebox "不支持的对象已清除完成"
			
			
		)
		on btn_check_modify pressed do
		(
			createDialog check_modify 150 176
		)
		on btn_attach_geo pressed do
		(
			attach_geo()
			--保存每个id的贴图
			global arr_diffPathN = #()
			global arr_ID = #()
			mm = multimaterial()	
			mm.numsubs = $.mat.numsubs
			currentMatNum = $.mat.numsubs
			for j=1 to currentMatNum do
			(
				if (($.mat[j]) != undefined )
				then(
					try(arr_diffPathN[j] = $.mat[j].diffusemap.filename
						print $.mat[j].diffusemap.filename
						append arr_ID j
					)catch()
				)
			)
		)
		on btn_modelEp pressed do
		(
		-- 			move_pivot()
			exportObj()
			/* thePath = getProjectPath()+"\\obj\\*.mtl"
			arr_mtl = getfiles thePath
			for f in arr_mtl do deleteFile f */
		)
		on btn_creatUV pressed do
		(
			createDialog regulation_UV 165 170				
		)
		on btn_chkuv pressed do
		(
			if flag == true then
			(
				v_check_30()
			)
			else
			(
				v_uncheck_30()
			)
		)
		on setUnit pressed do
		(
			units.SystemType = #millimeters
			
			units.DisplayType =  #Metric
			units.MetricType = #Millimeters
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
			arr_id = #{}
			--faceN = polyop.getNumFaces $
			face_sel =$.EditablePoly.getselection #face		
			for i in face_sel do
			(
				id = polyop.getFaceMatID $ i
				append arr_id id
			)
			arr_N = 0  --合并后的id
			arr_difMap =#() --存储合并后每个id贴图
			arr_ndifMap = #()
			for i in arr_id do
			(
				append arr_difMap $.mat[i].diffusemap.filename
				arr_ndifMap = makeUniqueArray arr_difMap
			)
			for i in arr_id do 
			(
				if (arr_ndifMap.count != 1) then
				(
					messagebox ("所选面贴图不一致,不能合并ID ！")
					return false
				)
				else
				(
					arr_N = i
					polyop.setFaceMatID $ face_sel arr_N
				)
					
			)
			/* max modify mode 
			subObjectLevel = 0 */
		)
		on btn_chkmatid pressed do
		(
			if selection[1]==undefined then return false
			index = $.getMaterialIndex true 
			$.EditablePoly.selectByMaterial index
			edt_matid.text = index as string
			--$.EditablePoly.SelectElement()
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
			
			for obj in geometry do
			(
				
				converttopoly obj
				arrFace = #()
				arrmatid = #()
				arrmatno = #()
				objmat = obj.mat
				if classof objmat == Standardmaterial then continue
				submatnum = objmat.materialList.count
				for i = 1 to  submatnum do
				(	
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
				matcnt = arrFace.count
				local mm
				if  matcnt > 1 then
				(
					mm = multimaterial()
		
					mm.numsubs = matcnt
					for j=1 to matcnt do
					(
						mat = standardMaterial()
						mat =  objmat.materialList[arrmatno[j]]
						mm[j] = mat
					)	
		
					for j = 1 to matcnt do
					(
						obj.EditablePoly.selectByMaterial arrmatid[j]
						--obj.EditablePoly.setMaterialIndex j
						for ij =1 to arrFace.count do
						(
							polyop.setFaceMatID obj arrFace[ij] ij
						)
					)
				)
				else
				(
					mm = standardMaterial()
					mm =  objmat.materialList[arrmatno[1]]
					
				)
				
				meditMaterials[1]= mm
				obj.mat = meditMaterials[1]
				--obj.mat = mm
			)
			messagebox "材质整理完毕"
			
		)
		on spn_matid buttonup do
		(
			if objects.count != 1 then messagebox "物体模型个数不为1,请合并物体后再来检查"
			else
			(
				if spn_matid.value < 0 then
					chuli objects[1] -1
				else chuli objects[1]  1
				spn_matid.value = 0
			)
		)
	)
	createdialog PickMesh
-- 	/* rollout MovieLRollout "二.处理提取物体" width:219 height:264
-- 	(		
-- 	)
-- 	/* on MovieLRollout open  do
-- 	(
-- 		fn emptyList =
-- 		(
-- 			selMeshTab =#()
-- 			flag = true
-- 			arr_diffPath=#()
-- 			diffPath =""
-- 			print "callbacks"
-- 		)		
-- 	)  */

-- 	
-- 	fn getIDsOfElement obj =
--     ( --此函数用来获取每个element中的第一个face ID
-- 		select obj
-- 		faceNum=polyOp.getNumFaces $
-- 		ids=#{1} --储存face id
-- 		tempID=1
-- 		while tempID <= faceNum do
-- 		( 
-- 			polyOp.setFaceSelection $ #{tempID}
-- 			$.EditablePoly.SelectElement()
-- 			selFace=polyOp.getFaceSelection $
-- 			ids[tempID]=true
-- 			tempID+=selFace.numberset
-- 		)
-- 		ids as array --把结果转换成数组，便于使用
--     )
-- 	
-- 	rollout IDSet "三.定义材质ID" width:219 height:171
-- 	(
-- 		
-- 		
-- 	)
-- 	gw = newRolloutFloater "Spp Scene ToolMovieTools" 230 290
-- 	addrollout 	PickMesh 	  gw
-- 	addrollout	MovieLRollout gw 
-- 	addrollout  IDSet gw */

)