package org.ranapat.signals.examples {
	import flash.utils.Dictionary;
	import org.ranapat.signals.Signals;
	
	public class SimpleDispatchExample {
		public static var __signals__:Dictionary = new Dictionary();
		
		private var _value:uint;
		
		public function SimpleDispatchExample() {
			Signals.autoEmitAll(this);
		}
		
		public function get value():uint {
			return this._value;
		}
		
		public function set value(_value:uint):void {
			this.__setValue.apply(this, [ _value ]);
		}
		
		//[Emits(values = "value")]
		[Emits]
		public var __setValue:Function = function (_value:uint):void {
			this._value = _value;
		}
		
	}

}