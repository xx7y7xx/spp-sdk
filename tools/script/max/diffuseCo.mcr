macroScript diffuseCo
category:"Superpolo"
ButtonText:"diffuseCo" 
tooltip:"diffuseCo" Icon:#("Maxscript", 8)
(
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

	rollout diffuseCo_Rollout "加载页贴图颜色调整" width:160 height:45
	(
		button diffuseCo_btn "开始调整(correct)" pos:[11,10] width:140 height:23
		on diffuseCo_btn pressed  do
		(
			diffuseCo_correct()
		)
	)
	createdialog diffuseCo_Rollout
)
