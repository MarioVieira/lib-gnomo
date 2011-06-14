package uk.co.baremedia.gnomo.signals
{
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.utils.UtilsScreens;
	import uk.co.baremedia.gnomo.vo.VOViewNavigation;
	
	public class SignalViewNavigation extends Signal
	{
		public function SignalViewNavigation()
		{
			super(String);
		}
		
		public function requestView(screenName:String):void
		{
			dispatch(screenName);
		}
	}
}