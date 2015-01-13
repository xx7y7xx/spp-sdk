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
 * @brief rename selected mesh, give it a prefix, example "plant"
 * next to prefix is a number. mesh name is like "plant123"
 */
fn renameSelection prefix =
(
	local sel = getcurrentselection()
	if sel.count > 0 then
	(
		for i = 1 to sel.count do
		(
			sel[i].name = prefix + (i as string)
		)
		messagebox "命名完成！请进入下一步操作"
	)
	else
	(
		messagebox "请选择物体！"
	)
)

/**
 * @brief check selected mesh, 
 * building must be "bud123..."
 * plant must be "plant123..."
 * sky must be "sky1..."
 */
fn checkMeshNamePrefixOfSelection prefix =
(
	local sel = getcurrentselection()
	if sel.count <= 0 do
	(
		messagebox "请选择物体！"
		return false
	)
	
	local errormsg = stringStream ""
	for i = 1 to sel.count do
	(
		if (namerulePrefixChecker prefix sel[i].name) == false do
		(
			format "%\n" sel[i].name to:errormsg
		)
	)
	
	if (errormsg as String) == "" then
	(
		messagebox "没有发现错误！请进入下一步操作"
	)
	else
	(
		local wtpath = checkpPath()
		wtpath = wtpath  + "\\plan\\问题"		
		makedir wtpath	
		local filename = wtpath + "\\mesh名字的前缀有问题——需要修改.txt"
		local outFile = createFile filename
		close outFile
		messagebox ("发现错误：" + filename)
	)
)

/**
 * @brief 场景导出
 * @param isMeshgenFollowMeshName true按照名称进行meshgen，false自动计算mesh的bounding box然后进行meshgen
 */
fn export_scene isMeshgenFollowMeshName =
(
	xfile_export() -- 导出x文件
	
	--先注释掉
	--fnmeshgen() --meshgen
	expHudxml() --hud tree
	expxml() 	-- effect xml
	explodxml()	--lod xml
	
	fnmeshgen(isMeshgenFollowMeshName) -- 导出meshgen数据
	
	messagebox"本体和场景导出完毕！！！"
)

 -- #####################################贴图重命名#############################################
 fn renametexture namestr= (
	try(
	   heatsize = 600000000-heapsize
	)catch()
	 i = 0;
	 renmess = ""
	 --遍历所有mesh
	 for iobj in  geometry do
	 (
		 --获取当前mesh下的所有材质
		 mat = iobj.material
		 submatnum = getNumSubMtls mat
		 --如果为父材质
		 if submatnum == 0 do
		 (
			 texfilename = mat.diffuseMap.filename
			 texNameArr = filterString texfilename "\\."
			 texN = ""
			 for itexN =1 to (texNameArr.count-2) do
			 (
				 texN += texNameArr[itexN] + "\\" 
			 )
			--tmpname = ("t" + "_" + (i as string)) 
			tmpname = ( namestr + (i as string))
				--如果已经命过名跳过
			flag=matchPattern texfilename pattern: (texN + namestr+"*") ignoreCase:false 
			if(flag==true)do
			(
-- 				print "pass"
				continue
			)
			--遍历其他的gemo
			for iobjt in  geometry do
			(
				tmat = iobjt.material
				tsubmatnumber = getNumSubMtls tmat
				--在父材质上
				if tsubmatnumber == 0 do
				(
					try(
						tmtexfilename = tmat.diffuseMap.filename
					)catch()
					/* flag=matchPattern tmtexfilename pattern: (texN + namestr+"*") ignoreCase:false 
					if(flag==true) do
					(
						continue
						print "continue"
					)	 */
					if tmtexfilename == texfilename do
					(
						tmat.diffuseMap.filename = texN + tmpname +"."+texNameArr[texNameArr.count]
					)
				)
				--在子材质上
				 if tsubmatnumber >0 do
				(
					for itm = 1 to tsubmatnumber do
					(
						itsmat = getSubMtl tmat itm
						if itsmat == undefined do
						(
							continue 
-- 							print "continue"
						)
						try(
							tmtexfilename = itsmat.diffuseMap.filename
						)catch()
						/* flag=matchPattern tmtexfilename pattern: (texN + namestr+"*") ignoreCase:false 
						if(flag==true) do
						(
							continue
						)	 */
						if tmtexfilename == texfilename do
						(
							itsmat.diffuseMap.filename = texN + tmpname +"."+texNameArr[texNameArr.count]
							--tmat.diffuseMap.filename = tmpname
						)
					)
				) 
			)
			--diplay
-- 			renmess = renmess + ( texfilename + " " + tmpname +"."+ texNameArr[texNameArr.count] + "\n") 
--  			print renmess
			/* flag=matchPattern texfilename pattern: (texN + namestr+"*") ignoreCase:false 
			 if(flag!=true) do
			(
				renameFile texfilename (texN + tmpname +"."+ texNameArr[texNameArr.count])
			) */
			renameFile texfilename (texN + tmpname +"."+ texNameArr[texNameArr.count])
			i += 1
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
				texN = ""
				for itexN =1 to (texNameArr.count-2) do
				(
					texN += texNameArr[itexN] + "\\" 
				)
				--tmpname = ("t" + "_" + (i as string)) 
				tmpname = ( namestr + (i as string))
					--pass
				flag=matchPattern itexfilename pattern: (texN + namestr+"*") ignoreCase:false 
				if(flag==true)do
				(
					--print "pass"
					continue
				)
				for iobjt in  geometry do
				(
					tmat = iobjt.material
					tsubmatnumber = getNumSubMtls tmat
					if tsubmatnumber == 0 do
					(
						try(
							tmtexfilename = tmat.diffuseMap.filename
-- 							flag=matchPattern tmtexfilename pattern: (texN + namestr+"*") ignoreCase:false 
						)catch()
						/* if(flag==true) do
						(
							continue
						)	 */
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
							try(
								tmtexfilename = itsmat.diffuseMap.filename
							)catch()
							/* flag=matchPattern tmtexfilename pattern: (texN + namestr+"*") ignoreCase:false 
							if(flag==true) do
							(
								continue
							)	 */
							if tmtexfilename == itexfilename do
							(
								itsmat.diffuseMap.filename = texN + tmpname +"."+texNameArr[texNameArr.count]
								--tmat.diffuseMap.filename = tmpname
							)
						)
					)
				)
				--display
-- 				renmess = renmess + ( itexfilename + " " + tmpname +"."+ texNameArr[texNameArr.count] + "\n") 
-- 				print renmess
				renameFile itexfilename (texN + tmpname +"."+ texNameArr[texNameArr.count])
				i += 1
			)
		) 
	 )
 )
 
 fn resetMesh =
(
	for obj in geometry do
	(
		select obj
		subobjectLevel = 0
		max modify mode
		ResetXForm obj
		convertToMesh obj
	)
	
	
)

fn checkVertUVInfo =
(
	sel = getcurrentselection()
	cnt = sel.count
	if cnt == 1 then
	(
		o = sel[1]
		converttomesh o
		isMapChannel = meshop.getMapSupport $ 1
		if isMapChannel then
		(
			vertCnt = meshop.getNumTVerts o
			
			i=1
			err = 0
			while i< vertCnt do
			(
				uvwInfo = getTVert o i
	-- 			format"%_uvwInfo: %\n" i uvwInfo
					
				info = (getTVert o i) as string
				fd = findString info "#QNAN"
				if fd !=undefined do 
				(
					err +=1
					messagebox"物体uv有错误，请查看uv并修改！"
					exit	
				)
				i+=1
			)
		)else (messagebox"此物体没有UV！")
		if err == 0 do messagebox"此物体uv没有错误！"
	)else messagebox"请选择一个物体！"
)