package uk.co.baremedia.gnomo.models
{
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.osflash.signals.Signal;

	public class ModelSettings extends Signal implements IModelChange
	{
		public const SETTINGS_CHANGE:String = "settingsChange";
		public const MODE_CHANGE	:String = "modeChange";
		
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