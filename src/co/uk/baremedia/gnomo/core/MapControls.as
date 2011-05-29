package co.uk.baremedia.gnomo.core
{
	import co.uk.baremedia.gnomo.controls.ControlSettings;
	
	import org.as3.mvcsc.interfaces.IMappingInjector;
	import org.robotlegs.core.IInjector;
	import co.uk.baremedia.gnomo.controls.ControlBroadcaster;
	import co.uk.baremedia.gnomo.controls.ControlReceiver;
	import co.uk.baremedia.gnomo.controls.ControlModes;

	import co.uk.baremedia.gnomo.controls.ControlAudioMonitor;

	import co.uk.baremedia.gnomo.controls.ControlNetworkManager;

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
			injector.mapSingleton(ControlReceiver);
			injector.mapSingleton(ControlNetworkManager);
			injector.mapSingleton(ControlAudioMonitor);
			injector.mapSingleton(ControlModes);
		}
	}
}