package uk.co.baremedia.gnomo.backgroundProcess
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.controls.ControlDeviceInfo;
	
	
	public class BackgroundProcessSetupLocalNetwork implements IInitializer
	{
		private var _localNetwork:LocalNetworkDiscovery;
		
		public function init(injector:IInjector):void
		{
			var controlDeviceInfo	:ControlDeviceInfo 		= injector.getInstance(ControlDeviceInfo);	
			_localNetwork									= injector.getInstance(LocalNetworkDiscovery);
			_localNetwork.clientName 						= controlDeviceInfo.deviceType;
		}
	}
}