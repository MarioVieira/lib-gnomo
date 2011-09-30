package uk.co.baremedia.gnomo.utils
{
	import flash.media.Camera;
	import flash.system.Capabilities;
	
	import uk.co.baremedia.gnomo.enums.EnumsLocalNetwork;
	import uk.co.baremedia.gnomo.vo.VODeviceInfo;

	public class UtilsDeviceInfo
	{		
		public static const LINUX	:String  = "linux";
		public static const WINDOWS	:String  = "win";
		public static const MAC		:String  = "mac";
		public static const OS		:String  = "os";
		
		public static const ANDROID	:String  = "and";
		public static const IPHONE	:String  = "ios";
		public static const IPAD	:String  = "ios";
		public static const IOS		:String  = "ios";
		
		
		public static function getDeviceType():VODeviceInfo
		{
			var deviceInfo:VODeviceInfo = new VODeviceInfo();
			var os:String 				= Capabilities.os.toLowerCase();
			var version:String 			= Capabilities.version.toLocaleLowerCase();
			
			if(	os.search(MAC) != -1)
			{
				deviceInfo.deviceType 	= (os.search(OS) != -1) 								? EnumsLocalNetwork.TYPE_PC : EnumsLocalNetwork.TYPE_MOBILE;
				deviceInfo.deviceVersion= (deviceInfo.deviceType != EnumsLocalNetwork.TYPE_PC) 	? getMacType(os) 			: MAC;
				
				//trace("deviceInfo.deviceType: "+deviceInfo.deviceType);
				//trace("deviceInfo.deviceVersion: "+deviceInfo.deviceVersion);
			}
			else if(version.search(ANDROID) != -1)
			{
				deviceInfo.deviceType 	= EnumsLocalNetwork.TYPE_MOBILE;
				deviceInfo.deviceVersion= ANDROID;
			}
			else
			{
				deviceInfo.deviceType 	= EnumsLocalNetwork.TYPE_PC;
				if(os.search(WINDOWS) != -1)
				{
					deviceInfo.deviceType = WINDOWS;	
				}
				else if(os.search(LINUX) != -1)
				{
					deviceInfo.deviceType = LINUX;
				}
			}
			
			return deviceInfo;
		}
		
		public static function getMacType(os:String):String
		{
			if(os.search(IPHONE) != -1) return IPHONE;
			else if(os.search(IPAD))	return IPAD;
			return null;
		}
		
		public static function get isPC():Boolean
		{
			return (Capabilities.version.indexOf("MAC") != -1 && Capabilities.version.indexOf("WIN") != -1);
		}
		
		public static function get isIOS():Boolean
		{
			return (Capabilities.version.indexOf("IOS") != -1);
		}
		
		public static function get isPlaybook():Boolean
		{
			return ( Capabilities.version.search("QNX") != -1 );
		}
		
		public static function get isAndroid():Boolean
		{
			return ( Capabilities.version.search("AND") != -1 );
		}
		
		/**
		 *	Android only gives access to back camera, and for PC we would need to display options for the user, 
		 * 		so giving only default camera access
		 *  
		 * @return 
		 * 
		 */		
		public static function get isMobileAndHasTwoCameras():Boolean
		{
			var cameras:int = (Camera.names) ? Camera.names.length : 0;
			
			if(isIOS && cameras > 1) 			return true;
			else if(isPlaybook && cameras > 1) 	return true;
			else 								return false;
		}
	}
}