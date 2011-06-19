package uk.co.baremedia.gnomo.utils
{
	import flash.media.Microphone;
	import flash.media.SoundTransform;

	public class UtilsMedia
	{
		public static function getMicrophone():Microphone
		{
			var mic:Microphone 	= Microphone.getMicrophone();
			
			mic.setLoopBack(true);
			
			mic.gain = 50;
			mic.rate = 4;
			
			var sound:SoundTransform = new SoundTransform(0);
			mic.soundTransform = sound; 
			
			return mic;
		}
	}
}