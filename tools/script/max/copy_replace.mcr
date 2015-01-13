
macroScript copy_replace
category:"Superpolo"
ButtonText:"copy_replace" 
tooltip:"copy_replace" Icon:#("Maxscript", 6)
(
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
	----------------------------------------------------------------
	
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

	createdialog seed_replace_plant
)

