package uk.co.baremedia.gnomo.signals
{
	import uk.co.baremedia.gnomo.vo.VOModeChange;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	import org.osflash.signals.Signal;
	
	
	public class SignalChangeMode extends Signal
	{
		public function SignalChangeMode()
		{
			super(VOModeChange);
		}
	}
}