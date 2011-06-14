package uk.co.baremedia.gnomo.core
{
	import org.as3.mvcsInjector.interfaces.IMappingInjector;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.signals.SignalChangeMode;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;

	/** 
	 * 
	 * @author Mario Vieira
	 * 
	 * Maps the Signals to be executed by SignalCommands when dispatched
	 *
	 */
	public class MapCommands implements IMappingInjector
	{
		/**
		 * 
		 * @param signalCommandMap
		 * 
		 */
		public function mapRules(injector:IInjector) : void
		{
			//Tracer.log(this, "mapSignalCommands");
			injector.mapSingleton(SignalNotifier);
			injector.mapSingleton(SignalChangeMode);
			injector.mapSingleton(SignalViewNavigation);
		}
	}
}