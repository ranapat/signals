package org.ranapat.signals.examples {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.ranapat.signals.Signals;
	import org.ranapat.signals.Slot;
	
	public class ClassB {
		private var slot1:Slot = new Slot(handleSignal1);
		private var slot2:Slot = new Slot(handleSignal2);
		private var slot3:Slot = new Slot(handleSignal3);
		private var slot4:Slot = new Slot(handleSignal4);
		private var slot5:Slot = new Slot(handleSignal5);
		
		public static var dictionary:Dictionary = new Dictionary(true);
		
		public function ClassB(classA:ClassA, classC:ClassC) {
			Signals.connect(ClassA.SIGNAL_A, this.slot1, classA, this, 1, false);
			Signals.connect(ClassA.SIGNAL_A, this.slot2, classA, this, 2, false);
			Signals.connect(ClassA.SIGNAL_A, this.slot3, classA, this, 0, true);
			Signals.connect(ClassA.SIGNAL_A, this.slot4, classA, this, 4, false);
			Signals.connect(ClassA.SIGNAL_A, this.slot5, classC, this, 0, false);
		}
		
		public function handleSignal1(param:String):void {
			trace("we are here..... (1) @@@@@@@@@@@ " + param)
		}
		public function handleSignal2(param:String):void {
			trace("we are here..... (2) @@@@@@@@@@@ " + param)
		}
		public function handleSignal3(param:String):void {
			trace("we are here..... (3) @@@@@@@@@@@ " + param)
		}
		public function handleSignal4(param:String):void {
			trace("we are here..... (4) @@@@@@@@@@@ " + param)
		}
		
		public function handleSignal5(e:Event):void {
			trace("we have event again... " + e);
		}
		
	}

}