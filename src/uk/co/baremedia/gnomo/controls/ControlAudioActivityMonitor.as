package uk.co.baremedia.gnomo.controls
{
	import com.projectcocoon.p2p.util.Tracer;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.osflash.signals.Signal;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.enums.EnumsSettings;
	import uk.co.baremedia.gnomo.helper.HelperConnection;
	import uk.co.baremedia.gnomo.interfaces.IAudioActivity;
	import uk.co.baremedia.gnomo.interfaces.IConnected;
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;
	import uk.co.baremedia.gnomo.utils.UtilsMessenger;
	import uk.co.baremedia.gnomo.vo.VOSlider;
	
	public class ControlAudioActivityMonitor implements IInitializer, IDispose
	{
		public static const ACTIVITY_MONITOR_CHECK	:Number = 100;
		public static const STOP_PLAY_TIMER			:Number = 1000;
		
		protected var _model						:ModelAudio;
		protected var _messenger					:IP2PMessenger;
		protected var _elapsedActivityStopTimeout	:Timer;
		protected var _activityMonitorTimer			:Timer;
		protected var _firstAudioAcitivityTime		:Date;
		protected var _logsControl					:ControlLogs;
		protected var _helperConnection				:IConnected;
		protected var _helperAudioActivity			:IAudioActivity;
		protected var _audioActivityMessage			:Signal;
		
		public var isActive:NetStream;
		
		public function ControlAudioActivityMonitor(audioModel:ModelAudio, messenger:IP2PMessenger, logsControl:ControlLogs, helperConnection:IConnected, helperAudioActivity:IAudioActivity) 
		{
			_model 				= audioModel;
			_messenger 			= messenger;
			_logsControl 		= logsControl;
			_helperConnection 	= helperConnection;
			_helperAudioActivity = helperAudioActivity;
			_elapsedActivityStopTimeout = new Timer(STOP_PLAY_TIMER);
			_elapsedActivityStopTimeout.addEventListener(TimerEvent.TIMER, onRegisterActivityTimedOut);
			_audioActivityMessage = new Signal(Number);
		}
		
		public function init(injector:IInjector):void
		{
			_model 		= injector.getInstance(ModelAudio);
			_messenger 	= injector.getInstance(IP2PMessenger);
			
			setSensibility(ModelAudio.DEFAULT_SENSISBILIY);
		}

		
		public function startActivityMonitor():void
		{
			//Tracer.log(this, "startActivityMonitor()");
			
			if(!_activityMonitorTimer) 
			{	
				_activityMonitorTimer = new Timer(ACTIVITY_MONITOR_CHECK);
				_activityMonitorTimer.addEventListener(TimerEvent.TIMER, checkBroadcasterActivity);
			}
			
			_activityMonitorTimer.reset();
			_activityMonitorTimer.start();
		}
		
		public function stopAcitivityMonitor():void
		{
			if(_activityMonitorTimer) _activityMonitorTimer.stop();
		}
		
		public function get audioActivityMessage():Signal
		{
			return _audioActivityMessage;
		}
		
		protected function checkBroadcasterActivity(event:Event):void
		{
			var activity:Boolean = _helperAudioActivity.hasBroadcasterAudioActivity;
			if(activity && !_model.audioActivityOn)
			{
				//Tracer.log(this, "START");
				_model.audioActivityOn = true;
				_firstAudioAcitivityTime = new Date();
				/*
				REMOVED WHEN NETWORK MESSAGE WERE TAKEN OUT
				broadcastLogging(true);*/
			}
			else if(!activity && _model.audioActivityOn)
			{
				if(!_elapsedActivityStopTimeout.running)
				{
					//Tracer.log(this, "start STOP timer");
					startActivityTimerToCloseLog();
				}
			}
		}
		
		private function startActivityTimerToCloseLog():void
		{
			_elapsedActivityStopTimeout.reset();
			_elapsedActivityStopTimeout.start();
		}
		
		private function onRegisterActivityTimedOut(e:Event):void
		{
			_elapsedActivityStopTimeout.stop();
			var tmpHasBroadcasterAudioActivity:Boolean = _helperAudioActivity.hasBroadcasterAudioActivity;
			
			if( !tmpHasBroadcasterAudioActivity )
			{
				_model.audioActivityOn = false;
				
				var now:Date = new Date();
				//Tracer.log(this, "STOP - activity in sec: "+ elapsedAudioAcitivityTime  );
				var elapsedAudioAcitivityTime:Number = (now.getTime() - _firstAudioAcitivityTime.getTime()) / 1000;
				
				if(elapsedAudioAcitivityTime > EnumsSettings.MINIMUM_ACTIVITY_TIME_IN_SEC)
					logTimeActivity(elapsedAudioAcitivityTime);
				
				/*
				REMOVED WHEN NETWORK MESSAGE WERE TAKEN OUT
				broadcastLogging(false);*/
			}
		}
		
		private function tryRegisterActivityLater():void
		{
			
		}		
		
		public function setSensibility(value:Number):void
		{
			value = (value < 0) ? 1 : value;
			var newValue:Number = value * .35 * 10;
			var vo:VOSlider = new VOSlider();
			vo.sliderActualValue = (newValue > 0) ? newValue : 1;
			vo.sliderViewValue = value;
			
			_model.sensibilityLevel = vo;
		}
		
/*	
		private function detectedBroadcasterAudioActivity():Boolean
		{
			return _helperAudioActivity.hasBroadcasterAudioActivity; 
			
/*			trace("activityLevel: "+_model.microphone.activityLevel  +"  sensibilityLevel: "+_model.sensibilityLevel.sliderActualValue);
			return (!UtilsDeviceInfo.isIOS) ? _model.microphone.activityLevel >= _model.sensibilityLevel.sliderActualValue 
				: (1 < 2);		
		}		
*/
		
		/*protected function broadcastAudioActivity(elapsedTimeInSec:Number):void
		{
			//Tracer.log(this, "sendMediaMessageToReceivers");
			//TO DO: non longer sending this info via network, but measuring it localy
			//_messenger.sendMessageToLocalNetwork( UtilsMessenger.getMessage(EnumsNotification.AUDIO_ACTIVITY, _messenger.deviceType, _messenger.deviceVersion, elapsedTimeInSec) );
			_audioActivityMessage.dispatch(elapsedTimeInSec);
		}
		
		protected function broadcastLogging(startedNotStoped:Boolean):void
		{
			//TO DO: non longer sending this info via network, but loging it localy
			//Tracer.log(this, "sendMediaMessageToReceivers");
			//_messenger.sendMessageToLocalNetwork( UtilsMessenger.getMessage(EnumsNotification.MONITOR_ACTIVITY, _messenger.deviceType, _messenger.deviceVersion, 0, startedNotStoped) );
		
		}*/

		/*********************************************************   	AUDIO ACTIVTY		*********************************************************/
		
		public function logTimeActivity(elapsedTimeInSec:Number):void
		{
			_logsControl.addLog(elapsedTimeInSec);
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			if(_activityMonitorTimer) _activityMonitorTimer.removeEventListener(TimerEvent.TIMER, checkBroadcasterActivity);
			_elapsedActivityStopTimeout.removeEventListener(TimerEvent.TIMER, onRegisterActivityTimedOut);
		}
	}
}