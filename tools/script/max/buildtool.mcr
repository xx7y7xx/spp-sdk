macroScript SPP_buildTool
category:"Superpolo"
ButtonText:"Build ToolSet" 
tooltip:"Spp Build ToolSet" Icon:#("Maxscript",2)
(

	
	fn getCmdPath = 
	(--�õ���Ŀ��·�� 

		p =maxFilePath
		cmd_p = ""
		cmd = ""
		if p != "" then 
		(-- �ж��Ƿ񱣴��ļ�
			p_arr = filterString p "\\"
			projectPath = p_arr[1] + "\\" + p_arr[2]
			if p_arr.count>3 and projectPath == "D:\p" then 
			(
				cmd_p = p_arr[1] + "\\" + p_arr[2] + "\\" + p_arr[3]
				cmd = "cd /d " +cmd_p
			)else
			(
				messagebox "�뱣������ȷ����ĿĿ¼�£�"
			)
			
		)else
		(
			messagebox "�뱣�泡����"
		)
		cmd

	)
-- 	 getCmdPath()
	-- �鿴build����
	-- cmd = getCmdPath()
	-- DOSCommand (cmd + " -h & pause")
	--------------------------------------------
	--���¹�����Ŀ�������ɰ�װ��
	-- cmd = getCmdPath()
	-- DOSCommand (cmd + "-publish")

	rollout builder "����鿴��" width:246 height:303
	(
		button btn1 "����Ԥ��" pos:[27,35] width:193 height:22
		GroupBox grp1 "����鿴��" pos:[11,11] width:222 height:57
		GroupBox grp2 "�����鿴��" pos:[11,80] width:223 height:214
		button btn3 "��̬�����" pos:[21,100] width:203 height:27
		button btn4 "��Ʒ�ʺ決" pos:[22,130] width:202 height:27
		button btn5 "ֻ�Ĺ���ͼ������˰�ť���¼���" pos:[15,225] width:216 height:27
		button btn6 "���Ⱥ決" pos:[111,179] width:112 height:27
		dropdownList ddl1 "��ϸ��" pos:[26,164] width:77 height:41 items:#("25", "49", "100", "225", "400")
		button btn47 "Ԥ��" pos:[23,255] width:198 height:29
		on btn1 pressed do
		(
			messagebox"�����У�����"
		)
		on btn3 pressed do
		(
			-- ��̬�ƹ�build
			cmd = getCmdPath()
			if cmd != "" do
			(
	-- 			DOSCommand (cmd+" & sppbuild")
				cmdstr = "/C \"" +	cmd+" & sppbuild"
				ShellLaunch "cmd" cmdstr	
				
			)
		)
		on btn4 pressed do
		(
			--����Ĭ�ϲ����決������Ĭ��ֵΪ16
			cmd = getCmdPath()
			if cmd != "" do
			(
-- 				DOSCommand (cmd +" & sppbuild --lighter")
				cmdstr = "/C \"" + cmd +" & sppbuild --lighter"
				ShellLaunch "cmd" cmdstr
			)
		)
		on btn5 pressed do
		(
			-- ����ʽ�����������targetĿ¼
			cmd = getCmdPath()
			if cmd != "" do
			(
				
-- 				DOSCommand (cmd + " & sppbuild --build")
				cmdstr = "/C \"" + cmd + " & sppbuild --build"
				ShellLaunch "cmd" cmdstr
			)
		)
		on btn6 pressed do
		(
			--ָ�������決������Ĭ��ֵΪ16
			cmd = getCmdPath()
			if cmd != "" do
			(
				inten = ddl1.selected 
-- 				DOSCommand (cmd + " & sppbuild --lighter2=" + inten )
				cmdstr = "/C \"" + cmd + " & sppbuild --lighter2=" + inten 
				ShellLaunch "cmd" cmdstr
			)
		)
		on btn47 pressed do
		(
			-- ���targetĿ¼
			cmd = getCmdPath() 
			if cmd != "" do
			(
				--DOSCommand (cmd + "\\target & spp --tools=\"viewscene\"")
				cmdstr = "/C \"" + cmd + "\\target & spp --tools=viewscene\""
				-- messageBox cmdstr
				ShellLaunch "cmd" cmdstr
			)
		)
	)
	try(destroyDialog builder)catch()
	CreateDialog builder
)



