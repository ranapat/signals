package examples {
	import flash.display.MovieClip;
	import flash.events.Event;
	import org.ranapat.signals.Signal;
	import org.ranapat.signals.Signals;
	
	public class ClassC extends MovieClip {
		public static const ENTER_FRAME:Signal = new Signal();
		
		public function ClassC() {
			Signals.connectNativeSignal(this, Event.ENTER_FRAME, this, ClassC.ENTER_FRAME);
		}
		
	}

}