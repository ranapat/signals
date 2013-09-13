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
	import org.ranapat.signals.Tools;
	
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
			
			/*
			// Example 1 start
			this.classA = new ClassA();
			this.classC = new ClassC();
			this.classB = new ClassB(this.classA, this.classC);
			this.classD = new ClassD();
			
			this.classA.doEmit();
			trace("\n")
			this.classA.doEmit();
			
			Signals.walk();
			this.addChild(this.classC);
			Signals.walk();
			
			Signals.connectNativeCallback(this, Event.ENTER_FRAME, this.handleEnterFrame);
			//addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			//Signals.connect(ClassD.SIGNAL, slot);
			//Signals.emit(ClassD.SIGNAL);
			
			//Signals.connect(this.classA, Main.SignalMainA, new Slot(this.handleSignalMain), this);
			//Signals.connect(this, this.SignalMainB, new Slot(this.handleSignalMain), this);
			//Signals.connect(this, this.SignalMainB, new Slot(this.handleSignalMain), this);
			//Signals.connect(this, this.SignalMainB, new Slot(this.handleSignalMain), this);
			//Signals.disconnect(this, this.SignalMainB);
			//Signals.connect(this.classA, this.SignalMainB, new Slot(this.handleSignalMain), this);
			//Signals.emit(this.classA, Main.SignalMainA, [ 10, 20 ]);
			
			//trace("try to emit signal directly :: " + Main.SignalMainA.emit())
			//trace("try to connect signal directly :: " + this.SignalMainB.connect(this, this.handleSignalMain));
			
			//this.SignalMainB.disconnect(new Slot(this.shot));
			//this.SignalMainB.disconnect(new Slot(function ():void { } ));
			//this.SignalMainB.disconnect();
			//Signals.disconnect(this);
			
			//trace("try to emit signal directly :: " + this.SignalMainB.emit(10, 99))
			
			
			//Signals.emit(this, this.SignalMainB);
			
			
			// Example 1 end
			*/
			
			/*
			// Example 2 start
			dispatchesExample = new DispatchesExample();
			trace("link (2) result is " + Signals.link(dispatchesExample, dispatchesExample.__setValue, this.handleValueChanged, this));
			dispatchesExample.doTheTest();
			dispatchesExample.value = 100;
			// Example 2 end
			*/
			
			/*
			// Example 3 start
			var simpleDispatchExample:SimpleDispatchExample = new SimpleDispatchExample();
			Signals.link(simpleDispatchExample, simpleDispatchExample.__setValue, this.handleSimpleDispatchExampleSetValue);
			simpleDispatchExample.value = 10;
			trace("the value is " + simpleDispatchExample.value)
			// Example 3 end
			*/
			
			/*
			// Example 4 start
			this.simpleA = new SimpleA();
			this.simpleB = new SimpleB(this.simpleA);
			this.simpleA.test(100);
			// Example 4 end
			*/
			
			/*
			// Example 5 start
			Signals.connect(this.SignalMainB, new Slot(this.handleStep5SignalMainB) );
			this.SignalMainB.emit();
			// Example 5 end
			*/
			
			// Example 6 start
			//SignalMainA.connect(this.handleStep6SignalMainB);
			//SignalMainA.emit();
			
			Signals.connect(SignalMainA, new Slot(this.handleStep6SignalMainB));
			Signals.emit(SignalMainA);
			// Example 6 end
		}
		
		public function handleStep6SignalMainB():void {
			trace("step6 handler")
		}
		
		public function handleStep5SignalMainB():void {
			trace("step5 handler")
		}
		
		public function handleSimpleDispatchExampleSetValue(_value:uint):void {
			trace("the value is just changed " + _value)
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
			
			if (this.classC && this.classC.parent) {
				this.classC.parent.removeChild(this.classC);
			}
			this.classC = null;
			
			this.classD = null;
			this.classE = null;
			
			this.dispatchesExample = null;
			
			System.gc();
			
			trace("")
		}
		
	}
	
}