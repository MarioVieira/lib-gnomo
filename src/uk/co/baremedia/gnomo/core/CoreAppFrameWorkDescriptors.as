package uk.co.baremedia.gnomo.core
{
	import org.as3.mvcsInjector.descriptors.DescriptoViews;
	import org.as3.mvcsInjector.descriptors.DescriptorAppFrameWork;

	public class CoreAppFrameWorkDescriptors
	{
		public static function getFrameWorkDescriptors(views:DescriptoViews):DescriptorAppFrameWork
		{
			var descriptor:DescriptorAppFrameWork 	= new DescriptorAppFrameWork();
			
			descriptor.viewsDescriptor				= views;
			descriptor.modelsMapping 				= new MapModels();
			descriptor.controlsMapping 				= new MapControls();
			descriptor.servicesMapping 				= new MapServices();
			descriptor.signalsMapping 				= new MapCommands();
			descriptor.backgroundProcesses		 	= new MapBackgroundProcesses();
			
			return descriptor;
		}
	}
}