package uk.co.baremedia.gnomo.controls
{
	import com.projectcocoon.p2p.util.Tracer;
	import com.projectcocoon.p2p.vo.MediaVO;
	
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.net.NetStreamInfo;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.enums.EnumsModes;
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.enums.EnumsSettings;
	import uk.co.baremedia.gnomo.interfaces.IAudioBroadcaster;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelDeviceInfo;
	import uk.co.baremedia.gnomo.models.ModelModes;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.utils.UtilsAppNotifier;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	public class ControlPlayer
	{
		protected var _netStreamSignal	:Signal;
		protected var _receiveStream	:NetStream;
		protected var _player			:Video;
		protected var _mediaProvider	:IAudioBroadcaster;
		
		public var debug:Signal;
		private var _playing			:Boolean;
		private var _volume				:Number = EnumsSettings.DEFAULT_VOLUME;
		private var _modelAudio			:ModelAudio;
		private var _notifier			:SignalNotifier;
		
		public function ControlPlayer(mediaProvider:IAudioBroadcaster, modelAudio:ModelAudio, notifer:SignalNotifier)
		{
			_notifier		= notifer;
			_modelAudio		= modelAudio;
			_netStreamSignal = new Signal(NetStream);
			debug 			= new Signal(VONotifierInfo);
			_player 		= new Video();
			_mediaProvider 	= mediaProvider;
		}
		
		public function get netStreamSignal():Signal
		{
			return _netStreamSignal;
		}
		
		public function stopAudio(unmountStream:Boolean = false):void
		{
			if(!unmountStream)
			{
				pauseStream();
			}
			else
			{
				clearNetStream();
				clearPlayer();
				_playing = false;
			}
		}
		
		private function clearPlayer():void
		{
			_player.clear();
			_player = new Video();
		}
		
		private function clearNetStream():void
		{
			if(_receiveStream)
			{
				_receiveStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_receiveStream.close();
				_modelAudio.receiving = false;
				_modelAudio.audioActivityStream = null;
			}
		}	
		
		public function setupStream(mediaInfo:MediaVO):void
		{
			//Tracer.log(this, "setupStream");
			stopAudio(true);
			mountStream(mediaInfo);
		}
		
		public function playStream():void
		{
			//Tracer.log(this, "playStream");
			_receiveStream.soundTransform = getVolume(10);
		}
		
		public function pauseStream():void
		{
			//Tracer.log(this, "pauseStream");
			_receiveStream.soundTransform = getVolume(0);
		}
		
		public function set volume(value:Number):void
		{
			Tracer.log(this, "volume: "+value);
			_volume = value;
			if(_receiveStream) _receiveStream.soundTransform = getVolume(_volume);
		}
		
		protected function mountStream(mediaInfo:MediaVO):void
		{
			_receiveStream = new NetStream(_mediaProvider.groupNetConnection, mediaInfo.publisherGroupspecWithAuthorization);// mediaInfo.publisherGroupspecWithAuthorization);
			_receiveStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			_receiveStream.play(mediaInfo.publisherStream);
			
			_playing = true;
			_player.attachNetStream(_receiveStream);
			_netStreamSignal.dispatch(_receiveStream);
			//always no volume when it first mount the stream
			_receiveStream.soundTransform = getVolume(_volume);
			
			/*var timer:Timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, onTime);
			timer.start();*/
			
			_modelAudio.audioActivityStream = _receiveStream;
			_modelAudio.receiving = true;
			//Tracer.log(this, "mountStream - _modelAudio: "+_modelAudio+"  _notifier: "+_notifier);
			UtilsAppNotifier.notifyApp(_notifier, "mic", "IOS KEEP ALIVE - MIC: "+ String(_modelAudio.microphone) );
		}
		
		protected function onTime(event:TimerEvent):void
		{
			printInfo()
		}
		
		protected function printInfo():void
		{
			if(_receiveStream && _receiveStream.info)
			trace("INFO dataBytesPerSecond - "+_receiveStream.info.dataBytesPerSecond+" - dataBytesPerSecond: "+_receiveStream.info.audioByteCount+"" +
				"\nisLive: "+_receiveStream.info.isLive+" - byteCount: "+_receiveStream.info.byteCount+" - playbackBytesPerSecond"+_receiveStream.info.playbackBytesPerSecond+
			"_receiveStream.liveDelay: "+_receiveStream.liveDelay+" - droppedFrames: "+_receiveStream.info.droppedFrames+" - SRTT"+_receiveStream.info.SRTT+" info.audioBytesPerSecond: "+_receiveStream.info.audioBytesPerSecond);
			else 
				trace("_receiveStream: "+_receiveStream.liveDelay);
		}
		
		protected function getVolume(vol:Number):SoundTransform
		{
			return new SoundTransform(vol);
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			//Tracer.log(this, "NetStream netStatusHandler - event.info.code: "+event.info.code);
		}

		public function get netStreamInfo():NetStreamInfo 
		{
			return (_receiveStream) ? _receiveStream.info : null;
		}
	}
}