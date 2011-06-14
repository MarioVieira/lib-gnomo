package uk.co.baremedia.gnomo.utils
{
	import flash.media.Microphone;

	public class UtilsMedia
	{
		public static function getMicrophone():Microphone
		{
			var mic:Microphone 	= Microphone.getMicrophone();
			mic.setLoopBack(false);
			mic.rate = 8;
			
			return mic;
		}
	}
}