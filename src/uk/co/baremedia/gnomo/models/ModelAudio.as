package uk.co.baremedia.gnomo.models
{
	import flash.media.Microphone;
	
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.osflash.signals.Signal;

	public class ModelAudio extends Signal implements IModelChange
	{
		public static const BROADCAST_CHANGE :String = "broadcast";
		public static const ACTIVITY_CHANGE  :String = "audio";
		
		private var _broadcasting:Boolean;
		public var receiving:Boolean;
		public var microphone:Microphone;
		
		public function get broadcasting():Boolean
		{
			return _broadcasting;
		}

		public function get dataChange():Signal
		{
			return this;
		}
		
		public function set broadcasting(value:Boolean):void
		{
			_broadcasting = value;
			broadcastModelChange(BROADCAST_CHANGE);
		}
		
		public function broadcastModelChange(changeType:String):void
		{
			dispatch(changeType);
		}
	}
}