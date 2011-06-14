package uk.co.baremedia.gnomo.controls
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.enums.EnumsScreens;
	import uk.co.baremedia.gnomo.interfaces.INetworkManager;
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.managers.ManagerAudio;
	import uk.co.baremedia.gnomo.managers.ManagerNetwork;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelDeviceInfo;
	import uk.co.baremedia.gnomo.models.ModelModes;
	import uk.co.baremedia.gnomo.models.ModelNetworkManager;
	import uk.co.baremedia.gnomo.signals.SignalCrossPlatformExchange;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	import uk.co.baremedia.gnomo.utils.UtilsAppNotifier;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	public class ControlUnits implements IInitializer, IDispose
	{
		protected var _controlAudio			:ManagerAudio;
		protected var _networkManager	    :INetworkManager;
		protected var _model				:ModelModes;
		protected var _modelDeviceInfo		:ModelDeviceInfo;
		protected var _appNotifier			:SignalNotifier;
		protected var _viewNavigation		:SignalViewNavigation;
		
		
		public function init(injector:IInjector):void
		{ 
			_modelDeviceInfo	= injector.getInstance(ModelDeviceInfo);
			_model 				= injector.getInstance(ModelModes);
			_appNotifier		= injector.getInstance(SignalNotifier);
			_viewNavigation		= injector.getInstance(SignalViewNavigation);
			
			_networkManager 	= new ManagerNetwork( injector.getInstance(LocalNetworkDiscovery), injector.getInstance(IP2PMessenger), injector.getInstance(ModelNetworkManager) );
			_controlAudio		= new ManagerAudio(_networkManager, injector.getInstance(ModelAudio), _modelDeviceInfo.deviceType, injector.getInstance(SignalCrossPlatformExchange) );
			
			setObservers();
		}

		private function setObservers():void
		{
			_networkManager.connectionStatus.add(onConnectionStatus);
			_networkManager.mediaBroadcast.add(onMediaBroadcast);
			_networkManager.debug.add(onDebug);
			_controlAudio.audioNotifier.add(onAudioNotifier);
		}

	
		/**
		 * 
		 * Used for when mode has not been set
		 * 
		 * @param mode
		 * 
		 */		
		public function setConnectedMode(connected:Boolean):void
		{
			//try connection
			/*if(_model.localNetworkConnected != connected)
			{*/
				notifySystem("setConnectedMode - mode: "+connected);
				if(connected) tryLocalNetworkConnection();
				else 		  disconnect();
			//}
			/*else
			{*/
				//notifySystem("setConnectedMode - SAME, NOT CHANGING IT - mode: "+connected);
			//}
		}
		
		
		public function disconnect():void
		{
			_networkManager.disconnect();	
		}
		
		public function setUnitMode(babyUnitNoParentUnit:Boolean):void
		{
			defineUnitMode(babyUnitNoParentUnit);
			
			/*if(!_model.localNetworkConnected)
			{
				notifySystem("setUnitMode (babyUnitNoParentUnit: "+babyUnitNoParentUnit+") - CONNECTING 1st");
				setConnectedMode(true);
			}
			else
			{
				defineUnitMode(babyUnitNoParentUnit);
			}*/	
		}
		
		public function requestNoWirelessScreen():void
		{
			requestScreen(EnumsScreens.SCREEN_NO_WIRELESS);
		}
		
		protected function requestScreen(screenName:String):void
		{
			_viewNavigation.requestView(screenName);
		}
		
		//the mods changes before the audio is broadcasted, so stops audio to receive it, or to wait for it
		//only called if connected to wireless
		private function defineUnitMode(babyUnitNoParentUnit:Boolean):void
		{
			notifySystem("defineUnitMode - babyUnitNoParentUnit: "+babyUnitNoParentUnit);
			
			if(babyUnitNoParentUnit && !_controlAudio.broadcasting)
			{
				_controlAudio.stopReceivingAudio();
				_controlAudio.broadcastAudio();
			}
			else if(!babyUnitNoParentUnit)
			{
				notifySystem("defineUnitMode - _controlAudio.stopBroadcast() ");
				_controlAudio.stopBroadcast();
			}
			
			notifyUnitModeChange(babyUnitNoParentUnit);
		}
		
		protected function setModelConnectedMode(connected:Boolean):void
		{
			_model.babyUnitNotParentUnit = connected;
		}
		
		protected function tryLocalNetworkConnection():void
		{
			requestScreen(EnumsScreens.SCREEN_CONNECT);
			_networkManager.connect();
			notifySystem(EnumsNotification.CONNECTING);
		}
		
		private function setPhoneMode():void
		{
			_model.localNetworkConnected = false;
			_networkManager.disconnect();
			stopAudio();
			notifyModeChange(false);
		}
		
		private function stopAudio():void
		{
			_controlAudio.stopReceivingAudio();
			_controlAudio.stopBroadcast();
		}
		
		private function defineConnectedChangeAction(connected:Boolean):void
		{
			if(_model.localNetworkConnected != connected)
			{
				if(!connected) stopAudio();
				_model.localNetworkConnected = connected;
				notifyModeChange(connected);
				
				requestScreen( (connected) ? EnumsScreens.SCREEN_UNITS : EnumsScreens.SCREEN_DISCONNECTED );
			}
		}
		
		private function notifyModeChange(connected:Boolean):void
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
		
		private function onMediaBroadcast(e:MediaBroadcastEvent):void
		{
			_controlAudio.handleMediaBroadcast(e);
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
			 Tracer.log(this, "dispose");
			_networkManager.connectionStatus.remove(onConnectionStatus);
			_networkManager.mediaBroadcast.remove(onMediaBroadcast);
			_networkManager.debug.remove(onDebug);
			_controlAudio.audioNotifier.remove(onAudioNotifier);
		}
		
	}
}