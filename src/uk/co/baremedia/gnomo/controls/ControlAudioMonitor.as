package uk.co.baremedia.gnomo.controls
{
	import com.projectcocoon.p2p.util.Tracer;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.enums.EnumsSettings;
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.utils.UtilsMessenger;
	
	public class ControlAudioMonitor implements IInitializer, IDispose
	{
		public static const ACTIVITY_MONITOR_TIMER	:Number = 100;
		public static const STOP_PLAY_TIMER			:Number = 1000;
		
		protected var _model						:ModelAudio;
		protected var _messenger					:IP2PMessenger;
		protected var _elapsedActivityStopTimeout	:Timer;
		protected var _activityMonitorTimer			:Timer;
		protected var _firstAudioAcitivityTime		:Date;
		protected var _logsControl					:ControlLogs;
		
		public function ControlAudioMonitor(audioModel:ModelAudio, messenger:IP2PMessenger, logsControl:ControlLogs) 
		{
			_model 				= audioModel;
			_messenger 			= messenger;
			_logsControl 		= logsControl;
			
			_elapsedActivityStopTimeout = new Timer(STOP_PLAY_TIMER);
			_elapsedActivityStopTimeout.addEventListener(TimerEvent.TIMER, onRegisterActivityTimer);
		}
		
		public function init(injector:IInjector):void
		{
			_model 		= injector.getInstance(ModelAudio);
			_messenger 	= injector.getInstance(IP2PMessenger);
		}

		/*********************************************************   	BROADCASTER		*********************************************************/
		
		public function startBroadcasterActivityMonitor():void
		{
			//Tracer.log(this, "startActivityMonitor()");
			
			if(!_activityMonitorTimer) 
			{	
				_activityMonitorTimer = new Timer(ACTIVITY_MONITOR_TIMER);
				_activityMonitorTimer.addEventListener(TimerEvent.TIMER, checkBroadcasterActivity);
			}
			
			_activityMonitorTimer.reset();
			_activityMonitorTimer.start();
		}
		
		public function stopBroadcasterAcitivityMonitor():void
		{
			if(_activityMonitorTimer) _activityMonitorTimer.stop();
		}
		
		protected function checkBroadcasterActivity(event:Event):void
		{
			var activity:Boolean = detectedBroadcasterAudioActivity();
			if(activity && !_model.audioActivityOn)
			{
				//Tracer.log(this, "START");
				_model.audioActivityOn = true;
				_firstAudioAcitivityTime = new Date();
				broadcastLogging(true);
			}
			else if(!activity && _model.audioActivityOn)
			{
				if(!_elapsedActivityStopTimeout.running)
				{
					//Tracer.log(this, "start STOP timer");
					startBroadcastActivityTimer();
				}
			}
		}
		
		private function startBroadcastActivityTimer():void
		{
			_elapsedActivityStopTimeout.reset();
			_elapsedActivityStopTimeout.start();
		}
		
		private function onRegisterActivityTimer(e:Event):void
		{
			//Tracer.log(this, "ON STOP timer check");
			_elapsedActivityStopTimeout.stop();
			
			if(!detectedBroadcasterAudioActivity())
			{
				_model.audioActivityOn = false;
				var now:Date = new Date();
				//Tracer.log(this, "STOP - activity in sec: "+ elapsedAudioAcitivityTime  );
				var elapsedAudioAcitivityTime:Number = (now.getTime() - _firstAudioAcitivityTime.getTime()) / 1000;
				
				if(elapsedAudioAcitivityTime > EnumsSettings.MINIMUM_ACTIVITY_TIME_IN_SEC)
					sendBroadcasterMessageToReceivers(elapsedAudioAcitivityTime);
				
				broadcastLogging(false);
			}
		}
		
		
		public function setSensibility(sliderValue:Number):void
		{
			_model.sensibilityLevel = sliderValue;
		}
		
	
		private function detectedBroadcasterAudioActivity():Boolean
		{
			//trace("activityLevel: "+_model.microphone.activityLevel  +"  sensibilityLevel: "+_model.sensibilityLevel);
			return _model.microphone.activityLevel >= _model.sensibilityLevel;
		}		
		
		protected function sendBroadcasterMessageToReceivers(elapsedTimeInSec:Number):void
		{
			//Tracer.log(this, "sendMediaMessageToReceivers");
			_messenger.sendMessageToLocalNetwork( UtilsMessenger.getMessage(EnumsNotification.AUDIO_ACTIVITY, null, elapsedTimeInSec) );
		}
		
		protected function broadcastLogging(startedNotStoped:Boolean):void
		{
			//Tracer.log(this, "sendMediaMessageToReceivers");
			_messenger.sendMessageToLocalNetwork( UtilsMessenger.getMessage(EnumsNotification.MONITOR_ACTIVITY, null, 0, startedNotStoped) );
		}

		/*********************************************************   	AUDIO ACTIVTY		*********************************************************/
		
		public function logTimeActivity(elapsedTimeInSec:Number):void
		{
			_logsControl.addLog(elapsedTimeInSec);
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			if(_activityMonitorTimer) _activityMonitorTimer.removeEventListener(TimerEvent.TIMER, checkBroadcasterActivity);
			_elapsedActivityStopTimeout.removeEventListener(TimerEvent.TIMER, onRegisterActivityTimer);
		}
	}
}