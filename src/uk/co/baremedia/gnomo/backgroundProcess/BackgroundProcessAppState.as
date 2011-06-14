package uk.co.baremedia.gnomo.backgroundProcess
{
	import org.as3.mvcsInjector.utils.Tracer;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsAppState;
	import uk.co.baremedia.gnomo.enums.EnumsScreens;
	import uk.co.baremedia.gnomo.models.ModelAppState;
	import uk.co.baremedia.gnomo.models.ModelScreens;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	import uk.co.baremedia.gnomo.utils.UtilsScreens;
	
	
	public class BackgroundProcessAppState implements IInitializer
	{
		protected var _appStateModel		:ModelAppState;
		protected var _signalViewNavigation	:SignalViewNavigation;
		protected var _modelScreens			:ModelScreens;
		
		public function init(injector:IInjector):void
		{
			_appStateModel 			= injector.getInstance(ModelAppState);
			_modelScreens 			= injector.getInstance(ModelScreens);
			_signalViewNavigation	= injector.getInstance(SignalViewNavigation);
			
			_appStateModel.add(onAppState);
		}
		
		private function onAppState(appState:String):void
		{
			Tracer.log(this, "onAppState - appState: "+appState);
			if(_appStateModel.currentState == EnumsAppState.DISCONNECTED)
			{
				_signalViewNavigation.dispatch( UtilsScreens.getViewNotification(EnumsScreens.SCREEN_MODES, _modelScreens) );
			}
		}
	}
}