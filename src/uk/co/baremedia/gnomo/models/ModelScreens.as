package uk.co.baremedia.gnomo.models
{
	import org.as3.mvcsInjector.vo.VOScreen;
	
	import uk.co.baremedia.gnomo.utils.UtilsScreens;
	
	public class ModelScreens
	{
		public var firstViewName	:String;
		private var _screens		:Vector.<VOScreen>;
		
		public function set screens(value:Vector.<VOScreen>):void
		{
			_screens = value;	
		}
		
		public function getScreenClassByName(name:String):Class
		{
			return UtilsScreens.getScreenByName(name, _screens);
		}
		
		public function getScreenInfoByName(name:String):VOScreen
		{
			return UtilsScreens.getScreenInfoByName(name, _screens);
		}
	}
}