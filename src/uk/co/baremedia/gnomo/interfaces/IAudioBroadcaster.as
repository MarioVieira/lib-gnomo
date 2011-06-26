package uk.co.baremedia.gnomo.interfaces
{
	import flash.media.Microphone;
	import flash.net.NetConnection;
	
	import org.osflash.signals.Signal;

	public interface IAudioBroadcaster
	{
		function get audioActivityMessage():Signal;
		function broadcastAudioToGroup(microphone:Microphone, orderType:String):void;
		function get groupNetConnection():NetConnection;
		function stopBroadcasting():void
	}
}