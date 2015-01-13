
--存储源数据
fn getProjectPath = 
(
	p = maxFilePath
	p = tolower p
	thisProjectPath = ""
	if p == "" then -- 判断是否保存文件
	(
		messagebox "请保存场景！"
		return false
	)
	else
	(
		p_arr = filterString p "\\"
		allProjectsPath = p_arr[1] + "\\" + p_arr[2]
		if p_arr.count>3 and allProjectsPath == "d:\p" then 
		(
			thisProjectPath = p_arr[1] + "\\" + p_arr[2] + "\\" + p_arr[3]
		)
		else
		(
			messagebox "请保存在正确的项目目录下！\n(Make sure this project is in [D:\\p\\] path)"
			return false
		)
	)
	return thisProjectPath
)
getProjectPath()

for obj in geometry do
(
	obj=$box01
	CenterPivot obj
	obj.pivot.z = obj.pivot.z-obj.height/2
	ResetXForm obj
	pos_o =obj.pos		
	obj.pos = [0,0,0]
	convertToPoly obj
	/* 输出材质 */
	obj_name=obj.name
	obj_name=obj_name + ".obj"
    filepath = getprojectpath()+"\\src\\art\\scene\\"
   -- makeDir (filepath + obj_name)--在当前处理的max路径下建立以对象物体为名的文件夹
    --输出这个文件成一个.x文件，并保存为以物体为名的文件夹内。
    filename=filepath + obj_name
	exportfile filename selectedOnly:TRUE
	obj.pos = pos_o
)
messagebox ("完毕")
