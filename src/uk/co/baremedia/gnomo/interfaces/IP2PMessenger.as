package uk.co.baremedia.gnomo.interfaces
{
	import org.osflash.signals.Signal;

	public interface IP2PMessenger extends ILocalNetworkMessenger
	{
		function sendMessageToAll(message:Object):void
		function get messenger():Signal;
	}
}