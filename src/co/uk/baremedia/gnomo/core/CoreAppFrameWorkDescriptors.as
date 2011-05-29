package co.uk.baremedia.gnomo.core
{
	import org.as3.mvcsc.descriptors.DescriptorAppFrameWork;

	public class CoreAppFrameWorkDescriptors
	{
		public static function getFrameWorkDescriptors():DescriptorAppFrameWork
		{
			var descriptor:DescriptorAppFrameWork 	= new DescriptorAppFrameWork();
			//descriptor.uniqueAppId 					= EnumsApp.applicationId;
			
			descriptor.modelsMapping 				= new MapModels();
			descriptor.viewsMapping  				= new MapViews();
			descriptor.controlsMapping 				= new MapControls();
			descriptor.servicesMapping 				= new MapServices();
			descriptor.commandsMapping 				= new MapCommands();
			descriptor.backgroundProcessesMapping 	= new MapBackgroundProcesses();
			
			return descriptor;
		}
	}
}