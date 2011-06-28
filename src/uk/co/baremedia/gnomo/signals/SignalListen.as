package uk.co.baremedia.gnomo.signals
{
	import org.osflash.signals.Signal;
	
	
	public class SignalListen extends Signal
	{
		private var _listening:Boolean;
		
		public function SignalListen()
		{
			super(Boolean);
		}
		
		public function set listening(value:Boolean):void
		{
			_listening = value;
			dispatch(value);
		}
		
		public function get listening():Boolean
		{
			return _listening;
		}
	}
}