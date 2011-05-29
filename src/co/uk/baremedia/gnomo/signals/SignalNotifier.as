package co.uk.baremedia.gnomo.signals
{
	import co.uk.baremedia.gnomo.vo.VONotifierInfo;
	
	import org.osflash.signals.Signal;
	
	public class SignalNotifier extends Signal
	{
		public function SignalNotifier()
		{
			super( VONotifierInfo );
		}
	}
}