package org.ranapat.signals.examples {
	import org.ranapat.signals.Signal;
	import org.ranapat.signals.Signals;
	
	public class ClassA {
		public static const SIGNAL_A:Signal = new Signal();
		public static const SIGNAL_B:Signal = new Signal();
		
		public function ClassA() {
			
		}
		
		public function doEmit():void {
			Signals.emit(ClassA.SIGNAL_A, this, [ "test1" ] );
		}
		
	}

}