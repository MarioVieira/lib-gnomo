package uk.co.baremedia.gnomo.controls
{
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.models.ModelModes;
	
	public class ControlPhoneCall implements IInitializer
	{
		protected var _modelModels:ModelModes;
		
		public function init(injector:IInjector):void
		{
			_modelModels = injector.getInstance(ModelModes);
			
			setObservers();
		}
		
		private function setObservers():void
		{
			_modelModels.add(onModelModeChange);
			
		}
		
		private function onModelModeChange(changeType:String):void
		{
			//Tracer.log(this, "onModelModeChange");
		}
	}
}