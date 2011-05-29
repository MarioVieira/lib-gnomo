package co.uk.baremedia.gnomo.utils
{
	import co.uk.baremedia.gnomo.enums.EnumsLocalNetwork;
	import co.uk.baremedia.gnomo.vo.VOLocalNetworkMessage;

	public class UtilsMessenger
	{
		public static function isMobileDevice(vo:VOLocalNetworkMessage):Boolean
		{
			if(vo)	return vo.deviceType == EnumsLocalNetwork.TYPE_MOBILE
			return 	false;
		}
		
		public static function isPCDevice(vo:VOLocalNetworkMessage):Boolean
		{
			if(vo)	return vo.deviceType == EnumsLocalNetwork.TYPE_PC
			return 	false;
		}
		
		public static function isBroadcasterRequest(vo:VOLocalNetworkMessage):Boolean
		{
			if(vo)	return vo.roleAsked == EnumsLocalNetwork.BROADCASTER_ROLE_CLAIMED;
			return 	false;
		}
		
		public static function isReceiverRequest(vo:VOLocalNetworkMessage):Boolean
		{
			if(vo)	return vo.roleAsked == EnumsLocalNetwork.RECEIVER_CONNECTED;
			return 	false;
		}

		public static function getMessage(message:String, deviceType:String):VOLocalNetworkMessage
		{
			return new VOLocalNetworkMessage(message, deviceType);	
		}
	}
}