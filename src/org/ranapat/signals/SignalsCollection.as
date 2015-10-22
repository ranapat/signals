package org.ranapat.signals {
	import flash.utils.Dictionary;
	
	internal final class SignalsCollection {
		private var dictionary:Dictionary;
		
		public function SignalsCollection() {
			this.dictionary = new Dictionary(true);
		}
		
		public function add(signal:Signal, slot:Slot, slotObject:Object, priority:int = 0, once:Boolean = false):void {
			var tmp:Vector.<SlotObject> = this.dictionary[signal] as Vector.<SlotObject>;
			tmp = tmp? tmp : new Vector.<SlotObject>();

			var inserted:Boolean = false;
			var length:uint = tmp.length;
			for (var i:uint = 0; i < length; ++i) {
				if (priority < tmp[i].priority) {
					tmp.splice(0, 0, new SlotObject(slot, slotObject, priority, once));
					
					inserted = true;
					break;
				}
			}
			if (!inserted) {
				tmp.push(new SlotObject(slot, slotObject, priority, once));
			}
			
			this.dictionary[signal] = tmp;
		}
		
		public function remove(signal:Signal, slot:Slot = null):void {
			var tmp:Vector.<SlotObject> = this.dictionary[signal] as Vector.<SlotObject>;
			
			if (tmp) {
				if (slot != null) {
					var length:uint = tmp.length;
					for (var i:uint = 0; i < length; ++i) {
						if (tmp[i].slot == slot) {
							tmp.splice(i, 1);
							break;
						}
					}
					
					this.dictionary[signal] = tmp;
				} else {
					this.dictionary[signal] = null;
					delete this.dictionary[signal];
				}
			}
		}
		
		public function emit(signal:Signal, parameters:Array = null):void {
			var tmp:Vector.<SlotObject> = this.dictionary[signal] as Vector.<SlotObject>;
			
			if (tmp) {
				var length:uint = tmp.length;
				for (var i:uint = 0; i < length; ++i) {
					var sTmp:SlotObject = tmp[i];
					var ssTmp:Slot = sTmp.slot;
					if (ssTmp != null) {
						try {
							var sssTmp:Function = ssTmp.getFunction(sTmp.key);
							sssTmp.apply(null, Tools.arrayToFixedCount(sssTmp.length, parameters));
						} catch (e:Error) {
							CONFIG::debug { trace(e.getStackTrace()); }
							trace("4:[Signals] Failed to call slot in " + sTmp.key + "::" + ssTmp.callbackName + " with reason " + e);
						}
						if (sTmp.once) {
							tmp.splice(i, 1);
							--i;
							--length;
						}
					}
				}
			}
		}
		
	}

}