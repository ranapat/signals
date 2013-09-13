package org.ranapat.signals {
	import flash.utils.Dictionary;
	
	internal final class SlotInternalObject {
		public var slot:Slot;
		public var priority:int;
		public var once:Boolean;
		
		public function SlotInternalObject(slot:Slot, priority:int = 0, once:Boolean = false) {
			this.slot = slot;
			this.priority = priority;
			this.once = once;
		}
	}

}