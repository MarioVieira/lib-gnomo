package uk.co.baremedia.gnomo.managers
{
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	
	import flash.media.Microphone;
	
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.controls.ControlAudioActivityMonitor;
	import uk.co.baremedia.gnomo.controls.ControlPlayer;
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.interfaces.IAudioBroadcaster;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.roles.RolesReceiver;
	import uk.co.baremedia.gnomo.signals.SignalCrossPlatformExchange;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.utils.UtilsMedia;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	import uk.co.baremedia.gnomo.vo.VOSlider;
	
	public class ManagerAudio
	{
		protected var _mediaMesseger		:IAudioBroadcaster;
		protected var _modelAudio			:ModelAudio;
		protected var _audioNotifier		:Signal;
		protected var _deviceType			:String;
		protected var _playerControl		:ControlPlayer;
		private var _crossPlatformExchange	:SignalCrossPlatformExchange;
		private var _audioMonitor			:ControlAudioActivityMonitor;
		private var _deviceVersion			:String;
		
		
		public function ManagerAudio(mediaMesseger:IAudioBroadcaster, controlAudioMonitor:ControlAudioActivityMonitor, model:ModelAudio, deviceType:String, deviceVersion:String, crossPlatformExchage:SignalCrossPlatformExchange, notifier:SignalNotifier)
		{
			_playerControl 			= new ControlPlayer(mediaMesseger, model, notifier);
			_audioMonitor			= controlAudioMonitor;
			_mediaMesseger 			= mediaMesseger;
			_modelAudio	   			= model;
			_deviceType    			= deviceType;
			_deviceVersion			= deviceVersion;
			_crossPlatformExchange 	= crossPlatformExchage;
			_audioNotifier 		   	= new Signal(VONotifierInfo);
			
			setObservers();
		}
		
		private function setObservers():void
		{
			/*
			* TO DO: remove the network depency to know about audio activity, LOCAL work in instead
			* _mediaMesseger.audioActivityMessage.add(onAudioActivityMessage);
			* 
			*/
			
			_modelAudio.add(onActiveNetStream);
		}
		
		/**
		 * 	
		 * When a new stream is added, regardless of being a broadcaster or listener we start / stop the activity audio checks
		 * 
		 **/ 
		private function onActiveNetStream(change:String):void
		{
			if(change == ModelAudio.NET_STREAM_CHANGE)
			{
				if(!_modelAudio.audioActivityStream && _audioMonitor.isActive)
					_audioMonitor.stopAcitivityMonitor();
				else if(_modelAudio.audioActivityStream && !_audioMonitor.isActive)
					_audioMonitor.startActivityMonitor();
			}
		}
		
		public function get modelAudio():ModelAudio
		{
			return _modelAudio;
		}
		
		
		/*private function onAudioActivityMessage(elapsedTimeInSec:Number):void
		{
			//Tracer.log(this, "onAudioActivityMessage - startNotStopAudio: "+startNotStopAudio);
			logTimeActivity(elapsedTimeInSec);
		}
		
		private function logTimeActivity(elapsedTimeInSec:Number):void
		{
			_audioMonitor.logTimeActivity(elapsedTimeInSec);	
		}*/
		
		public function get netStreamSignal():Signal
		{
			return _playerControl.netStreamSignal;
		}
		
		public function get broadcasterInfo():MediaBroadcastEvent
		{
			return _modelAudio.broadcasterInfo;
		}
		
		public function set broadcasterInfo(event:MediaBroadcastEvent):void
		{
			stopBroadcast();
			stopPlayingAudio(true);
			_audioMonitor.stopAcitivityMonitor();
			_modelAudio.broadcasterInfo = event;
			_modelAudio.broadcasting	= false;
		}
		
		public function get broadcasting():Boolean
		{
			return _modelAudio.broadcasting;
		}
		
		public function get audioNotifier():Signal
		{
			return _audioNotifier;
		}
		
		public function get debug():Signal
		{
			return _playerControl.debug;
		}
		
		public function broadcastAudio(orderType:String):void
		{
			//requestMicrophone();
			notifyAudioEvent("broadcastAudio()");
			
			var mic:Microphone = UtilsMedia.getMicrophone();
			
			if(mic) 
			{
				_playerControl.stopAudio(true);
				notifyAudioEvent(EnumsNotification.BROADCATING);
				notifyAudioEvent("broadcastAudio() - mic: "+mic);
				_modelAudio.broadcasting = true;
				_modelAudio.audioActivityStream = _mediaMesseger.broadcastAudioToGroup(mic, orderType, _deviceType, _deviceVersion);
				_modelAudio.microphone   = mic;
				_modelAudio.broadcasterInfo = null;
				_audioMonitor.startActivityMonitor();
			}
			else
			{
				notifyAudioEvent(EnumsNotification.NO_MICROPHONE_FOUND);
			}
		}
		
		public function stopPlayingAudio(unmountStream:Boolean = false):void
		{
			_playerControl.stopAudio(unmountStream);
		}
		
		public function stopBroadcast():void
		{
			//notifyAudioEvent("stopBroadacast() - _modelAudio.broadcasting: "+_modelAudio.broadcasting);
			if(_modelAudio.broadcasting)
			{
				//notifyAudioEvent("stopBroadacast() - killMicrophone");
				_audioMonitor.stopAcitivityMonitor();
				_mediaMesseger.stopBroadcasting();
				_modelAudio.broadcasting 	= false;
			}
		}
		
		private function notifyAudioEvent(message:String):void
		{
			_audioNotifier.dispatch( new VONotifierInfo(EnumsNotification.AUDIO, message) );
		}
		
		public function playBroadcasterStream(e:MediaBroadcastEvent, forcePlay:Boolean = false):void
		{
			var tmpBroadcasterInfo:MediaBroadcastEvent = (e) ? e : _modelAudio.broadcasterInfo;
			
			if(tmpBroadcasterInfo)
			{
				broadcasterInfo = tmpBroadcasterInfo;
				
				//var setupNewStream:Boolean = (!_modelAudio.broadcasterInfo || _modelAudio.broadcasterInfo && _modelAudio.broadcasterInfo.client.peerID != broadcasterInfo.client.peerID)
				//if(setupNewStream)
				
				var canReceive:Boolean = RolesReceiver.canClaimReceiverRole(_deviceType, tmpBroadcasterInfo.client.clientName);
				notifyAudioEvent( (canReceive) ? EnumsNotification.RECEIVING : EnumsNotification.NOT_ALLOWED_TO_RECEIVE_AUDIO );
				
				if( (forcePlay && canReceive) || (forcePlay && broadcasterInfo.mediaInfo.order == EnumsNotification.AUDIO_ACTIVITY) )
				{
					Tracer.log(this, "playBroadcasterStream");
					_playerControl.setupStream(broadcasterInfo.mediaInfo);
					_audioMonitor.startActivityMonitor();
				}
				else
				{
					Tracer.log(this, "playBroadcasterStream - canReceive: "+canReceive+" (CAN'T playing!)");
				}
			}
			else
			{
				Tracer.log(this, "playBroadcasterStream(e:MediaBroadcastEvent) (NULL parameter!)");
			}
		}
		
		public function setSensibility(slideValue:Number):void
		{
			_audioMonitor.setSensibility(slideValue);
		}
		
		public function set volume(value:Number):void
		{
			_playerControl.volume = value;
			_modelAudio.volume = value;
		}
		
		public function grabMicrophone():void
		{
			if(!_modelAudio.microphone) 
			{
				_modelAudio.microphone = UtilsMedia.getMicrophone();
				//Tracer.log(this, "grabbed mic: "+_modelAudio.microphone);
			}
			else
			{
				_modelAudio.microphone = null;
			}
		}
	}
}