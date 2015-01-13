fn checkProPath = 
(
	proPath =""
	-- �жϵ�ǰ��Ŀ��·�����Ƿ���� \src\art
	srcIndex = findString maxFilePath "src\\art\\"
	
	if srcIndex!=undefined then
	(
		proPath = substring maxFilePath 1 (srcIndex-2)
	)
	else
	(
		messagebox "�뱣������ȷ����ĿĿ¼�£�"
	)
	
	proPath
	
)

fn buildCHname =
( -- �ض���������������----user define  
/* 	
	<world>
		<meshobj name="cc_02#001" cname="��ѧ¥" />
	</world>
 */	
	pathN = checkProPath() + "\\src\\art\\position\\"
	makeDir pathN
	fileN = "build.xml"
	outFile = createFile ( pathN + fileN )
	
	if selection.count ==0 then
	(
		messagebox"��ѡ����Ҫ���������Ϣ�����壡"
	)else
	(
		format "<world>\n" to:outFile
		for i in selection do
		(
			objzhn = getUserProp i "cname"
			if objzhn != undefined do
			(
				format "\t<meshobj name=\"%\" cname=\"%\" />\n" i.name objzhn  to:outFile
			)
		)
		format "</world>\n" to:outFile
	)
	close outFile 
	messageBox "��������Ϣ�������Ѿ������ϣ�"
)

--����ǲ���ʹ��
buildCHname()

--�������������ѡ��ģ�͵���������
setUserProp $ "cname" "ͼ���"