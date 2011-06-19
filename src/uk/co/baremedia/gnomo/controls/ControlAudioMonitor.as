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
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.utils.UtilsMessenger;
	
	public class ControlAudioMonitor implements IInitializer, IDispose
	{
		public static const ACTIVITY_MONITOR_TIMER	:Number = 250;
		public static const STOP_PLAY_TIMER			:Number = 4000;
		
		protected var _stopPlayTimer				:Timer;
		protected var _activityMonitorTimer			:Timer;
		protected var _model						:ModelAudio;
		protected var _messenger					:IP2PMessenger;
		
		public function ControlAudioMonitor(audioModel:ModelAudio, messenger:IP2PMessenger) 
		{
			_model 		= audioModel;
			_messenger 	= messenger;
			
			_stopPlayTimer = new Timer(STOP_PLAY_TIMER);
			_stopPlayTimer.addEventListener(TimerEvent.TIMER, onStopPlayTimer);
		}
		
		public function init(injector:IInjector):void
		{
			_model 		= injector.getInstance(ModelAudio);
			_messenger 	= injector.getInstance(IP2PMessenger);
		}

		public function startActivityMonitor():void
		{
			Tracer.log(this, "startActivityMonitor()");
			
			if(!_activityMonitorTimer) 
			{	
				_activityMonitorTimer = new Timer(ACTIVITY_MONITOR_TIMER);
				_activityMonitorTimer.addEventListener(TimerEvent.TIMER, checkActivity);
			}
			
			_activityMonitorTimer.reset();
			_activityMonitorTimer.start();
		}
		
		public function stopAcitivityMonitor():void
		{
			if(_activityMonitorTimer) _activityMonitorTimer.stop();
		}
		
		public function setSensibility(sliderValue:Number):void
		{
			_model.sensibilityLevel = sliderValue;
		}
		
		protected function checkActivity(event:Event):void
		{
			if(detectedAudioActivity() && !_model.audioActvity)
			{
				sendMediaMessageToReceivers(true);
			}
			else if(_model.broadcasting && !detectedAudioActivity() && _model.audioActvity)
			{
				if(!_stopPlayTimer.running) stopPlayTimer();
			}
		}
		
		private function detectedAudioActivity():Boolean
		{
			//trace("activityLevel: "+_model.microphone.activityLevel  +"  sensibilityLevel: "+_model.sensibilityLevel);
			return _model.microphone.activityLevel >= _model.sensibilityLevel;
		}		
		
		protected function sendMediaMessageToReceivers(startNotStopPlayig:Boolean):void
		{
			Tracer.log(this, "sendMediaMessageToReceivers - startNotStopPlayig: "+startNotStopPlayig);
			_model.audioActvity = startNotStopPlayig;
			_messenger.sendMessageToLocalNetwork( UtilsMessenger.getMessage(EnumsNotification.AUDIO_ACTIVITY, null, startNotStopPlayig) );
		}

		protected function stopPlayTimer():void
		{
			Tracer.log(this, "stopPlayTimer");
			_stopPlayTimer.reset();
			_stopPlayTimer.start();
		}
		
		private function onStopPlayTimer(e:Event):void
		{
			_stopPlayTimer.stop();
			Tracer.log(this, "onStopPlayTimer - _stopPlayTimer.running: "+_stopPlayTimer.running);
			sendMediaMessageToReceivers(false);
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			_activityMonitorTimer.removeEventListener(TimerEvent.TIMER, checkActivity);
			_stopPlayTimer.removeEventListener(TimerEvent.TIMER, onStopPlayTimer);
		}
		
	}
}