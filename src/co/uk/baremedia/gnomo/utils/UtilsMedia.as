package co.uk.baremedia.gnomo.utils
{
	import flash.media.Microphone;

	public class UtilsMedia
	{
		public function UtilsMedia()
		{
		}

		public static function getDefaultMicrophone():Microphone
		{
			var mic:Microphone 	= Microphone.getMicrophone();
			mic.setLoopBack(false);
			mic.rate = 8;
			
			return mic;
		}
	}
}