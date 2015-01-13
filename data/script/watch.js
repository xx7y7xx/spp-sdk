/**************************************************************************
 *  This file is part of the UGE(Uniform Game Engine) of SPP.
 *  Copyright (C) by SanPolo Co.Ltd. 
 *  All rights reserved.
 *  See http://spp.spolo.org/ for more information.
 *
 *  SanPolo Co.Ltd
 *  http://spp.spolo.org/  sales@spolo.org spp-support@spolo.org
**************************************************************************/
(function(){
//watch
if (!Object.prototype.watch)
{
    Object.prototype.watch = function (prop, handler) {
		var descriptor = Object.getOwnPropertyDescriptor(this,prop);
		var getter,setter;
		if(descriptor)
		{
			getter = function () {
				return descriptor.get();
			};
			setter = function (val) {
				var oldval = descriptor.get();
				return descriptor.set(handler.call(this, prop, oldval, val));
			};
			getter.old_desc = descriptor;
		}else{
			var oldval = this[prop], newval = oldval,
			getter = function () {
				return newval;
			},
			setter = function (val) {
				oldval = newval;
				return newval = handler.call(this, prop, oldval, val);
			};
		}
		// can't watch constants
		if (delete this[prop]){
			// ECMAScript 5
			Object.defineProperty(this, prop,{
				get: getter,
				set: setter
			});
		}
    };
}

// object.unwatch
if (!Object.prototype.unwatch)
{
    Object.prototype.unwatch = function (prop) {
		var descriptor = Object.getOwnPropertyDescriptor(this,prop);
		if(descriptor && typeof descriptor.get.old_desc != "undefined")
		{
			delete this[prop];
			Object.defineProperty(this, prop,{
				get: descriptor.get.old_desc.get,
				set: descriptor.get.old_desc.set
			});
		}else{
			var val = this[prop];
			delete this[prop];
			this[prop] = val;
		}
    };
}

})();
