package uk.co.baremedia.gnomo.presentation
{
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.controls.ControlPersistedData;
	
	public class PresentationShell implements IDispose
	{
		public static const SHOW_AGREEMENT	:String = "showAgreement";
		public var uiChange					:Signal;
		
		private var _control				:ControlPersistedData;
		
		public function PresentationShell(control:ControlPersistedData)
		{
			uiChange = new Signal();
			_control = control;
			
			setObservers();
			performChecks();
		}
		
		private function setObservers():void
		{
			
		}
		
		private function performChecks():void
		{
			if(!_control.agreementAccepted) uiChange.dispatch(SHOW_AGREEMENT);	
		}
		
		public function set agreementAcepted(value:Boolean):void
		{
			_control.agreementAccepted = value;
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			
		}
	}
}