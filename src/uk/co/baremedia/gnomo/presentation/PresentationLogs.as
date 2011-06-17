package uk.co.baremedia.gnomo.presentation
{
	import org.as3.mvcsInjector.interfaces.IDispose;
	
	import uk.co.baremedia.gnomo.controls.ControlLogs;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	
	public class PresentationLogs implements IDispose
	{
		private var _control:ControlLogs;
		
		public function PresentationLogs(control:ControlLogs)
		{
			_control = control;
		}

		
		public function requestScreenUnits():void
		{
			_control.requestScreenUnits();
		}
		
		public function requestScreenLogsMain():void
		{
			_control.requestScreenLogsMain();	
		}
		
		public function requestScreenLogsDay():void
		{
			_control.requestScreenLogDay();
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			
		}
	}
}