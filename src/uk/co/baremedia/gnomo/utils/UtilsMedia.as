package uk.co.baremedia.gnomo.utils
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	
	import org.as3.mvcsInjector.utils.Tracer;
	
	public class UtilsMedia
	{
		public static const N_256KBPS			:Number = 268440;
		public static const N_128KBPS			:Number = 131070;
		public static const N_56KBPS			:Number = 56000;
		public static const DEFAULT_MIC_GAIN	:Number = 50;
		
		public static function getMicrophone(muted:Boolean = false):Microphone
		{
			var mic:Microphone 	= tryGettingEnhancedMic();
			
			if(!mic)
				mic = Microphone.getMicrophone();
			
			if(!mic)
				return null;
			
			mic.setLoopBack(true);
			mic.gain = DEFAULT_MIC_GAIN;
			mic.rate = 8;
			
			mic.soundTransform = noSound;
			
			if(muted) 
				muteMic(mic, muted);
				
			return mic;
		}
		
		private static function tryGettingEnhancedMic():Microphone
		{
			var enhancedMic:Microphone 	= Microphone.getEnhancedMicrophone();
			
			//Tracer.log(UtilsMedia, "tryGettingEnhancedMic - "+enhancedMic);
			if(enhancedMic)
			{
				var micOptions:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
				micOptions.autoGain = true;
				micOptions.isVoiceDetected = 1;
				micOptions.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
				enhancedMic.enhancedOptions = micOptions;
			}
				
			return null;
		}
		
		public static function get noSound():SoundTransform
		{
			return new SoundTransform(0);
		}
		
		public static function get fullSound():SoundTransform
		{
			return new SoundTransform(1);
		}
		
		public static function getCamera(backNotFrontCamera:Boolean, forceHighRes:Boolean = false):Camera
		{
			var cam:Camera = Camera.getCamera( getCameraIndex(backNotFrontCamera) );
			
			if(cam)
			{
				//Tracer.log(UtilsMedia, "getCamera - low"); 
				cam.setQuality(N_128KBPS, 80);
				cam.setMode(320,240,12, true);
				//cam.setKeyFrameInterval(24);
			}
			if(cam && forceHighRes)
			{
				//Tracer.log(UtilsMedia, "getCamera - high");
				cam.setQuality(N_256KBPS, 90);
				cam.setMode(320,240,12, true);
			}
			
			return cam;
		}
		
		protected static function getCameraIndex(backNotFront:Boolean):String
		{
			//Tracer.log(UtilsMedia, "getCameraIndex - UtilsDeviceInfo.IOS: "+UtilsDeviceInfo.IOS+"  UtilsDeviceInfo.isPlaybook: "+UtilsDeviceInfo.isPlaybook);
			
			if( UtilsDeviceInfo.isIOS )
			{
				return (backNotFront) ? "0" : "1";
			}
			else if( UtilsDeviceInfo.isPlaybook  )
			{
				return (backNotFront) ? "1" : "0";
			}
			else if( UtilsDeviceInfo.isAndroid && UtilsDeviceInfo.isMobileAndHasTwoCameras )
			{
				return (backNotFront) ? "0" : "1";
			}
			//null will get the default camera
			return null;
		}
		
		public static function muteMic(mic:Microphone, muteNotUnMute:Boolean):void
		{
			if(muteNotUnMute) 	mic.gain = 0;
			else			 	mic.gain = DEFAULT_MIC_GAIN;
		}
	}
}