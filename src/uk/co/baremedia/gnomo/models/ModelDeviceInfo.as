package uk.co.baremedia.gnomo.models
{
	import flash.system.Capabilities;
	
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;

	public class ModelDeviceInfo
	{
		public function ModelDeviceInfo() 
		{
			_isIOS = Capabilities.version.indexOf("IOS") == 0;
		}

		//mobile / pc
		public var deviceType			:String;
		
		//iPad, iPhone, Android, Mac, Pc, Linux		
		public var deviceVersion		:String;
		
		public function get isIOS()		:Boolean { return _isIOS }
		
		private var _isIOS				:Boolean;
		
	}
}