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

(function(){

// String辅助工具

/**
 * @brief 字符串是否以某个字符串开头。
 * @details 来源：http://rickyrosario.com/blog/javascript-startswith-and-endswith-implementation-for-strings/
 */
String.prototype.startsWith = function(prefix) {
    return this.indexOf(prefix) === 0;
};

})();

}
catch(e)
{
	alert(e);
}