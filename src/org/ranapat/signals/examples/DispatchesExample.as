package org.ranapat.signals.examples {
	import flash.utils.Dictionary;
	import org.ranapat.signals.MetadataAnalyzer;
	import org.ranapat.signals.Signal;
	import org.ranapat.signals.Signals;
	import org.ranapat.signals.Slot;
	
	public class DispatchesExample {
		public static const ValueChangedSignal:Signal = new Signal(null, { key: Signals.__LINK__, value: "__setValue" } );
		
		//public static var __signals__:Dictionary = new Dictionary();
		public var __signals__:Dictionary = new Dictionary();
		
		public var anotherValue:String;
		
		private var _value:int;
		public function set value(_value:int):void {
			this.__setValue.apply(this, [ _value ]);
		}
		public function get value():int {
			return this._value;
		}
		//[Emits(object = "org.ranapat.signals.examples.DispatchesExample", signal = "ValueChangedSignal", values = "value,anotherValue")]
		//[Emits(signal = "ValueChangedSignal", values = "value,anotherValue")]
		//[Emits(values = "value,anotherValue")]
		//[Emits()]
		public var __setValue:Function = function (_value:int):void {
			this._value = _value;
			this.anotherValue = "anotherValue::" + _value;
		}
		
		public function DispatchesExample() {
			Signals.autoEmitAll(this);
			
			this.anotherValue = "hi";
			
			trace("link (1) result is " + Signals.link(this, DispatchesExample.ValueChangedSignal.get(Signals.__LINK__), this.handleValueChanged, this));
			
			this.value = 5;
			this.value = 6;
		}
		
		public function doTheTest():void {
			this.value = 7;
			this.value = 8;
		}
		
		public function handleValueChanged(__value:int = -1, _anotherValue:String = null):void {
			trace("....... we are here (1)........ " + __value + " .. " + value + " .. " + anotherValue + " .. " + _anotherValue);
		}
		
	}

}