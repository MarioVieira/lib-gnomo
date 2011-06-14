package uk.co.baremedia.gnomo.utils
{
	import uk.co.baremedia.gnomo.enums.EnumsCrossPlatformExchange;
	import uk.co.baremedia.gnomo.vo.VOCrossPlatformExchange;
	
	import flash.media.Microphone;
	
	public class UtilsCrossPlatformExchange
	{
		public static function requestMicrophone():VOCrossPlatformExchange
		{
			var vo:VOCrossPlatformExchange = new VOCrossPlatformExchange();
			vo.exchangeEnumeration = EnumsCrossPlatformExchange.MICROPHONE;
			vo.requestNotResponse = true;
			
			return vo;
		}
		
		public static function provideMicrophone(mic:Object):VOCrossPlatformExchange
		{
			var vo:VOCrossPlatformExchange = new VOCrossPlatformExchange();
			vo.exchangeEnumeration = EnumsCrossPlatformExchange.MICROPHONE;
			vo.requestNotResponse  = false;
			vo.object			   = mic;
			
			return vo;
		}
	}
}