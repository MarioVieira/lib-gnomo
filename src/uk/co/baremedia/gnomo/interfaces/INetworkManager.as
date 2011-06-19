package uk.co.baremedia.gnomo.interfaces
{
	import uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage;
	
	import flash.media.Microphone;
	
	import org.osflash.signals.Signal;

	public interface INetworkManager extends IAudioBroadcaster
	{
		function set microphone(value:Microphone):void;
		
		function get connectionStatus():Signal;
		
		function get mediaBroadcast():Signal;
		
		function get audioActivityMessage():Signal;
		
		function get debug():Signal;

		function keepAlive(startNotStopMonitor:Boolean):void;

		function connect():void;

		function disconnect(switchOff:Boolean = false):void;

		function get deviceType():String;

		function sendMessageToLocalNetwork(message:VOLocalNetworkMessage):void;
	}
}