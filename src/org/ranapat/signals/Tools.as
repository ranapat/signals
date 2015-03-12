package org.ranapat.signals {
	import flash.sampler.getSavedThis;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	internal final class Tools {

		public static function arrayToFixedCount(count:uint, array:Array = null):Array {
			if (array) {
				var result:Array = [];
				var length:uint = array.length;
				length = length > count? count : length;
				for (var i:int = 0; i < length; ++i) {
					result.push(array[i]);
				}
				while (result.length < count) {
					result.push(null);
				}
				return result;
			} else {
				return array;
			}
		}
		
		public static function getVariableName(t:Object, v:Function):String {
			try {
				var methods:XMLList = describeType(t)..variable.@name;
				for each (var m:String in methods) {
					if (t.hasOwnProperty(m) && t[m] != null && t[m] === v) return m;            
				}
			} catch (e:Error) {
				//
			}
			
			return null;                                        
		}
		
		public static function getFunctionName(f:Function, t:Object = null):String {
			try {
				t = t? t : getSavedThis(f);
				var methods:XMLList = describeType(t)..method.@name;
				for each (var m:String in methods) {
					if (t.hasOwnProperty(m) && t[m] != null && t[m] === f) return m;            
				}
			} catch (e:Error) {
				//
			}
			
			return null;                                        
		}
		
		public static function ensureAbstractClass(instance:Object, _class:Class):void {
			var className:String = getQualifiedClassName(instance);
			if (getDefinitionByName(className) == _class) {
				throw new Error(getQualifiedClassName(_class) + " Class can not be instantiated directly.");
			}
		}
	}

}