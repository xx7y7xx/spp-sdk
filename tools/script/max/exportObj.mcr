
--�洢Դ����
fn getProjectPath = 
(
	p = maxFilePath
	p = tolower p
	thisProjectPath = ""
	if p == "" then -- �ж��Ƿ񱣴��ļ�
	(
		messagebox "�뱣�泡����"
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
			messagebox "�뱣������ȷ����ĿĿ¼�£�\n(Make sure this project is in [D:\\p\\] path)"
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
	/* ������� */
	obj_name=obj.name
	obj_name=obj_name + ".obj"
    filepath = getprojectpath()+"\\src\\art\\scene\\"
   -- makeDir (filepath + obj_name)--�ڵ�ǰ�����max·���½����Զ�������Ϊ�����ļ���
    --�������ļ���һ��.x�ļ���������Ϊ������Ϊ�����ļ����ڡ�
    filename=filepath + obj_name
	exportfile filename selectedOnly:TRUE
	obj.pos = pos_o
)
messagebox ("���")
