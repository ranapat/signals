package org.ranapat.signals {
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
			if (_object) {
				Signals.emit(_object, this, args);
				
				result = true;
			}
			return result;
		}
		
		public function connect(object:Object, callback:Function, priority:int = 0, once:Boolean = false):Boolean {
			var result:Boolean = false;
			var _object:Object = this.object;
			if (_object) {
				Signals.connect(_object, this, new Slot(callback), object, priority, once);
				
				result = true;
			}
			return result;
		}
		
		public function disconnect(slot:Slot = null):Boolean {
			var result:Boolean = false;
			var _object:Object = this.object;
			if (_object) {
				Signals.disconnect(_object, this, slot);
				
				result = true;
			}
			return result;
		}
		
		private function get object():* {
			if (this.weak) {
				for (var object:Object in this.weak) {
					return object;
				}
			}
			return null;
		}
		
	}

}