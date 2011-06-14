package uk.co.baremedia.gnomo.models
{
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.osflash.signals.Signal;

	public class ModelModes extends Signal implements IModelChange
	{
		private var _localNetworkConnected	:Boolean;
		private var _babyUnitNoParentUnit	:Boolean;
		
		public static const UNIT_CHANGE		:String = "unitChange";
		public static const MODE_CHANGE		:String = "modeChange";
		
		public function ModelModes()
		{
			super(String);
		}
		
		public function set babyUnitNotParentUnit(value:Boolean):void
		{
			_babyUnitNoParentUnit = value;
			broadcastModelChange(UNIT_CHANGE);
		}
		
		public function get babyUnitNotParentUnit():Boolean
		{
			return _babyUnitNoParentUnit;
		}
		
		public function set localNetworkConnected(value:Boolean):void
		{
			_localNetworkConnected = value;	
			broadcastModelChange(MODE_CHANGE);
		}
		
		public function get localNetworkConnected():Boolean
		{
			return _localNetworkConnected;			
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