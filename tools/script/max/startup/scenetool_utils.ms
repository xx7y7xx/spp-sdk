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

fn camera_path_export =
(
	fn export outFile selectcamera duration delaytime = 
	(
		format "<wanders>\n" to:outFile
		
		format "\t<wander>\n" to:outFile
		local eular = (quatToEuler ((selectcamera.transform) as quat))
		format "\t\t<start posX=\"%\" posY=\"%\" posZ=\"%\" rotX=\"%\" rotY=\"%\" rotZ=\"%\" />\n" (selectcamera.pos.x) (selectcamera.pos.z) (selectcamera.pos.y) (-((eular.x-90)/180)*3.1415926) (-((eular.z)/180)*3.1415926) (-((eular.y)/180)*3.1415926)  to: outFile
		format "\t\t<wander0 posX=\"%\" posY=\"%\" posZ=\"%\" rotX=\"%\" rotY=\"%\" rotZ=\"%\" />\n" (selectcamera.pos.x) (selectcamera.pos.z) (selectcamera.pos.y) (-((eular.x-90)/180)*3.1415926) (-((eular.z)/180)*3.1415926) (-((eular.y)/180)*3.1415926)  to: outFile
				
		for t in animationRange.start to animationRange.end by (1s/frameRate) do
		(
			if(t>=1) then
			(
				at time t 
				(
					thistransform = selectcamera.transform
					local eular = (quatToEuler (thistransform as quat))
					format "\t\t<wander% posX=\"%\" posY=\"%\" posZ=\"%\" rotX=\"%\" rotY=\"%\" rotZ=\"%\" />\n" (t.frame as integer) (selectcamera.pos.x) (selectcamera.pos.z) (selectcamera.pos.y) (-((eular.x-90)/180)*3.1415926) (-((eular.z)/180)*3.1415926) (-((eular.y)/180)*3.1415926)  to: outFile
				)
			)
		)
		format "\t</wander>\n\n" to:outFile						
		format "</wanders>\n" to:outFile
	)
	
	dir = getProjectPath()
	dir += "\\src\\product\\position\\wander\\"
	
	
	-- This is default value
	duration = "20"
	delaytime = "20"
	
	
	makeDir  dir  
	
	for icam in cameras do
	(
		if (classof icam) == Targetobject do
		(
			continue
		)
		tmpstr = icam.name
		idx = findstring tmpstr "00"
		if idx == undefined then
		(
			camname=replace tmpstr 7 1 "00" 
		)
		else
			camname = tmpstr
		filename = dir + "wander_" + camname + ".xml"
		outFile = createFile filename
		export outFile icam duration delaytime
		close outFile 
	)
)



-- import sky lightmap file
fn importSkyLitmap =
(
	cp = checkpPath()
	srcdir = "\\src\\art\\scene\\lightmap"
	outputPath = cp + srcdir
	if doesFileExist outputPath then
	(
		srcfile = "D:\\spp_sdk\\data\\effectextures\\litmap.jpg"
		if not (doesFileExist srcfile) then
		(
			print "������lightmapģ��û���ҵ�"
			return 0
		)
		bkflag = false
		dfilename = ""
		for i in geometry where not bkflag do
		(
			if(matchPattern i.name pattern:("sky*") ignoreCase:false) do
			(
				tmpstr = i.name
				idx = findstring tmpstr "#"
				while idx != undefined do
				(
					tmpstr=replace tmpstr idx 1 "_" 
					idx = findstring tmpstr "#"
				)
				dfilename = tmpstr
			)
		)
		--print dfilename
		dfile = (outputPath+"\\"+ dfilename + ".jpg")
		--print dfile
		copyFile srcfile dfile
	)
)

--  set brightness texture map
fn expBrightness =
(
	arrALLTexMap = #()
	cp = checkpPath()
	cp = checkpPath()
	srcdir = "\\src\\art\\scene\\lightmap"
	inwrt = cp + "\\target\\art\\textures\\"
	testPath = cp + srcdir
	--���lightmap�ļ���û�д��ھͲ��õ���ͼ��Ϣ��
	if not doesFileExist testPath then
	(	
		return 0;
	)
	for obj in geometry do
	(
		--texname = ""
		plvalue = "+58$1.1"
		value = "-53$1";
		if(matchPattern obj.name pattern:("plant*") ignoreCase:false) then
			value = plvalue
		else if(matchPattern obj.name pattern:("sky*") ignoreCase:false) do
		(
			tmpstr = obj.name
			idx = findstring tmpstr "#"
			while idx != undefined do
			(
				tmpstr=replace tmpstr idx 1 "_" 
				idx = findstring tmpstr "#"
			)
			value = "-75$1"
			dfilename = cp + "\\target\\art\\lightmaps\\" + tmpstr + ".jpg" + "$" + value
			append arrALLTexMap dfilename
			continue
		)
		
		
		
		mat = obj.material
		submatnum = getNumSubMtls mat
		if submatnum == 0 then
		(
			 --texname = texname + (mat.diffuseMap.filename) + "\n"
			if toLower(getFilenameType (mat.diffuseMap.filename)) == ".png" then value = plvalue
			texname = inwrt + filenameFromPath (mat.diffuseMap.filename) + "$" + value
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
			t_value = value
			for f = 1 to objfaces while bkflag == false do
			(	--�˴�����ֱ���Ȱ�������
				submatid = getFaceMatID obj f
				value = t_value
				CurrentSubMtl = mat.materialList[submatid]
				try(
					if (CurrentSubMtl.diffuseMap) != undefined  then
					(
						if toLower(getFilenameType (CurrentSubMtl.diffuseMap.filename)) == ".png" then value = plvalue
						tmptexname = inwrt +filenameFromPath (CurrentSubMtl.diffuseMap.filename) + "$" + value
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
	
	
	srcdir = "\\src\\art\\scene\\effect"
	outputPath=cp+srcdir
	makeDir outputPath
	fileN  = "\\BrightnessInfo.txt"
	filename = (outputPath + fileN )
	if (existFile filename) then 
		try(deletefile filename)catch()
	outFile = createFile filename
	print arrALLTexMap.count
	if arrALLTexMap.count > 0 then
	(
		cnt = arrALLTexMap.count
		for i = 1 to (cnt-1) do 
			format (arrALLTexMap[i]+"\n") to:outFile
		format (arrALLTexMap[cnt]) to:outFile
	)
	close outFile
	filename
)


/**
 * @brief ��������
 * @param isMeshgenFollowMeshName true�������ƽ���meshgen��false�Զ�����mesh��bounding boxȻ�����meshgen
 */
fn export_scene isMeshgenFollowMeshName =
(
	start_timestamp = timestamp()
	
	xfile_export() -- ����x�ļ�
	
	expHudxml() --hud tree
	expxml() 	-- effect xml
	explodxml()	--lod xml
	importSkyLitmap() -- import litmap
	expBrightness()
	
	fnmeshgen(isMeshgenFollowMeshName) -- ����meshgen����
	
	end_timestamp = timestamp()
	process_time = end_timestamp - start_timestamp
	
	messagebox ("����ͳ���������ϣ�����\n" + (timeFormatter process_time))
)

-------------------------����������--------------------------------------
fn rename nn = 
(
	sel = getcurrentselection()
	for i =1 to sel.count do
	(
		if i<10 do
		(
			sel[i].name = nn + "#" + "00" +(i as string) 
		)
		if i<100 and i>=10 do 
		(
			sel[i].name = nn + "#" + "0" +(i as string)
		)
		if i>100 do
		(
			sel[i].name = nn + "#" +(i as string)
		)
	)
)
 
	

	
	
	
-------------------------x�ļ��Լ�������Ϣ����--------------------------------------


--rename lightingmap
fn renamelightmap = 
(
	lp = checkpPath()
	lp +=  "\\src\art\scene\lightmap\\"
	lmarr = a = getFiles (lp+"*.jpg")
	for i in lmarr do
	(
		if (matchPattern i pattern:"*VRayTotalLightingMap*") == true do
		(
			fsIndex = findString i "VRayTotalLightingMap"
			
			s1=replace i fsIndex 20 "" 
			renameFile  i s1
		)
	)
)

-------------------------lightmap����--------------------------------------
	
fn lightmap_export =
(
	
	cp = checkpPath()
	for obj in geometry  do
	(
		
		
		-- ��¼�ڷ�λ��
		
		
		if((getUserProp obj "bake") == 1) do
		(
			
			select obj
			subobjectLevel = 0
			max modify mode
			ResetXForm obj
			convertToPoly obj
			--print ((obj.name) + ((obj.transform) as string))
			scene_pos = obj.transform
			-- �ƶ�����������ԭ��
			obj.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
			ResetXForm obj
			convertToPoly obj
			ChannelInfo.CopyChannel obj 3 1
			ChannelInfo.PasteChannel obj 3 3
			ChannelInfo.CopyChannel obj 3 2
			ChannelInfo.PasteChannel obj 3 1
			srcdir = "\\src\\art\\uv_lightmap"
			outputPath = cp + srcdir 
			makedir outputPath
			filename = outputPath + "\\" + "light_" + obj.name  + ".3ds"
			select obj
			exportfile filename #noPrompt selectedOnly:TRUE
			
			ChannelInfo.CopyChannel obj 3 3
			ChannelInfo.PasteChannel obj 3 1
			-- �ص��ڷ�λ��
			obj.transform = scene_pos
			clearSelection()
		)
		
	)
)

-------------------------���嵼��--------------------------------------
fn basemodel_export =
(
	disableSceneRedraw()
	cp = checkpPath()
	if cp.count>6 do
	(
		i = 0
		clearSelection()
		allGeom = for i in geometry collect i
		--ResetXForm allGeom
		--convertToPoly allGeom
		--����ǰ����ɾ�����е�����3ds
		srcdir = "\\src\\art\\factory\\neirong01"
		outputPath=cp+srcdir
		oldfiles=outputPath + "\\" +  "*.3ds"
		for oldfile in getFiles oldfiles do deleteFile oldfile
		for obj in geometry  do
		(
			
			
			-- ��¼�ڷ�λ��
			
			select obj
			subobjectLevel = 0
			max modify mode
			ResetXForm obj
			convertToPoly obj
			--print ((obj.name) + ((obj.transform) as string))
			scene_pos = obj.transform
			-- �ƶ�����������ԭ��
			obj.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
			ResetXForm obj
			convertToPoly obj
			-- ��������
			objname = obj.name 
			fs=findString objname "#"
			if fs == undefined then
			(-- �������û��#�ſ���ֱ�ӵ���
				-- export selected
				srcdir = "\\src\\art\\factory\\neirong01"
				outputPath = cp + srcdir 
				makedir outputPath
				filename = outputPath + "\\" + objname  + ".3ds"
				select obj
				exportfile filename #noPrompt selectedOnly:TRUE
				i += 1
				-- �ص��ڷ�λ��
				obj.transform = scene_pos
				rename objname
				clearSelection()
			)else
			(-- ���������#�ţ��ȸı�mesh���֣���������ص�λ�ã������������أ�ȡ��ѡ��
				fs= fs-1
				nobjname = substring objname 1 fs
				obj.name = nobjname
				
				-- export selected
				srcdir = "\\src\\art\\factory\\neirong01"
				outputPath = cp + srcdir 
				makedir outputPath
				filename = outputPath + "\\" + nobjname  + ".3ds"
				select obj
				exportfile filename #noPrompt selectedOnly:TRUE
				i += 1
				-- �ص��ڷ�λ��
				obj.transform = scene_pos
				rename nobjname
				clearSelection()
			)
			
		)
	)
	enableSceneRedraw() 
	message = format"��������%���壬ʵ�ʵ���%�����壡\n" allGeom.count i
-- 	messagebox"���嵼�������ϣ����Խ�����һ����"
	
)

fn basem_export =
(
	disableSceneRedraw()
	cp = checkpPath()
	if cp.count>6 do
	(
		i = 0
		allGeom = getcurrentselection()
		--ResetXForm allGeom
		--convertToPoly allGeom
		for obj in allGeom do
		(
			-- ��¼�ڷ�λ��
			
			select obj
			subobjectLevel = 0
			max modify mode
			ResetXForm obj
			convertToPoly obj
			--print ((obj.name) + ((obj.transform) as string))
			scene_pos = obj.transform
			-- �ƶ�����������ԭ��
			obj.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
			ResetXForm obj
			convertToPoly obj
			-- ��������
			objname = obj.name 
			fs=findString objname "#"
			if fs == undefined then
			(-- �������û��#�ſ���ֱ�ӵ���
				-- export selected
				srcdir = "\\src\\art\\factory\\neirong01"
				outputPath = cp + srcdir 
				makedir outputPath
				filename = outputPath + "\\" + objname  + ".3ds"
				if (existFile filename) then deletefile filename
				select obj
				exportfile filename #noPrompt selectedOnly:TRUE
				i += 1
				-- �ص��ڷ�λ��
				obj.transform = scene_pos
				rename objname
				clearSelection()
			)else
			(-- ���������#�ţ��ȸı�mesh���֣���������ص�λ�ã������������أ�ȡ��ѡ��
				fs= fs-1
				nobjname = substring objname 1 fs
				obj.name = nobjname
				
				-- export selected
				srcdir = "\\src\\art\\factory\\neirong01"
				outputPath = cp + srcdir 
				makedir outputPath
				filename = outputPath + "\\" + nobjname  + ".3ds"
				if (existFile filename) then deletefile filename
				select obj
				exportfile filename #noPrompt selectedOnly:TRUE
				i += 1
				-- �ص��ڷ�λ��
				obj.transform = scene_pos
				rename nobjname
				clearSelection()
			)
		)
	)
	enableSceneRedraw() 
	message = format"��������%���壬ʵ�ʵ���%�����壡\n" allGeom.count i
	
)


--###################################  ����༭   ����  ###################################

	-----------�����ķ����������·�-----------------
	fn pivot2minz =
	(
		sel = getcurrentselection()
		if sel.count == 1 do
		(
			x = $.center.x
			y = $.center.y
			z = $.min.z
			$.pivot = [x,y,z]
			ResetXForm $
			convertToPoly $
		)

	)


	----------------------��������ģɣ��´�����ά����--------------------------------------
	fn newMulByObjID matName = 
	(-- ���������id������������ͬ�������ݵ�multimat������
		--1.�õ��������� id ����
		theObj = selection[1]
		if (classof theObj == Editable_Poly) then
		(
			id_arr = #()
			faceNum = polyop.getNumFaces theObj
			for i = 1 to faceNum do
			(
				faceId = polyop.getFaceMatID theObj i
				appendIfUnique id_arr faceId
			)
			format "%\n" id_arr
			idNum = id_arr.count

			-- 2.��������id �ƶ�multi mat,     ����������
			m = multimaterial numsubs:idNum
			theObj.material = m
			m.name = matName + "m"
			for i=1 to idNum do
			(
				m[i].name = matName + "m"+ (i as string)
			)
			meditMaterials[1] = m
		)else
		(
			messagebox "�����ת����polygon��"
		)

	)
-- 	newMulByObjID "xx"
	
	-------------------����ģ�͵�ID�����������Ķ�ά����---------------------------------
	fn renameMulByObjID matName = 
	(

		obj = selection[1]
		if (classof obj == Editable_Poly) then
		(
			if obj.mat != undefined do
			(
				if classof obj.material == Multimaterial do
				(
					obj.mat.name = matName +"m"
					num = obj.mat.numsubs
					for i = 1 to num do
					(
						obj.mat[i].name = matName + "m"+ (i as string)
					)
					max mtledit
					meditMaterials[1] = obj.mat
					redrawviews()
				)
			)
		)else
		(
			messagebox "�����ת����polygon��"
		)

	)
-- 	renameMulByObjID "xw"
-----------------------------------------------------------------------------------------------��������	

	-- rename "tr01"	
		
--###################################  �����༭  ###################################
	


	
--###################################  ���Ա༭  ###################################
 
---------------------------------��ע����Ҫ�決��ģ�͵�fn------------------------------------------------------
fn  noLightMap=
(-- ��ʼ
/* 
		<nolightMap>
			<meshobj name="cc_1#001" />
		</nolightMap>
 */
	pathN = checkpPath() + "\\src\\art\\lights\\lightmap"
	makeDir pathN
	fileN = "\\nolightmap.xml"
	outFile = createFile (pathN + fileN )
	
	if selection.count !=0 do
	(
		format"<nolightMap>\n"  to:outFile
		for i in selection do
		(
			format"\t<meshobj name=\"%\" />\n" i.name to:outFile
		)
		format"</nolightMap>\n"  to:outFile
	)
	close outFile 
	messageBox "����Ҫ�決�������Ѿ������ϣ�"
 )
-----------------------------�����崴����������------------------------------------------------------
fn buildCHname =
( -- �ض���������������----user define  
/* 	
	<world>
		<meshobj name="cc_02#001" cname="��ѧ¥" />
	</world>
 */	
	pathN = checkpPath() + "\\src\\art\\position"
	makeDir pathN
	fileN = "\\build.xml"
	outFile = createFile (pathN + fileN )
	
	if selection.count ==0 then
	(
		messagebox"��ѡ����Ҫ���������Ϣ�����壡"
	)else
	(
		format "<world>\n" to:outFile
		for i in selection do
		(
			objzhn = getUserProp i "cname"
			if objzhn != undefined do
			(
				format "\t<meshobj name=\"%\" cname=\"%\" />\n" i.name objzhn  to:outFile
			)
		)
		format "</world>\n" to:outFile
	)
	close outFile 
	messageBox "��������Ϣ�������Ѿ������ϣ�"
)
	
	
---------------------------�����־�Խ�������ͼ����-----------------------------------------------------
fn exporttexname =
(
	
	if (selection.count == 0) then
	(
		message = "you need Select Some Mesh!"
		messageBox message
		return 1
	)
	for obj in selection do
	(
		texname = ""
		mat = obj.material
		submatnum = getNumSubMtls mat
		if submatnum == 0 do
		(
			 texname = texname + (mat.diffuseMap.filename) + "\n"
		)
		--add
		if(classof obj.baseobject != Editable_Mesh)then	convertToMesh obj
		arrTexMap = #()
		if submatnum > 0 do
		(
			objfaces = obj.numfaces
			bkflag = false
			matcount = 0
			for f = 1 to objfaces while bkflag == false do
			(	--�˴�����ֱ���Ȱ�������
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
						)
					)
				)catch()
				if matcount == submatnum then bkflag = true
			)
		)
		for istr in arrTexMap do texname += istr + "\n"
		
		cp = checkpPath()
		srcdir = "\\plan\\��־����"
		outputPath = cp + srcdir
			
		makedir  outputPath	

		filename = outputPath +  "\\" + obj.name + ".txt"
		--deletefile filename
		outFile = createFile filename
	
		format "%\n" texname to:outFile
		close outFile
		
	)
	messagebox"��鿴��plan\��־�������ļ��У�����"
	

 )
 
------------------------------------repair uv 
fn repUVW =
(
	fn RepairUVW targetMesh =
	(
		sourceClass = ClassOf targetMesh.Baseobject
		ConvertToMesh targetMesh
		for  fi = 1 to GetNumFaces targetMesh.mesh do
		(
			ft = GetTVFace targetMesh.mesh fi
	 
			for ni = 1 to 3 do
			(
				tempUvw = getTVert  targetMesh.mesh  ft[ni]
				for ui = 1 to 3 do
				(
					if (not tempUvw[ui] >= 0) and (not tempUvw[ui] <= 0) do tempUvw[ui] = 1
				)
				SetTVert  targetMesh.mesh  ft[ni] tempUvw
			)
		)
		Update targetMesh
		if sourceClass == Editable_Poly do ConvertTo targetMesh Editable_Poly
		AddModifier targetMesh (Unwrap_UVW())
		converttomesh targetMesh
	)
	 
	for tempObj in Selection  as array do RepairUVW tempObj
)


fn thePath =
(
	p =maxFilePath
	p_arr = filterString p "\\"
	realPath = p_arr[1]+ "\\" + p_arr[2]+ "\\" + p_arr[3]+"\\plan\\����\\������Ϣ.txt"
)

fn CheckName =	  --@zhanghongru E10����max�����пո��밴�������淶�޸���ȷ��
(
	sceneName =  maxFileName
	if (findString maxFileName " "!=undefined ) then
	(
		messagebox ("E10����max�����пո��밴�������淶�޸���ȷ��")
		errorMsg ="E10����max�����пո��밴�������淶�޸���ȷ��"	
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