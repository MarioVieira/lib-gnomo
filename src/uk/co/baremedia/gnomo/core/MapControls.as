package uk.co.baremedia.gnomo.core
{
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	
	import org.as3.mvcsInjector.interfaces.IMappingInjector;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.controls.ControlAudioActivityMonitor;
	import uk.co.baremedia.gnomo.controls.ControlBroadcaster;
	import uk.co.baremedia.gnomo.controls.ControlDeviceInfo;
	import uk.co.baremedia.gnomo.controls.ControlLogs;
	import uk.co.baremedia.gnomo.controls.ControlMessenger;
	import uk.co.baremedia.gnomo.controls.ControlPersistedData;
	import uk.co.baremedia.gnomo.controls.ControlPhoneCall;
	import uk.co.baremedia.gnomo.controls.ControlSettings;
	import uk.co.baremedia.gnomo.controls.ControlUnits;
	import uk.co.baremedia.gnomo.controls.ControlViewNavigator;
	import uk.co.baremedia.gnomo.helper.HelperAudioActivity;
	import uk.co.baremedia.gnomo.helper.HelperConnection;
	import uk.co.baremedia.gnomo.interfaces.IAudioActivity;
	import uk.co.baremedia.gnomo.interfaces.IConnected;
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
			injector.mapSingleton(ControlAudioActivityMonitor);
			injector.mapSingleton(ControlUnits);
			injector.mapSingleton(SignalCrossPlatformExchange);
			
			injector.mapSingleton(LocalNetworkDiscovery);
			injector.mapSingletonOf(IP2PMessenger, ControlMessenger);
			injector.mapSingleton(ControlViewNavigator);
			injector.mapSingleton(ControlPersistedData);
			injector.mapSingleton(ControlLogs);
			injector.mapSingletonOf(IConnected, HelperConnection);
			injector.mapSingletonOf(IAudioActivity, HelperAudioActivity);
		}
	}
}