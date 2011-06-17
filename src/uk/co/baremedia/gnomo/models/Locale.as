package uk.co.baremedia.gnomo.models
{
	import flash.filesystem.File;
	import flash.system.System;
	
	import org.as3.serializer.persister.control.SerializerCRUD;
	import org.as3.serializer.persister.events.PersisterEvent;
	
	import uk.co.baremedia.gnomo.descriptors.DescriptorLanguage;
	
	[Bindable] //for Flex
	public class Locale
	{
		protected static var _descriptor:DescriptorLanguage;
		
		//modes screen
		//public static function get ():String{ return ; }
		
		public function setLanguage(descriptor:DescriptorLanguage):void
		{
			_descriptor = descriptor;
		}
		
		//Keys
		
		//modes screen
		public static function get screenModesButtonWireless				():String { return  _descriptor.screenModesButtonWireless };
		public static function get screenModesButtonPhone					():String { return  _descriptor.screenModesButtonPhone };
		public static function get screenModeWirelessFunction				():String { return  _descriptor.screenModeTextWirelessFunction };
		public static function get screenModeOneWirelessNote				():String { return  _descriptor.screenModeTextWirelessNote };
		public static function get screenModePhoneFunction					():String { return  _descriptor.screenModeTextPhoneFunction };
		public static function get screenModeOnePhoneNote					():String { return  _descriptor.screenModeTextPhoneNote };
		
		//no wireless available screen
		public static function get screenNoWirelessButtonConnectedNow		():String { return  _descriptor.screenNoWirelessButtonConnectedNow };
		public static function get screenNoWirelessBack						():String { return  _descriptor.screenNoWirelessBack };
		public static function get screenModeTextMessage					():String { return  _descriptor.screenModeTextMessage };
		
		//screen connect wireless
		public static function get screenConnectTextMessage					():String { return  _descriptor.screenConnectTextMessage };
		public static function get screenConnectButtonConnect				():String { return  _descriptor.screenConnectButtonConnect };
		
		//screen baby and parent unit
		public static function get screenUnitsTextSetABabyUnit				():String { return  _descriptor.screenUnitsTextSetABabyUnit };
		public static function get screenUnitsTextConnecting				():String { return  _descriptor.screenUnitsTextConnecting };
		public static function get screenUnitsTextConnected					():String { return  _descriptor.screenUnitsTextConnected };
		public static function get screenUnitsTextBabyUnit					():String { return  _descriptor.screenUnitsTextBabyUnit};
		public static function get screenUnitsTextParentUnit				():String { return  _descriptor.screenUnitsTextParentUnit };
		public static function get screenUnitsTextSensibiity				():String { return  _descriptor.screenUnitsTextSensibiity };
		
		public static function get screenUnitsButtonSetAsBabyUnit			():String { return  _descriptor.screenUnitsButtonSetAsBabyUnit };
		public static function get screenUnitsButtonListenNow				():String { return  _descriptor.screenUnitsButtonListenNow };
		public static function get screenUnitsButtonSwapModes				():String { return  _descriptor.screenUnitsButtonSwapModes };
		public static function get screenUnitsButtonLogs					():String { return  _descriptor.screenUnitsButtonLogs };
		public static function get screnUnitsButtonDisconnect				():String { return  _descriptor.screenUnitsButtonDisconnect };
		public static function get screenUnitsButtonStopListening			():String { return  _descriptor.screenUnitsButtonStopListening };
		
		
		//screen try to connect, it was not possible
		public static function get screenTryConnetingAgainTextMessage		():String { return  _descriptor.screenTryConnetingAgainTextMessage };
		public static function get screenTryConnetingAgainButtonTryAgain	():String { return  _descriptor.screenTryConnetingAgainButtonTryAgain };
		public static function get screenTryConnetingAgainButtonSwapModes	():String { return  _descriptor.screenTryConnetingAgainButtonSwapModes };
		public static function get buttonBack								():String { return  _descriptor.buttonBack };
		public static function get buttonQuit								():String { return  _descriptor.buttonQuit };
		
		//screen try to connect, it was not possible
		public static function get screenLogsTextActivity					():String { return  _descriptor.screenLogsTextActivity };
		public static function get screenLogsPrevious						():String { return  _descriptor.screenLogsPrevious };
	}
}