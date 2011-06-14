package uk.co.baremedia.gnomo.models
{
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.vo.VOViewNavigation;
	
	public class ModelAppState extends Signal implements IModelChange
	{
		private var _currentState		:String;
		private var _currentScreenInfo	:VOViewNavigation;
		
		public function set currentState(value:String):void
		{
			_currentState = value;
			broadcastModelChange(value);
		}
		
		public function set currentScreenInfo(value:VOViewNavigation):void
		{
			_currentScreenInfo = value;
		}
		
		public function get currentScreenInfo():VOViewNavigation
		{
			return _currentScreenInfo;
		}
		
		public function get currentState():String
		{
			return _currentState;
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