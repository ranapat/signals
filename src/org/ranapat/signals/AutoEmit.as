package org.ranapat.signals {
	import flash.utils.Dictionary;
	
	public class AutoEmit implements AutoEmitable {
		private var ___signals__:Dictionary;
		
		public function AutoEmit() {
			this.___signals__ = new Dictionary();
		}
		
		public function get __signals__():Dictionary {
			return ___signals__;
		}
		
		public function set __signals__(value:Dictionary):void {
			___signals__ = value;
		}
		
	}

}