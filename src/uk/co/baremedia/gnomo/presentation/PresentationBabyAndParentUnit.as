package uk.co.baremedia.gnomo.presentation
{
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;
	
	import uk.co.baremedia.gnomo.controls.ControlUnits;
	import uk.co.baremedia.gnomo.enums.EnumsModes;
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	public class PresentationBabyAndParentUnit
	{
		public var uiChange							:Signal;
		
		[Bindable] public var connectedStatus		:String = "";
		[Bindable] public var modeStatus			:String = "";
		[Bindable] public var debugInfo	 			:String = "";
		[Bindable] public var systemNotifications	:String = "";
		[Bindable] public var messaging				:String = "";
		
		private var _controlUnits					:ControlUnits;
		private var _appNotifier 					:SignalNotifier;
		
		public function PresentationBabyAndParentUnit(control:ControlUnits, notifier:SignalNotifier)
		{
			uiChange	 		= new Signal();
			
			_controlUnits 		= control;  
			_appNotifier 		= notifier;
			
			setObservers();
			setupUI();
		}
		  
		 
		/**************************************************************************************************************
		 * 												SETUP
		 **************************************************************************************************************/ 
		
		private function setupUI():void
		{
			setConnected(false);
			setMode(EnumsModes.PARENT_UNIT);
		}
		
		private function setObservers():void
		{
			_appNotifier.add(onAppNotification);	
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			_appNotifier.remove(onAppNotification);
		}
		
		/**************************************************************************************************************
		 * 												CONTROLS
		 **************************************************************************************************************/ 
		
		public function changeConnectedMode(wirelessNotPhone:Boolean):void
		{
			//Tracer.log(this, "changeMode - babyCallNotParentUnit: "+babyCallNotParentUnit);
			_controlUnits.setConnectedMode(wirelessNotPhone);
		}
		
		public function changeUnitMode(babyNotParentUnit:Boolean):void
		{
			//Tracer.log(this, "changeMode - babyCallNotParentUnit: "+babyCallNotParentUnit);
			_controlUnits.setUnitMode(babyNotParentUnit);
		}
		
		private function setMode(mode:String):void
		{
			modeStatus = mode;
		}
		
		private function setConnected(connected:Boolean):void
		{
			//for tests only
			connectedStatus = (connected) ? EnumsModes.MODE_LOCAL_NETWORK : EnumsModes.MODE_PHONE;	
		}
		
		public function clearLogs():void
		{
			debugInfo = null; 
			systemNotifications = null;
		}
		
		public function setAudioSensibilityLevel(sensibility:Number):void
		{
			
		}
		
		/**************************************************************************************************************
		 * 												OBSERVERS
		 **************************************************************************************************************/ 
		
		private function onAppNotification(info:VONotifierInfo):void
		{
			var value		:String = info.notificationValue.toString();
			//Tracer.log(this, "onAppNotification - notificationType: "+info.notificationType);
			
		  	if(info.notificationType == EnumsNotification.CONNECTION_CHANGE)
			{
				setConnected(info.notificationValue);
			}
			else if(info.notificationType == EnumsNotification.UNIT_CHANGE)
			{
				setMode(value);
			}
			else if(info.notificationType == EnumsNotification.SYSTEM_NOTIFICATION || info.notificationType == EnumsNotification.AUDIO)
			{
				systemNotifications = (!systemNotifications) ? value : systemNotifications += "\n" + value;
			} 
			else if(info.notificationType == EnumsNotification.DEBUG)
			{
				debugInfo = (!debugInfo) ? value : debugInfo += "\n"+ value;
			}
			else if(info.notificationType == EnumsNotification.P2P_MESSAGE)
			{
				messaging = value;
			}
			
			uiChange.dispatch();
		}
		
		private function onModeChange(mode:String):void
		{
			setMode(mode);	
		}
	}
}