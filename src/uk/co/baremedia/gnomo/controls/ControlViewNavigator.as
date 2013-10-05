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
	
	public class ControlViewNavigator implements IInitializer, IDispose
	{
		private var _screenModel	:	ModelScreens;
		private var _viewNavigator	:	ViewNavigator;
		private var _appNotifier	:	SignalNotifier;
		private var _navigator		:	ViewNavigator;
		
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
			
			CONFIG::DESKTOP
			{
				_viewNavigator 				= new ViewNavigator(contextView, _screenModel.getScreenClassByName(firstScreenName), null, null, ViewTransition.NONE);
				_screenModel.currentScreen	= _screenModel.getScreenInfoByName(firstScreenName);
			}
		}
		
		public function navigateToScreen(screenName:String):void
		{
			if(_screenModel.currentScreen && _screenModel.currentScreen.name != screenName)
			{
				var screenVo:VOScreen = _screenModel.getScreenInfoByName(screenName);
				if(screenVo)
				{
					defineScreen(screenVo);
					defineViewChangeAction(screenVo);
				}
				else
				{
					_screenModel.currentScreen = new VOScreen(null, null, screenName, -1);	
				}
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
			//Tracer.log(this, "navigateToScreen: "+vo.name);
			_screenModel.currentScreen = vo;
			var transition:String = (vo.type != EnumsViewNavigation.TYPE_POPUP) ? ViewTransition.SLIDE : ViewTransition.NONE;
			
			CONFIG::DESKTOP
			{
				if(vo.name == _screenModel.firstViewName)
				{
					_viewNavigator.popToFirstView();
				}
				else
				{
					_viewNavigator.pushView(vo.clazz, null, null, transition);
				}
				
				return;
			}
			
			//_navigator.pushView(vo.clazz, null, null, 
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			Tracer.log(this, "dispose() - NOTHING to dispose");	
		}
	}
}