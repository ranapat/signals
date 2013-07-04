package org.ranapat.signals {
	
	public class Slot {
		public var callbackName:String;
		
		public function Slot(callback:Function) {
			this.callbackName = Tools.getFunctionName(callback);
		}
		
		public function getFunction(_class:Object):Function {
			return _class[this.callbackName];
		}
		
	}

}