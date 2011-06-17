package uk.co.baremedia.gnomo.presentation
{
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.controls.ControlUnits;
	import uk.co.baremedia.gnomo.models.Locale;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelModes;
	
	public class PresentationUnits implements IDispose
	{
		[Bindable] public var textSwapOrQuitButton		:String;
		[Bindable] public var textConnectionStatus		:String;
		[Bindable] public var textTopNote				:String;
		[Bindable] public var textListenNow				:String;
		
		[Bindable] public function get connected()		:Boolean{ return _modelModes.localNetworkConnected; }
		[Bindable] public var receiving					:Boolean;
		[Bindable] public var broadcasting				:Boolean;
		[Bindable] public var listening					:Boolean;
		
		
		public var uiChange								:Signal;
		
		private var _controlUnits						:ControlUnits;
		private var _modelModes							:ModelModes;
		private var _modelAudio							:ModelAudio;
		
		
		public function PresentationUnits(control:ControlUnits, modelModes:ModelModes, modelAudio:ModelAudio) 
		{
			uiChange 			= new Signal();
			_controlUnits 		= control;
			_modelModes     	= modelModes;
			_modelAudio 		= modelAudio;
			
			setObservers();
			setText();
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			_modelModes.remove(onModeChange);
			_modelAudio.remove(onModelAudio);
		}
		
		private function setObservers():void
		{
			_modelModes.add(onModeChange);
			_modelAudio.add(onModelAudio);
		}
		
		private function setText():void
		{
			defineNoteText();
			defineConnectedRelatedText(_modelModes.localNetworkConnected);
			defineListenText();
			notifyUiDataChange();
		}
		
		public function listenOrStopListening():void
		{
			if(!listening)
			{
				listenBroadcaster(true);
			}
			else
			{
				listenBroadcaster(false);
			}
		}

		private function listenBroadcaster(listenNotStop:Boolean):void
		{
			if(listenNotStop && _controlUnits.hasBroadcasterInfo)
			{
				listening = true;
				_controlUnits.listenBroadcaster();
			}
			else if(!listenNotStop)
			{
				_controlUnits.stopListening();
				listening = false;
			}
			
			defineListenText();
			notifyUiDataChange();
		}
		
		public function defineListenText():void
		{
			textListenNow = (!listening) ? Locale.screenUnitsButtonListenNow : Locale.screenUnitsButtonStopListening;
		}
		
		public function showLogs():void
		{
			_controlUnits.requestScreenLogsMain();
		}
		
		public function swapModesOrQuit():void
		{
			if(connected) _controlUnits.disconnect();
			else		  _controlUnits.requesScreenModes();
		}
		
		public function setAsBabyUnit():void
		{
			_controlUnits.setUnitMode(true);
		}
		
		public function setSensibility(sliderValue:Number):void
		{
			Tracer.log(this, "setSensibility"); 	
		}
		
		private function onModelAudio(change:String):void
		{
			//Tracer.log(this, "onModelAudio");
			setReceiving();
			setBroadcasting();
			defineNoteText(); 
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
		}
		
		private function defineNoteText():void
		{
			if(!_modelAudio.broadcasting && !receiving) textTopNote = Locale.screenUnitsTextSetABabyUnit;
			else if(_modelAudio.broadcasting) 		    textTopNote = Locale.screenUnitsTextBabyUnit; 
			else if(receiving)						    textTopNote = Locale.screenUnitsTextParentUnit;
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
				textSwapOrQuitButton = Locale.screenUnitsButtonSwapModes;
				textConnectionStatus = Locale.screenUnitsTextConnected;
			}
			else
			{
				textSwapOrQuitButton = Locale.buttonQuit;
				textConnectionStatus = Locale.screenUnitsTextConnecting;	
			}
		}
		
		private function onModeChange(change:String):void
		{
			defineConnectedRelatedText(_modelModes.localNetworkConnected);
			defineNoteText();
			setReceiving();
			setBroadcasting();
			notifyUiDataChange();
		}		
	}
}