package uk.co.baremedia.gnomo.interfaces
{
	import flash.media.Microphone;
	
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage;

	public interface INetworkManager extends IAudioBroadcaster
	{
		function set broadcastMonitorState(value:Boolean):void
		
		function get netStreamSignal():Signal;
		
		function get groupConnectedSignal():Signal;
		
		function set microphone(value:Microphone):void;
		
		function get connectionStatus():Signal;
		
		function get mediaBroadcast():Signal;
		
		function get debug():Signal;

		function startNetworkMonitor(startNotStopMonitor:Boolean):void;
		
		function connect():void;

		function disconnect(switchOff:Boolean = false):void;

		function get deviceType():String;

		function sendMessageToLocalNetwork(message:VOLocalNetworkMessage):void;
	}
}