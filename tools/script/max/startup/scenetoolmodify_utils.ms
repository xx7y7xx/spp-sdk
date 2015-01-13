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
		messagebox "������ɣ��������һ������"
	)
	else
	(
		messagebox "��ѡ�����壡"
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
		messagebox "��ѡ�����壡"
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
		messagebox "û�з��ִ����������һ������"
	)
	else
	(
		local wtpath = checkpPath()
		wtpath = wtpath  + "\\plan\\����"		
		makedir wtpath	
		local filename = wtpath + "\\mesh���ֵ�ǰ׺�����⡪����Ҫ�޸�.txt"
		local outFile = createFile filename
		close outFile
		messagebox ("���ִ���" + filename)
	)
)

/**
 * @brief ��������
 * @param isMeshgenFollowMeshName true�������ƽ���meshgen��false�Զ�����mesh��bounding boxȻ�����meshgen
 */
fn export_scene isMeshgenFollowMeshName =
(
	xfile_export() -- ����x�ļ�
	
	--��ע�͵�
	--fnmeshgen() --meshgen
	expHudxml() --hud tree
	expxml() 	-- effect xml
	explodxml()	--lod xml
	
	fnmeshgen(isMeshgenFollowMeshName) -- ����meshgen����
	
	messagebox"����ͳ���������ϣ�����"
)

 -- #####################################��ͼ������#############################################
 fn renametexture namestr= (
	try(
	   heatsize = 600000000-heapsize
	)catch()
	 i = 0;
	 renmess = ""
	 --��������mesh
	 for iobj in  geometry do
	 (
		 --��ȡ��ǰmesh�µ����в���
		 mat = iobj.material
		 submatnum = getNumSubMtls mat
		 --���Ϊ������
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
				--����Ѿ�����������
			flag=matchPattern texfilename pattern: (texN + namestr+"*") ignoreCase:false 
			if(flag==true)do
			(
-- 				print "pass"
				continue
			)
			--����������gemo
			for iobjt in  geometry do
			(
				tmat = iobjt.material
				tsubmatnumber = getNumSubMtls tmat
				--�ڸ�������
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
				--���Ӳ�����
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
		 --������ǰmesh�����в���
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
					messagebox"����uv�д�����鿴uv���޸ģ�"
					exit	
				)
				i+=1
			)
		)else (messagebox"������û��UV��")
		if err == 0 do messagebox"������uvû�д���"
	)else messagebox"��ѡ��һ�����壡"
)