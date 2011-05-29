package co.uk.baremedia.gnomo.core
{
	import org.as3.mvcsc.interfaces.IMappingSignalCommand;
	import org.robotlegs.core.ISignalCommandMap;

	/** 
	 * 
	 * @author Mario Vieira
	 * 
	 * Maps the Signals to be executed by SignalCommands when dispatched
	 *
	 */
	public class MapCommands implements IMappingSignalCommand
	{
		/**
		 * 
		 * @param signalCommandMap
		 * 
		 */
		public function mapSignalCommands(signalCommandMap : ISignalCommandMap) : void
		{
			//Tracer.log(this, "mapSignalCommands");
			//signalCommandMap.mapSignalClass(SignalRemoteServiceStatus, CommandRemoteServiceStatus);
		}
	}
}