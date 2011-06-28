package uk.co.baremedia.gnomo.presentation
{
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;
	
	import uk.co.baremedia.gnomo.controls.ControlUnits;
	import uk.co.baremedia.gnomo.enums.EnumsLocalNetwork;
	import uk.co.baremedia.gnomo.enums.EnumsModes;
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.enums.EnumsSettings;
	import uk.co.baremedia.gnomo.models.ModelDeviceInfo;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;
	import uk.co.baremedia.gnomo.utils.UtilsNetwork;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	public class PresentationScreenModes
	{
		public var uiChange							:Signal;
		[Bindable] public var isMobileType 			:Boolean;			 
		
		private var _controlUnits					:ControlUnits;
		private var _model							:ModelDeviceInfo;
		
		
		public function PresentationScreenModes(control:ControlUnits, model:ModelDeviceInfo)
		{
			uiChange	 		= new Signal();
			
			_controlUnits 		= control;  
			_model		 		= model;
			
			setObservers();
			setupUI();
		}
		
		
		/**************************************************************************************************************
		 * 												SETUP
		 **************************************************************************************************************/ 
		
		private function setupUI():void
		{
			removeMobileItems();
		}
		
		private function removeMobileItems():void
		{
			if(_model.deviceType == EnumsLocalNetwork.TYPE_PC || _model.deviceVersion == UtilsDeviceInfo.IPAD)
			{
				Tracer.log(this, "removeMobileItems()");
				isMobileType = false;
				uiChange.dispatch();
			}
		}
		
		private function setObservers():void
		{
			
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			
		}
		
		/**************************************************************************************************************
		 * 												CONTROLS
		 **************************************************************************************************************/ 
		
		public function changeConnectedMode(wirelessNotPhone:Boolean):void
		{
			if(wirelessNotPhone) setWirelessMode();
			else 				 setPhoneMode();
		}
		
		private function setPhoneMode():void
		{
			if(isMobileType)
			{
				Tracer.log( this, "connectPhoneMode()" );
				_controlUnits.setConnectedMode(false);
			}
		}
		
		private function setWirelessMode():void
		{
			
			if(UtilsNetwork.hasWiFiConnection()) requestScreenConnect();
			else								 _controlUnits.requestNoWirelessScreen();
		}	

		private function requestScreenConnect():void
		{
			/*if(UtilsNetwork.hasWiFiConnection()) _controlUnits.requestScreenConnect();
			else								 _controlUnits.requestNoWirelessScreen();*/
		}
	}
}