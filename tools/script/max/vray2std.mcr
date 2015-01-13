macroScript vray2std
category:"Superpolo"
ButtonText:"vray2std" 
tooltip:"vray2std" Icon:#("Maxscript", 3)
(
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
	fn v2s =
	(
		arrTexInfo = #()
		arrTexNum = #()
		myIncrement = 0
		p = checkpPath() + "\\src\\art\\scene\\diffuse\\"
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
					if o.material.diffusemap != undefined then
					(
						texmap = o.material.diffusemap.filename
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
				)
				catch
				(
					testflag = true	
				)
				if testflag then
				(
					if (classof o.material == VRayLightMtl) then
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
						if o.material [m].diffusemap != undefined then
						(
							texmap = o.material [m].diffusemap.filename
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
					)
					catch
					(
						testflag = true	
					)
					if testflag then
					(
						if (classof o.material == VRayLightMtl) then
							cl = o.material [m].color
						else			
							cl = o.material [m].diffuse
	
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
	
	
	
rollout StandToDiffusemapRollout "diffuse转diffusemap" width:151 height:42
(
	button btn1 "转换" pos:[25,8] width:109 height:25
	on btn1 pressed  do
(
	v2s()
	messagebox "ok"
	)
)
createdialog StandToDiffusemapRollout
)	