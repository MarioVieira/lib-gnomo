package uk.co.baremedia.gnomo.interfaces
{
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osflash.signals.Signal;

	public interface IAudioBroadcaster
	{
		function broadcastAudioToGroup(microphone:Microphone, orderType:String, deviceType:String, deviceVersion:String):NetStream;
		function get groupNetConnection():NetConnection;
		function stopBroadcasting():void;
	}
}