package uk.co.baremedia.gnomo.controls
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	import com.projectcocoon.p2p.util.Tracer;
	
	import flash.net.NetStream;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.osflash.signals.Signal;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsLocalNetwork;
	import uk.co.baremedia.gnomo.enums.EnumsModes;
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.enums.EnumsScreens;
	import uk.co.baremedia.gnomo.enums.EnumsSettings;
	import uk.co.baremedia.gnomo.interfaces.INetworkManager;
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.managers.ManagerAudio;
	import uk.co.baremedia.gnomo.managers.ManagerNetwork;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelDeviceInfo;
	import uk.co.baremedia.gnomo.models.ModelModes;
	import uk.co.baremedia.gnomo.models.ModelNetworkManager;
	import uk.co.baremedia.gnomo.signals.SignalCrossPlatformExchange;
	import uk.co.baremedia.gnomo.signals.SignalListen;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	import uk.co.baremedia.gnomo.utils.UtilsAppNotifier;
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	public class ControlUnits implements IInitializer, IDispose
	{
		protected var _networkManager	    :INetworkManager;
		protected var _controlAudio			:ManagerAudio;
		protected var _model				:ModelModes;
		protected var _modelDeviceInfo		:ModelDeviceInfo;
		protected var _appNotifier			:SignalNotifier;
		protected var _viewNavigation		:SignalViewNavigation;
		protected var _controlDirectMessages:ControlDirectConnection;
		protected var _controlSpecificVersion:ControlSpecificVersion;
		protected var _listening			:SignalListen;
		
		/************************************************ SETUP *******************************************************/
		
		public function init(injector:IInjector):void
		{ 
			_controlDirectMessages	= new ControlDirectConnection();
			_modelDeviceInfo	= injector.getInstance(ModelDeviceInfo);
			_model 				= injector.getInstance(ModelModes);
			_appNotifier		= injector.getInstance(SignalNotifier);
			_viewNavigation		= injector.getInstance(SignalViewNavigation);
			_listening			= new SignalListen();
			
			_networkManager 	= new ManagerNetwork( injector.getInstance(LocalNetworkDiscovery), injector.getInstance(IP2PMessenger), injector.getInstance(ModelNetworkManager), _appNotifier);
			_controlAudio		= new ManagerAudio(_networkManager, injector.getInstance(ControlAudioMonitor), injector.getInstance(ModelAudio), _modelDeviceInfo.deviceType, injector.getInstance(SignalCrossPlatformExchange), _appNotifier);
			setObservers();
			
			//for tests only
			_modelDeviceInfo.deviceVersion = UtilsDeviceInfo.IOS;
		}

		private function setObservers():void
		{
			_networkManager.connectionStatus.add(onConnectionStatus);
			_networkManager.mediaBroadcast.add(onBroadcasterMedia);
			_networkManager.debug.add(onDebug);
			_controlAudio.audioNotifier.add(onAudioNotifier);
			_controlAudio.netStreamSignal.add(onReceiveNetStream);
			_networkManager.groupConnectedSignal.add(onGroupConnected);
			_controlDirectMessages.netStreamMessage.add(onNetStreamMessage);
			_controlAudio.audioActivityMessage.add(onAudioActivityMessage);
			
			//_networkManager.audioActivityMessage.add(onAudioActivityMessage);
		}
		
		/************************************************ NOTIFICATION *******************************************************/
		public function get listenSignal():SignalListen
		{
			return _listening;
		}
		
		public function get isIOS():Boolean
		{
			return _modelDeviceInfo.isIOS;
		}
		
		public function get netStreamMessage():Signal
		{
			return _controlDirectMessages.netStreamMessage;
		}
	
		public function setConnectedMode(connected:Boolean):void
		{
			//notifySystem("setConnectedMode - mode: "+connected);
			if(connected) tryLocalNetworkConnection();
			else 		  disconnect();
		}
		
		public function disconnect():void
		{
			_controlAudio.stopBroadcast();
			_controlAudio.stopPlayingAudio(true);
			listening = false;
			_networkManager.disconnect(true);
		}
		
		public function get hasBroadcasterInfo():Boolean
		{
			return (_controlAudio.broadcasterInfo != null);
		}
		
		public function setUnitMode(babyUnitNoParentUnit:Boolean):void
		{
			defineUnitMode(babyUnitNoParentUnit, EnumsNotification.BABY_UNIT_TAKEN);
		}
		
		public function listenBroadcaster():void
		{
			listening = true;
			_controlAudio.playBroadcasterStream(null, true);
		}
		
		public function stopListening():void
		{
			listening = false;
			_controlAudio.stopPlayingAudio();
		}
		
		public function requestNoWirelessScreen():void
		{
			requestScreen(EnumsScreens.SCREEN_NO_WIRELESS);
		}
		
		public function requestScreenUnits():void
		{
			requestScreen(EnumsScreens.SCREEN_UNITS);
		}
		
		public function requestScreenLogsMain():void
		{
			requestScreen(EnumsScreens.SCREEN_LOG_MAIN);
		}
		
		public function sendDirectMessage(message:String, integer:int):void
		{
			_controlDirectMessages.sendDirectMessage(message, integer);
		}

		/************************************************ PROTECTED *******************************************************/  
		protected function set listening(value:Boolean):void
		{
			_listening.listening = value;
		}
		
		protected function keepAliveForIOS():void
		{
			if(isIOS)
			{
				startNetworkMonitor(false);
				_controlAudio.grabMicrophone();
				UtilsAppNotifier.notifyApp(_appNotifier, EnumsNotification.KEEP_ALIVE);
			}
		}
		
		protected function requestScreen(screenName:String):void
		{
			_viewNavigation.requestView(screenName);
		}
		
		protected function setModelConnectedMode(connected:Boolean):void
		{
			_model.babyUnitNotParentUnit = connected;
		}
		
		protected function tryLocalNetworkConnection():void
		{
			requestScreen(EnumsScreens.SCREEN_UNITS);
			_networkManager.connect();
			notifySystem(EnumsNotification.CONNECTING);
		}
		
		private function stopAudio():void
		{
			_controlAudio.stopPlayingAudio();
			_controlAudio.stopBroadcast();
		}
		
		public function setSensibility(slideValue:Number):void
		{
			_controlAudio.setSensibility(slideValue);
		}
		
		public function set volume(value:Number):void
		{
			_controlAudio.volume = value;
		}
		
		private function defineConnectedChangeAction(connected:Boolean):void
		{
			if(_model.localNetworkConnected != connected)
			{
				//For testing
				//if(!connected) stopAudio();
				_model.localNetworkConnected = connected;
				notifyModeChange(connected);
				requestScreen( (connected) ? EnumsScreens.SCREEN_UNITS : EnumsScreens.SCREEN_DISCONNECTED );
			}
		}
		//the modes changes before the audio is broadcasted, so stops audio to receive it
		private function defineUnitMode(babyUnitNoParentUnit:Boolean, orderType:String):void
		{
			if(babyUnitNoParentUnit)
			{
				_controlAudio.broadcastAudio(orderType);
				//if(isIOS) startNetworkMonitor(false);
			}
			else
			{
				_controlAudio.stopBroadcast();
			}
			
			notifyUnitModeChange(babyUnitNoParentUnit);
		}
		
		private function startNetworkMonitor(startNotStop:Boolean):void
		{
			Tracer.log(this, "startNetworkMonitor - startNotStop: "+startNotStop);
			_networkManager.startNetworkMonitor(startNotStop);
		}
		
		/************************************************ NOTIFICATION *******************************************************/
		
		protected function notifyModeChange(connected:Boolean):void
		{
			UtilsAppNotifier.notifyApp(_appNotifier, EnumsNotification.CONNECTION_CHANGE, connected );	
		}
		
		protected function notifyUnitModeChange(connected:Boolean):void
		{
			UtilsAppNotifier.notifyApp(_appNotifier, EnumsNotification.UNIT_CHANGE, UtilsAppNotifier.getUnitChange(connected) );
		}
		
		private function notifyReceivingAudio(receivingNotSending:Boolean):void
		{
			UtilsAppNotifier.notifyApp(_appNotifier, EnumsNotification.AUDIO, (receivingNotSending) ? EnumsNotification.RECEIVING : EnumsNotification.BROADCATING);
		}
		
		private function notifySystem(message:String):void
		{
			UtilsAppNotifier.notifyApp(_appNotifier, EnumsNotification.SYSTEM_NOTIFICATION, message);
		}
		
		protected function onConnectionStatus(connected:Boolean):void
		{
			defineConnectedChangeAction(connected);
		}
		
		/************************************************ HANDLERS *******************************************************/
		
		private function onAudioActivityMessage(startNotStopAudio:Boolean):void
		{
			if(!_listening.listening && startNotStopAudio)
			{
				listenBroadcaster();
			}
			else if(_listening.listening && !startNotStopAudio)
			{
				stopListening();
			}
		}
		
		private function onNetStreamMessage(message:String, integer:int):void
		{
			if(!_controlAudio.broadcasting && message == EnumsNotification.AUDIO_ACTIVITY)
			{
				//Tracer.log(this, "onNetStreamMessage - AUDIO_ACTIVITY - integer: "+integer);
				if(integer == 1) listenBroadcaster();
				else		 	 stopListening();
			}
		}
		
		private function onReceiveNetStream(netStream:NetStream):void
		{
			_controlDirectMessages.setupDirectConnection(netStream);
		}
		
		private function onGroupConnected():void
		{
			_networkManager.netStreamSignal.add(onReceiveNetStream);	
		}
		
		private function onBroadcasterMedia(e:MediaBroadcastEvent):void
		{
			//Tracer.log(this, "onMediaBroadcast - e.mediaInfo.order: "+e.mediaInfo.order);
			_controlAudio.playBroadcasterStream(e, isIOS);
			listening = isIOS;
			keepAliveForIOS();
		}
		
		private function onDebug(info:VONotifierInfo):void
		{
			_appNotifier.dispatch(info);
		}
		
		private function onAudioNotifier(info:VONotifierInfo):void
		{
			if(info.notificationValue == EnumsNotification.RECEIVING)
			{
				setUnitMode(false);
			}
			
			_appNotifier.dispatch(info);	
		}

		public function dispose(recursive:Boolean=true):void
		{
			_networkManager.connectionStatus.remove(onConnectionStatus);
			_networkManager.mediaBroadcast.remove(onBroadcasterMedia);
			_networkManager.debug.remove(onDebug);
			_controlAudio.audioNotifier.remove(onAudioNotifier);
			_controlAudio.netStreamSignal.remove(onReceiveNetStream);
			_networkManager.groupConnectedSignal.remove(onGroupConnected);
			_controlDirectMessages.netStreamMessage.remove(onNetStreamMessage);
			_controlAudio.audioActivityMessage.remove(onAudioActivityMessage);
		}
	}
}