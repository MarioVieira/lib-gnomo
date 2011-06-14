package uk.co.baremedia.gnomo.interfaces
{
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MediaVO;
	
	import flash.media.Microphone;
	import flash.net.NetConnection;

	public interface IAudioBroadcaster
	{
		function broadcastAudioToGroup(microphone:Microphone):void;
		function get groupNetConnection():NetConnection;
		function stopBroadcasting():void
	}
}