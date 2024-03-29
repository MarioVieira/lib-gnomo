package uk.co.baremedia.gnomo.presentation
{
	import com.projectcocoon.p2p.util.Tracer;
	
	import flash.net.sendToURL;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.controls.ControlPersistedData;
	import uk.co.baremedia.gnomo.controls.ControlUnits;
	import uk.co.baremedia.gnomo.enums.EnumsLanguage;
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelModes;
	import uk.co.baremedia.gnomo.models.ModelNetworkManager;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.utils.UtilsResources;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	public class PresentationUnits implements IDispose
	{
		public static const ALERT_AGREEMENT				:String  = "agreement";
		public static const ALERT_IMPORTANT				:String  = "important";
		public static const ALERT_DISCONNECTED			:String  = "disconnected";
		
		[Bindable] public var textQuitButton			:String; 
		[Bindable] public var textSlider				:String;
		[Bindable] public var textConnectionStatus		:String;
		[Bindable] public var textTopNote				:String;
		[Bindable] public var textAudioButtonControl	:String;
		
		[Bindable] public function get connected()		:Boolean{ return _modelModes.localNetworkConnected; }
		[Bindable] public var receiving					:Boolean;
		[Bindable] public var broadcasting				:Boolean;
		[Bindable] public var listening					:Boolean;
		[Bindable] public var buttonAudioControlEnabled	:Boolean;
		[Bindable] public var sliderLevel				:Number = 1;
		
		public var uiChange								:Signal;
		public var openAlert							:Signal;
		public var connectedSignal						:Signal;
		
		private var _controlUnits						:ControlUnits;
		private var _modelModes							:ModelModes;
		private var _modelNetwork						:ModelNetworkManager
		private var _modelAudio							:ModelAudio;
		private var _controlPersistentData				:ControlPersistedData;
		private var _signalNotifier						:SignalNotifier;
		private var _alertOpen							:Boolean;
		
		
		
		public function PresentationUnits(control:ControlUnits, controlPersistentData:ControlPersistedData, modelNetwork:ModelNetworkManager, modelModes:ModelModes, modelAudio:ModelAudio, signalNotifier:SignalNotifier = null) 
		{
			uiChange 				= new Signal();
			openAlert				= new Signal(String);
			connectedSignal			= new Signal(Boolean);
			_controlUnits 			= control;
			_controlPersistentData  = controlPersistentData;
			_modelModes     		= modelModes;
			_modelAudio 			= modelAudio;
			_modelNetwork			= modelNetwork;
			_signalNotifier			= signalNotifier;
			
			setObservers();
			setText();
		}
		
		private function checkNeedsConnecting():void
		{
			if(!connected)
			{
				_controlUnits.setConnectedMode(true);
			}
		}
		
		public function get modelMonitor():ModelModes
		{
			return _controlUnits.modelMonitor;
		}
		
		public function alertClosed(id:String):void
		{
			_alertOpen = false;
			if(id == ALERT_AGREEMENT)
			{
				requestAlert(ALERT_IMPORTANT);
			}
			else if(id == ALERT_IMPORTANT)
			{
				_controlPersistentData.importantAlerted = true;
				checkNeedsConnecting();
			}
		}

		protected function requestAlert(alert:String):void
		{
			if(!alert)
			{
				_alertOpen = false;
				openAlert.dispatch(alert);
			}
			else if(!_alertOpen) 
			{
				_alertOpen = true;
				openAlert.dispatch(alert);
			}
		}

		
		public function checkHasToShowAlerts():void
		{
			if(!_controlPersistentData.agreementAccepted) 	  requestAlert(ALERT_AGREEMENT);
			else if(!_controlPersistentData.importantAlerted) requestAlert(ALERT_IMPORTANT);
		}
		
		public function agreementAccepted(value:Boolean):void
		{
			_controlPersistentData.agreementAccepted = value;	
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			_modelModes.remove(onModeChange);
			_modelAudio.remove(onModelAudio);
			_modelNetwork.remove(onConnectionAlert);
		}
		
		private function setObservers():void
		{
			_modelModes.add(onModeChange);
			_modelAudio.add(onModelAudio);
			_modelNetwork.add(onConnectionAlert);
			_signalNotifier.add(onSignalNotifier);
			
			_controlUnits.listenSignal.add(onListening);
			//_controlUnits.monitorMode.add(onMonitorMode);
		}
		
		private function onListening(listening:Boolean):void
		{
			this.listening = listening;
			defineAudioControlButtonLabel();
			notifyUiDataChange();
			setReceiving();
			//Tracer.log(this, "onListening - listening: "+listening);
		}
		
		private function onSignalNotifier(vo:VONotifierInfo):void
		{
			if(vo.notificationType == EnumsNotification.KEEP_ALIVE)
			{
				textTopNote = "KEEP IOS ALIVE and STOP NETWORK MONITOR!";
			}
			else if(vo.notificationType == "mic")
			{
				textConnectionStatus = vo.notificationValue.toString();		
			}
		}
		
		private function setText():void
		{
			//Tracer.log(this, "setText() - UtilsResources.getKey(EnumsLanguage.VOLUME): "+UtilsResources.getKey(EnumsLanguage.VOLUME) );
			defineNoteText();
			defineSliderData();
			defineConnectedRelatedText(_modelModes.localNetworkConnected);
			defineAudioControlButtonLabel();
			notifyUiDataChange();
		}
		
		private function defineSliderData():void
		{
			if(!broadcasting)
			{
				textSlider  = UtilsResources.getKey(EnumsLanguage.VOLUME);
				sliderLevel = _modelAudio.volume;
			}
			else 
			{
				textSlider = UtilsResources.getKey(EnumsLanguage.SENSIBILITY);
				sliderLevel = _modelAudio.sensibilityLevel / 10;	
			}
		}
		
		public function listenOrStopListening():void
		{
			listenBroadcaster(!listening); 
		}
		
		private function listenBroadcaster(listenNotStop:Boolean):void
		{
			if(listenNotStop && _controlUnits.hasBroadcasterInfo)
			{
				_controlUnits.listenBroadcaster(true);
			}
			else if(!listenNotStop)
			{
				_controlUnits.stopListening();
			}
			
			defineSliderData();
			defineAudioControlButtonLabel();
			notifyUiDataChange();
			setReceiving();
		}
		
		public function defineAudioControlButtonLabel():void
		{
			if(!_controlUnits.isIOS) 
			{
				textAudioButtonControl = (!listening) ? UtilsResources.getKey(EnumsLanguage.LISTEN_NOW) : UtilsResources.getKey(EnumsLanguage.STOP_LISTENING);
			}
			else 					 
			{
				textAudioButtonControl = (listening) ? UtilsResources.getKey(EnumsLanguage.MUTE) 		: UtilsResources.getKey(EnumsLanguage.UNMUTE);
			}
		}
		
		public function showLogs():void
		{
			_controlUnits.requestScreenLogsMain();
		}
		
		public function disconnectOrConnect():void
		{
			if(_modelNetwork.connected) _controlUnits.setConnectedMode(false);
			else					  	_controlUnits.setConnectedMode(true); 
		}
		
		public function setAsBabyUnit():void
		{
			_controlUnits.setUnitMode(true);
		}
		
		public function set sliderValue(value:Number):void
		{
			if(!broadcasting) volume 			= value;
			else			  audioSensibility 	= value;
		}
		
		protected function set audioSensibility(value:Number):void
		{
			//Tracer.log(this, "audioSensibility: "+(value <= 8) ? value * 10 : 8 * 10 );
			_controlUnits.setSensibility( (value <= 8) ? value * 10 : 8 * 10 );
		}
		
		protected function set volume(value:Number):void
		{
			//Tracer.log(this, "volume: "+value );
			_controlUnits.volume = value;
		}
		
		private function onModelAudio(change:String):void
		{
			//Tracer.log(this, "onModelAudio");
			setReceiving();
			setBroadcasting();
			defineNoteText(); 
			defineSliderData();
			defineConnectedRelatedText(_modelModes.localNetworkConnected);
			notifyUiDataChange();
		}
		
		private function setBroadcasting():void
		{
			broadcasting = _modelAudio.broadcasting;
		}
		
		private function setReceiving():void
		{
			receiving = _modelAudio.broadcasterInfo != null;
			
			//buttonAudioControlEnabled = receiving && !listening;
			/*canStopListening 		  = receiving && listening;*/
		}
		
		private function defineNoteText():void
		{
			if(!_modelAudio.broadcasting && !receiving) textTopNote = _modelModes.textTopNote = UtilsResources.getKey(EnumsLanguage.SET_A_BABY_UNIT);
			else if(_modelAudio.broadcasting) 		    textTopNote = _modelModes.textTopNote = UtilsResources.getKey(EnumsLanguage.BABY_UNIT); 
			else if(receiving)						    textTopNote = _modelModes.textTopNote = UtilsResources.getKey(EnumsLanguage.PARENT_UNIT);
		}
		
		//no binding in Flash
		private function notifyUiDataChange():void
		{
			uiChange.dispatch();
		}
		
		private function defineConnectedRelatedText(localNetworkConnected:Boolean):void
		{
			if(localNetworkConnected) 
			{
				textQuitButton = UtilsResources.getKey(EnumsLanguage.DISCONNECT);
				textConnectionStatus = _modelModes.textConnectedStatus = UtilsResources.getKey(EnumsLanguage.CONNECTED);
			}
			else
			{
				textQuitButton = UtilsResources.getKey(EnumsLanguage.CONNECT);
				textConnectionStatus = _modelModes.textConnectedStatus = UtilsResources.getKey(EnumsLanguage.CONNECTING);
			}
		}
		
		private function onModeChange(change:String):void
		{
			Tracer.log(this, "onModeChange - _modelModes.localNetworkConnected: "+_modelModes.localNetworkConnected);
			defineConnectedRelatedText(_modelModes.localNetworkConnected);
			defineNoteText();
			defineSliderData();
			setReceiving();
			setBroadcasting();
			notifyUiDataChange();
		}
		
		private function onConnectionAlert(changeType:String):void
		{
			if(changeType == ModelNetworkManager.CONNECTION_ALERT && _modelNetwork.connectionAlert && !_alertOpen)
			{
				requestAlert(ALERT_DISCONNECTED);
			}
			else if(changeType == ModelNetworkManager.CONNECTION_ALERT && !_modelNetwork.connectionAlert && _alertOpen)
			{
				requestAlert(null);
			}
		}
	}
}