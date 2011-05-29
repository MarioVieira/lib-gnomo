package co.uk.baremedia.gnomo.controls
{
	import co.uk.baremedia.gnomo.enums.EnumsLocalNetwork;
	import co.uk.baremedia.gnomo.models.ModelBroadcaster;
	import co.uk.baremedia.gnomo.models.ModelDeviceInfo;
	import co.uk.baremedia.gnomo.models.ModelNetworkManager;
	import co.uk.baremedia.gnomo.signals.SignalNotifier;
	import co.uk.baremedia.gnomo.utils.UtilsMedia;
	import co.uk.baremedia.gnomo.utils.UtilsMessenger;
	import co.uk.baremedia.gnomo.vo.VOLocalNetworkMessage;
	import co.uk.baremedia.gnomo.vo.VONotifierInfo;
	
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.util.Tracer;
	
	import flash.events.Event;
	import flash.media.Microphone;
	
	import org.robotlegs.core.IInjector;
	import co.uk.baremedia.gnomo.enums.EnumsNotification;

	public class ControlNetworkManager
	{
		protected var _modelBroadcaster		:ModelBroadcaster;
		
		protected var _notifier				:SignalNotifier;
		protected var _modelLocalNetwork	:ModelNetworkManager;
		protected var _controlBroadcaster	:ControlBroadcaster;
		protected var _modelDeviceInfo		:ModelDeviceInfo;
		protected var _localNetworkDiscovery:LocalNetworkDiscovery;
		
		public function ControlNetworkManager()
		{
			_localNetworkDiscovery = new LocalNetworkDiscovery();
			_localNetworkDiscovery.addEventListener(Event.DEACTIVATE, onConnection);
			_localNetworkDiscovery.addEventListener(Event.ACTIVATE, onDisconnected);
			_localNetworkDiscovery.addEventListener(MessageEvent.DATA_RECEIVED, onMessage);
			_localNetworkDiscovery.addEventListener(MediaBroadcastEvent.MEDIA_BROADCAST, onMedia);
		}
		
		[Inject]
		public var injector:IInjector;
		
		[PostConstruct]
		public function init():void
		{
			_modelLocalNetwork 	 = injector.getInstance(ModelNetworkManager);
			_modelDeviceInfo   	 = injector.getInstance(ModelDeviceInfo);
			_controlBroadcaster  = injector.getInstance(ControlBroadcaster);
			_modelBroadcaster	 = injector.getInstance(ModelBroadcaster); 
		}
		
		/************************************************************************
		 *							COMMON CONTROLS
		 ***********************************************************************/
		
		protected function notifyApp(info:int):void
		{
			_notifier.dispatch(	new VONotifierInfo(info) );
		}
		
		public function connect():void
		{
			_localNetworkDiscovery.connect();	
		}
		
		public function disconnect():void
		{
			_localNetworkDiscovery.close();
		}
		
		public function claimBroadcasterRole():void
		{
			broadcastMicrophone();
		}

		//NOT THERE YET
		public function claimReceiverRole():void
		{
			if(canClaimReceiverRole)
			{
				sendMessage( UtilsMessenger.getMessage(EnumsLocalNetwork.RECEIVER_CONNECTED, _modelDeviceInfo.deviceType) );
			}
		}
		
		protected function canClaimReceiverRole():Boolean
		{
			//mobiles can always receive 
			if(_modelDeviceInfo.deviceType == EnumsLocalNetwork.TYPE_MOBILE)
			{
				return true;	
			}
				//PCs can only receive from Mobiles, never PCs (else uses can have a PC to PC app)
			else if(_modelDeviceInfo.deviceType == EnumsLocalNetwork.TYPE_PC)
			{
				return (_modelBroadcaster.type == EnumsLocalNetwork.TYPE_MOBILE);
			}
		}
		
		
		/************************************************************************
		 *								CONTROLS
		 ***********************************************************************/
		
		protected function broadcastMicrophone():void
		{
			var mic:Microphone = UtilsMedia.getDefaultMicrophone();
			
			if(mic)
			{
				_modelBroadcaster.broadcaster = true;
				_localNetworkDiscovery.microphone;
				_localNetworkDiscovery.startBrodcast();
				notifyApp(EnumsNotification.BROADCATING);
			}
		}

		private function stopBroadcasting():void
		{
			if(_modelLocalNetwork.broadcaterInfo.broadcast) 
			{
				Tracer.log(this, "stopBroadcasting");	
			}
		}
		
		
		
		
		
		
		/************************************************************************
		 *								HANDLERS
		 ***********************************************************************/
		
		private function onConnection(event:Event):void
		{
			Tracer.log(this, "onConnected");
			_modelLocalNetwork.groupConnected = true;
		}
		
		private function onDisconnected(event:Event):void
		{
			Tracer.log(this, "onConnected");
			//_modelLocalNetwork.groupConnected = false;	
		}
		
		private function onMedia(event:MediaBroadcastEvent):void
		{
			Tracer.log(this, "onMedia - event.mediaInfo.mediaType: "+event.mediaInfo.mediaType);
			stopBroadcasting();
			//connect to stream
		}
		
		/************************************************************************
		 *								MESSENGER
		 ***********************************************************************/
		
		protected function onMessage(e:MessageEvent):void
		{
			Tracer.log(this, "onMessage - e.message.data: "+e.message.data);
			var messageData:VOLocalNetworkMessage = e.message.data as VOLocalNetworkMessage;
			if(messageData) defineMessageOperation(messageData);
		}

		protected function defineMessageOperation(message:VOLocalNetworkMessage):void
		{
			if( UtilsMessenger.isBroadcasterRequest(message) )
			{
				handleBroadcasterRequest(message);	
			}
			else if( UtilsMessenger.isReceiverRequest(message) )
			{
				handleReceiverRequest(message);
			}
		
			/*
			if(message.roleAsked == EnumsLocalNetwork.BROADCASTER_ROLE_CLAIMED)
			{
				broadcasterRoleClaimed();
			}
			else if(message == EnumsLocalNetwork.RECEIVER_CONNECTED)
			{
				
			}
			*/
		}
		
		protected function sendMessage(message:VOLocalNetworkMessage):void
		{
			_localNetworkDiscovery.sendMessageToAll(message);
		}
		  
	}
}