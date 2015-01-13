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

try{

require("console.js");

/// 在CUI下画图用的。
/// @reference wikipedia:Curses_(programming_library)
/// 接口模仿的[http://search.cpan.org/~marcus/Curses-UI-0.95/ Curses-UI]
var CursesUI = null;

(function(){
	CursesUI = {};
	
	CursesUI.ProgressBar = function(max, pos)
	{
		max /= 3;
		pos /= 3;
		var progressBar = "[";
		for(var i = 0; i < max; i++)
		{
			if(i < pos)
				progressBar += "=";
			else
				progressBar += " ";
		}
		progressBar += "]  " + Math.round(pos/max*100) + "%";
		console.debug(progressBar + "\n");
	}
	
})();

}catch(e){
	alert(e);
}