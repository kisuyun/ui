//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, May 2, 2012  10:09:21 AM
// Author: henrichen

/**
 * Accelerometer implementation for Cordova device.
 */
class CordovaAccelerometer extends AbstractAccelerometer {
	void getCurrentAcceleration(AccelerationEventListener onSuccess, ErrorListener onError) {
		_getCurrentAcceleration0(_wrapFunction(onSuccess), onError);
	}

	watchAcceleration(AccelerationEventListener onSuccess, ErrorListener onError, [Map options]) {
		String opts = options === null || options["frequency"] === null ? '{"frequency":3000}' : JSON.stringify(options);
print("CordovaAccelerometer.watchAcceleration: opts:"+opts);		
		return _watchAcceleration0(_wrapFunction(onSuccess), onError, opts);
	}
	
	void clearWatch(var watchID) {
print("CordovaAccelerometer.clearWatch: watchID:"+watchID);		
		_clearWatch0(watchID);
	}

	//parameter called back from javascript Cordova would be a {}, must convert paremeter type back to dart Acceleration
	_wrapFunction(dartFn) {   
		var $dartFn = dartFn;
		return ((Acceleration accel) { //Use Acceleration to trick frogc to generate proper code
		  print("orignal accel is Acceleration:"+ (accel is Acceleration));
		  $dartFn(new AccelerationEvent(this, new Acceleration(accel.x, accel.y, accel.z, accel.timestamp)));});
	}

	void _getCurrentAcceleration0(AccelerationEventListener onSuccess, ErrorListener onError) native
		"navigator.accelerometer.getCurrentAcceleration(onSuccess, onError);";
	_watchAcceleration0(AccelerationEventListener onSuccess, ErrorListener onError, String opts) native
		"return navigator.accelerometer.watchAcceleration(onSuccess, onError, opts ? JSON.parse(opts) : null);";
	void _clearWatch0(var watchID) native
		"navigator.accelerometer.clearWatch(watchID);";
}
