package uk.co.baremedia.gnomo.utils
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	
	import org.as3.mvcsInjector.utils.Tracer;
	
	public class UtilsMedia
	{
		private static const N_256KBPS:Number = 268440;
		private static const N_128KBPS:Number = 131070;
		
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
		
		public static function getCamera(backNotFrontCamera:Boolean, forceHighRes:Boolean = true):Camera
		{
			var cam:Camera = Camera.getCamera( getCameraIndex(backNotFrontCamera) );
			
			if(cam)					cam.setMode(320, 240, 10, false);
			if(cam && forceHighRes) cam.setQuality(N_128KBPS, 90);
			return cam;
		}
		
		protected static function getCameraIndex(backNotFront:Boolean):String
		{
			//Tracer.log(UtilsMedia, "getCameraIndex - UtilsDeviceInfo.IOS: "+UtilsDeviceInfo.IOS+"  UtilsDeviceInfo.isPlaybook: "+UtilsDeviceInfo.isPlaybook);
			
			if( UtilsDeviceInfo.isIOS )
			{
				return (backNotFront) ? "0" : "1";
			}
			else if( UtilsDeviceInfo.isPlaybook )
			{
				return (backNotFront) ? "1" : "0";
			}
			
			return null;
		}
	}
}