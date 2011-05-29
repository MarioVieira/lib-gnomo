package co.uk.baremedia.gnomo.models
{
	import co.uk.baremedia.gnomo.vo.VODevice;
	
	import org.as3.interfaces.IModelChange;
	import org.osflash.signals.Signal;

	public class ModelNetworkManager extends Signal implements IModelChange
	{
		public static const CONNECTION_STATUS	:String = "connectionStatus";

		public var connectDevices				:Vector.<VODevice>;
		public var broadcaster					:Boolean;
		
		private var _connected					:Boolean;
		
		

		public function get groupConnected():Boolean
		{
			return _connected;
		}

		public function set groupConnected(value:Boolean):void
		{
			_connected = value;
			broadcastModelChange( CONNECTION_STATUS );
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