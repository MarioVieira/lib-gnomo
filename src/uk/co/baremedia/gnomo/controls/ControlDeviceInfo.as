package uk.co.baremedia.gnomo.controls
{
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.models.ModelDeviceInfo;
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;
	import uk.co.baremedia.gnomo.vo.VODeviceInfo;

	
	public class ControlDeviceInfo extends Signal implements IInitializer, IModelChange
	{
		private var _model:ModelDeviceInfo;
		
		public function init(injector:IInjector):void
		{
			_model = injector.getInstance(ModelDeviceInfo);
			setDeviceInformation();
		}
		
		public function get deviceType():String
		{
			return (_model) ? _model.deviceType : null;
		}
		
		public function get deviceVersion():String
		{
			return (_model) ? _model.deviceVersion : null;
		}
		
		private function setDeviceInformation():void
		{
			var deviceInfo:VODeviceInfo = UtilsDeviceInfo.getDeviceType();
			_model.deviceVersion = deviceInfo.deviceVersion;
			_model.deviceType 	 = deviceInfo.deviceType;
			
			Tracer.log(this, "setDeviceInformation - deviceVersion: "+_model.deviceVersion+"  deviceType: "+_model.deviceType);
		}
		
		public function get dataChange():Signal
		{
			return this;
		}
		
		public function broadcastModelChange(changeType:String):void
		{
			dispatch(changeType);
		}
	}
}