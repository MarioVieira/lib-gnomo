package uk.co.baremedia.gnomo.utils
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	
	public class UtilsMedia
	{
		private static const QUARTER_OF_A_MEGABIT:Number = 268440;
		
		public static function getMicrophone():Microphone
		{
			var mic:Microphone 	= Microphone.getMicrophone();
			
			mic.setLoopBack(true);
			
			mic.gain = 50;
			mic.rate = 8;
			
			var sound:SoundTransform = new SoundTransform(0);
			mic.soundTransform = sound;
			
			return mic;
		}
		
		public static function getCamera(backNotFrontCamera:Boolean, forceHighRes:Boolean = false):Camera
		{
			var cam:Camera = Camera.getCamera( getCameraIndex(backNotFrontCamera) );
			
			if(cam)					cam.setMode(320, 240, 15, false);
			if(cam && forceHighRes) cam.setQuality(QUARTER_OF_A_MEGABIT, 100);
			return cam;
		}
		
		protected static function getCameraIndex(backNotFront:Boolean):String
		{
			//this is just for debugging, case is PC will detecte
			
			if( UtilsDeviceInfo.IOS )
			{
				return (backNotFront) ? "1" : "0";
			}
			else if( UtilsDeviceInfo.isPlaybook)
			{
				return (backNotFront) ? "0" : "1";
			}
			
			return "0";
		}
	}
}