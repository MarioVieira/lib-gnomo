package uk.co.baremedia.gnomo.controls
{
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsScreens;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	
	
	public class ControlLogs implements IInitializer
	{
		protected var _viewNavigation		:SignalViewNavigation;
		
		public function ControlLogs()
		{
		}
		
		public function init(injector:IInjector):void
		{
			_viewNavigation = injector.getInstance(SignalViewNavigation);
		}
		
		public function requestScreenUnits():void
		{
			_viewNavigation.dispatch(EnumsScreens.SCREEN_UNITS);
		}
		
		public function requestScreenLogsMain():void
		{
			_viewNavigation.dispatch(EnumsScreens.SCREEN_LOG_MAIN);
		}
		
		public function requestScreenLogDay():void
		{
			_viewNavigation.dispatch(EnumsScreens.SCREEN_LOG_DAY);
		}
	}
}