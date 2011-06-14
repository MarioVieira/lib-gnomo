package uk.co.baremedia.gnomo.backgroundProcess
{
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.controls.ControlUnits;
	
	public class BackgroundProcessUnitsControl implements IInitializer
	{
		private var _controlModes	   :ControlUnits;
		
		public function init(injector:IInjector):void
		{
			_controlModes = injector.getInstance(ControlUnits);
		}
	}
}