package org.ranapat.signals {
	import flash.utils.Dictionary;
	
	internal final class SlotObject {
		private var dictionary:Dictionary;
		
		public function SlotObject(slot:Slot, slotObject:Object, priority:int = 0, once:Boolean = false) {
			this.dictionary = new Dictionary(true);
			this.dictionary[slotObject] = new SlotInternalObject(slot, priority, once);
		}
		
		public function get value():SlotInternalObject {
			for (var object:* in this.dictionary) {
				return this.dictionary[object] as SlotInternalObject;
			}
			return null;
		}
		
		public function get key():* {
			for (var object:* in this.dictionary) {
				return object;
			}
			return null;
		}
		
		public function get slot():Slot {
			var tmp:SlotInternalObject = this.value;
			if (tmp) {
				return tmp.slot;
			}
			return null;
		}
		
		public function get priority():int {
			var tmp:SlotInternalObject = this.value;
			if (tmp) {
				return tmp.priority;
			}
			return 0;
		}
		
		public function get once():Boolean {
			var tmp:SlotInternalObject = this.value;
			if (tmp) {
				return tmp.once;
			}
			return false;
		}
	}

}