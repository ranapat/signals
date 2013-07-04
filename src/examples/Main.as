package examples {
	import flash.display.Sprite;
	import flash.events.Event;
	import org.ranapat.signals.Signals;
	
	public class Main extends Sprite {
		private var classA:ClassA;
		private var classB:ClassB;
		private var classC:ClassC;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.classA = new ClassA();
			this.classC = new ClassC();
			this.classB = new ClassB(this.classA, this.classC);
			
			this.classA.doEmit();
			this.classA.doEmit();
			
			Signals.walk();
			
			Signals.walk();
			
			this.addChild(this.classC);
			
			trace("we are here...")
			
			//addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			Signals.connectNativeCallback(this, Event.ENTER_FRAME, this.handleEnterFrame);
		}
		
		private function handleEnterFrame(e:Event):void {
			Signals.walk();
			
			this.classA = null;
			this.classB = null;
			this.classC = null;
			trace("")
		}
		
	}
	
}