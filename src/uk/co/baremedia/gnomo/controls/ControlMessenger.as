package uk.co.baremedia.gnomo.controls
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.MessageEvent;
	
	import org.osflash.signals.Signal;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;
	import uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage;
	
	public class ControlMessenger extends Signal implements IInitializer, IP2PMessenger
	{
		private var _localNetwork:LocalNetworkDiscovery;
		
		public function init(injector:IInjector):void
		{
			_localNetwork = injector.getInstance(LocalNetworkDiscovery);
			_localNetwork.addEventListener(MessageEvent.DATA_RECEIVED, dispatch)
		}
		
		public function sendMessageToAll(message:Object):void
		{
			_localNetwork.sendMessageToAll(message);
		}
		
		public function sendMessageToLocalNetwork(message:VOLocalNetworkMessage):void
		{
			sendMessageToAll(message);
		}

		public function get deviceType():String
		{
			return _localNetwork.clientName;
		}

		public function get messenger():Signal
		{
			return this;
		}

		public function get deviceVersion():String
		{
			return UtilsDeviceInfo.getDeviceType().deviceVersion;
		}
	}
}