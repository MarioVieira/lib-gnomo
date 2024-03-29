package uk.co.baremedia.gnomo.controls
{
	import uk.co.baremedia.gnomo.vo.VOLog;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsScreens;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	import uk.co.baremedia.gnomo.vo.VOLog;
	import uk.co.baremedia.gnomo.vo.VOLogs;
	
	
	public class ControlLogs implements IInitializer
	{
		protected var _viewNavigation		:SignalViewNavigation;
		protected var _controlPersistedData	:ControlPersistedData;
	
		public function ControlLogs(controlPersistedData:ControlPersistedData)
		{
			_controlPersistedData = controlPersistedData;
		}
		
		public function addLog(elapsedAudioTransmission:Number):void
		{
			_controlPersistedData.addLog(elapsedAudioTransmission);
		}
		
		public function get logs():VOLogs
		{
			return _controlPersistedData.logs;
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