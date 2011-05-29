package co.uk.baremedia.gnomo.core
{
	import org.as3.mvcsc.descriptors.DescriptorExternalAppFrameWork;
	import org.as3.mvcsc.interfaces.IMappingBackgroundProcesses;
	import org.robotlegs.core.IInjector;

	/**
	 * @author Mario Vieira
	 * 	
	 * 	This class is responsible to all is a background process, and in anything that will happen independent of displaying a graphic user interface
	 */
	 
	public class MapBackgroundProcesses implements IMappingBackgroundProcesses
	{
		/** @private **/
		//protected var _downloadControl					:ControlDownload;
		
		/**
		 * 
		 * @param injector
		 * @param signalCommandMap
		 * 
		 */
		public function initialize(injector : IInjector, appExternalFrameWorkDescriptor : DescriptorExternalAppFrameWork):void  
		{
			backgroundProcessesCairngormBridge(injector, appExternalFrameWorkDescriptor);
			backgroundProcessesRules(injector);
			backgroundProcessesInstances(injector);
		}
		
		/** @private **/
		protected function backgroundProcessesRules(injector : IInjector) : void
		{
			//Tracer.log(this, "backgroundProcessesRules");
			//injector.mapSingleton(ControlDownload);
		}
	
		/** @private **/
		protected function backgroundProcessesInstances(injector : IInjector) : void
		{
			//Tracer.log(this, "backgroundProcessesInstances");	
			//_downloadControl = injector.getInstance(ControlDownload);
		}
		
		protected function backgroundProcessesCairngormBridge(injector : IInjector, appFrameWorkDescriptor : DescriptorExternalAppFrameWork):void
		{
			//_routedCairngormFronController.addCairngormCommands(injector, appFrameWorkDescriptor.cairngormEventsRules);
		}
	}
}
