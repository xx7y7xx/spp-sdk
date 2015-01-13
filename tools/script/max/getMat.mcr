macroScript getMat
category:"Superpolo"
ButtonText:"getMat" 
tooltip:"getMat" Icon:#("Maxscript", 17)
(
	-- �����������Գ���������ʱ�� ������36�Ŵ���ģ�mat���ҷ���
	global sMatN_arr = #()
	global sMat_arr = sceneMaterials
	
	rollout getMatRollout "ͨ�����������ҵ�����" width:259 height:35
	(
		button getMat_btn1 "�õ��������" pos:[144,5] width:102 height:22
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

