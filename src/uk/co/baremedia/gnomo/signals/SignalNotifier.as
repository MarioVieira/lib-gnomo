package uk.co.baremedia.gnomo.signals
{
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	import org.osflash.signals.Signal;
	
	public class SignalNotifier extends Signal
	{
		public function SignalNotifier()
		{
			super( VONotifierInfo );
		}
	}
}