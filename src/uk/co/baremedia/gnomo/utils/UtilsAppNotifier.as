package uk.co.baremedia.gnomo.utils
{
	import uk.co.baremedia.gnomo.enums.EnumsModes;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	
	public class UtilsAppNotifier
	{
		public static function notifyApp(notifier:SignalNotifier, info:String, value:Object = null):void
		{
			notifier.dispatch(	new VONotifierInfo(info, value) );
		}
		
		public static function getUnitChange(connected:Boolean):String
		{
			return (connected) ? EnumsModes.BABY_UNIT : EnumsModes.PARENT_UNIT;
		}
	}
}