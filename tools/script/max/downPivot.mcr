macroScript downPivot
category:"Superpolo"
ButtonText:"downPivot" 
tooltip:"downPivot" Icon:#("Maxscript", 7)
(
	fn down_pivot =(
		o = getcurrentselection()
		if o.count != 0 then
		(
			for i = 1 to o.count do
			(
				ResetXForm o[i]
				convertToPoly o[i]
				max modify mode
				
				bb = nodeLocalBoundingBox o[i]
				cen = (bb[1]+bb[2])/2
				o[i].pivot = [cen.x,cen.y,bb[1].z]
				
				ResetXForm o[i]
				convertToPoly o[i]
				max modify mode
			)
		)
	)
	
	rollout d_pivot_Rollout "整理中心坐标" width:160 height:45
	(
		button d_pivot_btn "整理坐标(D_pivot)" pos:[11,10] width:140 height:23
		on d_pivot_btn pressed  do
		(
			down_pivot()
		)
	)
	createdialog d_pivot_Rollout
)

