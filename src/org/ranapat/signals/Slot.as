package org.ranapat.signals {
	import flash.sampler.getSavedThis;
	import flash.utils.Dictionary;
	
	public class Slot {
		private var weak:Dictionary;
		
		public var callbackName:String;
		
		public function Slot(callback:Function, object:Object = null) {
			this.weak = new Dictionary(true);
			this.weak[(object? object : getSavedThis(callback))] = 1;
			
			this.callbackName = Tools.getFunctionName(callback);
		}
		
		public function getFunction(object:Object = null):Function {
			return (object? object : this.object)[this.callbackName];
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