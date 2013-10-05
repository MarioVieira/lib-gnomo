package uk.co.baremedia.gnomo.helper
{
	import flash.net.NetStream;
	
	import org.as3.mvcsInjector.utils.Tracer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.controls.ControlPlayer;
	import uk.co.baremedia.gnomo.interfaces.IAudioActivity;
	import uk.co.baremedia.gnomo.interfaces.IConnected;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelModes;
	import uk.co.baremedia.gnomo.models.ModelNetworkManager;
	
	public class HelperAudioActivity implements IAudioActivity
	{
		private var _helperConnection:IConnected;
		private var _modelAudio:ModelAudio;
		private var _hasAudioActvityViaNetworkTraffic:Boolean;
		private var _audioByteCount:Number;
		
		public function init(injector:IInjector):void
		{
			_helperConnection = injector.getInstance(IConnected);
			_modelAudio = injector.getInstance(ModelAudio);
		}
		
		public function get hasBroadcasterAudioActivity():Boolean
		{
			checkHasAudioActivityViaNetworkTraffic();
			
			return _hasAudioActvityViaNetworkTraffic;
		}
		
		private function checkHasAudioActivityViaNetworkTraffic():void
		{
			var newAudioByteCount:Number = (_modelAudio.audioActivityStream && _modelAudio.audioActivityStream.info) ? _modelAudio.audioActivityStream.info.audioByteCount : 0;
			_hasAudioActvityViaNetworkTraffic = _audioByteCount < newAudioByteCount;
			_audioByteCount = newAudioByteCount;
			//Tracer.log(this, "_audioByteCount "+_audioByteCount+" newAudioByteCount: "+newAudioByteCount+" _hasAudioActvityViaNetworkTraffic: "+_hasAudioActvityViaNetworkTraffic);
		}
	}
}