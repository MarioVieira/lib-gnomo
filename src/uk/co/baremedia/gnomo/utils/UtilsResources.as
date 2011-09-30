package uk.co.baremedia.gnomo.utils
{
	import mx.resources.ResourceManager;
	
	[Bindable]
	public class UtilsResources
	{
		public static var bundleName:String = "en_US";
		
		public static function getKey(key:String):String
		{
			return ResourceManager.getInstance().getString(bundleName, key);
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