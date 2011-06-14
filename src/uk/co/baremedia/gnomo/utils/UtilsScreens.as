package uk.co.baremedia.gnomo.utils
{
	import org.as3.mvcsInjector.vo.VOScreen;
	
	import uk.co.baremedia.gnomo.models.ModelScreens;
	import uk.co.baremedia.gnomo.vo.VOViewNavigation;
	
	public class UtilsScreens
	{
		public static function getViewNotification(screenName:String, model:ModelScreens):VOViewNavigation
		{
			var vo:VOViewNavigation = new VOViewNavigation();
			vo.viewInfo = model.getScreenInfoByName(screenName);
			
			return vo;
		}
		
		public static function getScreenByName(name:String, screens:Vector.<VOScreen>):Class
		{
			for each(var screen:VOScreen in screens)
			{
				if(screen.name == name) return screen.clazz; 	
			}
			
			return null;
		}
		
		public static function getScreenInfoByName(name:String, screens:Vector.<VOScreen>):VOScreen
		{
			for each(var screen:VOScreen in screens)
			{
				if(screen.name == name) return screen; 	
			}
			
			return null;
		}
	}
}