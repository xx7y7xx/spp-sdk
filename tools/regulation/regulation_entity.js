//�����������ȹ���ʵ�֡�
try {
	BRA = {
		name : "bra",
		pc : {
			"pccommandinput" : {
				action : [
					{
						name : "Bind",//���ͳ����е���������
						param : [
							['trigger','PadMinus'],
							['command','darkness']
						]
					},
					{
						name : "Bind",  //��߳����е���������
						param : [
							['trigger','PadPlus'],
							['command','brilliance']
						]
					},
					{
						name : "Bind",//�رմ���
						param : [
							['trigger','ESC'],
							['command','quit']
						]
					}
				]
			},
			"pclight" : {
				
			}
		},
		event : {
			//close
			"pccommandinput_quit1" : function(){
				System.Quit();
			},
			/*  ���ͻ���������  */
			"pccommandinput_darkness1" : function(){
				Event.Send({
					name: "bra.effect.darkness",
					player: this
				});
			},
			/*  ���ͻ��������� 
			"pccommandinput_darkness0" : function(){
				Event.Send({
					name: "bra.effect.darkness.stop",
					player: this
				});
			},
			 */
			 /* ��߳����е���������
			"pccommandinput_brilliance0" : function(){
				Event.Send({
					name: "bra.effect.brilliance.stop",
					player: this
				});
			},
			*/
			/*  ��߻���������  */
			"pccommandinput_brilliance1" : function(){
				Event.Send({
					name: "bra.effect.brilliance",
					player: this
				});
			}
		}
	};
}
catch (e)
{
	alert(e);
}