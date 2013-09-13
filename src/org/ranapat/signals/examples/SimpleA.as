package org.ranapat.signals.examples {
	import org.ranapat.signals.Signal;
	
	public class SimpleA {
		public var signalA:Signal = new Signal(this);
		
		public function SimpleA() {
		}
		
		public function test(value:int):void {
			this.signalA.emit(value);
		}
		
	}

}