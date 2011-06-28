package uk.co.baremedia.gnomo.models
{
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;

	public class ModelDeviceInfo
	{

		//mobile / pc
		public var deviceType	:String;
		
		//iPad, iPhone, Android, Mac, Pc, Linux		
		public var deviceVersion		:String;
		public function get isIOS():Boolean { return (deviceVersion == UtilsDeviceInfo.IOS); }
	}
}