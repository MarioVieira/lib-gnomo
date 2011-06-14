package uk.co.baremedia.gnomo.enums
{
	import uk.co.baremedia.gnomo.vo.VOCrossPlatformExchange;
	
	public class EnumsCrossPlatformExchange
	{
		public static const MICROPHONE:String = "requestMicrophone";
		
		public static function isMicrophoneExchange(info:VOCrossPlatformExchange, expectingRequestNotResponse:Boolean):Boolean
		{
			return (info.requestNotResponse == expectingRequestNotResponse && info.exchangeEnumeration == MICROPHONE);
		}
	}
}