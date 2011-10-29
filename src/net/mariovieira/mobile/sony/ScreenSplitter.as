package net.mariovieira.mobile.sony
{
	import com.sony.nfx.largescreen.util.MultiDisplay;
	import com.sony.nfx.largescreen.util.MultiDisplayEvent;
	
	import flash.display.Screen;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	
	import mx.core.UIComponent;
	
	import net.mariovieira.mobile.sony.vo.DeviceScreenVO;
	
	import org.as3.mvcsInjector.utils.Tracer;
	
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	/** 
	* 
	* @author Mario Vieira
	* 
	**/	
	
	public class ScreenSplitter extends EventDispatcher
	{
		public static const DUAL_SCREEN :String = "dualScreen";
		
		private var _displayInfo		:MultiDisplay;
		private var _deviceScreenInfo	:DeviceScreenVO;
		
		protected var _topScreen		:UIComponent;
		protected var _baseScreen		:UIComponent;
		protected var _container		:SkinnableContainer;
		
		public var debugInfo:String = "";
		
		public function ScreenSplitter()
		{
			setupMultiDisplay();
		}
		
		public function setupScreens(topScreen:UIComponent, baseScreen:UIComponent, container:SkinnableContainer, topScreenYOffSet:int = 0):void
		{
			_topScreen 			= topScreen;
			_baseScreen 		= baseScreen;
			_container 			= container;
			
			updateScreenInfo(topScreenYOffSet);
			initiateLayout();
		}
		
		private function updateScreenInfo(topScreenYOffSet:int):void
		{
			_deviceScreenInfo.screen1Height  = _deviceScreenInfo.screen1Height - topScreenYOffSet;
			_deviceScreenInfo.screen2offSetY = _deviceScreenInfo.screen1Height;
		}
		
		[Bindable(event="twoScreens")]
		public function get isDualScreen():Boolean
		{
			return _deviceScreenInfo.isDualScreen;
		}
		
		public function get deviceScreenInfo():DeviceScreenVO
		{
			return _deviceScreenInfo;
		}
		
		public function onAddedToStage(stage:Stage):void
		{
			setupStage(stage);
		}
		
		protected function setupTopScreen(screen:UIComponent):void
		{
			placeScreen(screen, _container.width, (_deviceScreenInfo.isDualScreen) ? _deviceScreenInfo.screen1Height : _container.height, 0, 0);
		}
		
		protected function setupBaseScreen(screen:UIComponent):void
		{
			if(_deviceScreenInfo.isDualScreen)
				placeScreen(screen, _container.width, _deviceScreenInfo.screen2Height, 0, _deviceScreenInfo.screen2offSetY);
			else
				_container.removeElement(screen);
		}
		
		private function setupMultiDisplay():void
		{
			_displayInfo = new MultiDisplay(); 
			_displayInfo.addEventListener(MultiDisplayEvent.DETECTION_EVENT, onMultiScreenDevice, false, 0, true);
		}
		
		private function onMultiScreenDevice(event:MultiDisplayEvent):void 
		{
			if( event.screenCount == 2 ) 
			{
				_deviceScreenInfo = new DeviceScreenVO(true, _displayInfo.getScreenCount(), 
															 (_displayInfo.getScreenHeightPixels(0)),
															 _displayInfo.getScreenHeightPixels(1),
															 _displayInfo.getScreenOffSetYPixels(1));
			}
			else
			{
				_deviceScreenInfo = new DeviceScreenVO(false);
			}
			
			broadcastIsDualScreen();
		}
		
		private function broadcastIsDualScreen():void
		{
			dispatchEvent( new Event(DUAL_SCREEN) );
		}
		
		private function initiateLayout():void
		{
			layoutScreens(_topScreen, _baseScreen);
		}
		
		private function setupStage(stage:Stage):void
		{
			if(Capabilities.cpuArchitecture == "ARM")
				stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		private function layoutScreens(topScreen:UIComponent, baseScreen:UIComponent):void
		{
			setupTopScreen(topScreen);
			setupBaseScreen(baseScreen);
		}
		
		private function placeScreen(screen:UIComponent, width:Number, height:Number, x:Number, y:Number):void
		{
			screen.width  = width;
			screen.height = height;
			screen.x 	  = x;
			screen.y 	  = y;
		}
	}
}