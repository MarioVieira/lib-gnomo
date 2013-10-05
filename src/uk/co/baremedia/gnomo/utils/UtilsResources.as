package uk.co.baremedia.gnomo.utils
{
	import mx.resources.ResourceManager;
	
	import org.osflash.signals.Signal;
	
	[Bindable]
	public final class UtilsResources
	{
		public static const ENGLISH:String 		= "en_US";
		public static const ITALIAN:String 		= "it_IT";
		public static const PORTUGUESE:String 	= "pt_BR";
		public static const SPANISH:String 		= "es_ES";
		public static const FRENCH:String 		= "fr_FR";
		
		//protected static var _bundleName:String = "en_US";
		protected static var _bundleName:String = "text";
		
		public static var bundleChange:Signal = new Signal();
		
		public static function getKey(key:String):String
		{
			return ResourceManager.getInstance().getString(bundleName, key);
		}
		
		public static function set bundleName(value:String):void
		{
			_bundleName = value;
			bundleChange.dispatch();
		}
		
		public static function get bundleName():String
		{
			return _bundleName;
		}
		
		/**
		 *
		 * Faking up locale chain and using a different bundle name 
		 *  
		 * @param value
		 * 
		 */
		public static function set localeChain(value:String):void
		{
			bundleName = value;
		}
	}
}