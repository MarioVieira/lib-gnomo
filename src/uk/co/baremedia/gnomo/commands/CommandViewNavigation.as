package uk.co.baremedia.gnomo.commands
{
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.SignalCommand;
	
	import uk.co.baremedia.gnomo.utils.transitions.ViewNavigator;
	import uk.co.baremedia.gnomo.vo.VOViewNavigation;
	import uk.co.baremedia.gnomo.controls.ControlViewNavigator;
	
	public class CommandViewNavigation extends SignalCommand implements IInitializer
	{
		private var _vo			:VOViewNavigation;
		private var _navigator	:ControlViewNavigator;
		
		public function init(injector:IInjector):void
		{
			_vo 		= injector.getInstance(VOViewNavigation);
			_navigator 	= injector.getInstance(ViewNavigator);
		}
		
		override public function execute():void
		{
			//_navigator.defineScreen(_vo);		
		}
	}
}