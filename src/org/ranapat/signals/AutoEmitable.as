package org.ranapat.signals {
	import flash.utils.Dictionary;
	
	public interface AutoEmitable {
		function get __signals__():Dictionary;
		function set __signals__(_value:Dictionary):void;
	}
	
}