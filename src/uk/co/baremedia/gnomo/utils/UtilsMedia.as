package uk.co.baremedia.gnomo.utils
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	
	import org.as3.mvcsInjector.utils.Tracer;
	
	public class UtilsMedia
	{
		public static const N_256KBPS:Number = 268440;
		public static const N_128KBPS:Number = 131070;
		public static const DEFAULT_MIC_GAIN:Number = 50;
		
		public static function getMicrophone():Microphone
		{
			var mic:Microphone 	= Microphone.getMicrophone();
			
			mic.setLoopBack(true);
			
			mic.gain = DEFAULT_MIC_GAIN;
			mic.rate = 8;
			
			mic.soundTransform = noSound;
			
			return mic;
		}
		
		public static function get noSound():SoundTransform
		{
			return new SoundTransform(0);
		}
		
		public static function get fullSound():SoundTransform
		{
			return new SoundTransform(1);
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
		
		public static function muteMic(mic:Microphone, muteNotUnMute:Boolean):void
		{
			if(muteNotUnMute) 	mic.gain = 0;
			else			 	mic.gain = DEFAULT_MIC_GAIN;
		}
	}
}