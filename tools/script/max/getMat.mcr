macroScript getMat
category:"Superpolo"
ButtonText:"getMat" 
tooltip:"getMat" Icon:#("Maxscript", 17)
(
	-- 这个工具是针对场景构建的时候 跳出的36号错误的，mat查找方法
	global sMatN_arr = #()
	global sMat_arr = sceneMaterials
	
	rollout getMatRollout "通过材质名字找到材质" width:259 height:35
	(
		button getMat_btn1 "得到这个材质" pos:[144,5] width:102 height:22
		editText matN_edt1 "" pos:[11,6] width:127 height:20
		on getMat_btn1 pressed do
		(
			clearlistener()
			for i in sMat_arr do
			(
		-- 		format "%\n" i
				append sMatN_arr i.name 
			)
			theMat = findItem sMatN_arr matN_edt1.text 
			if theMat != 0 do
			(
				max mtledit
				setMeditMaterial 1 sMat_arr[theMat]
			)

		)
	)
	createdialog getMatRollout
)

