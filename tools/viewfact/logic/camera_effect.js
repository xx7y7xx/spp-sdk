/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

/* ==========================================================================================================
	���¶Ը��ļ�����˵����
		���ļ���Ҫ��������¼�����Ӧ���磺
			1. ������ �� ��ס���ţ�����������ˮƽ��ת��
			2. ����Ҽ� �� ��ס���ţ�����������������ת��
			3. ����ƶ� �� ��ȡ����¼����������Ϣ��
 ==========================================================================================================*/
 
try{
	(function(){
		
		/*	ͨ����껬����ȡ���������Ϣ	*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//������ƶ��Ĺ�����ʱ�̻�ȡ��ǰ����Ļ���������꣬x��y
			player.mousex = e.x;
			player.mousey = e.y;
		},"crystalspace.input.mouse.0.move");
		
		/*	����Ҽ���ת	*/
		Event.Subscribe(function(e){
			var actor = e.player;
			//��������Ҽ�Ϊ����״̬
			// actor.mouseright = true;
			//��ȡplayer�ĵ�ǰλ������
			var position = actor.pcarray['pcmesh'].GetProperty('position');
			var rotation = actor.pcarray['pcmesh'].GetProperty('rotation');
			iCamera.pcarray['pcmesh'].PerformAction(
				'MoveMesh'
					[
						'position',[position.x, position.y, position.z],
						'rotation',[rotation.x, rotation.y, rotation.z]
					]
			);
			iCamera.pcarray['pcdefaultcamera'].PerformAction('SetFollowEntity',['entity','camera']);
		},"camera.effect.mouserightrotation");
		
		/* ������ק */
		Event.Subscribe(function(e){
			var actor = e.player;
			var startX = player.startX ;
			var startY = player.startY ;
			var x = player.mousex ;
			var y = player.mousey ;
			if(player.mouseleft){
				// �������ˮƽ��ק����ת�Ƕ�
				if( x > startX ) {
					// ��ת
					iCamera.pcarray['pcmesh'].PerformAction('RotateMesh', ['rotation',[0, -0.01, 0]]);
				}else{
					// ��ת
					iCamera.pcarray['pcmesh'].PerformAction('RotateMesh', ['rotation',[0, 0.01, 0]]);
				}
			}
			if(player.mouseright){
				/*	�������仯�Լ������rotation�ı仯	*/
				var g2d = C3D.g2d;
				var screen_width = g2d.width;
				//����camera��ƫת
				var rotationy = ((x - startX)/screen_width)*Math.PI/2;
				var rotationY = actor.startRotationY - rotationy;
				if(rotationY <= -Math.PI){
					rotationY = 2*Math.PI + rotationY;
				}
				if(rotationY <= Math.PI){
					rotationY = -2*Math.PI + rotationY;
				}
				//	���player��ǰ��λ��
				var current_pos = actor.pcarray['pcmesh'].GetProperty('position');
				//	�����������ת
				iCamera.pcarray['pcmesh'].PerformAction(
					'MoveMesh',
						[
							'position',[current_pos.x, current_pos.y,current_pos.z],
						],
						[
							'rotation',[0, 0-rotationY, 0]
						]
				);
				//����camera��pitchֵ 
				var screen_height = g2d.height;
				var cameraPitch = player.startPitch + ((startY-y)/screen_height)*0.5;
				iCamera.pcarray['pcdefaultcamera'].SetProperty('pitch',cameraPitch);
			}
		},"camera.effect.mousemove");
	})();
} catch(e){
	alert(e);
}