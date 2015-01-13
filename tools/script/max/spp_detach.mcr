macroScript SPP_detach
category:"Superpolo"
ButtonText:"SPP_detach" 
tooltip:"SPP_detach" Icon:#("Maxscript", 2)
(
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
	rollout detach_objRollout "detach_obj" width:162 height:69
	(
		button btn1 "detach_obj" pos:[16,10] width:136 height:23
-- 		button btn2 "rename_obj" pos:[15,40] width:136 height:23
		on btn1 pressed  do
		(
			detach_obj()
		)
/* 		on btn2 pressed  do
		(
			rename_objo()	
		) */
	)
	createdialog detach_objRollout
)







