package org.ranapat.signals {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class Signals {
		
		private static var dictionary:Dictionary = new Dictionary(true);
		
		public static function connect(signalObject:Object, signal:Signal, slot:Slot, slotObject:Object, priority:int = 0, once:Boolean = false):void {
			var tmp:SignalsCollection = Signals.dictionary[signalObject] as SignalsCollection;
			tmp = tmp? tmp : new SignalsCollection();
			
			tmp.add(signal, slot, slotObject, priority, once);
			
			Signals.dictionary[signalObject] = tmp;
		}
		
		public static function disconnect(object:Object, signal:Signal = null, slot:Slot = null):void {
			var tmp:SignalsCollection = Signals.dictionary[object] as SignalsCollection;
			if (tmp) {
				if (signal != null) {
					tmp.remove(signal, slot);
				} else {
					Signals.dictionary[object] = null;
					delete Signals.dictionary[object];
				}
			}
		}
		
		public static function emit(object:Object, signal:Signal, parameters:Array = null):void {
			var tmp:SignalsCollection = Signals.dictionary[object] as SignalsCollection;
			if (tmp) {
				tmp.emit(signal, parameters);
			}
		}
		
		public static function connectNativeCallback(object:IEventDispatcher, event:String, callback:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void {
			object.addEventListener(event, callback, useCapture, priority, useWeakReference);
		}
		
		public static function connectNativeSignal(object:IEventDispatcher, event:String, signalObject:Object, signal:Signal, priority:int = 0, once:Boolean = false):Function {
			var _function:Function = function (e:Event):void { Signals.emit( signalObject, signal, [ e ] ); };
			object.addEventListener(event, _function, false, 0, true);
			return _function;
		}
		
		public static function disconnectNative(object:IEventDispatcher, event:String, callback:Function):void {
			object.removeEventListener(event, callback);
		}
		
		public static function walk():void {
			//return;
			for (var i:Object in Signals.dictionary) {
				trace("4:[SLOTS] <<<<<<<<<<walk>>>>>>>>>> " + i + " .. " + Signals.dictionary[i])
			}
		}
	}

}