package uk.co.baremedia.gnomo.managers
{
	import uk.co.baremedia.gnomo.controls.ControlPlayer;
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.interfaces.IAudioBroadcaster;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.roles.RolesReceiver;
	import uk.co.baremedia.gnomo.signals.SignalCrossPlatformExchange;
	import uk.co.baremedia.gnomo.utils.UtilsMedia;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	
	import flash.media.Microphone;
	
	import org.osflash.signals.Signal;

	public class ManagerAudio
	{
		protected var _mediaMesseger	:IAudioBroadcaster;
		protected var _modelAudio		:ModelAudio;
		protected var _audioNotifier	:Signal;
		protected var _deviceType		:String;
		protected var _playerControl	:ControlPlayer;
		private var _crossPlatformExchange:SignalCrossPlatformExchange;
		
		public function ManagerAudio(mediaMesseger:IAudioBroadcaster, model:ModelAudio, deviceType:String, crossPlatformExchage:SignalCrossPlatformExchange)
		{
			_playerControl 			= new ControlPlayer(mediaMesseger);
			_mediaMesseger 			= mediaMesseger;
			_modelAudio	   			= model;
			_deviceType    			= deviceType;
			_crossPlatformExchange 	= crossPlatformExchage;
			_audioNotifier 		   	= new Signal(VONotifierInfo);
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
		
		public function broadcastAudio():void
		{
			//requestMicrophone();
			notifyAudioEvent("broadcastAudio()");
			
			var mic:Microphone = UtilsMedia.getMicrophone();
				
			if(mic) 
			{
				notifyAudioEvent(EnumsNotification.BROADCATING);
				notifyAudioEvent("broadcastAudio() - mic: "+mic);
				_modelAudio.broadcasting = true;
				_mediaMesseger.broadcastAudioToGroup(mic);
				_modelAudio.microphone   = mic;
			}
			else
			{
				notifyAudioEvent(EnumsNotification.NO_MICROPHONE_FOUND);
			}
		}
		
		public function stopReceivingAudio():void
		{
			_playerControl.stopAudio();	
		}
		
		public function stopBroadcast():void
		{
			notifyAudioEvent("stopBroadacast() - _modelAudio.broadcasting: "+_modelAudio.broadcasting);
			if(_modelAudio.broadcasting)
			{
				notifyAudioEvent("stopBroadacast() - killMicrophone");
				_mediaMesseger.stopBroadcasting();
				_modelAudio.broadcasting 	= false;
			}
		}
		
		
		private function notifyAudioEvent(message:String):void
		{
			_audioNotifier.dispatch( new VONotifierInfo(EnumsNotification.AUDIO, message) );
		}
		
		
		public function handleMediaBroadcast(e:MediaBroadcastEvent):void
		{
			var canReceive:Boolean = RolesReceiver.canClaimReceiverRole(_deviceType, e.client.clientName);
			notifyAudioEvent( (canReceive) ? EnumsNotification.RECEIVING : EnumsNotification.NOT_ALLOWED_TO_RECEIVE_AUDIO );
			
			if(canReceive)
			{
				_playerControl.playStream(e.mediaInfo);
			}
		}
	}
}