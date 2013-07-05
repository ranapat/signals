package org.ranapat.signals.examples {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.Dictionary;
	import org.ranapat.signals.Signals;
	import org.ranapat.signals.Slot;
	
	public class Main extends Sprite {
		private var classA:ClassA;
		private var classB:ClassB;
		private var classC:ClassC;
		private var classD:ClassD;
		private var classE:ClassE;
		
		private var dictionary:Dictionary = new Dictionary(true);
		
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
			this.classD = new ClassD();
			
			//dictionary[this.classB] = 1;
			
			this.classA.doEmit();
			this.classA.doEmit();
			
			Signals.walk();
			
			
			
			//this.addChild(this.classC);
			
			trace("we are here...")
			
			
			
			Signals.walk();
			
			
			
			
			
			//Signals.connectNativeCallback(this, Event.ENTER_FRAME, this.handleEnterFrame);
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			/*
			classD = new ClassD();
			
			
			Signals.connect(classD, ClassD.SIGNAL, slot, this);
			
			
			classD = null;
			*/
			
		}
		
		private var slot:Slot = new Slot(handleSlot);
		
		public function handleSlot():void {
			
		}
		
		private function handleEnterFrame(e:Event):void {
			Signals.walk();

			this.classA = null;
			this.classB = null;
			this.classC = null;
			this.classD = null;
			this.classE = null;
			
			//System.gc();
			
			System.gc();
			
			trace("")
		}
		
	}
	
}