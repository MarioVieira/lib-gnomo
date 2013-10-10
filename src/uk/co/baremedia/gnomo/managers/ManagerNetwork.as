package uk.co.baremedia.gnomo.managers
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.AccelerationEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.util.ClassRegistry;
	import com.projectcocoon.p2p.util.Tracer;
	import com.projectcocoon.p2p.vo.BroadcasterMediaVO;
	
	import flash.events.Event;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.enums.EnumsLocalNetwork;
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.interfaces.IAudioBroadcaster;
	import uk.co.baremedia.gnomo.interfaces.IBroadcasting;
	import uk.co.baremedia.gnomo.interfaces.ILocalNetworkMessenger;
	import uk.co.baremedia.gnomo.interfaces.INetworkManager;
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelNetworkManager;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.utils.UtilsAppNotifier;
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;
	import uk.co.baremedia.gnomo.utils.UtilsMessenger;
	import uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;

	public class ManagerNetwork implements ILocalNetworkMessenger, IAudioBroadcaster, INetworkManager
	{
		[Bindable] public var autoConnect	:Boolean = true;
		public var _groupConnectionSignal	:Signal;
		
		private var _mediaBroadcast			:Signal;
		private var _noConnection			:Signal;
		private var _debug					:Signal;
		
		protected var _modelLocalNetwork	:ModelNetworkManager;
		protected var _controlNetworkMonitor:ManagerNetworkMonitor;
		protected var _localNetwork			:LocalNetworkDiscovery;
		protected var _messenger			:IP2PMessenger;
		
		private var _groupConnected			:Boolean;
		private var _audioActivity			:Signal;
		private var _monitorActivity		:Signal;
		private var _signalNotifier			:SignalNotifier;
		private var _broadcasterInfo		:IBroadcasting;
		
		
		public function ManagerNetwork(localNetwork:LocalNetworkDiscovery, messenger:IP2PMessenger, model:ModelNetworkManager, signalNotifier:SignalNotifier, brodcaterInfo:IBroadcasting)
		{
			_messenger				= messenger;
			_localNetwork			= localNetwork;
			_modelLocalNetwork 		= model;
			
			_groupConnectionSignal  = new Signal();
			
			_mediaBroadcast 		= new Signal(MediaBroadcastEvent);
			_noConnection			= new Signal();
			_debug					= new Signal();
			_audioActivity			= new Signal();
			_monitorActivity		= new Signal();
			_signalNotifier			= signalNotifier;
			_broadcasterInfo		= brodcaterInfo;
			
			registerClassesForSerialization();
			setupLocalNetwork(deviceType);
			setupNetworkMonitor(messenger);
		}
		

		public function set broadcastMonitorState(value:Boolean):void
		{
			_controlNetworkMonitor.broadcastMonitorState;
		}
		
		public function get netStreamSignal():Signal
		{
			return _localNetwork.netStreamSignal;
		}
		
		public function get groupConnectedSignal():Signal
		{
			return _groupConnectionSignal
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
			_controlNetworkMonitor.connectionStatus.add(onConnectionChange);
		}

		private function setupLocalNetwork(deviceType:String):void
		{
			//Tracer.log(this, "setupLocalNetwork - deviceType: "+deviceType);
			_localNetwork.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnection);
			_localNetwork.addEventListener(MessageEvent.DATA_RECEIVED, onMessage);
			_localNetwork.addEventListener(MediaBroadcastEvent.MEDIA_BROADCAST, onMedia);
			_localNetwork.connect();
			//_localNetwork.accelerometerInterval = 50;
		}
		
		protected function onAccelerometer(event:AccelerationEvent):void
		{
			//ONLY TESTING
			UtilsAppNotifier.notifyApp(_signalNotifier, EnumsNotification.ACCELEROMETER, event.acceleration);
				
			//Tracer.log(this, "onAccelerometer  - x: "+event.acceleration.accelerationX+" y: "+event.acceleration.accelerationY+" z: "+event.acceleration.accelerationZ);
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
		
		public function startNetworkMonitor(startNotStopMonitor:Boolean):void
		{
			_controlNetworkMonitor.startNetworkMonitor(startNotStopMonitor);
		}
		
		public function connect():void
		{
			//Tracer.log(this, "connect - _groupConnected: "+_groupConnected);
			if(_groupConnected) startNetworkMonitor(true);
			else 			   	_noConnection.dispatch();
		}
		
		public function disconnect(switchOff:Boolean = false):void
		{
			//Tracer.log(this, "disconnect");
			startNetworkMonitor(false);
			if(switchOff) _localNetwork.close();
			_groupConnected = false;
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
		
		public function broadcastAudioToGroup(microphone:Microphone, orderType:String, deviceType:String, deviceVersion:String):BroadcasterMediaVO
		{
			_localNetwork.microphone = microphone;
			return _localNetwork.startBrodcast(orderType, null, null, false, false, deviceType, deviceVersion);
		}
		
		public function stopBroadcasting():void
		{
			_localNetwork.stopMedia();
		}
		
		
		/* TO DO:
		* 
		* Audio acitivty is no longer a message
		*
		*/
		protected function defineMessageOperation(message:VOLocalNetworkMessage):void
		{
			if(message.messageType == EnumsLocalNetwork.ACTIVE_BROADCASTER_CHECK && _broadcasterInfo.broadcasting)
			{
				_localNetwork.sendMediaMessageToAll( _localNetwork.mediaInfo );
			}
			
			_controlNetworkMonitor.defineMessageOperation(message);
		}
		
		/************************************************************************
		 *								HANDLERS
		 ***********************************************************************/
		private function onGroupConnection(event:Event):void
		{
			//Tracer.log(this, "onGroupConnection");
			_groupConnectionSignal.dispatch();
			if(!_groupConnected)
			{
				_groupConnected = true;
				if(autoConnect) connect();
			}
		}
		
		private function onConnectionChange(connected:Boolean):void
		{
			//Tracer.log(this, "onConnectionNotification - connected: "+connected);
			if(!_modelLocalNetwork.connected && connected)
				checkNeedsBroadcasterIsActive();
			
			_modelLocalNetwork.connected = connected;
		}
		
		//this.deviceType seems to be used with an uui (clientName), not touching it...
		private function checkNeedsBroadcasterIsActive():void
		{
			_messenger.sendMessageToLocalNetwork( UtilsMessenger.getMessage(EnumsLocalNetwork.ACTIVE_BROADCASTER_CHECK, UtilsDeviceInfo.getDeviceType().deviceType, deviceVersion));
		}
		
		protected function onMedia(event:MediaBroadcastEvent):void
		{
			//Tracer.log(this, "onMedia - mediaInfo.order: "+event.mediaInfo.order);
			_mediaBroadcast.dispatch(event);
		}
		
		protected function onMessage(e:MessageEvent):void
		{
			var messageData:VOLocalNetworkMessage = e.message.data as VOLocalNetworkMessage;
			//Tracer.log(this, "onMessage - messageData: "+messageData);
			if(messageData)
			{
				defineMessageOperation(messageData);
			}
		}

		public function get deviceVersion():String
		{
			return UtilsDeviceInfo.getDeviceType().deviceVersion;
		}
	}
}