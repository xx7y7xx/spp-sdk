/**************************************************************************
 *
 *  This file is part of the UGE(Uniform Game Engine).
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *
 *  See http://uge.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://uge.spolo.org/  sales@spolo.org uge-support@spolo.org
 *
**************************************************************************/

try {

	MAN = {
		name : "man",
		property : {
			meshName : "man"
		},
		pc : {
			"pcmesh" : {
				action : [
					{
						name : "SetMesh",
						param : [
							['name','man']
						]
					},
					{
						name : "SetAnimation",
						param : [
							['animation','stand'],
							['cycle',true]
						]
					},
					{
						name : "SetVisible",
						param : [
							['visible',false]
						]
					},
					{
						name : "RotateMesh",
						param : [
							['rotation',[0, 0.08, 0]]
						]
					}
				]
			},
			"pclight" : {},
			"pclinearmovement" : {},
			"pcactormove" : {},
			"pcmover" : {},
			"pctimer" : {},
			"pccommandinput" : {
				action : [
					{
						name: "Activate",
						param:[
							['activate', false]
						]
					},
					{
						name : "Bind",	//Êó±ê×ó¼üµã»÷
						param : [
							['trigger','MouseButton0'],
							['command','mouseleft']
						]
					}
				]
			}
		},
		event : {}
	};
}
catch (e)
{
	alert(e);
}