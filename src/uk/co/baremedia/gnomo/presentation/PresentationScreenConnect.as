package uk.co.baremedia.gnomo.presentation
{
	import org.as3.mvcsInjector.interfaces.IDispose;
	
	import uk.co.baremedia.gnomo.controls.ControlUnits;
	
	public class PresentationScreenConnect implements IDispose
	{
		protected var _controlUnits:ControlUnits;
		
		public function PresentationScreenConnect(controlUnits:ControlUnits)
		{
			_controlUnits = controlUnits;	
		}
		
		public function connect():void
		{
			_controlUnits.setConnectedMode(true);
			_controlUnits.requestScreenUnits();
		}
		
		public function requestScreenModes():void
		{
			_controlUnits.requesScreenModes();
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			
		}
	}
}