macroScript SPP_ChangeNameTool
category:"Superpolo"
ButtonText:"ChangeNameTool" 
tooltip:"ChangeNameTool" Icon:#("Maxscript", 6)
(
	rollout ChangeNameTool "修改物体名称" width:162 height:90
	(
		button btn1 "修改物体名称" pos:[16,22] width:128 height:23
		
		on btn1 pressed do
		(
			for i in geometry do
			(
				try(
				index = findstring i.name "_"						
				i.name = replace i.name index 1 "#"
				)catch()
			)
		)
	)
	gw = newRolloutFloater "Spp Scene ToolModify" 185 705
	addrollout  ChangeNameTool gw
)