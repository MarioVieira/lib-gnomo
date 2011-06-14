package uk.co.baremedia.gnomo.core
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	
	import org.as3.mvcsInjector.interfaces.IMappingInjector;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.controls.ControlAudioMonitor;
	import uk.co.baremedia.gnomo.controls.ControlBroadcaster;
	import uk.co.baremedia.gnomo.controls.ControlDeviceInfo;
	import uk.co.baremedia.gnomo.controls.ControlMessenger;
	import uk.co.baremedia.gnomo.controls.ControlPhoneCall;
	import uk.co.baremedia.gnomo.controls.ControlSettings;
	import uk.co.baremedia.gnomo.controls.ControlUnits;
	import uk.co.baremedia.gnomo.controls.ControlViewNavigator;
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.signals.SignalCrossPlatformExchange;

	/**   
	 * 
	 * Maps the application Controls
	 *
	 * 
	 * @author Mario Vieira
	 * 
	 */
	public class MapControls implements IMappingInjector
	{
		/**
		 * 
		 * @param injector
		 * 
		 */
		public function mapRules(injector : IInjector) : void
		{
			//Tracer.log(this, "mapRules");			
			//concerns several UI elements (logout, notifications, etc)
			injector.mapSingleton(ControlSettings);
			injector.mapSingleton(ControlBroadcaster);
			injector.mapSingleton(ControlPhoneCall);
			injector.mapSingleton(ControlDeviceInfo);
			injector.mapSingleton(ControlAudioMonitor);
			injector.mapSingleton(ControlUnits);
			injector.mapSingleton(SignalCrossPlatformExchange);
			
			injector.mapSingleton(LocalNetworkDiscovery);
			injector.mapSingletonOf(IP2PMessenger, ControlMessenger);
			injector.mapSingleton(ControlViewNavigator);
		}
	}
}