package uk.co.baremedia.gnomo.models
{
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.osflash.signals.Signal;

	public class ModelReceiver extends Signal implements IModelChange
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