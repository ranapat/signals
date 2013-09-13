package org.ranapat.signals.examples {
	
	public class SimpleB {
		
		public function SimpleB(simpleA:SimpleA) {
			simpleA.signalA.connect(this.handleSignal, this);
		}
		
		public function handleSignal(value:int):void {
			trace("my value is " + value)
		}
		
	}

}