/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/

Event.key = {
	value : {
		// 功能键值
		backspace : 8, 	//  "Backspace"键值
		TAB : 9,        //  "Tab"
		ENTER : 10,     //  "Enter"
		ESC : 27,       //  "ESC"
		space : 32,	    //  空格键
		quotaMark : 39, //  "'"键值
		semicolon : 59, //  ";"键值
		comma : 44,     //  ","键值
		sub : 45,       //  "-"键值
		add : 61,      	//  "+"键值
		period : 46,    //  "."键值
		slash : 47,     //  "/"键值
		left_brackets : 91,   // "["键值
		right_brackets : 93,  // "]"键值
		backSlash : 92, 	  // "\"键值
		point : 96, 	// "~"键值
		CapsLock : 1089663,  //  大小写锁定
		
		// alt, ctrl, shift
		// Left
		ctrlLeft : 1089568,
		shiftLeft : 1089536,
		altLeft : 1089600,
		// Right
		ctrlRight : 1089569,
		shiftRight : 1089537,
		altRight : 1089601,
		// 键盘模拟鼠标的右击功能
		CONTEXT : 1081354,      //  "右键"
		
		// 数值键
		numKey0 : 48, //  数值"0"
		numKey1 : 49, //  数值"1"
		numKey2 : 50, //  数值"2"
		numKey3 : 51, //  数值"3" 
		numKey4 : 52, //  数值"4"
		numKey5 : 53, //  数值"5"
		numKey6 : 54, //  数值"6"
		numKey7 : 55, //  数值"7"
		numKey8 : 56, //  数值"8"
		numKey9 : 57, //  数值"9"
		
		
		// 大写字母键值
		A : 65, //字母"A"
		B : 66, //字母"B"
		C : 67, //字母"C"
		D : 68, //字母"D"
		E : 69, //字母"E"
		F : 70, //字母"F"
		G : 71, //字母"G"
		H : 72, //字母"H"
		I : 73, //字母"I"
		J : 74, //字母"J"
		K : 75, //字母"K"
		L : 76, //字母"L"
		M : 77, //字母"M"
		N : 78, //字母"N"
		O : 79, //字母"O"
		P : 80, //字母"P"
		Q : 81, //字母"Q"
		R : 82, //字母"R"
		S : 83, //字母"S"
		T : 84, //字母"T"
		U : 85, //字母"U"
		V : 86, //字母"V"
		W : 87, //字母"W"
		X : 88, //字母"X"
		Y : 89, //字母"Y"
		Z : 90,	//字母"Z"
		
		// 小写字母键值
		a : 97,  // 字母"a"
		b : 98,  // 字母"b"
		c : 99,  // 字母"c"
		d : 100, // 字母"d"
		e : 101, // 字母"e"
		f : 102, // 字母"f"
		g : 103, // 字母"g"
		h : 104, // 字母"h"
		i : 105, // 字母"i"
		j : 106, // 字母"j"
		k : 107, // 字母"k"
		l : 108, // 字母"l"
		m : 109, // 字母"m"
		n : 110, // 字母"n"
		o : 111, // 字母"o"
		p : 112, // 字母"p"
		q : 113, // 字母"q"
		r : 114, // 字母"r"
		s : 115, // 字母"s"
		t : 116, // 字母"t"
		u : 117, // 字母"u"
		v : 118, // 字母"v"
		w : 119, // 字母"w"
		x : 120, // 字母"x"
		y : 121, // 字母"y"
		z : 122, // 字母"z"

		// 方向键值
		UP : 1081344,     //  方向键上
		DOWN : 1081345,   //  方向键下
		LEFT : 1081346,   //  方向键左
		RIGHT : 1081347,  //  方向键右
		// 功能键值
		PGUP : 1081348,         //  "PageUp"
		PGDN : 1081349,         //  "PageDwon"
		HOME : 1081350,         //  "Home"
		END : 1081351,          //  "End"
		INS : 1081352,          //  "Insert"
		DEL : 1081353,          //  "Delete"
		ScrLock : 1089727,      //  "ScrLock"
		PRINTSCREEN : 1081355,  //  "PrintScreen"
		PAUSE : 1081356,        //  "Pause"
		
		// F功能键值
		F1 :  1081360,  //  "F1"
		F2 :  1081361,  //  "F2"
		F3 :  1081362,  //  "F3"
		F4 :  1081363,  //  "F4"
		F5 :  1081364,  //  "F5"
		F6 :  1081365,  //  "F6"
		F7 :  1081366,  //  "F7"
		F8 :  1081367,  //  "F8"
		F9 :  1081368,  //  "F9"
		F10 : 1081369,  //  "F10"
		F11 : 1081370,  //  "F11"
		F12 : 1081371,  //  "F12"
		
		// 小键盘键值
		PADNumLock : 1106079,
		// 小键盘数值键值
		PAD0 : 1097776,  //  "0"
		PAD1 : 1097777,  //  "1"
		PAD2 : 1097778,  //  "2"
		PAD3 : 1097779,  //  "3"
		PAD4 : 1097780,  //  "4"
		PAD5 : 1097781,  //  "5"
		PAD6 : 1097782,  //  "6"
		PAD7 : 1097783,  //  "7"
		PAD8 : 1097784,  //  "8"
		PAD9 : 1097785,  //  "9"
		//  小键盘功能键
		PADDECIMAL : 1097774,// .
		PADDIV : 1097775,    // /
		PADMULT : 1097770,   // *
		PADMINUS : 1097773,  // -
		PADPLUS : 1097771,   // +
		PADENTER : 1097738,  // Enter
	},
	type : {
		up : 0,
		down : 1,
	}
	
};