package uk.co.baremedia.gnomo.interfaces
{
	import com.projectcocoon.p2p.vo.BroadcasterMediaVO;
	import com.projectcocoon.p2p.vo.BroadcasterVo;
	
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osflash.signals.Signal;

	public interface IAudioBroadcaster
	{
		function broadcastAudioToGroup(microphone:Microphone, orderType:String, deviceType:String, deviceVersion:String):BroadcasterMediaVO
		function get groupNetConnection():NetConnection;
		function stopBroadcasting():void;
	}
}