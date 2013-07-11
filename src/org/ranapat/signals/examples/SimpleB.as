package org.ranapat.signals.examples {
	
	public class SimpleB {
		
		public function SimpleB(simpleA:SimpleA) {
			simpleA.signalA.connect(this, this.handleSignal);
		}
		
		public function handleSignal(value:int):void {
			trace("my value is " + value)
		}
		
	}

}