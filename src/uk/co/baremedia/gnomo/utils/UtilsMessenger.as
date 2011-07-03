package uk.co.baremedia.gnomo.utils
{
	import uk.co.baremedia.gnomo.enums.EnumsLocalNetwork;
	import uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage;

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
		
		/*
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
		*/

		public static function getMessage(messageType:String, deviceType:String, elapsedTimeInSec:Number = 0, startedNotStoppedLog:Boolean = false):VOLocalNetworkMessage
		{
			var vo:VOLocalNetworkMessage = new VOLocalNetworkMessage();
			
			vo.deviceType 		 = deviceType;
			vo.messageType 		 = messageType;
			vo.elapsedTimeInSec  = elapsedTimeInSec;
			vo.startNotStop		 = startedNotStoppedLog;
			
			return vo;
		}
	}
}