package uk.co.baremedia.gnomo.backgroundProcess
{
	import flash.display.DisplayObjectContainer;
	
	import org.as3.mvcsInjector.descriptors.DescriptoViews;
	import org.as3.mvcsInjector.interfaces.IScreenInitializer;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.controls.ControlViewNavigator;
	import uk.co.baremedia.gnomo.models.ModelAppState;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	
	public class BackgroundProcessViewNavigator implements IScreenInitializer, IInitializer
	{
		private var _viewNavigator		:ControlViewNavigator;
		private var _injector			:IInjector;
		private var _signalViewNavigator:SignalViewNavigation;
		private var _appViewState		:ModelAppState;
		
		public function init(injector:IInjector):void
		{
			_injector	   		 = injector;
			_viewNavigator 		 = injector.getInstance(ControlViewNavigator);
			_signalViewNavigator = injector.getInstance(SignalViewNavigation);
			_appViewState  		 = injector.getInstance(ModelAppState);
			
			setObservers();
		}
		
		private function setObservers():void
		{
			_signalViewNavigator.add(onViewNavigation);
		}
		
		private function onViewNavigation(screenName:String):void
		{
			_viewNavigator.navigateToScreen(screenName);	
		}
		
		public function setupAppScreens(descriptor:DescriptoViews):void
		{
			Tracer.log(this, "setupScreens - descriptor.firstScreenName: "+descriptor.firstScreenName); 
			_viewNavigator.setupViewNavigator(_injector.getInstance(DisplayObjectContainer), descriptor.firstScreenName, descriptor.screens);
		}
	}
}