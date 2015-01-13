fn scene_clean = 
(
	heapSize += 2000000
-- scene clean

-------------------------------------- 清理环境
-- delete  sort

--------------------- delete
-- light camera
-- Particle_View
--------------------- ungroup
-- ungroup
--------------------- convert to poly
-- ChamferCyl
-- Circle
-- SplineShape
--------------------- delete
-- non poly count object 
--------------------- delete
-- dummy
---------------------------------------
pv = #()
group_arr = #()
nonface_arr = #() 
dummy_arr = #()

clearlistener()
for i in objects do
(
	co = classof i 

-- 	format "%\n" i.name
-- 	format "%\n" co
-- 	format "%\n\n\n" pc
	
	-- Particle_View
	if co == Particle_View do
	(
		append pv i 	
	)
)

------------------------------------------- light camera Particle_View
delete cameras
delete lights
delete pv

gc light:false delayed:false


------------------------------------------- ungroup all 

for i in objects do
(
	co = classof i 
	gh = isGroupHead i 
	if gh == true do
	(
		append group_arr i
	)
	
)
for i in group_arr do
(
	ungroup i
	
)
gc light:false delayed:false
-------------------------------------------- convert to poly
for i in objects do
(
	converttopoly i
	resetxform i
	converttopoly i
	
)
gc light:false delayed:false
-------------------------------------------- delete non poly count object 
for i in objects do
(
	pc = getPolygonCount i
	faceN = pc[1]	
	if faceN == 0 do
	(
		append nonface_arr i
	)
)
delete nonface_arr
gc light:false delayed:false
-------------------------------------------- delete dummy
for i in objects do
(
	co = classof i
	if co == dummy do
	(
		append dummy_arr i 	
	)
	
)
delete dummy_arr
gc light:false delayed:false
all_obj = for i in objects collect i
all_obj.count
)
scene_clean()