package uk.co.baremedia.gnomo.controls
{
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsScreens;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	
	
	public class ControlLogs implements IInitializer
	{
		protected var _viewNavigation		:SignalViewNavigation;
		protected var _controlPersistedData	:ControlPersistedData;
		
		public function ControlLogs(controlPersistedData:ControlPersistedData)
		{
			_controlPersistedData = controlPersistedData;
		}
		
		public function addLog(action:String, elapsedAudioTransmission:Number):void
		{
			_controlPersistedData.addLog(action, elapsedAudioTransmission);
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