package org.ranapat.signals {
	import flash.sampler.getSavedThis;
	import flash.utils.Dictionary;
	
	public class Signal {
		private var weak:Dictionary;
		private var dictionary:Dictionary;
		
		public function Signal(object:Object = null, ...args) {
			if (object) {
				this.weak = new Dictionary(true);
				this.weak[object] = 1;
			}
			
			this.dictionary = new Dictionary(true);

			if (args is Array) {
				for each (var obj:Object in args) {
					if (obj.hasOwnProperty("key") && obj.hasOwnProperty("value")) {
						this.set(obj["key"], obj["value"]);
					}
				}
			} else if (args is Object) {
				if (obj.hasOwnProperty("key") && obj.hasOwnProperty("value")) {
					this.set(obj["key"], obj["value"]);
				}
			}
		}
		
		public function set(key:*, value:*):void {
			this.dictionary[key] = value;
		}
		
		public function get(key:*):* {
			return this.dictionary[key];
		}
		
		public function emit(...args):Boolean {
			var result:Boolean = false;
			var _object:Object = this.object;
			if (_object || SignalsSettings.ALLOW_NULL_OBJECTS) {
				Signals.emit(this, _object, args);
				
				result = true;
			} else if (!_object && !SignalsSettings.ALLOW_NULL_OBJECTS) {
				trace("2:[Signals] :: Signal::emit :: SignalsSettings.ALLOW_NULL_OBJECTS is false, null objects rejected!");
			}
			return result;
		}
		
		public function connect(callback:Function, object:Object = null, priority:int = 0, once:Boolean = false):Slot {
			object = object? object : getSavedThis(callback);
			
			var result:Slot = null;
			var _object:Object = this.object;
			if (_object || SignalsSettings.ALLOW_NULL_OBJECTS) {
				result = new Slot(callback, object);
				Signals.connect(this, result, _object, object, priority, once);
			} else if (!_object && !SignalsSettings.ALLOW_NULL_OBJECTS) {
				trace("2:[Signals] :: Signal::connect :: SignalsSettings.ALLOW_NULL_OBJECTS is false, null objects rejected!");
			}
			return result;
		}
		
		public function disconnect(slot:Slot = null):Boolean {
			var result:Boolean = false;
			var _object:Object = this.object;
			if (_object || SignalsSettings.ALLOW_NULL_OBJECTS) {
				Signals.disconnect(_object, this, slot);
				
				result = true;
			} else if (!_object && !SignalsSettings.ALLOW_NULL_OBJECTS) {
				trace("2:[Signals] :: Signal::disconnect :: SignalsSettings.ALLOW_NULL_OBJECTS is false, null objects rejected!");
			}
			return result;
		}
		
		public function get object():Object {
			if (this.weak) {
				for (var object:Object in this.weak) {
					return object;
				}
			}
			return null;
		}
		
	}

}