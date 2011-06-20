package uk.co.baremedia.gnomo.utils
{
	import mx.resources.ResourceManager;
	
	public class UtilsResources
	{
		public static function getKey(key:String):String
		{
			return ResourceManager.getInstance().getString("text", key);
		}
	}
}