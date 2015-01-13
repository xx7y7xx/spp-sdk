macroScript CageModel_Tool
category:"Superpolo"
ButtonText:"CageModel_Tool" 
tooltip:"CageModel_Tool" Icon:#("Maxscript",12)
(

	fn  merge_spline_to_poly op =
	(-- op: 3 - merge  2 - subtraction
		clearlistener()
	-- 	һ ����ghosttown��ʹ�ã��ó�����
	-- 1.���ߣ�ƴͼ�Σ����þ�ȷ
	-- 2.converttopoly
	-- 3.����proboolean

	-- ���´�����shape��ģ�ͺ��塪��>�Ȱ���ת����poly���ٺ���poly
		
		spline_arr = #()
		geom_arr = #()
		gspline_arr = #()
		boolnode = #()
		bl
		
		try (
		sel = for i in selection collect i 
		if sel.count >2 then
		(
			for i in sel do
			(
				aa = convertToSplineShape  i
				if aa != undefined do
				(
					append spline_arr i
				)
				if (classof i) == Editable_Poly or (classof i) == Editable_mesh do
				(
					append geom_arr i
				)
			)
			geom_arr
			
			for i in spline_arr do
			(
				converttopoly i
				append gspline_arr i
			)
			bl = gspline_arr[1]
-- 			boolnode[1] = gspline_arr[1]
-- 			bl = boolnode[1]
			deleteItem gspline_arr 1
			ProBoolean.CreateBooleanObjects bl gspline_arr 3 2 0
			select bl
			converttopoly bl
			resetxform bl
			converttopoly bl
			
			ProBoolean.CreateBooleanObjects bl geom_arr op 2 0
			select bl
			converttopoly bl
			resetxform bl
			converttopoly bl
			bl.wirecolor = (color 214 228 153)
		)else if sel.count == 2 then 
		(
			a = converttopoly sel[1]
			b = converttopoly sel[2]
			ProBoolean.CreateBooleanObjects a b op 2 0
			select a
			converttopoly a
			resetxform a
			converttopoly a
			a.wirecolor = (color 214 228 153)
		)else (messagebox"���ѡ�����壡")
		)catch(messagebox"ģ�ͽṹ̫���ӣ����߱�����")
		
	)
	

	fn select_similar = 
	(
		allGeom = for i in geometry collect i
		if nodeGetBoundingBox != undefined do
		(
			selsimilar = for i in allGeom where (nodeGetBoundingBox i i.transform) as string == (nodeGetBoundingBox $ $.transform) as string collect i
			select selsimilar
		)
	)
	-- select_similar()

	rollout CageModel_Tool_Rollout "CageModel_Tool" width:162 height:101
	(
		button btn1 "�������棨+��" pos:[14,10] width:131 height:28
		button btn2 "�������棨-��" pos:[16,49] width:128 height:26
		on btn1 pressed  do
		(
			merge_spline_to_poly 3
		)
		on btn2 pressed  do
		(
			merge_spline_to_poly 2
		)
	)
	createdialog CageModel_Tool_Rollout
)