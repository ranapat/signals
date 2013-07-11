package org.ranapat.signals {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	public class Signals {
		public static const __LINK__:String = "__link__";
		
		private static const EMITS_META_TAG_NAME:String = "Emits";
		private static const EMITS_META_TAG_OBJECT:String = "object";
		private static const EMITS_META_TAG_SIGNAL:String = "signal";
		private static const EMITS_META_TAG_VALUES:String = "values";
		
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
		
		public static function autoEmitAll(object:*):void {
			var metatags:Vector.<XML> = MetadataAnalyzer.getMetaTags(object, null, true);
			if (metatags.length > 0) {
				for each (var metadata:XML in metatags) {
					if (metadata.name() == "variable") {
						Signals.autoEmit(object, metadata.@name);
					}
				}
			}
		}
		
		public static function autoEmit(object:*, member:String):Boolean {
			var result:Boolean = false;
			
			var metatags:Vector.<XML> = MetadataAnalyzer.getMetaTags(object, member);
			if (metatags.length > 0) {
				for each (var metadata:XML in metatags) {
					if (
						metadata.@name == Signals.EMITS_META_TAG_NAME
						&& metadata.arg
						&& metadata.arg[0].@key == Signals.EMITS_META_TAG_OBJECT
						&& metadata.arg[1].@key == Signals.EMITS_META_TAG_SIGNAL
						&& metadata.arg[2].@key == Signals.EMITS_META_TAG_VALUES
					) {
						try {
							var _function:Function = object[member] as Function;
							var _class:Class = ApplicationDomain.currentDomain.getDefinition(metadata.arg[0].@value) as Class;
							var _signal:Signal = _class[metadata.arg[1].@value] as Signal;
							var _paramParts:Array = metadata.arg[2].@value.split(",");
							if (_function != null && _signal != null) {
								object[member] = function (...args):void {
									_function.apply(object, args);
									
									var _params:Array = [];
									for each (var param:String in _paramParts) {
										_params.push(object[param]);
									}
									
									Signals.emit(object, _signal, _params);
								};
								
								result = true;
							}
						} catch (e:Error) {
							trace("4:[Signals] Failed to enable signal :: " + e);
						}
					}
				}
			}
			
			return result;
		}
		
		public static function link(object:*, member:*, expression:Function, expressionHolder:Object, priority:int = 0, once:Boolean = false):Boolean {
			var result:Boolean = false;
			
			var metatags:Vector.<XML> = MetadataAnalyzer.getMetaTags(object, member);
			if (metatags.length > 0) {
				for each (var metadata:XML in metatags) {
					if (
						metadata.@name == Signals.EMITS_META_TAG_NAME
						&& metadata.arg
						&& metadata.arg[0].@key == Signals.EMITS_META_TAG_OBJECT
						&& metadata.arg[1].@key == Signals.EMITS_META_TAG_SIGNAL
					) {
						try {
							var _class:Class = ApplicationDomain.currentDomain.getDefinition(metadata.arg[0].@value) as Class;
							Signals.connect(object, _class[metadata.arg[1].@value], new Slot(expression), expressionHolder, priority, once);
							
							result = true;
						} catch (e:Error) {
							trace("4:[Signals] Failed to link signal-slot :: " + e);
						}
					}
				}
			}
			
			return result;
		}
		
		public static function walk():void {
			//return;
			for (var i:Object in Signals.dictionary) {
				trace("4:[Signals] <<<<<<<<<<walk>>>>>>>>>> " + i + " .. " + Signals.dictionary[i])
			}
		}
	}

}