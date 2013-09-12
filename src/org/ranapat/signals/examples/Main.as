package org.ranapat.signals.examples {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.utils.describeType;
	import org.ranapat.signals.Signal;
	import org.ranapat.signals.Signals;
	import org.ranapat.signals.Slot;
	
	[SomethingCustom()]
	[CustomMeta(param1 = "foo", param2 = "bar")]
	[CustomMeta(param1 = "foo7", param2 = "bar7")]
	
	public class Main extends Sprite {
		public static const SignalMainA:Signal = new Signal();
		public var SignalMainB:Signal = new Signal(this);
		
		private var classA:ClassA;
		private var classB:ClassB;
		private var classC:ClassC;
		private var classD:ClassD;
		private var classE:ClassE;
		
		private var simpleA:SimpleA;
		private var simpleB:SimpleB;
		
		private var dispatchesExample:DispatchesExample;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//this.classA = new ClassA();
			//this.classC = new ClassC();
			//this.classB = new ClassB(this.classA, this.classC);
			//this.classD = new ClassD();
			
			//this.classA.doEmit();
			//this.classA.doEmit();
			
			//Signals.walk();
			
			//this.addChild(this.classC);
			
			
			//Signals.walk();
			
			
			
			
			
			//Signals.connectNativeCallback(this, Event.ENTER_FRAME, this.handleEnterFrame);
			
			//addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			/*
			classD = new ClassD();
			
			
			Signals.connect(classD, ClassD.SIGNAL, slot, this);
			
			
			classD = null;
			*/
			
			
			//trace("#$$$$$$$$$$$$$$$$$$$$$$$")
			
			/*
			dispatchesExample = new DispatchesExample();
			trace("link (2) result is " + Signals.link(dispatchesExample, DispatchesExample.ValueChangedSignal.get(Signals.__LINK__), this.handleValueChanged, this));
			dispatchesExample.doTheTest();
			dispatchesExample.value = 100;
			*/
			
			Signals.connect(this.classA, Main.SignalMainA, new Slot(this.handleSignalMain), this);
			//Signals.connect(this, this.SignalMainB, new Slot(this.handleSignalMain), this);
			//Signals.connect(this, this.SignalMainB, new Slot(this.handleSignalMain), this);
			//Signals.connect(this, this.SignalMainB, new Slot(this.handleSignalMain), this);
			//Signals.disconnect(this, this.SignalMainB);
			//Signals.connect(this.classA, this.SignalMainB, new Slot(this.handleSignalMain), this);
			Signals.emit(this.classA, Main.SignalMainA, [ 10, 20 ]);
			
			//trace("try to emit signal directly :: " + Main.SignalMainA.emit())
			//trace("try to connect signal directly :: " + this.SignalMainB.connect(this, this.handleSignalMain));
			
			//this.SignalMainB.disconnect(new Slot(this.shot));
			//this.SignalMainB.disconnect(new Slot(function ():void { } ));
			//this.SignalMainB.disconnect();
			//Signals.disconnect(this);
			
			//trace("try to emit signal directly :: " + this.SignalMainB.emit(10, 99))
			
			
			//Signals.emit(this, this.SignalMainB);
			
			/*
			this.simpleA = new SimpleA();
			this.simpleB = new SimpleB(this.simpleA);
			this.simpleA.test(100);
			*/
		}
		
		public function shot():void {
			
		}
		
		public function handleSignalMain(value:int = -1, value2:int = -1):void {
			trace("oh, even this shit works... " + value + " .. " + value2);
		}
		
		public function handleValueChanged(__value:int = -1, _anotherValue:String = null):void {
			trace("....... we are here (2)........ " + __value + " >> " + _anotherValue);
		}
		
		private var ttt:Number;		
		
		private var slot:Slot = new Slot(handleSlot);
		
		public function handleSlot():void {
			trace("we have something here.........")
		}
		
		private function handleEnterFrame(e:Event):void {
			Signals.walk();

			this.classA = null;
			this.classB = null;
			this.classC = null;
			this.classD = null;
			this.classE = null;
			
			this.dispatchesExample = null;
			
			System.gc();
			
			trace("")
		}
		
	}
	
}