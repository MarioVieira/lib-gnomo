package uk.co.baremedia.gnomo.models
{
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.osflash.signals.Signal;

	public class ModelNetworkManager extends Signal implements IModelChange
	{
		public static const CONNECTION_STATUS	:String = "connectionStatus";
		public static const CONNECTION_ALERT	:String = "connectionAlert";
		
		public var broadcaster					:Boolean;
		
		private var _connected					:Boolean;
		
		//starts as true so there will be a change if not connected
		private var _connectionAlert			:Boolean;
		
		
		public function get connected():Boolean
		{
			return _connected;
		}

		public function set connected(value:Boolean):void
		{
			_connected = value;
			connectionAlert = !value;
			broadcastModelChange(CONNECTION_STATUS);
		}
		
		public function set connectionAlert(value:Boolean):void
		{
			_connectionAlert = value;
			broadcastModelChange(CONNECTION_ALERT);
		}
		
		public function get connectionAlert():Boolean
		{
			return _connectionAlert;
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