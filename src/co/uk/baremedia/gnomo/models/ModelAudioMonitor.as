package co.uk.baremedia.gnomo.models
{
	import org.as3.interfaces.IModelChange;
	import org.osflash.signals.Signal;

	public class ModelAudioMonitor extends Signal implements IModelChange
	{
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