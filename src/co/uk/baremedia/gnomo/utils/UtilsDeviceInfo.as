package co.uk.baremedia.gnomo.utils
{
	import co.uk.baremedia.gnomo.models.ModelDeviceInfo;
	
	import org.robotlegs.core.IInjector;

	public class UtilsDeviceInfo
	{		
		
		private function getDeviceModel(injector:IInjector):ModelDeviceInfo
		{
			return ModelDeviceInfo( injector.getInstance(ModelDeviceInfo) );
		}
		
		public function setDeviceType(injector:IInjector, type:String):void
		{
			getDeviceModel(injector).deviceType = type;
		}
	}
}