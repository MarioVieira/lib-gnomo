package uk.co.baremedia.gnomo.models
{
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.osflash.signals.Signal;

	public class ModelNetworkManager extends Signal implements IModelChange
	{
		public static const CONNECTION_STATUS	:String = "connectionStatus";

		public var broadcaster					:Boolean;
		
		private var _connected					:Boolean;
		
		public function get connected():Boolean
		{
			return _connected;
		}

		public function set connected(value:Boolean):void
		{
			_connected = value;
			broadcastModelChange(CONNECTION_STATUS);
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