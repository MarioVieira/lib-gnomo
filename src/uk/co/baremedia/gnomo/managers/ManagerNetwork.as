package uk.co.baremedia.gnomo.managers
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.util.ClassRegistry;
	import com.projectcocoon.p2p.util.Tracer;
	import com.projectcocoon.p2p.vo.MediaVO;
	
	import flash.events.Event;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.interfaces.IAudioBroadcaster;
	import uk.co.baremedia.gnomo.interfaces.ILocalNetworkMessenger;
	import uk.co.baremedia.gnomo.interfaces.INetworkManager;
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.models.ModelDeviceInfo;
	import uk.co.baremedia.gnomo.models.ModelNetworkManager;
	import uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;

	public class ManagerNetwork implements ILocalNetworkMessenger, IAudioBroadcaster, INetworkManager
	{
		private var _mediaBroadcast			:Signal;
		private var _noConnection			:Signal;
		private var _debug					:Signal;
		
		protected var _modelLocalNetwork	:ModelNetworkManager;
		protected var _controlNetworkMonitor:ManagerNetworkMonitor;
		protected var _localNetwork			:LocalNetworkDiscovery;
		protected var _messenger			:IP2PMessenger;
		
		private var _groupConnected			:Boolean;
		private var _keepAlive 				:Boolean = true;
		private var _audioActivity			:Signal;
		
		public function ManagerNetwork(localNetwork:LocalNetworkDiscovery, messenger:IP2PMessenger, model:ModelNetworkManager)
		{
			_messenger			= messenger;
			_localNetwork		= localNetwork;
			_modelLocalNetwork 	= model;
			
			_mediaBroadcast 	= new Signal(MediaBroadcastEvent);
			_noConnection		= new Signal();
			_debug				= new Signal();
			_audioActivity		= new Signal();
			
			registerClassesForSerialization();
			setupLocalNetwork(deviceType);
			setupNetworkMonitor(messenger);
		}
		
		public function set microphone(value:Microphone):void
		{
			_localNetwork.microphone = value;
		}
		
		public function get mediaBroadcast():Signal
		{
			return _mediaBroadcast;
		}
		
		public function get audioActivityMessage():Signal
		{
			return _audioActivity;
		}

		public function get noConnection():Signal
		{
			return _noConnection;
		}

		public function get debug():Signal
		{
			return _debug;
		}

		private function setupNetworkMonitor(messenger:IP2PMessenger):void
		{
			_controlNetworkMonitor = new ManagerNetworkMonitor(messenger);
			_controlNetworkMonitor.monitorDebug.add(onMonitorDebug);
			_controlNetworkMonitor.connectionStatus.add(onConnectionChange);
		}

		private function setupLocalNetwork(deviceType:String):void
		{
			//Tracer.log(this, "setupLocalNetwork - deviceType: "+deviceType);
			_localNetwork.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnection);
			_localNetwork.addEventListener(MessageEvent.DATA_RECEIVED, onMessage);
			_localNetwork.addEventListener(MediaBroadcastEvent.MEDIA_BROADCAST, onMedia);
			_localNetwork.connect();
		}
		
		public function get connectionStatus():Signal
		{
			return _controlNetworkMonitor.connectionStatus;
		}
		
		protected function registerClassesForSerialization():void
		{
			ClassRegistry.registerClass("uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage", VOLocalNetworkMessage);
		}
		
		protected function onMonitorDebug(message:String):void
		{
			_debug.dispatch(new VONotifierInfo(EnumsNotification.DEBUG, message) ); 
		}
		
		/************************************************************************
		 *							COMMON CONTROLS
		 ***********************************************************************/
		
		public function keepAlive(startNotStopMonitor:Boolean):void
		{
			_keepAlive  = startNotStopMonitor;
			_controlNetworkMonitor.keepAlive(startNotStopMonitor);
		}
		
		public function connect():void
		{
			//Tracer.log(this, "connect");
			if(_groupConnected) keepAlive(true);
			else 			   	_noConnection.dispatch();
		}
		
		public function disconnect(switchOff:Boolean = false):void
		{
			//Tracer.log(this, "disconnect");
			keepAlive(false);
			if(switchOff) _localNetwork.close();
		}
		
		
		public function get deviceType():String
		{
			return _localNetwork.clientName;		 	
		}
		
		public function sendMessageToLocalNetwork(message:VOLocalNetworkMessage):void
		{
			//Tracer.log(this, "sendMessageToLocalNetwork");
			_localNetwork.sendMessageToAll(message);
		}
		
		public function get groupNetConnection():NetConnection
		{
			return _localNetwork.groupNetConnection();
		}
		
		public function broadcastAudioToGroup(microphone:Microphone, orderType:String):void
		{
			_localNetwork.microphone = microphone;
			_localNetwork.startBrodcast(orderType);
		}
		
		public function stopBroadcasting():void
		{
			_localNetwork.stopMedia();
		}
		
		protected function defineMessageOperation(message:VOLocalNetworkMessage):void
		{
			if(message.messageType == EnumsNotification.AUDIO_ACTIVITY)
			{
				_audioActivity.dispatch(message.startNotStopAudio);
			}
			else
			{
				_controlNetworkMonitor.defineMessageOperation(message);
			}
		}
		
		/************************************************************************
		 *								HANDLERS
		 ***********************************************************************/
		private function onGroupConnection(event:Event):void
		{
			//Tracer.log(this, "onGroupConnection");
			_groupConnected = true;
		}
		
		private function onConnectionChange(connected:Boolean):void
		{
			//Tracer.log(this, "onConnectionNotification - connected: "+connected);
			_modelLocalNetwork.connected = connected;
		}
		
		protected function onMedia(event:MediaBroadcastEvent):void
		{
			Tracer.log(this, "onMedia - mediaInfo.order: "+event.mediaInfo.order);
			keepAlive(true);
			_mediaBroadcast.dispatch(event);
		}
		
		protected function onMessage(e:MessageEvent):void
		{
			var messageData:VOLocalNetworkMessage = e.message.data as VOLocalNetworkMessage;
			
			//Tracer.log(this, "onMessage - messageData: "+messageData);
			if(messageData && _keepAlive)
			{
				defineMessageOperation(messageData);
			}
		}
	}
}