package org.ranapat.signals {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.sampler.getSavedThis;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	final public class Signals {
		public static const __LINK__:String = "__link__";
		
		private static const DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME:String = "__signals__";
		private static const DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX:String = "autoGeneratedSignal_";
		
		private static const EMITS_META_TAG_NAME:String = "Emits";
		private static const EMITS_META_TAG_OBJECT:String = "object";
		private static const EMITS_META_TAG_SIGNAL:String = "signal";
		private static const EMITS_META_TAG_VALUES:String = "values";
		
		private static var dictionary:Dictionary = new Dictionary(true);
		
		public function Signals() {
			Tools.ensureAbstractClass(this, Signals);
		}
		
		public static function connect(signal:Signal, slot:Slot, signalObject:Object = null, slotObject:Object = null, priority:int = 0, once:Boolean = false):void {
			signalObject = signalObject? signalObject : signal.object;
			slotObject = slotObject? slotObject : slot.object;
			
			if (!signalObject) {
				trace("3:[Signals] :: connect :: signalObject is null, you might have leaks!");
				if (!SignalsSettings.ALLOW_NULL_OBJECTS) {
					trace("2:[Signals] :: Signals::connect :: SignalsSettings.ALLOW_NULL_OBJECTS is false, null objects rejected!");
					return;
				}
			}
			if (!slotObject) {
				trace("3:[Signals] :: connect :: slotObject is null, you might have leaks!");
				if (!SignalsSettings.ALLOW_NULL_OBJECTS) {
					trace("2:[Signals] :: Signals::connect :: SignalsSettings.ALLOW_NULL_OBJECTS is false, null objects rejected!");
					return;
				}
			}
			
			var tmp:SignalsCollection = Signals.dictionary[signalObject] as SignalsCollection;
			tmp = tmp? tmp : new SignalsCollection();
			
			tmp.add(signal, slot, slotObject, priority, once);
			
			Signals.dictionary[signalObject] = tmp;
		}
		
		public static function disconnect(object:Object = null, signal:Signal = null, slot:Slot = null):void {
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
		
		public static function massDisconnect(slotObject:Object):void {
			var signalsCollection:SignalsCollection;
			for (var object:Object in Signals.dictionary) {
				signalsCollection = Signals.dictionary[object] as SignalsCollection;
				if (signalsCollection) {
					for (var signal:Object in signalsCollection.dictionary) {
						signalsCollection.remove(signal as Signal, null, slotObject);
					}
				}
			}
		}
		
		public static function emit(signal:Signal, object:Object = null, parameters:Array = null):void {
			object = object? object : signal.object;
			
			var tmp:SignalsCollection = Signals.dictionary[object] as SignalsCollection;
			if (tmp) {
				tmp.emit(signal, parameters);
			}
		}
		
		public static function connectNativeCallback(object:IEventDispatcher, event:String, callback:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void {
			object.addEventListener(event, callback, useCapture, priority, useWeakReference);
		}
		
		public static function connectNativeSignal(object:IEventDispatcher, event:String, signalObject:Object, signal:Signal, priority:int = 0, once:Boolean = false):Function {
			var _function:Function = function (e:Event):void { Signals.emit( signal, signalObject, [ e ] ); };
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
			
			var _memberName:String = member;
			var metatags:Vector.<XML> = MetadataAnalyzer.getMetaTags(object, member);
			if (metatags.length > 0) {
				for each (var metadata:XML in metatags) {
					if (
						metadata.@name == Signals.EMITS_META_TAG_NAME
						&& metadata.arg
					) {
						try {
							var _signal:Signal;
							var _paramParts:Array;
							var _dictionary:Dictionary;
							
							if (
								metadata.arg.length() == 3
								&& metadata.arg[0].@key == Signals.EMITS_META_TAG_OBJECT
								&& metadata.arg[1].@key == Signals.EMITS_META_TAG_SIGNAL
								&& metadata.arg[2].@key == Signals.EMITS_META_TAG_VALUES
							) {
								_signal = (ApplicationDomain.currentDomain.getDefinition(metadata.arg[0].@value) as Class)[metadata.arg[1].@value] as Signal;
								_paramParts = metadata.arg[2].@value.split(",");
							} else if (
								metadata.arg.length() == 2
								&& metadata.arg[0].@key == Signals.EMITS_META_TAG_SIGNAL
								&& metadata.arg[1].@key == Signals.EMITS_META_TAG_VALUES							
							) {
								_signal = (ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[metadata.arg[0].@value] as Signal;
								_paramParts = metadata.arg[1].@value.split(",");
							} else if (
								metadata.arg.length() == 1
								&& metadata.arg[0].@key == Signals.EMITS_META_TAG_VALUES							
							) {
								try {
									if (object[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary) {
										_dictionary = object[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary;
									}
								} catch (e:Error) {
									if ((ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary) {
										_dictionary = (ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary;
									}
								}
								
								if (_dictionary) {
									if (_dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] as Signal) {
										_signal = _dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] as Signal;
									} else {
										_signal = new Signal();
										_dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] = _signal;
									}
								}
								
								_paramParts = metadata.arg[0].@value.split(",");
							} else if (
								metadata.arg.length() == 0
							) {
								try {
									if (object[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary) {
										_dictionary = object[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary;
									}
								} catch (e:Error) {
									if ((ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary) {
										_dictionary = (ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary;
									}
								}
								
								if (_dictionary) {
									if (_dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] as Signal) {
										_signal = _dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] as Signal;
									} else {
										_signal = new Signal();
										_dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] = _signal;
									}
								}
							}
							
							result = Signals.autoEmitSignalOnFunction(object, member, _signal, _paramParts);
						} catch (e:Error) {
							trace("4:[Signals] Failed to enable signal :: " + e);
						}
					}
				}
			}
			
			return result;
		}
		
		public static function link(object:*, member:*, expression:Function, expressionHolder:Object = null, priority:int = 0, once:Boolean = false):Boolean {
			var result:Boolean = false;
			
			expressionHolder = expressionHolder? expressionHolder : getSavedThis(expression);
			
			var _memberName:String = MetadataAnalyzer.getMemberName(object, member);
			var metatags:Vector.<XML> = MetadataAnalyzer.getMetaTags(object, member);
			if (metatags.length > 0) {
				for each (var metadata:XML in metatags) {
					if (
						metadata.@name == Signals.EMITS_META_TAG_NAME
						&& metadata.arg
					) {
						try {
							var _signal:Signal;
							var _dictionary:Dictionary;
							
							if (
								metadata.arg.length() == 3
								&& metadata.arg[0].@key == Signals.EMITS_META_TAG_OBJECT
								&& metadata.arg[1].@key == Signals.EMITS_META_TAG_SIGNAL
							) {
								_signal = (ApplicationDomain.currentDomain.getDefinition(metadata.arg[0].@value) as Class)[metadata.arg[1].@value];
							} else if (
								metadata.arg.length() == 2
								&& metadata.arg[0].@key == Signals.EMITS_META_TAG_SIGNAL
							) {
								_signal = (ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object)) as Class)[metadata.arg[0].@value];
							} else if (
								metadata.arg.length() == 1
								&& metadata.arg[0].@key == Signals.EMITS_META_TAG_VALUES							
							) {
								try {
									if (object[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary) {
										_dictionary = object[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary;
									}
								} catch (e:Error) {
									if ((ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary) {
										_dictionary = (ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary;
									}
								}
								
								if (_dictionary) {
									if (_dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] as Signal) {
										_signal = _dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] as Signal;
									}
								}
							} else if (
								metadata.arg.length() == 0
							) {
								try {
									if (object[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary) {
										_dictionary = object[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary;
									}
								} catch (e:Error) {
									if ((ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary) {
										_dictionary = (ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(object).replace("::", ".")) as Class)[Signals.DYNAMIC_SIGNALS_DICTIONATY_HOLDER_PARAMETER_NAME] as Dictionary;
									}
								}
								
								if (_dictionary) {
									if (_dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] as Signal) {
										_signal = _dictionary[Signals.DYNAMIC_SIGNALS_DICTIONARY_KEY_PREFIX + _memberName] as Signal;
									}
								}
							}
							
							if (_signal) {
								Signals.connect(
									_signal,
									new Slot(expression, expressionHolder),
									object,
									expressionHolder,
									priority, once
								);
								
								result = true;
							}
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
		
		private static function autoEmitSignalOnFunction(object:*, member:String, _signal:Signal = null, _paramParts:Array = null):Boolean {
			var result:Boolean = false;
			
			var _function:Function = object[member];
			if (_function != null && _signal != null) {
				object[member] = function (...args):void {
					_function.apply(object, args);
					
					var _params:Array = [];
					if (_paramParts) {
						for each (var param:String in _paramParts) {
							_params.push(object[param]);
						}
					}
					
					Signals.emit(_signal, object, _params);
				};
				
				result = true;
			}
			
			return result;
		}
	}

}