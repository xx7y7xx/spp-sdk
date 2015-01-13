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

macroScript SPP_sceneToolModify
category:"Superpolo"
ButtonText:"Scene ToolModify" 
tooltip:"Spp Scene ToolModify" Icon:#("Maxscript", 3)
(

	
		
--------------------------------------------------------------------------------------------
-- ##################################### 材质和贴图重命名 ##############################################	
   /* fn checkmat = (
	 i = 0;
	   
	 renmess = ""
	 --遍历所有mesh
	 for iobj in  geometry do
	 (
		 --获取当前mesh下的所有材质
		 mat = iobj.material
		 
		 if mat.name.count >= 12 do
		 (
			tmpname = ("m" + "_" + (i as string)) 
				
			renmess = renmess + mat.name + " " + tmpname + "\n"
				
			mat.name = tmpname	 
			i += 1
		 )
		 
		 submatnum = getNumSubMtls mat
		 --遍历当前mesh下所有子材质
		 if submatnum >0 do
		 (
			 for im = 1 to submatnum do
			 (
				 imat = getSubMtl mat im
				 if imat == undefined do
				(
					continue 
				)
				 --判断name长度是否大于12
				if imat.name.count >= 12 do
				(--将所有名字为imat.name的material都改名
					tmpname = ("m" + "_" + (i as string)) 
					imat.name = tmpname
					
					i += 1
				)
			 )
		)
	 )
	  */
	 
/* 	  try(
			
			wtpath = checkpPath()
			wtpath = wtpath  + "\\plan"	
				
			makedir  wtpath	

			filename = wtpath +  "\\材质重命名.txt"
			outFile = createFile filename
		
			format "%\n" renmess to:outFile
			close outFile
		)catch() */
 --)
-- checkmat()

  /* fn checktexture = (
	 i = 0;
	 renmess = ""
	 --遍历所有mesh
	 for iobj in  geometry do
	 (
		 --获取当前mesh下的所有材质
		 mat = iobj.material
		 submatnum = getNumSubMtls mat
		 if submatnum == 0 do
		 (
			 texfilename = mat.diffuseMap.filename
			 texNameArr = filterString texfilename "\\."
		     texname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]
			 
			 texN = ""
			 for itexN =1 to (texNameArr.count-2) do
			 (
				 texN += texNameArr[itexN] + "\\" 
			 )
			 
			 if texname.count >=12 do
			 (
				tmpname = ("t" + "_" + (i as string)) 
				for iobjt in  geometry do
				(
					tmat = iobjt.material
					tsubmatnumber = getNumSubMtls tmat
					if tsubmatnumber == 0 do
					(
						 tmtexfilename = tmat.diffuseMap.filename
						 
						if tmtexfilename == texfilename do
						(
							tmat.diffuseMap.filename = texN + tmpname +"."+texNameArr[texNameArr.count]
							--tmat.diffuseMap.filename = tmpname
						)
					)
					if tsubmatnumber >0 do
					(
						for itm = 1 to tsubmatnumber do
						(
							 itsmat = getSubMtl tmat itm
							if itsmat == undefined do
							(
								continue 
							)
							 tmtexfilename = itsmat.diffuseMap.filename

							if tmtexfilename == texfilename do
							(
								itsmat.diffuseMap.filename = texN + tmpname +"."+texNameArr[texNameArr.count]
								--tmat.diffuseMap.filename = tmpname
							)
						)
					)
				)
				
				renmess = renmess + ( texfilename + " " + tmpname +"."+ texNameArr[texNameArr.count] + "\n") 
				renameFile texfilename (texN + tmpname +"."+ texNameArr[texNameArr.count])

				--cmdstr = "ren " + texfilename +" "+ tmpname +"."+ texNameArr[texNameArr.count]
				--DOSCommand cmdstr
				i += 1
			)
		 )
		 --遍历当前mesh下所有材质
		 if submatnum >0 do
		 (
			 for im = 1 to submatnum do
			 (
				 imat = getSubMtl mat im
				 if imat == undefined do
				 (
				 	continue
				 )
				 itexfilename = imat.diffuseMap.filename
				 texNameArr = filterString itexfilename "\\."
				 itexname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]

				 if itexname.count >= 12 do
				 (
					 
					texN = ""
					for itexN =1 to (texNameArr.count-2) do
					(
						texN += texNameArr[itexN] + "\\" 
					)
					
					tmpname = ("t" + "_" + (i as string)) 
					
					for iobjt in  geometry do
					(
						tmat = iobjt.material
						tsubmatnumber = getNumSubMtls tmat
						if tsubmatnumber == 0 do
						(
							tmtexfilename = tmat.diffuseMap.filename

							if tmtexfilename == itexfilename do
							(
								tmat.diffuseMap.filename = texN + tmpname +"."+texNameArr[texNameArr.count]
								--tmat.diffuseMap.filename = tmpname
							)
						)
						if tsubmatnumber >0 do
						(
							for itm = 1 to tsubmatnumber do
							(
								 itsmat = getSubMtl tmat itm
								if itsmat == undefined do
								(
									continue 
								)
								
								 tmtexfilename = itsmat.diffuseMap.filename
				
								if tmtexfilename == itexfilename do
								(
									itsmat.diffuseMap.filename = texN + tmpname +"."+texNameArr[texNameArr.count]
									--tmat.diffuseMap.filename = tmpname
								)
							)
						)
					)
					renmess = renmess + ( itexfilename + " " + tmpname +"."+ texNameArr[texNameArr.count] + "\n") 
					
					renameFile itexfilename (texN + tmpname +"."+ texNameArr[texNameArr.count])
					--cmdstr = "ren " + itexfilename +" "+ tmpname +"."+ texNameArr[texNameArr.count]
					--DOSCommand cmdstr
					
					i += 1
				  )
				 
			 )
		)
	 ) */
/* 	 
	 try(
			
			wtpath = checkpPath()
			wtpath = wtpath  + "\\plan"	
				
			makedir  wtpath	

			filename = wtpath +  "\\贴图重命名.txt"
			outFile = createFile filename
		
			format "%\n" renmess to:outFile
			close outFile
		)catch() */
--  )


---####################################################################################################
---########################################   rollout界面     #########################################
---####################################################################################################
	
---########################################   rollout内容    #########################################		
	rollout selbyname "根据名字选择" width:163 height:163
	(
		button selectObj_btn "选择物体" pos:[16,73] width:135 height:25
		edittext thename_edit "" pos:[12,39] width:140 height:26
		label n_lbl "在下面键入物体名称" pos:[13,11] width:137 height:27
		label lbl11 "用户也可以关掉这个对话框,直接在场景中选择物体" pos:[17,106] width:132 height:46
			
		on selectObj_btn pressed do
		(
			try
			(
			theobj = getnodebyname thename_edit.text
			select theobj
			selnameflag = true	
			--max zoomext sel all
			)catch(messagebox"场景中没有叫这个名字的物体!")
		)
	)
--------------------------------   选择合并相同材质的物体   -----------------------------------------
	
  rollout attachMeshes "合并相同材质的物体" width:162 height:90
  (
  	label lbl1 "还有重复材质模型:" pos:[10,12] width:125 height:21
  	button btn_ok "合并处理" pos:[8,60] width:146 height:20
  	label lbl_disp "" pos:[7,33] width:146 height:23
	fn matnum =
	(
		mtl = #() ; tmp = #() ; fin = #()
		flag=0
		sel = geometry as array
		sel = for i in sel where canConvertTo i Editable_mesh collect i
		for i in sel do
		(
			if findItem mtl i.material == 0 do
				append mtl i.material
		)			
		 for m in mtl do
		(
			tmp = for i in sel where i.material == m collect i
			append fin tmp
		)				
		 for i in fin do
		(
			if i.count > 2 do
			(	
				flag=flag+i.count
			)
		)
		lbl_disp.Text=flag as string
		if lbl_disp.Text == "0"do
		(
			lbl_disp.Text = "没有再需要合并的模型了！"
		)
	)
	
	fn mergemat =
	(
		try(
			heatsize = 600000000-heapsize
		)catch()
		mtl = #() ; tmp = #() ; fin = #()
		sel = geometry as array
		sel = for i in sel where canConvertTo i Editable_mesh collect i
			
		for i in sel do
		(
			if findItem mtl i.material == 0 do
				append mtl i.material
		)
		num=0 
		flag=true
		for m in mtl where flag == true  do
		(
			tmp = for i in sel where i.material == m collect i
				if(tmp.count>2)then
					num=num+tmp.count
			if(num<2000 and tmp.count>2) then
			(
				append fin tmp
			)
			else if(num>2000)then
			(
				if(fin.count<1)then
				   append fin tmp
				flag =false
				  
			)
		)				
		for i in fin do
		(
			--if i.count > 2 then
			--(				
				trg = snapshot i[1]
				selectMore trg
				delete i[1] -- del source obj
				deleteItem i 1 -- del item array
				for j in i do
					meshop.attach trg j attachMat:#IDToMat condenseMat:true		
		--	)
		)
-- 		messagebox "success"
	)

  	on attachMeshes open  do
	(
	matnum()
  	)
  	on btn_ok pressed do
  	(
  		mergemat()
  		matnum()
  	)
  )
	rollout checkfaceNumRollout "检查模型面数面板" width:162 height:250
	(
		button checkN_btn "1.检查模型面数" pos:[11,11] width:134 height:28
		label lbl16 "2.如果有错误报告，选择报告里面的物体并detach，如果没有报告，请直接点击关闭！" pos:[13,49] width:134 height:60
		button sel_mesh_btn "3.选择物体" pos:[15,107] width:132 height:25
		button detach_btn "5.detach" pos:[17,175] width:127 height:28
		label lbl17 "4.转成Editablepoly，以6w面为上限，选择element" pos:[14,140] width:128 height:29
		button closeop "关闭" pos:[22,216] width:120 height:23
		on checkN_btn pressed do
		(
			local delFlag = false
			local msgboxFlag = true
			checkFaceNum delFlag msgboxFlag
		)
		on sel_mesh_btn pressed do
		(
			createdialog selbyname
		)
		on detach_btn pressed do
		(
			facesel = polyop.getFaceSelection $
			polyop.detachFaces $ facesel asNode:true

			)
	)
	
	--
	fn renamemesh =
	(
		--disableSceneRedraw()
		--先去掉场景中带#号的mesh名的#号后的名字内容
		for i = geometry do
		(
			fdstr = findString (i.name) "#"
			if fdstr != undefined do
			(
				i.name = substring (i.name) 1 (fdstr-1)
			)
		)
		myobj = #()
		local subname
		--加上#号重命名
		for i = geometry do
		(
			fdstr = findString (i.name) "#"
			flag = 0
			if fdstr != undefined then
			(
				subname = substring (i.name) 1 (fdstr-1)
				if(finditem myobj subname ==0)then
				(
					append myobj subname
					flag = 1
				)
			)
			else
			(
				flag = 1
				subname = i.name
			)
			if(flag == 1)do
			(
				instancemgr.getinstances i &instances
				n2=1
				for j in instances do 
				(
					j.name=subname+"#"+(n2 as string)
					n2+=1
				)
			 )
		)
		--若加上#号后还有模型重名,在其名前加上一个字母
		arrySname = #()
		strasc = "abcdefghijklmnopqrstuvwxyz"
		errnum =0
		for i = geometry do
		(
			iname = i.name
			if(finditem arrySname iname ==0)then
			(
				append arrySname iname
			)
			else
			(
				iflag = true
				tmpname=""
				fdstr = findString (i.name) "#"
				for ia =1 to 26 while  iflag == true do
				(
					tmpname = substring strasc ia 1
					postname = replace iname fdstr 1 (tmpname+"#")
					if(finditem arrySname postname ==0)then
					(
						iflag = false
						instancemgr.getinstances i &instances
						for j in instances do 
						(	
							jname = replace j.name fdstr 1 (tmpname+"#")
							append arrySname jname
							j.name= jname
						)
					)
					--这种情况出现的可能性较小
					if ia==26 do 
					(
						str = "模型"+iname+"重名,没有重命名成功!"
						print str
						errnum +=1
					)
				)
			)	
		)
		if (geometry.count != 0 and errnum == 0) then 
			messagebox "模型名字重命名成功!"
		else
		(
			--str = "场景中没有模型或有"+(errnum as string)+"个模型重名,请手动进行修改!"
			str = "A13——场景中模型重名太多,还有"+(errnum as string)+"个模型须重名,请手动进行修改!"
			messagebox str
		)
	)
	
	
	rollout renameGRollout "给地面重命名" width:162 height:71
	(
		label sel_g_lbl "1.请选择所有地面，不要单选" pos:[12,10] width:140 height:29
		button rename_g_btn "2.点击开始重命名" pos:[12,41] width:140 height:26 toolTip:""
		on rename_g_btn pressed do
		(
			sel = getcurrentselection()
			if sel.count > 0 then
			(
				for i=1 to sel.count do
				(
					sel[i].name = "gnd" + (i as string)
				)
				messagebox"给地面命名完成！请进入下一步操作"
			)else(messagebox"请选择地面物体！")
		)
	)
	rollout renameWRollout "给水面重命名" width:162 height:71
	(
		label sel_w_lbl "1.请选择所有水面，不要单选" pos:[12,10] width:140 height:29
		button rename_w_btn "2.点击开始重命名" pos:[12,41] width:140 height:26 toolTip:""
		on rename_w_btn pressed do
		(
			sel = getcurrentselection()
			if sel.count > 0 then
			(
				for i=1 to sel.count do
				(
					sel[i].name = "wtr" + (i as string)
				)
				messagebox"给地面命名完成！请进入下一步操作"
			)else(messagebox"请选择水面物体！")
		)
	)
	rollout texpath "texpath" width:404 height:94
	(
		edittext edt1 "贴图路径：" pos:[4,58] width:322 height:21
		button btn_chan "处理" pos:[338,55] width:52 height:28
		label texPath_lbl "将scene文件夹下的贴图文件夹路径拷贝到下面！如：D:\p\daxue\src\art\scene\diffuse " pos:[9,11] width:325 height:32
		
		on btn_chan pressed do
		(
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
						diffuse_map = itsmat.diffuseMap
						if diffuse_map == undefined do
						(
							messagebox (iobjt.name + "[" + itsmat.name + "] has no diffuse map!")
							return False
						)
						 tmtexfilename = diffuse_map.filename
						 texNameArr = filterString tmtexfilename "\\."
						 texname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]
						
						
						 itsmat.diffuseMap.filename = (edt1.text)+ "\\" +texname
					)
				)
			)
			messagebox"贴图路径设置完毕,可以进行下一步！"
		)
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
	
	rollout errorMeshto "错误模型处理" width:278 height:411
	(
		label gj_lbl "1.根据plan\问题 中的列表找到错误mesh名称,填到下面的框中，点击选择" pos:[12,33] width:252 height:30
		button selectbyname_btn "选择(sel)" pos:[190,66] width:73 height:23
		button checkone_btn "2.检查单物体坏面(checkone)" pos:[13,93] width:252 height:30
		label lbl_bitmap "3.如果能看到选择的面，就手动处理" pos:[13,129] width:249 height:21
		button deleteface_btn "4.删除坏面(delbadPoly)" pos:[15,170] width:248 height:29
		button closethis_btn "关闭窗口" pos:[17,373] width:248 height:30
		button btn_doModify "1.显示大于四边形的面" pos:[17,294] width:247 height:29 enabled:true
		edittext edt_meshname "" pos:[15,67] width:167 height:19
		GroupBox grp1 "坏面问题" pos:[5,14] width:268 height:192
		label lbl3 "如果看不到就执行第4步，删除坏面！" pos:[24,150] width:234 height:23 enabled:true
		GroupBox grp2 "大于四边形问题" pos:[6,273] width:266 height:93
		GroupBox grp5 "ID问题" pos:[5,210] width:266 height:58
		button btn11 "1.显示模型上在Mat里缺少ID的面(ID)" pos:[17,231] width:247 height:29 enabled:false
		--abc

		button btn_modifyN "2.修改四边形" pos:[17,326] width:247 height:29 enabled:true
		/* button btn_modify "2.修改四边形（有闪面手动）" pos:[17,361] width:187 height:29 enabled:true
		
		button btn_modifyEnd "修改完成" pos:[206,361] width:59 height:29 enabled:true */
	/* 	on btn_modify pressed do
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
-- 			meshOps.visibleEdge obj
-- 			converttopoly obj
			meshOps.startTurn obj
		) */
		
		/* on btn_modifyEnd pressed do
		(
			if selection[1]== undefined then 
			(
				messagebox ("没有选中修改物体！")
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
		) */

		on selectbyname_btn pressed do
		(
			--createdialog selbyname
			errflag = true
			try
			(
				theobj = getnodebyname edt_meshname.text
				select theobj
				errflag = false	
				--max zoomext sel all
			)catch(
				messagebox"场景中没有叫这个名字的物体!"
			)
			if errflag == false do
			(
				--最大化viewport与所选物
				act=#()
				act=getViewSize()
				max tool maximize
				base=#()
				base=getViewSize()
				if(act[1]>=base[1])do (max tool maximize)
				--
				--找到所有与些模型有关的Instance模型并记录下来
				obj = selection[1]
				instancemgr.getinstances obj &instances
				--for i in instances do append arrobj i
				subobjectLevel = 0
				max modify mode
				ResetXForm obj
				convertToPoly obj
				obj_pos = obj.transform
				objpos=obj.pos
				obj.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] objpos)
				--ResetXForm fake_obj
				--max tool maximize
				max zoomext sel all
				btn_doModify.enabled = true
				--messagebox "已准备好,请操作:"
			)
			
		)
		on checkone_btn pressed do
		(
			local selFlag = true -- check by selected or auto check (by name).
			local deleteFaces = false -- obsolete param
			local delFlag = false -- delete after check.
			local msgboxFlag = false -- show msgbox after each checking.
			local handle = "select" -- what to do after find error.
			
			checkMeshFace selFlag deleteFaces delFlag msgboxFlag handle
		)
		on deleteface_btn pressed do
		(
			selface = $.selectedFaces 
			selface_arr = selface as bitarray 
			meshop.deleteFaces $  selface_arr
			update $
		
		-- 			checkMeshFace deleteFaces=true
			setFaceSelection $ #{}
			subobjectLevel = 0
		)
		on closethis_btn pressed do
		(
			destroydialog errorMeshto
		)
		on btn_doModify pressed do
		(
			checkMeshSingle()
		)
		on btn11 pressed do
		(
			try(
				select obj
				instanceReplace arrobj obj
				obj.transform = obj_pos
				ResetXForm obj
				convertToPoly obj
			)catch( messagebox "操作失败,请重新操作")
			btn_doModify.enabled = false
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
	
	
	rollout uv_tool "uv检查" width:171 height:53
	(
		button selmesh_btn "1.选择物体(selectbyName)" pos:[4,4] width:160 height:18
		button uvCheck_btn "2.单选模型检查(checkUV)" pos:[4,25] width:160 height:18
		on selmesh_btn pressed do
		(
			createdialog selbyname
		)
		on uvCheck_btn pressed do
		(
			checkVertUVInfo()
		)
	)
	
	--zhanghongru
	fn thePath =
	(
		p =maxFilePath
		p_arr = filterString p "\\"
		realPath = p_arr[1]+ "\\" + p_arr[2]+ "\\" + p_arr[3]+"\\plan\\问题\\错误信息.txt"
	)
	
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
	
	fn CheckName =	  --@zhanghongru E10——max名称有空格，请按照制作规范修改正确！
	(
		sceneName =  maxFileName
		if (findString maxFileName " "!=undefined ) then
		(
			messagebox ("E10——max名称有空格，请按照制作规范修改正确！")
			errorMsg ="E10——max名称有空格，请按照制作规范修改正确！"	
			fileName = thePath()
			if ((openfile fileName) == undefined ) then
			(
				out_name = thePath()
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
	
---########################################   rollout框架    #########################################
	rollout version_rollout "版本Ver1.0.5.3" width:171 height:55
	(
		label version_lbl "Copyright (C) 2012 Sanpolo Co.LTD     http://www.spolo.org" pos:[13,7] width:146 height:45
	)
		rollout resetScn_tool "一.重置环境" width:171 height:300
		(
			button sceneRest_btn "1.重置环境(reset)" pos:[4,58] width:160 height:18
			progressBar doit_prog "" pos:[13,81] width:145 height:14 color:(color 255 0 0)
			label lbl_bitmap "2.用bitmap/photometric paths     指认贴图路径" pos:[13,106] width:146 height:35
			label lbl_saveScene "3.设置完路径，保存，重打开    场景！" pos:[12,139] width:154 height:28
			label quebao_lbl "保证项目路径正确：         D:\p\(项目名称)\src\art\scene\max\\" pos:[7,6] width:157 height:48
			button checkEnv_btn "2.环境检查(checkEnv)" pos:[4,180] width:160 height:18
			on sceneRest_btn pressed do
			(
				scene_reset doit_prog
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
			)
		)
			
		
	rollout attach_tool "二.模型处理(1)" width:171 height:300
	(
-- 		button attach_btn "1.合并同材质物体(attachMesh)" pos:[4,4] width:160 height:18
		button checkSameMesh_btn "1.检查同名Mesh(sameNMesh)" pos:[4,5] width:160 height:18
		button faceNum_btn "2.检查模型面数(faceNum)" pos:[4,27] width:160 height:18
-- 		progressBar renameMesh_bar "" pos:[13,124] width:145 height:14 color:(color 255 0 0)
		--button setgroundN_btn "4.地面命名(renameground)" pos:[3,112] width:160 height:18
		--label dandu_lbl "3.保证每个建筑都是单独模型，如果不是，请手动拆开！" pos:[7,48] width:156 height:32
		--label lbl7 "4.单个物体超过300三角面并需要复用的物体，请使用instance的方式复制" pos:[7,87] width:151 height:46
-- 		on attach_btn pressed do
-- 		(
-- 			createdialog attachMeshes
-- 		)

-- 		on renameMesh_btn pressed do
-- 		(
-- 			objs = geometry as array
-- 			for o = 1 to objs.count do
-- 			(
-- 				objs[o].name = "o"+ (o as string)
-- 				renameMesh_bar.value = 100.*o/objs.count 
-- 			)
-- 			messagebox"mesh重命名完毕，请进入下一步操作！"
-- 		)

		/* on setgroundN_btn pressed do
		(
			createdialog renameGRollout
		) */
		on checkSameMesh_btn pressed do
		(
			local delFlag = false
			local msgboxFlag = true
			checkSameNobj delFlag msgboxFlag
		)
		on faceNum_btn pressed do
		(
			local delFlag = false
			local msgboxFlag = true
			
			ckSmallMesh false
			checkFaceNum delFlag msgboxFlag
			ChkTexMapNums()
			ChkSceneFaceNums()
			messagebox "检查完毕,请查看问题文件夹！！！"
		)
	)
	rollout checkmt_tool "三.材质和贴图" width:171 height:300
	(
		button checkmt_btn "1.材质贴图检查(checkMatTex)" pos:[4,4] width:160 height:18
		button settpath_btn "2.设置贴图路径(setPath)" pos:[4,25] width:160 height:18
--  		button renameMatTex_btn "3.材质贴图重命名(rename)" pos:[4,46] width:160 height:18
		button mat_btn "3.处理材质(Mat)" pos:[4,46] width:160 height:18
		on checkmt_btn pressed do
		(
			local delFlag = false
			checkmattex delFlag
			messagebox "检查完毕,请查看问题文件夹！！！"
		)
		on settpath_btn pressed do
		(
			CreateDialog texpath
		)
		
 /*######################################################
  ##  zhanghongru 整合diffuseCo.mcr和vray2std.mcr中的功能
  #######################################################*/
		
		-- diffuseCo.mcr
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
	
	--vray2std.mcr
	fn v2s =
	(
		for o in geometry do 
		(
/* 		if classof o.material == VRayMtl \
			or classof o.material == VRay2SidedMtl \
			or classof o.material == VRayBlendMtl \
			or classof o.material == VRayCarPaintMtl \
			or classof o.material == VRayFastSSS \
			or classof o.material == VRayFastSSS2 \
			or classof o.material == VRayLightMtl \
			or classof o.material == VRayMtlWrapper \
			or classof o.material == VRayOverrideMtl \
			or classof o.material == VRayVectorDisplBake \
			or classof o.material == VRaySimbiontMtl  */
			if classof o.material == VRayMtl do 
			(

				tt = Standardmaterial ()
				tt.diffusemap = o.material.texmap_diffuse
				
		tt.diffuse = o.material.diffuse
				o.material = tt
			)
		if classof o.material == Multimaterial then 
			for m = 1 to o.material.numsubs do
			(
/* 				if classof o.material [m] == VRay2SidedMtl \
				or classof o.material [m] == VRayBlendMtl \
				or classof o.material [m] == VRayFastSSS \
				or classof o.material [m] == VRayCarPaintMtl \
				or classof o.material [m] == VRayFastSSS2 \
				or classof o.material [m] == VRayLightMtl \
				or classof o.material [m] == VRayMtlWrapper \
				or classof o.material [m] == VRayOverrideMtl \
				or classof o.material [m] == VRayVectorDisplBake \
				or classof o.material [m] == VRaySimbiontMtl \
				or classof o.material [m] == VRayMtl  */
				if classof o.material [m] == VRayMtl do
				(

				tt = Standardmaterial ()
				tt.diffusemap = o.material[m].texmap_diffuse
				
		tt.diffuse = o.material[m].diffuse
				o.material [m] = tt
				)
			)
			
		)
		actionMan.executeAction 0 "40807"
	)
		
		
		on mat_btn pressed do
		(
			diffuseCo_correct()
			v2s()
		)
--  		on renameMatTex_btn pressed do
-- 		(
-- 		
-- 			checkmat()
-- 			checktexture()
-- 			--messagebox "材质名称超过12字符，以及贴图命名超过8字符已经被重新命名！！！"
-- 			viewport.SetRenderLevel #wireFrame
-- 			 mystr="z"
-- 			 arry=getLocalTime()
-- 			 for i =4 to 8 do
-- 				 mystr=mystr+(arry[i] as string)
-- 			-- print mystr
-- 			messagebox ("开始运行,请选择确定,运行时请勿触碰max，出现对话框才可以结束操作!")
-- 			--mystr ="z"+(timestamp() as string)+(timestamp() as string)
-- 			renametexture mystr
-- 			renametexture "tex_"
-- 			messagebox "贴图重命名成功!"
-- 		) 	
		
	)
	
	/*
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
	
	--end
	*/
	

	--zhanghongru add spp_detach & downPivot 
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
	fn detach_obj = 
	(
		-- detach
		obj = selection[1]
		converttopoly obj
		facelist = polyop.getFaceSelection obj
		num = facelist.numberset
		if num > 0 do
		(
			polyOp.detachFaces obj facelist  asNode:true name: "detch_object"
			thenode = getnodebyname "detch_object"
			select thenode
			the_z = thenode.min.z
			the_x = thenode.center.x
			the_y = thenode.center.y
			thenode.pivot = [the_x,the_y,the_z]
			resetxform thenode
			converttopoly thenode
			thenode.name = "detach_obj"
		)
	)
	fn rename_objo =
	(
		rename_arr =#()
		for i in geometry do
		(
			n = i.name
			if n == "detch_obj" do
			(
				append rename_arr i
			)
		)
		for j=1 to rename_arr.count do
		(
			rename_arr[j].name = "ooo" + (j as string)
			
		)	
	)
	rollout mesh_tool "四.模型处理(2)" width:175 height:300
	(
		button detachM_btn "拆分物体(detach)" pos:[4,8] width:160 height:18
		button dpoint_btn "规范坐标位置(Dpoint)" pos:[4,29] width:160 height:18
		button checkMesh_btn "1.场景模型检查(checkMesh)" pos:[4,73] width:160 height:18
		button errorMesh_btn "4.错误处理(errorMesh)" pos:[4,146] width:160 height:18
		button checkUV_btn "5.错误UV检查(checkUV)" pos:[4,167] width:160 height:18
		label lbl3 "3.如果有同名物体的错误，请从场景找出，改成新名即可！" pos:[7,115] width:156 height:33
		radiobuttons checkMode_rdo "" pos:[5,55] width:136 height:16 labels:#("自动查", "选择查") default:1 columns:2
		button btn_clnUnspportedObj "2.清除不支持的工具对象" pos:[4,94] width:160 height:18
		on detachM_btn pressed do
		(
			detach_obj()
		)
		
		on dpoint_btn pressed do
		(
			down_pivot()
		)
		on checkMesh_btn pressed do
		(
			local delFlag = false
			local msgboxFlag = true
            checkMesh delFlag
			checkUnsupportedObject delFlag
			if  checkMode_rdo.state == 1 do
			(
				local selFlag = false -- auto check all obj in scene, not only selected ones.
				local handle = "log" -- create error log file after find error.
				checkMeshFace selFlag false delFlag msgboxFlag handle
			)
			if  checkMode_rdo.state == 2 do
			(
				local selFlag = true
				local handle = "log" -- create error log file after find error.
				checkMeshFace selFlag false delFlag msgboxFlag handle
			)
			
		)
		on errorMesh_btn pressed do
		(
			CreateDialog errorMeshto
		)
		on checkUV_btn pressed do
		(
			createdialog uv_tool
		)
		on btn_clnUnspportedObj pressed do
		(
			local delFlag = true
			checkUnsupportedObject delFlag
			/*
			-- comment by chenyang
			-- spp:ticket:2469#comment:28
			--------------------------- deleting missing maps
			print "Deleting missed maps:"
			for i in scenematerials do
			(
				delete_missed_maps i
			)
			*/
			-----------------------------
			messagebox "不支持的对象已清除完成"
			
		)
	)


	--ckHudFaceCross true 作为检查cross,true为选择模型检查,fasle为文案使用检查
	
	
	/**
	 * @brief 五.规范命名 -> 给天空球重命名
	 */
	rollout rlt_renameSky "给天空球重命名" width:162 height:71
	(
		label sel_g_lbl "1.请选择所有天空球，不要单选" pos:[12,10] width:140 height:29
		button rename_g_btn "2.点击开始重命名" pos:[12,41] width:140 height:26 toolTip:""
		on rename_g_btn pressed do
		(
			renameSelection "sky"
		)
	)
	/**
	 * @brief 五.规范命名 -> 给植物重命名
	 */
	rollout rlt_renamePlant "给植物重命名" width:162 height:71
	(
		label sel_g_lbl "1.请选择所有植物，不要单选" pos:[12,10] width:140 height:29
		button rename_g_btn "2.点击开始重命名" pos:[12,41] width:140 height:26 toolTip:""
		on rename_g_btn pressed do
		(
			renameSelection "plant"
		)
	)
	/**
	 * @brief 五.规范命名 -> rename selected mesh to building, 
	 * or check if the selected mesh is name with building name format.
	 */
	rollout rlt_renBldg "建筑规范命名" width:162 height:92
	(
		label sel_bldg_lbl "1. 请选择所有建筑物，不要单选" pos:[12,10] width:140 height:29
		button rename_bldg_btn "2.点击开始重命名" pos:[12,41] width:140 height:26 toolTip:""
		button check_bldg_btn "2.检查是否规范命名" pos:[12,62] width:140 height:26 toolTip:""
		on rename_bldg_btn pressed do
		(
			renameSelection "bud"
		)
		on check_bldg_btn pressed do
		(
			checkMeshNamePrefixOfSelection "bud"
		)
	)
	/**
	 * @brief 五.规范命名
	 * rule : "prop123"
	 * rename selected mesh to props.
	 * check if the selected mesh is name with props name format.
	 */
	rollout rlt_renProp "小品规范命名" width:162 height:92
	(
		label sel_prop_lbl "1. 请选择所有小品，不要单选" pos:[12,10] width:140 height:29
		button rename_prop_btn "2.点击开始重命名" pos:[12,41] width:140 height:26 toolTip:""
		button check_prop_btn "2.检查是否规范命名" pos:[12,62] width:140 height:26 toolTip:""
		on rename_prop_btn pressed do
		(
			renameSelection "prop"
		)
		on check_prop_btn pressed do
		(
			checkMeshNamePrefixOfSelection "prop"
		)
	)
	--******************本体重命名***************
	function comparemesh obj1 obj2 =
	(
		try(
		o1v = obj1.mesh.verts.count	
		o1f = obj1.mesh.faces.count
		o1e = obj1.mesh.edges.count
		o2v = obj2.mesh.verts.count
		o2f = obj2.mesh.faces.count
		o2e = obj2.mesh.edges.count
		)catch(return false)
		if o2v == o1v THEN 		
			if o2f == o1f THEN		
				if o2e == o1e THEN	
				(
					return true
				)
				else return false
			else return false
		else return false
	)
	function comparemats obj1 obj2 =
	(
		m1 = obj1.material
		m2 = obj2.material
		if m1 == m2 then 
			return true
		else 
			return false 
	)
	function comparesize obj1 obj2 =
	(
		theoldtransform2 = obj2.transform
		obj2.transform = obj1.transform	
		vnums = obj1.mesh.verts.count
		icount = 0
		for i = 1 to 7 do
		(	
			rdnum1 = random 1 vnums
			rdnum2 = random 1 vnums
			rdnum3 = random 1 vnums
			while(rdnum1 == rdnum2)do
			(
				rdnum2 = random 1 vnums
			)
			while(rdnum1 == rdnum3 or rdnum2 == rdnum3)do
			(
				rdnum3 = random 1 vnums
			)
			
			obj1p1 = (getVert obj1 rdnum1)
			obj1p2 = (getVert obj1 rdnum2)
			obj1p3 = (getVert obj1 rdnum3)
			obj2p1 = (getVert obj2 rdnum1)
			obj2p2 = (getVert obj2 rdnum2)
			obj2p3 = (getVert obj2 rdnum3)
			
			obj1line1 = distance obj1p1 obj1p2	
			obj1line2 = distance obj1p1 obj1p3
			obj2line1 = distance obj2p1 obj2p2
			obj2line2 = distance obj2p1 obj2p3
			bili1 = (float)(obj1line1/obj1line2)
			bili2 = (float)(obj2line1/obj2line2)
			tmpd = abs (bili2 - bili1)
			if(tmpd <= 1.0e-6) then
			(
				icount += 1
			)
		)
		obj2.transform = theoldtransform2	
		
		--print icount
		if(icount > 5) then
			return true
		else 
			return false
		--return true
	)

	-- main function comparison
	function similarobjects obj1 obj2  =
	(
		if (comparemesh obj1 obj2) != true then
			return false
		if (comparemats obj1 obj2) != true then
			return false 
		if (comparesize obj1 obj2) != true then 
			return false
		else
			return true
	)

	fn renameontology =
	(
		--处理下划线
		for iobj in geometry do
		(
			iobjname = iobj.name
			idx = findString iobjname "_"
			if (idx != undefined) then
			(
				iobj.name = substring iobjname 1 (idx-1)
			)
		)
			
	
		disablesceneredraw() -- disable scene redraw
		arrChange = #() --记录模型是事遍历过
		for i=1 to geometry.count do 
		(
			iobj = geometry[i]
			if(classof iobj.baseobject != Editable_Mesh)then
					convertToMesh iobj
			arrChange[i] = false
		)
		theobjs = geometry as array
		arrSameMesh = #()
		gemcount = theobjs.count
		for i=1 to gemcount-1 do
		(
			thecompare = theobjs[i]
			if(arrChange[i] == false)then
			(
				arrChange[i] = true
				tmparr = #(thecompare)
				for ii = (i+1) to gemcount do
				(
					obj = theobjs[ii]
					sameflag = similarobjects thecompare obj 
					if(sameflag == true)then
					(
						append tmparr obj
						arrChange[ii] = true
					)
				)
				--if(tmparr.count>1)then
					append arrSameMesh tmparr
			)
		)
		for i=1 to geometry.count do 
		(
			iobj = geometry[i]
			if(arrChange[i] == false)then 
			(
				tmparr = #(iobj)
				append arrSameMesh tmparr
			)
		)
		arrName = #()
		for i = 1 to arrSameMesh.count do
		(
			chgname = "obj"
			bkflag = false
			tmpname = ""
			for j = 1 to arrSameMesh[i].count while bkflag == false do
			(
				orgname = arrSameMesh[i][j].name
				nameidx = findString orgname "#"
				if(nameidx != undefined)then
					tmpname = substring orgname 1 (nameidx-1)
				else
					tmpname = orgname
				fs = finditem arrName tmpname
				if(fs == 0)then
				(	
					append arrName tmpname
					bkflag = true
				)
			   --在处理重命名时,有些不能改的名字前缀
			   arrnivaryame = #("sky", "plant", "wtr", "gnd")
			   subbkflag = false
			   for i=1 to 4 while (subbkflag==false) do 
			   (
					idx = findString orgname arrnivaryame[i]
					if(idx != undefined)then
					(
						chgname = arrnivaryame[i]
						subbkflag = true
					)
			   )
			)
			if(bkflag == false)then
			(
			   
				nameidx = 1;
				tmpname = chgname + (nameidx) as string
				while(finditem arrName tmpname != 0)do
				(
					nameidx = nameidx+1
					tmpname = chgname + (nameidx) as string
				) 
				append arrName tmpname
			)
			--以上代码防止模型名字重复,
			arrValue = arrSameMesh[i]
			count = arrValue.count
			for ii=1 to count do 
			(
				--orgname = arrValue[ii].name
				arrValue[ii].name = tmpname +"#" + ii as string
				--print (orgname +" change: "+ arrValue[ii].name)
			)
		)
		enablesceneredraw()
	)
	--over
	global seed_state
	
-- copy_replace 
-- 	先选择target mesh
-- 	再选择需要替换的meshes
-- 	执行copy_replace命令
-- 	（勾选R 为随机；不勾选，为正常替换）
	
	fn first_other_sel = 
	(
		first_other_sel_arr = #(undefined,#())
		all_sel = getcurrentselection()
		first_sel = (getcurrentselection())[1]
		other_sel = deleteItem all_sel 1
		first_other_sel_arr[1] = first_sel
		first_other_sel_arr[2] = other_sel
		return first_other_sel_arr
		
	) --  #(#(first_sel),#(other_sel))
	
	
	fn copy_replace isR = 
	(
		sel = first_other_sel()
		for i = 1 to sel[2].count do
		(
			copy_one = copy sel[1]
			
			if isR == true do
			(
				copy_one.pos = sel[2][i].pos 
				ang = random 1 360
				rotate copy_one (angleaxis ang [0,0,1])
			)
			if isR == false do
			(
				copy_one.transform = sel[2][i].transform
			)
		)
		aa = select sel[2]
		max delete 	
	)

	---------------------------------------------------------------
--   copy_seed
--  	先选择target mesh
-- 	在需要种植的地方点选即可
-- 	执行copy_seed命令
-- 	（勾选R 为随机；不勾选，为正常替换）	
	

/* 	fn getR =
	(
		return chkbox.checked
	) */
	fn copy_seed =
	(
		--global isR
		--messagebox (isR as String)
		tool plantCreator 
		(	
-- 			local isR
			fn plantcreat_fn =
			(
				tar_arr = #()
				sel_cnt = selection.count
				if sel_cnt == 1 then
				(
					append tar_arr selection[1]
					
				)else if sel_cnt > 1 then
				(
					messagebox"只能选择一个物体！！"
					
				)else if sel_cnt < 1 then
				(
					messagebox"请选择一个物体！！"
				)
				tar_arr 
			)
			-- mousepoint mousemove 
			on mousepoint clickno do 
			(
				tar = plantcreat_fn()
				copyobj = copy tar[1]
				format"% \n" gridDist 
				copyobj.pos = worldPoint
				if seed_state == true do
				(
					ang = random 1 360
					rotate copyobj (angleaxis ang [0,0,1])
				)
			)
		)
		starttool plantCreator 
	)
	
	rollout seed_replace_plant "种树" width:164 height:61
	(
		checkbox replace_r_chk "Checkbox" pos:[25,9] width:15 height:19
		label lbl1 "R" pos:[12,9] width:11 height:19
		button replace_btn "替换(replace)" pos:[48,8] width:110 height:20
		checkbox seed_r_chk "Checkbox" pos:[25,36] width:15 height:19
		label lbl2 "R" pos:[12,36] width:11 height:19
		button seed_btn "种树(seed)" pos:[48,35] width:110 height:20
-- 		slider dist_sld "" pos:[11,61] width:146 height:25

		on replace_btn pressed do
		(
			re_state = replace_r_chk.state
			if re_state == false then
			(
				copy_replace false
				
			)else if re_state == true do
			(
				copy_replace true
			)
		)
		on seed_btn pressed do
		(
			seed_state = seed_r_chk.state
			if seed_state == false then
			(
				copy_seed()
			)else if seed_state == true do
			(
				copy_seed()
			)
		)
	)
	
	rollout plant_tool "植物" width:170 height:60
	(
		button btn_replace "1.替换/种植(replace)" pos:[4,4] width:160 height:21
		button btn_cross "2.检查HUD交叉(cross)" pos:[4,30] width:160 height:24
		on btn_replace pressed do
		(
			try destroydialog seed_replace_plant catch()
			createdialog seed_replace_plant
		)
		on btn_cross pressed do
		(
			ckHudFaceCross true
		)
	)
	
	--ground edit
	rollout GEditRollout "地形编辑" width:157 height:106
	(
		button btn_slice "细分" pos:[9,8] width:65 height:26
		button btn_undo "撤消细分" pos:[84,8] width:65 height:24
		button btn_softsel "soft selection" pos:[9,38] width:96 height:27
		spinner spn2 "" pos:[106,40] width:45 height:16 enabled:false range:[-1000,1000,0] scale:1
		button btn_ok "完成" pos:[9,68] width:140 height:29
		local SliceValue
		local Xmax
		local Xmin
		local Ymax
		local Ymin
		local SPlane
		local selFace
		local VertsArray
		local RayPlus
		local currsliceobj
		--SliceValue
		----round function---- need to fix float bugs
		fn round_to val n:3 = 
		(
		local mult = 10.0 ^ n
		(floor ((val * mult) + 0.5)) / mult
		)

		--Func creates help dummy grid and invisible dummy with given direction (imho it is easy to calc so)
		fn CreateGrid pos:[0,0,0] lsegs:4 =  (
			 SLPlane  = plane name:"SLPlane" length:(4*SliceValue) width:(4*SliceValue) lengthsegs:lsegs widthsegs:4 wirecolor:red
			setTransformLockFlags $SLPlane  #{4,5,7,8,9}
			try (delete $InvisDummy) catch true
			InvisDummy  = box name:"InvisDummy" length:1 width:1  height:10
			setTransformLockFlags $InvisDummy  #{4,6}
			$InvisDummy.dir = [1,0,0]
			$InvisDummy.parent = $SLPlane
			hide $InvisDummy
		)
		---making slice function---
		fn SliceGrid A  =
		(
			
			If A == 1 then   								--Negative X direction, if slice direction will go from Xmin, Ymax and up
				(
			SPlane  = (ray [Xmax,Ymin,0]  RayPlus)
			SPlane.pos = $SLPlane.pos - ((RayPlus*SliceValue)*(floor (distance $SLPlane.pos [Xmax,Ymin,0]/SliceValue)+1))
				for i=1 to (floor (distance [Xmin,Ymax,0] [Xmax,Ymin,0]/SliceValue)+1) do 
					(

				SPlane.pos=SPlane.pos+(SPlane.dir*SliceValue)
				selFace = polyop.getFaceSelection $ as array
				PolyOp.slice $  selFace SPlane 
					)
				selFace = polyop.getFaceSelection $ as array
				) 
				If A == 2 then   							--Positive X direction...from Xmin, Ymin, and up
				(
				SPlane  = (ray [Xmin,Ymin,0]  RayPlus)
				SPlane.pos = $SLPlane.pos - ((RayPlus*SliceValue)*(floor (distance $SLPlane.pos [Xmin,Ymin,0]/SliceValue)+1))
				
				for i=1 to (floor (distance [Xmin,Ymin,0] [Xmax,Ymax,0]/SliceValue)+1) do 
					(
				SPlane.pos=SPlane.pos+(SPlane.dir*SliceValue)
				selFace = polyop.getFaceSelection $ as array
				PolyOp.slice $  selFace SPlane 
					)
				selFace = polyop.getFaceSelection $ as array
				) 
				If A == 3 then 							 -- X ==0
				(
				SPlane  = (ray [Xmin,Ymin,0]  RayPlus)
				SPlane.pos  = [$SLPlane.pos[1] - ((floor ((distance [Xmin,0,0]  [$SLPlane.pos[1],0,0])/SliceValue)+1)*SliceValue),$SLPlane.pos[2] - ((floor ((distance [0,Ymin,0]  [0,$SLPlane.pos[2],0])/SliceValue)+1)*SliceValue),0]

					while SPlane.pos[2]<Ymax do 
						(
					SPlane.pos=SPlane.pos+(SPlane.dir*SliceValue)
					selFace = polyop.getFaceSelection $ as array
					PolyOp.slice $  selFace SPlane 
						)

				) 
				If A == 4 then   							-- Y ==0  
				(
				SPlane  = (ray [Xmin,YMin,0]  RayPlus)
				SPlane.pos  = [$SLPlane.pos[1] - ((floor ((distance [Xmin,0,0]  [$SLPlane.pos[1],0,0])/SliceValue)+1)*SliceValue),$SLPlane.pos[2] - ((floor ((distance [0,Ymin,0]  [0,$SLPlane.pos[2],0])/SliceValue)+1)*SliceValue),0]
				
					while SPlane.pos[1]<Xmax do 
						(
					SPlane.pos=SPlane.pos+(SPlane.dir*SliceValue)
					selFace = polyop.getFaceSelection $ as array
					PolyOp.slice $  selFace SPlane 
						)

				) 
			)
						
		on GEditRollout open do
		(
			try(
				if selection.count > 0 then
				(
					if not viewport.isWire()then max wire smooth
					convertToPoly selection[1]
					subobjectLevel = 4
				)
			)
			catch()
		)
		on GEditRollout close do
		(	
			try(
				delete $SLPlane
				delete $InvisDummy
			)catch()		
		)
		on btn_slice pressed do
		(	
			fn PrepSlice = (		
				ResetXForm $
				collapsestack $
				holdMaxFile()                                          --- hold if needed
				SliceValue = 10
				--SliceValue = s1.value
					------computing min/max points
				VertsArray = polyOp.getVertsUsingFace $ (polyOp.getFaceSelection $) as array
				Xmax = (PolyOp.getvert $ VertsArray[1] )[1]
				Xmin = (PolyOp.getvert $ VertsArray[1] )[1]
				Ymin = (PolyOp.getvert $ VertsArray[1] )[2]
				Ymax = (PolyOp.getvert $ VertsArray[1] )[2]
				for v=1 to VertsArray.count do (  if (PolyOp.getvert $ VertsArray[v])[1] > Xmax  then Xmax = (PolyOp.getvert $ VertsArray[v])[1] )
				for v=1 to VertsArray.count do (  if (PolyOp.getvert $ VertsArray[v])[2] > Ymax  then Ymax = (PolyOp.getvert $ VertsArray[v])[2] )
				for v=1 to VertsArray.count do (  if (PolyOp.getvert $ VertsArray[v])[1] < Xmin  then Xmin = (PolyOp.getvert $ VertsArray[v])[1] )
				for v=1 to VertsArray.count do (  if (PolyOp.getvert $ VertsArray[v])[2] < Ymin  then Ymin = (PolyOp.getvert $ VertsArray[v])[2] )
				---------computing positive Y only ray--------------
				names = for i in objects collect i.name
				if findItem names "InvisDummy" == 0 then CreateGrid lsegs:4
		
		
				RayPlus=$InvisDummy.dir
				RayPlus = [round_to RayPlus[1], round_to RayPlus[2],0]
				if (RayPlus[1]<=0 and RayPlus[2]<=0) then
					( 
					--messagebox "3!"
					RayPlus = [abs RayPlus[1], abs RayPlus[2],0]
					)
					else
					If (RayPlus[1]>0; RayPlus[2]<0) then
					(
					--messagebox "4!"
					RayPlus = [-RayPlus[1], -RayPlus[2],0]
					)
				RayPlus = [round_to RayPlus[1], round_to RayPlus[2],0]
				
				--print RayPlus
				
				(
					case  of (
					(RayPlus[1] == 0) : SliceGrid 3
					(RayPlus[2] == 0) : SliceGrid 4
					(RayPlus[1]<0 and RayPlus[2] !=0) :SliceGrid 1
					(RayPlus[1]>0 and RayPlus[2] !=0) : SliceGrid 2
										)
		
					--rotating vector
					If RayPlus[1]>0 then
					RayPlus = [-RayPlus[2], RayPlus[1],0]
					else
					RayPlus  = [RayPlus[2],-RayPlus[1],0]
						
					case  of (
					(RayPlus[1] == 0) : SliceGrid 3
					(RayPlus[2] == 0) : SliceGrid 4
					(RayPlus[1]<0 and RayPlus[2] !=0) : SliceGrid 1
					(RayPlus[1]>0 and RayPlus[2] !=0) : SliceGrid 2
					)
				)
				redrawViews()
			)
			-----------------Checking selection-----------------
			if (selection.count != 0 and (classof $ ==Editable_Poly or classof $ == Editable_mesh))
			then
			(
				currsliceobj = $ --
				if classof $ == Editable_Poly then
				( 
					if subobjectlevel == 4 then
					(
						if (PolyOp.getfaceselection $ as array).count != 0 then PrepSlice() else messagebox "No faces selected!"
					) else messagebox "No faces selected!"
				)
											
				if classof $ == Editable_Mesh then
					if subobjectlevel == 4 then
						( 
							if (getfaceselection $ as array).count !=0 then
							(
								convertTo $ PolyMeshObject
								subobjectlevel = 4
								if (PolyOp.getfaceselection $ as array).count != 0 then PrepSlice()  else messagebox "No faces selected!"
								convertTo $ TriMeshGeometry
								subobjectlevel = 4
							)  else messagebox "No faces selected!"
					)  else messagebox "No faces selected!"
			)
			else messagebox "Select Mesh or Poly!"		
		
			try(
				delete $SLPlane
				delete $InvisDummy
			)catch()		
							
							
		)
		on btn_undo pressed do
		(	
			fetchMaxFile quiet:true
			try(
				convertToPoly currsliceobj
				subobjectLevel = 4
			)catch()
		)
		on btn_softsel pressed do
		(
			spn2.enabled = false
			
			if selection.count > 0 then 
				currsliceobj = selection[1]
			else if(currsliceobj == undefined)then
			  messagebox "请选择一个模型进行 soft selection"
			
			if(currsliceobj != undefined)then
			(
				select currsliceobj
				convertToPoly currsliceobj
				currsliceobj.useSoftSel = on
				currsliceobj.falloff = 40
				subobjectLevel = 1
				max move
				spn2.enabled = true
				spn2.value = currsliceobj.falloff
			)	
		
		)
		on spn2 changed val do
		(
			try(
				select currsliceobj
				currsliceobj.falloff = spn2.value
			)catch(print"falloff error")
		)
		on btn_ok pressed do
		(   
			try(
				select currsliceobj
				currsliceobj.SetSelection #Vertex #{1.. currsliceobj.GetNumVertices()}
				currsliceobj.weldThreshold = 0.1
				currsliceobj.weldFlaggedVertices()
				subObjectLevel = 0
				spn2.enabled = false
				max move
				currsliceobj.useSoftSel = off
			)catch(print "error")
		)
	)
	
	rollout createMode_tool "五.创建模型" width:170 height:50
	(
		button btn_replace "1.地形编辑(Ground)" pos:[4,5] width:160 height:18
		button btn_cross "2.植物(Plant)" pos:[2,27] width:160 height:18
		
		
		on btn_replace pressed do
		(
			try destroydialog GEditRollout catch()
				createdialog GEditRollout
		)
		on btn_cross pressed do
		(
			try destroydialog plant_tool catch()
			createdialog plant_tool
		)
	)

	rollout meshrename_tool "六.规范命名" width:180 height:106
	(
		button btn_renameground "1.地面命名(renameground)" pos:[4,4] width:160 height:18
		button btn_renameSky "2.天空命名(renameSky)" pos:[4, 25] width:160 height:18
		button btn_renamePlant "3.植物命名(renamePlant)" pos:[4, 46] width:160 height:18
		button btn_renBldg "4.建筑命名(renBldg)" pos:[4, 67] width:160 height:18
		button btn_renProp "5.小品命名(renProp)" pos:[4, 88] width:160 height:18
		--@ticket:1545 liuyingtao提出不再需要改功能
		--@fixme 不仅仅注释掉按钮就好了，还需要把相应函数删除。
		--button btn_renamewater "2.水面命名(renamewater)" pos:[4,25] width:160 height:18
		button btn_renameModel "6.整体规范命名(renameModel)" pos:[4, 109] width:160 height:18
		button btn_checkMeshName "7.检查mesh命名(checkMeshN)" pos:[4, 130] width:160 height:18
		on btn_renameground pressed do
		(
			createdialog renameGRollout
		)
		on btn_renameSky pressed do
		(
			createdialog rlt_renameSky
		)
		on btn_renamePlant pressed do
		(
			createdialog rlt_renamePlant
		)
		on btn_renBldg pressed do
		(
			createdialog rlt_renBldg
		)
		on btn_renProp pressed do
		(
			createdialog rlt_renProp
		)
		on btn_renamewater pressed do
		(
			createdialog renameWRollout
		)
		on btn_renameModel pressed do
		(
			renameontology()	--本体与实例重命名
			messagebox "整体规范命名成功!"
			--renamemesh()		--按instance命名的以后不用,先注释掉
		)
		on btn_checkMeshName pressed do
		(
			local delFlag = false
			local msgboxFlag = true
			checkMeshName(delFlag)
		)
	)
	
			/**********************漫游路径提供的方法*******************************/
	fn createCamera =
	(
		global cameraA
		global cameraB
		global targetA
		--生成的第一条线的名字
		global f_line
		global theCamera
		global theTarget		
		layerCamera = layermanager.newLayerFromName "layerCamera"
		viewport.setGridVisibility #all false

		tool CameraCreator numpoints:3
		(	
			fn F_Spline PointA PointB =
			--创建摄像机轨道线
			(	
				--将在默认层中进行画线
				x=layermanager.getlayerfromname "layerPath"
					if (x==undefined) then
					(
						/*
						layer1 = LayerManager.newLayer()
						layer1.setname "layer01"
						layer1.current =true
						*/
						x = layermanager.newLayerFromName "layerPath"
						x.current=true
					)
					else
						x.current = true
				
				ss = SplineShape pos:PointA  	
				addNewSpline ss
				addKnot ss 1 #smooth #curve  PointA
				addKnot ss 1 #smooth #curve  PointB
				updateShape ss
				--ss		
				f_line = ss
				select ss
				$.vertexTicks = on
				$.wirecolor = color 228 214 153

			)				
			--绑定路径，创建动画
			fn bindCamera theObj spline=
			(
				--thePath = spline				  
				--theObj=cone radius1:6 radius2:0 height:15--create object to travel on path
				theObj.pos.controller=path follow:true constantVel:false--assign path controller to object
				PosCont=theObj.pos.controller --grab the path controller
				PosCont.path=spline --set path to shape node
				--PosCont.axis=2 --point local Z axis along path
				animate on --create keys at?
				(  
					--at time 25 PosCont.percent=25 --frame 30 - 25% along path
					at time 3000 PosCont.percent=100 -- frame 100 - 95% along path
				)
			)	
			--鼠标点击事件
			on mousePoint clickno do 
			(
				if clickno == 1 --如果clickno == 1，表明第一次按下鼠标 
				then 
				(
					--添加camera层
					x=layermanager.getlayerfromname "layerCamera"
					if (x==undefined) then
					(
						/*
						layer1 = LayerManager.newLayer()
						layer1.setname "layer01"
						layer1.current =true
						*/
						x = layermanager.newLayerFromName "layerCamera"
						x.current=true
					)
					else
						x.current = true
					
					
					global cam = freeCamera()
					theCamera=cam			
					cam.type = #target
					theTarget=cam.target
					cam.target.pos = WorldPoint
					cam.pos = worldPoint
					targetA=cam.pos	
				)
				if clickno == 2
				then
				(				
					cameraA=WorldPoint
					select cam
					$.wirecolor = color 154 215 229
					
					for i = 0 to LayerManager.count-1 do (LayerManager.getLayer i).isFrozen = off
					(LayerManager.current).isFrozen = on ; ok

					--print cameraA					
				)
				if clickno == 3
				then
				( 
					cameraB=WorldPoint	
					F_Spline cameraA cameraB	
					selection[1].pos=targetA
					bindCamera theTarget f_line
					F_Spline cameraA cameraB
					bindCamera theCamera f_line
					
				)
			)	
			--鼠标移动事件
			on mouseMove clickno do 
			(		
				if clickno == 1 or clickno==2 then
				(
					cam.pos=worldpoint
				)			
			)	
		)
		starttool CameraCreator				
	)
    /***********************方法结束****************************/
	
	rollout pathNavigation  "七.漫游路径" width:180 height:191
	(
		button btn_createCamera "1.创建摄像机" pos:[4,4] width:160 height:18
		button btn_addKey "2.添加关键帧" pos:[15,45] width:140 height:18
		button btn_modifyPath "3.修改路径" pos:[15,65] width:140 height:18
		button btn_finish "完成" pos:[15,85] width:140 height:18			
		GroupBox pathModify "修改" pos:[5,24] width:160 height:95
		on btn_createCamera pressed do
		(		
			animationRange = interval 0 3000
			createCamera()			
		)
		on btn_addKey pressed do
		(
			try
			(
			max modify mode
			subobjectLevel = 1
			modPanel.setCurrentObject selection[1].baseObject
			splineOps.startInsert selection[1]
			)
			catch
			(
				showproperties $camera01
			)			
		)		
		on btn_modifyPath pressed do
		(			
			try
			(
			max modify mode
			subobjectLevel = 1
			modPanel.setCurrentObject selection[1].baseObject
			)
			catch
			(
				
			)			
		)	
		on btn_finish pressed do
		(
			try
			(
				max modify mode
				subobjectLevel = 0
				modPanel.setCurrentObject selection[1].baseObject				
			)
			catch
			(
				
			)
		)
	)
	
	rollout spp_view "八.引擎预览" width:180 height:56
	(
		button btn_export_x "1.导出x文件(export X)" pos:[12,23] width:149 height:18
		checkbox chk_MgByName "通过名字导meshgen" pos:[9,4] width:146 height:18 checked:true
		GroupBox grp7 "" pos:[7,-5] width:160 height:53
		on btn_export_x pressed do
		(
			export_scene(chk_MgByName.checked)
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
	
	--zhanghongru模型导出
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

	
	rollout MovieLRollout "九.影视工具" width:180 height:191
	(
		button dpoint_btn "1.规范坐标位置(Dpoint)" pos:[4,5] width:163 height:20
		button mtex_btn "2.合并贴图(MTex)" pos:[4,26] width:160 height:18
		button btn_medges "3.黑边处理" pos:[4,47] width:160 height:18
		button btn_modelEp "4.模型导出" pos:[4,68] width:160 height:18
		
		on btn_medges pressed do
		(
			try(destroydialog MEdgeRollout)catch()
			createdialog MEdgeRollout			
		)		
		on mtex_btn pressed do
		(			
			createDialog ro_tag 150 415	
		)
		on dpoint_btn pressed do
		(
			down_pivot()			
		)
		on btn_modelEp pressed do
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
				/* 输出材质 */
				oldname = obj.name
				try
				(
					fsindex=findString (obj.name) "#"
					obj_name = (substring (obj.name) 1 (fsindex-1))
				)
				catch
				(
					messagebox ("命名规范有问题！")
					return 0
				)
				try(filepath = getprojectpath()+"\\src\\art\\scene\\obj\\")catch(return 0)
				makeDir filepath --在当前处理的max路径下建立以对象物体为名的文件夹
				--输出这个文件成一个.x文件，并保存为以物体为名的文件夹内。
				obj_name=obj_name + ".obj"
				filename=filepath + obj_name
				exportfile filename #noPrompt selectedOnly:TRUE
				--exportfile filename #noProm	pt selectedOnly:TRUE
				obj.pos = pos_o
			)
			messagebox ("物体导出成功！")
		)
	)
	
	rollout bake_section "七. 烘培环节 (Bake)" width:171 height:202
	(
		button btn_bake "2.烘焙环境准备 (bake)" pos:[3,22] width:160 height:18
		button btn_reset "4.还原环境(reset bake)" pos:[4,65] width:160 height:18
		button select_unbake "3.断点续选物体" pos:[4,43] width:160 height:18
		button lightmap_export_btn "5.导出 (export)" pos:[8,115] width:154 height:18
-- 		button build_n_view_btn "构建并预览 (build&view)" pos:[4,88] width:160 height:18
		button btn_adjSunPos "1.创建/调整太阳位置" pos:[6,1] width:160 height:18
		checkbox chk_MgByName "通过名字导meshgen" pos:[10,95] width:146 height:18 checked:true
/* 		
		
		fn addUVW obj theMapChannel =
		(
			local unwrapMod = unwrap_UVW()


-- 			unwrapMod.setAlwaysEdit off
			unwrapMod.setMapChannel theMapChannel
-- 			unwrapMod.setFlattenAngle 45.0
-- 			unwrapMod.setFlattenSpacing 0.00
-- 			unwrapMod.setFlattenNormalize on
-- 			unwrapMod.setFlattenRotate on
-- 			unwrapMod.setFlattenFillHoles on
-- 			unwrapMod.setApplyToWholeObject on
-- 			unwrapMod.name = "spp_UVW"

			addmodifier obj unwrapMod

			subobjectLevel = 3

			objs = modPanel.getCurrentObject();
			uv = obj.modifiers[ #unwrap_uvw ]
			nodeFaceNum = uv.numberPolygons()
			uv.selectFacesByNode #{1..nodeFaceNum} obj



			objs.flattenMap 45.0 \
			#([1,0,0],[-1,0,0], [0,1,0],[0,-1,0], [0,0,1],[0,0,-1]) \
			0.01 true 0 true true
			
			return obj
		) */

		fn addUVW obj theMapChannel=
		(
			converttopoly obj
			max modify mode
			unwrapMod = unwrap_UVW()

			unwrapMod.setAlwaysEdit off
			unwrapMod.setMapChannel theMapChannel
			unwrapMod.setFlattenAngle 45.0
			unwrapMod.setFlattenSpacing 0.00
			unwrapMod.setFlattenNormalize on
			unwrapMod.setFlattenRotate on
			unwrapMod.setFlattenFillHoles on
			unwrapMod.setApplyToWholeObject on

			addmodifier obj unwrapMod

			modPanel.setCurrentObject obj.Unwrap_UVW
			uv = modPanel.getCurrentObject();
			if classof (uv) == Unwrap_UVW then
			(
				uv.unwrap2.setTVSubObjectMode 3
-- 				format"%----------%\n" obj uv
				nodeFaceNum = uv.unwrap6.numberPolygonsByNode obj
-- 				format"%----------%\n" obj nodeFaceNum
				uv.unwrap6.selectFacesByNode #{1..nodeFaceNum} obj
				uv.unwrap2.flattenMap 45.0 \
				#([1,0,0],[-1,0,0], [0,1,0],[0,-1,0], [0,0,1],[0,0,-1]) \
				0.01 true 0 true true
				converttopoly obj
			)else
			(
				format"%\n" obj.name
			)
		)
		
		fn createbakew =
		(
			start_timestamp = timestamp()
			
			-- 剔除不是geometry的模型
			objs = #()
			arrbakemesh = #()
			arrbakemesh = for  i in geometry where not (matchPattern i.name pattern:("plant*")) collect i
			try (
				objarry = deepCopy arrbakemesh --deep copy
				if selection.count == 0 then
				(
					messagebox "没有选择任何物体！"
					return false
				)
				else
				(
						objs = for i in selection where (finditem objarry i != 0) collect i
						if objs.count == 0 then 
						(
							messagebox "请重新选择类型为geometry的模型"
							return false
						)
						else
						(
							select objs
						)
				)

			)catch messagebox "pls select objects"
					
			--createdialog bakeNew
			--set all opacityMapEnable off
			for iobj in arrbakemesh do
			(
				mat = iobj.mat
				if((classof mat) == Standardmaterial) then			
				(
					mat.opacityMapEnable = off
				)
				else
				(
					if((classof mat) == Multimaterial) do
					(
						submatnum = getNumSubMtls mat
						for im = 1 to submatnum do
						(
							if(classof (mat[im])) == Standardmaterial do
							mat[im].opacityMapEnable = off
						)
					)
				)
			)
			
			--set all mat alpha
			for iobj in arrbakemesh do
			(
				if(iobj.mat != undefined) do
				(
					if((classof iobj.mat) == Standardmaterial) then			
					(
						if(iobj.mat.diffusemap != undefined) do
						(
							texname_arr = #()
							texname_arr = filterstring iobj.mat.diffusemap.filename "\\ ."
							if((toLower (texname_arr[texname_arr.count])) == "png") do 
							(
								iobj.mat.opacityMap = Bitmaptexture fileName:(iobj.mat.diffusemap.filename)
								iobj.mat.opacityMap.monoOutput = 1
							)
						)
					)
					else
					(
						if((classof iobj.mat) == Multimaterial) do
						(
							submatnum = getNumSubMtls iobj.mat
							for im = 1 to submatnum do
							(
								if(((classof (iobj.mat[im])) == Standardmaterial) and (iobj.mat[im].diffusemap != undefined)) do
								(
									
									
									texname_arr = #()
									texname_arr = filterstring iobj.mat[im].diffusemap.filename "\\ ."
									if((toLower (texname_arr[texname_arr.count])) == "png") do 
									(
										--messagebox "alpha"
										iobj.mat[im].opacityMap = Bitmaptexture fileName:(iobj.mat[im].diffusemap.filename)
										iobj.mat[im].opacityMap.monoOutput = 1
									)
									
								)
							)
						)
					)
				)
			)
			
			--set all diffuseMapEnable off
			for i in arrbakemesh do
			(
				if(i.mat == undefined) do
				(
					continue
				)
				if((classof i.mat) == Standardmaterial) then			
				(
					if(i.mat.diffusemap != undefined)do
					(
						i.mat.diffuseMapEnable = off
						i.mat.Diffuse = color 128 128 128
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
								i.mat[im].diffuseMapEnable = off
								i.mat[im].Diffuse = color 128 128 128
							)
						)
					)
				)
			)
			
			
			
			
			-- setheightmap
			for iobj in arrbakemesh do
			(
				
				
				--iobj = $
				mat = iobj.mat
				
				
				if((classof mat) == Standardmaterial) then			
				(
					if(mat.diffusemap != undefined)do
					(
						 texfilename = mat.diffuseMap.filename
						 texNameArr = filterString texfilename "\\."
						 texname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]
						 
						 texN = ""
						 for itexN =1 to (texNameArr.count-3) do
						 (
							 texN += texNameArr[itexN] + "\\" 
						 )
						 
						 hmapn = texN + "heightmap\\" + "h" + texname
						 
						
						if(getFileSize  hmapn) > 0 do
						(
							mat.displacementMap = Bitmaptexture fileName:hmapn
						)
						 
					)
				)
				else
				(
					if((classof mat) == Multimaterial) do
					(
						submatnum = getNumSubMtls mat
						for im = 1 to submatnum do
						(
							if(((classof (mat[im])) == Standardmaterial) and (mat[im].diffusemap != undefined)) do
							(
								
								 texfilename = mat[im].diffuseMap.filename
								 texNameArr = filterString texfilename "\\."
								 texname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]
								 
								 texN = ""
								 for itexN =1 to (texNameArr.count-3) do
								 (
									 texN += texNameArr[itexN] + "\\" 
								 )
								 
								 hmapn = texN + "heightmap\\" + "h" + texname
								 

								 if(getFileSize  hmapn) > 0 do
								 (
									mat[im].displacementMap = Bitmaptexture fileName:hmapn
								 )							
							)
						)
					)
				)
				
				
			)	
		
		-- setnormalmap =
			for iobj in arrbakemesh do
			(
				
				
				--iobj = $
				mat = iobj.mat
				
				
				if((classof mat) == Standardmaterial) then			
				(
					if(mat.diffusemap != undefined)do
					(
						 texfilename = mat.diffuseMap.filename
						 texNameArr = filterString texfilename "\\."
						 texname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]
						 
						 texN = ""
						 for itexN =1 to (texNameArr.count-3) do
						 (
							 texN += texNameArr[itexN] + "\\" 
						 )
						 
						 nmapn = texN + "normalmap\\" + "n" + texname

						if(getFileSize  nmapn) > 0 do
						(
							mat.bumpMap = Normal_Bump()
							mat.bumpMap.normal_map = Bitmaptexture fileName:nmapn
						)
						 
					)
				)
				else
				(
					if((classof mat) == Multimaterial) do
					(
						submatnum = getNumSubMtls mat
						for im = 1 to submatnum do
						(
							if(((classof (mat[im])) == Standardmaterial) and (mat[im].diffusemap != undefined)) do
							(
								
								 texfilename = mat[im].diffuseMap.filename
								 texNameArr = filterString texfilename "\\."
								 texname = texNameArr[texNameArr.count-1]+"."+texNameArr[texNameArr.count]
								 
								 texN = ""
								 for itexN =1 to (texNameArr.count-3) do
								 (
									 texN += texNameArr[itexN] + "\\" 
								 )
								 
								 nmapn = texN + "normalmap\\" + "n" + texname
								 
								 if(getFileSize  nmapn) > 0 do
								 (
									mat[im].bumpMap = Normal_Bump()
									mat[im].bumpMap.normal_map = Bitmaptexture fileName:nmapn
								 )
							
							)
						)
					)
				)
				
				
			)		
			--process sky
			

			sel = for obj in selection collect obj
			clearselection()
			icount = 0;
			for i in sel do
			(
-- 				print (i.name)
				--inamearr = filterstring (i.name) "#"
-- 				print (inamearr[1])
				if(matchPattern i.name pattern:("sky*") ignoreCase:false) do
				(
-- 					print ("process sky")
					select i
					addUVW i 3
					max hide selection
					icount += 1
				)
			)
			enablesceneredraw()
			select sel
			completeRedraw()
			if(sel.count == icount) then
			(
				messagebox "选择的物体中没有可以bake的物体，\n请再选择一个以上需要bake的物体"
				max unhide all
				return false
			)
				
			for i in arrbakemesh do
			(
				i.INodeBakeProperties.removeAllBakeElements() 
			)
			
			--addUVW
/* 			for obj in objs do
			(
				--messagebox (obj.name)
				macros.run "Modifier Stack" "Convert_to_Poly"
				addUVW obj 2
				macros.run "Modifier Stack" "Convert_to_Poly"
			) */
			----------------------------------------------------
			clearlistener()
			disablesceneredraw()
			sel = for obj in selection collect obj
			clearselection()
			for i in sel do
			(	
				select i
				addUVW i 2
				clearselection()
			)
			enablesceneredraw()
			select sel
			----------------------------------------------------			
			for obj in objs do
			(
				

				
				 l = (obj.max.y - obj.min.y)
				 w = (obj.max.x - obj.min.x)
				 h = (obj.max.z - obj.min.z)
				 
				sizen = (((log10 (sqrt(l^2 + w^2 + h^2)))/(log10 2)) as Integer) + 2
				
				if(sizen > 8) do
					sizen = 8
				
				if(sizen < 5) do
					sizen = 5
				
				if((obj.name[1] +obj.name[2] + obj.name[3]) == "gnd") do
				(
					print (obj.name[1] +obj.name[2] + obj.name[3])
					sizen = 10
				)

				size = 2^sizen

				
				bakelm = VRayTotalLightingMap() -- instance of the bake element class
				bakelm.outputSzX =bakelm.outputSzY = size --set the size of the baked map --specifythe full file path, name and type:
				bakelm.fileType = (obj.name+".jpg")
				
				bakelm.fileName = filenameFromPath bakelm.fileType
				bakelm.filterOn = true --enable filtering
				bakelm.enabled = true --enable baking --Preparing theobjectfor baking:
				obj.INodeBakeProperties.addBakeElement bakelm --add first element
				obj.INodeBakeProperties.bakeEnabled = true --enabling baking
				obj.INodeBakeProperties.bakeChannel = 2 --channel to bake
				obj.INodeBakeProperties.nDilations = 1 --expand the texturea bit
			)
			
			
			
			

			
			
			
			
			global defaultRenderSet=renderers.current
				
		-- 	--renderPresets.LoadAll 0 (GetDir #renderPresets  + "bake.rps")
			myRenderSet=vray()
			myRenderSet.system_frameStamp_on = false
			myRenderSet.imageSampler_type = 1
			myRenderSet.twoLevel_baseSubdivs = 1
			myRenderSet.twoLevel_fineSubdivs = 4
			myRenderSet.gi_on = true
			myRenderSet.gi_primary_type = 2
			myRenderSet.gi_secondary_type = 2
			myRenderSet.environment_gi_on = true
			myRenderSet.environment_gi_color =  [255,255,255]
			myRenderSet.environment_gi_color_multiplier = 0.8
			myRenderSet.dmc_earlyTermination_threshold  = 0.001
			myRenderSet.dmc_subdivs_mult = 10.0
			myRenderSet.system_frameStamp_on = false
			myRenderSet.options_shadows = true
				
			-- myRenderSet.mapping=on
			-- myRenderSet.shadows=on
			-- myRenderSet.autoReflect=on
			-- myRenderSet.antiAliasing=on
			-- myRenderSet.antiAliasFilter=catmull_rom()--has set in fn.bakeRender

			renderers.current=myRenderSet
			
			renderPresets.LoadAll 0 (GetDir #renderPresets  + "\bake.rps")
			
			
			max file save
			
			
			selobjname = #()
			
			
			for i in objs do
			(
				append selobjname (i.name)
			)
			
			-- use another file to bake
			tmpmaxfilename = maxFilePath + "baketmpfile.max"
			saveMaxFile(tmpmaxfilename)
			
			
			loadMaxFile (tmpmaxfilename)
			--替换所有材质为vray材质
			
			for iobj in objects do
			(
				
				
				--iobj = $
				mat = iobj.mat
				
				
				if((classof mat) == Standardmaterial) then			
				(
					tmpa = Bitmaptexture()
					if(mat.opacityMap != undefined)do
					(
						tmpa = mat.opacityMap
					)
					mat = VRayMtl()
					mat.texmap_diffuse_on = off
					mat.Diffuse = color 128 128 128
					mat.texmap_opacity_on = off
					if((tmpa.filename) != "") do
					(
						mat.texmap_opacity_on = on
						mat.texmap_opacity = tmpa
					)
				)
				else
				(
					if((classof mat) == Multimaterial) do
					(
						submatnum = getNumSubMtls mat
						for im = 1 to submatnum do
						(
							if(((classof (mat[im])) == Standardmaterial) and (mat[im].diffusemap != undefined)) do
							(
								
								tmpa = Bitmaptexture()
								if(mat[im].opacityMap != undefined)do
								(
									tmpa = mat[im].opacityMap
								)
								mat[im] = VRayMtl()
								mat[im].texmap_diffuse_on = off
								mat[im].Diffuse = color 128 128 128
								mat[im].texmap_opacity_on = off
								
								if((tmpa.filename) != "") do
								(
									mat[im].texmap_opacity_on = on
									mat[im].texmap_opacity = tmpa
								)
								
							
							)
						)
					)
				)
				
				iobj.mat = mat
				
			)
			
			objs = #()
			for i in objects do
			(
				fo = findItem selobjname (i.name)
				if fo > 0 do
				(
					append objs i
				)
			)
			
			
			select objs
			
			max file save
			
			local end_timestamp = timestamp()
			local process_time = end_timestamp - start_timestamp
			
			messagebox ("烘焙准备完成！！！\n" + (timeFormatter process_time))
			
			macros.run "Render" "BakeDialog"

			
		)
		
		
		fn resetbake = 
		(
			
			max unhide all --将隐藏的天空球显示出来
			vsun = #()
			for isun in objects do
			(
				if ((classof(isun)) == vraysun )do
				(
					append vsun isun
				)
			)
			
			delete vsun
			
			
			--set all diffuseMapEnable on
			for i in geometry do
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
			
			
			for i in geometry do
			(
				i.INodeBakeProperties.removeAllBakeElements() 
			)
		)
		
		
		
		fn getlightmappath = 
		(--get project path

			p =maxFilePath
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
			cmd = cmd + "\src\art\scene\lightmap\\"

		)
		
		
		fn select_unbakefn = 
		(
-- 			lightpath = getlightmappath()
/* 			--messagebox (lightpath)
			objs = #()
			for iobj in objects do
			(
				iobjN = iobj.name
				fidx = findString iobjN "#"
				if fidx != undefined do
				(
					iobjNN = replace iobjN fidx 1 "_"
					lightfn = lightpath + iobjNN + ".png"
					print lightfn
					if(getFileSize  lightfn) > 0 then
					(
						--messagebox (iobj.name)
						continue
					)
					else
					(
						append objs iobj
					)	
				)
			)
			select objs
			 */
			 
			clearselection()
			pp = checkpPath()
			-- get 
			wtp
			if cmd != "" do
			(
				lmp = filterString pp "\\"
				wt = "D:\\" + lmp[lmp.count-1] + "\\" + lmp[lmp.count] + "\\src\\art\\scene\\lightmap"
				makedir wt
				wtp = wt + "\\lightmap.txt"
				
				dp = "\\\\" + pp + "\\src\\art\\scene\\lightmap\\"
				try
				(
					cmdstr = "/C \"" + "spp --tools=checklightmap --input="+ dp +" --output=" + wtp
					ShellLaunch "cmd" cmdstr
				)catch()

			)
			-- readfile
			pngs = #()
			oo = openFile  wtp
			while not eof oo do 
			(
				meshObjName = readLine oo
				append pngs meshObjName
			)
			pngs
			objs =#()

			for iobj in geometry do
			(
				same = 0
				iobjN = iobj.name
				fidx = findString iobjN "#"
				if fidx != undefined do
				(
					iobjNN = replace iobjN fidx 1 "_"
					lightfn = iobjNN + ".jpg"
					same = findItem pngs lightfn
					
					if same > 0 then
					(
						
						continue
					)
					else
					(
						append objs iobj
					)	
				)
			)
			select objs
			close oo
		)

		
-- 		on build_n_view_btn pressed do
-- 		(
-- 			sppbuild()
-- 		)

		
		GroupBox grp9 "" pos:[5,86] width:160 height:52
		on btn_bake pressed do
		(
			createbakew()
		)
		on btn_reset pressed do
		(
			resetbake()
		)
		on select_unbake pressed do
		(
			select_unbakefn()
		)
		on lightmap_export_btn pressed do
		(
			export_scene(chk_MgByName.checked)
		)
		on btn_adjSunPos pressed do
		(
			try(
			global sunObj = vraysun pos:(point3 1000 1000 1000) --create sun object
			targetObj = dummy pos:(point3 0 0 0) --then target
			sunObj.intensity_multiplier = 0.05
			sunObj.ozone = 0.035
			sunObj.shadow_subdivs = 8
			sunObj.photon_emit_radius = 5000
			sunObj.size_multiplier = 0.1
			targetObj.lookat = sunObj
			)catch(messagebox ("运行出错：没有安装vray!"))
		)
	)

	gw = newRolloutFloater "Spp Scene ToolModify" 185 705
	addrollout	version_rollout gw rolledUp:true
	addrollout  resetScn_tool gw
	addrollout  attach_tool gw	
	addrollout  checkmt_tool gw
	addrollout  mesh_tool gw
	addrollout 	createMode_tool gw
	addrollout	meshrename_tool gw
	addrollout  pathNavigation gw
	addrollout  bake_section gw rolledUp:true

	if(checksdk()) then
	(
		addrollout	spp_view gw
		addrollout	MovieLRollout gw rolledUp:true
	)

)