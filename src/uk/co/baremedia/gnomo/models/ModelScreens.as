package uk.co.baremedia.gnomo.models
{
	import org.as3.mvcsInjector.vo.VOScreen;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.utils.UtilsScreens;
	
	public class ModelScreens extends Signal
	{
		public var firstViewName	:String;
		private var _screens		:Vector.<VOScreen>;
		private var _currentScreen	:VOScreen;
		
		public function ModelScreens() 
		{
			super(VOScreen);
		}
		
		public function set currentScreen(voScreen:VOScreen):void 
		{
			_currentScreen = voScreen;
			dispatch(voScreen);
		}
		
		public function get currentScreen():VOScreen 
		{
			return _currentScreen;
		}
		
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