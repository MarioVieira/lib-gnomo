package uk.co.baremedia.gnomo.controls
{
	import flash.display.Sprite;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.as3.mvcsInjector.vo.VOScreen;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.enums.EnumsNotification;
	import uk.co.baremedia.gnomo.enums.EnumsViewNavigation;
	import uk.co.baremedia.gnomo.models.ModelScreens;
	import uk.co.baremedia.gnomo.signals.SignalNotifier;
	import uk.co.baremedia.gnomo.utils.transitions.ViewNavigator;
	import uk.co.baremedia.gnomo.utils.transitions.ViewTransition;
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	import uk.co.baremedia.gnomo.vo.VOViewNavigation;
	
	public class ControlViewNavigator implements IInitializer, IDispose
	{
		private var _screenModel	:	ModelScreens;
		private var _viewNavigator	:	ViewNavigator;
		private var _appNotifier	:	SignalNotifier;
		
		public function init(injector:IInjector):void
		{
			_screenModel = injector.getInstance(ModelScreens);
			_appNotifier = injector.getInstance(SignalNotifier);
		}
		
		public function setupViewNavigator(contextView:Sprite, firstScreenName:String, screens:Vector.<VOScreen>):void
		{
			//Tracer.log(this, "setupViewNavigator - contextView: "+contextView+" firstScreenName: "+firstScreenName+" screens: "+screens);
			_screenModel.firstViewName	= firstScreenName;
			_screenModel.screens 		= screens;
			_viewNavigator 				= new ViewNavigator(contextView, _screenModel.getScreenClassByName(firstScreenName), null, null, ViewTransition.NONE);
			_screenModel.currentScreen	= _screenModel.getScreenInfoByName(firstScreenName);
		}
			
		public function navigateToScreen(screenName:String):void
		{
			if(_screenModel.currentScreen.name != screenName)
			{
				var screenVo:VOScreen = _screenModel.getScreenInfoByName(screenName);
				defineScreen(screenVo);
				defineViewChangeAction(screenVo);
			}
		}
		
		private function defineViewChangeAction(vo:VOScreen):void
		{
			notifyViewChange(vo);
		}
		
		private function notifyViewChange(vo:VOScreen):void
		{
			_appNotifier.dispatch( new VONotifierInfo(EnumsNotification.SCREEN_CHANGE, vo.name) );
		}
		
		protected function defineScreen(vo:VOScreen):void
		{
			_screenModel.currentScreen = vo;
			
			Tracer.log(this, "navigateToScreen: "+vo.name);
			
			var transition:String;
			
			if(vo.type != EnumsViewNavigation.TYPE_POPUP) transition = ViewTransition.SLIDE;
			else 												   transition = ViewTransition.NONE;
			
			if(vo.name == _screenModel.firstViewName)
			{
				_viewNavigator.popToFirstView();
			}
			else
			{
				_viewNavigator.pushView(vo.clazz, null, null, transition);
			}
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			Tracer.log(this, "dispose() - NOTHING to dispose");	
		}
	}
}