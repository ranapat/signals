package org.ranapat.signals {
	
	final public class SignalsSettings {
		public static var ALLOW_NULL_OBJECTS:Boolean = true;
		
		public function SignalsSettings() {
			Tools.ensureAbstractClass(this, SignalsSettings);
		}
	}

}