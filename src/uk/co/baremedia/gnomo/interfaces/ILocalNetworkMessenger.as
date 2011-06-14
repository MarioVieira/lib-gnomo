package uk.co.baremedia.gnomo.interfaces
{
	import uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage;
	
	import org.osflash.signals.Signal;

	public interface ILocalNetworkMessenger
	{
		function get deviceType() 										  : String;
		function sendMessageToLocalNetwork(message:VOLocalNetworkMessage) : void;
	}
}  