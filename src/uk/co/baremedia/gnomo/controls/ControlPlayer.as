package uk.co.baremedia.gnomo.controls
{
	import com.projectcocoon.p2p.vo.MediaVO;
	
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.interfaces.IAudioBroadcaster;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	public class ControlPlayer
	{
		protected var _receiveStream	:NetStream;
		protected var _player			:Video;
		protected var _mediaProvider	:IAudioBroadcaster;
		
		public var debug:Signal;
		
		public function ControlPlayer(mediaProvider:IAudioBroadcaster)
		{
			debug 			= new Signal(VONotifierInfo);
			_player 		= new Video();
			_mediaProvider 	= mediaProvider;
		}
		
		
		public function stopAudio():void
		{
			clearNetStream();
			clearPlayer();
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
				_receiveStream.close();
				_receiveStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			}
		}	
		
		public function playStream(mediaInfo:MediaVO):void
		{
			stopAudio();
			
			_receiveStream = new NetStream(_mediaProvider.groupNetConnection, mediaInfo.publisherGroupspecWithAuthorization);// mediaInfo.publisherGroupspecWithAuthorization);
			_receiveStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			_receiveStream.play(mediaInfo.publisherStream);
			
			_player.attachNetStream(_receiveStream);
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			Tracer.log(this, "NetStream netStatusHandler - event.info.code: "+event.info.code);
		}
	}
}