package uk.co.baremedia.gnomo.utils
{
	import com.soenkerohde.mobile.StageWebViewUIComponent;
	
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	import flash.media.StageWebView;
	
	[Event(name="open", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	
	public class UtilsStageWebView extends StageWebViewUIComponent
	{
		public static const DEFAULT_SHOW_TIMER_VALUE :Number = 7000;
		public static const DEFAULT_HIDE_TIMER_VALUE :Number = 5000;
		
		protected var _showTimer				:Timer;
		protected var _hideTimer				:Timer;
		protected var _showTimerValue			:Number; 
		protected var _hideTimerValue			:Number;
		protected var _autoShow					:Boolean;
		protected var _autoHide					:Boolean;
		
		private var _visibilityAllowed			:Boolean = true;
		private var _added						:Boolean;
		private var _wasOpen					:Boolean;
		private var _pausedHideNotShow			:Boolean;
		
		public function UtilsStageWebView()
		{
			_showTimerValue = DEFAULT_SHOW_TIMER_VALUE;
			_hideTimerValue = DEFAULT_HIDE_TIMER_VALUE;
		}
		
		
		public function pause():void
		{
			if(_hideTimer.running)
			{
				_hideTimer.stop();
				_pausedHideNotShow = true;
			}
			else if(_showTimer.running)
			{
				_showTimer.stop();
				_pausedHideNotShow = false;
			}
		}
		
		public function resume():void
		{
			if(_pausedHideNotShow)
				_hideTimer.start();
			else
				_showTimer.start();
		}
		
		/**
		 * 
		 * Allows to redraw the StageWebView viewPort in order to reposition it (eg: autoOrients true)
		 * 
		 */		
		public function updateViewPortMeasures():void
		{
			if(stageWebView)
				stageWebView.viewPort = new Rectangle(0, yOffset, myStage.width, myStage.fullScreenHeight - yOffset);
		}
		
		public function set visibilityAllowed(value:Boolean):void
		{
			_visibilityAllowed = value;
			if(!value)
			{
				_wasOpen = stageWebView != null; 
				hide();
				broadcastClose();
			}
			else if(_wasOpen)
			{
				show();
				broadcastOpen();
			}
		}
		
		/**
		 *
		 * It will show the StageWebView after the elapsed DEFAULT_SHOW_TIMER_VALUE, and remove it if was visible.
		 * @see DEFAULT_SHOW_TIMER_VALUE
		 *  
		 * @param value
		 * 
		 */		
		public function set autoShowTimer(value:Boolean):void
		{	
			_autoShow = value;
			setupTimer(true, value);
			startTime(_showTimer, true);
		}
		
		/**
		 *
		 * It will hide the StageWebView after the elapsed DEFAULT_HIDE_TIMER_VALUE
		 * @see DEFAULT_HIDE_TIMER_VALUE
		 *  
		 * @param value
		 * 
		 */
		public function set autoHideTimer(value:Boolean):void
		{
			_autoHide = value; 
			setupTimer(false, value);
		}
		
		/**
		 * 
		 * Set a new value for the showing the StageWebView
		 * 
		 * @param value
		 * 
		 */		
		public function set showTimerDelay(value:Number):void
		{
			_showTimerValue = value;
			if(_showTimer)
				_showTimer.delay = value;
		}
		
		/**
		 * 
		 * Set a new timer for hiding the StageWebView
		 * 
		 * @param value
		 * 
		 */		
		public function set hideTimerDelay(value:Number):void
		{
			_hideTimerValue = value;
			if(_hideTimer) 
				_hideTimer.delay = value;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			setupTimer(true, false);
			setupTimer(false, false);
		}
		/************************ SETUP ************************/
		
		override protected function buildStageWebView():void
		{
			if(!_autoShow) 
			{
				super.buildStageWebView();
			}
		}
		
		private function checkNeedsBuilding():void
		{
			if(!_added) 
			{
				_added = true;
				super.buildStageWebView();
			}
		}
		
		private function startTime(timer:Timer, startNotStop:Boolean):void
		{
			if(startNotStop) 
			{
				timer.reset();
				timer.start();
			}
			else
			{
				timer.stop();
			}
		}
		
		protected function onHideTimer(event:TimerEvent):void
		{
			startTime(_hideTimer, false);
			broadcastClose();
			hide();
			
			if(_autoShow)
				startTime(_showTimer, true);
		}
		
		protected function onShowTimer(event:TimerEvent):void
		{
			if(_visibilityAllowed)
			{
				checkNeedsBuilding();
				
				startTime(_showTimer, false);
				broadcastOpen();
				show();
				
				if(_autoHide)
				{
					startTime(_hideTimer, true);
				}
			}
		}
		
		private function broadcastOpen():void
		{
			dispatchEvent(new Event(Event.OPEN));
		}
		
		private function broadcastClose():void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function setupTimer(showNotHideTimer:Boolean, mountNotUnmout:Boolean):void
		{
			if(showNotHideTimer)
			{
				if(mountNotUnmout)
				{
					_showTimer = new Timer(_showTimerValue);
					_showTimer.addEventListener(TimerEvent.TIMER, onShowTimer);
				}
				else
				{
					if(_showTimer)
					{
						_showTimer.removeEventListener(TimerEvent.TIMER, onHideTimer);
						_showTimer = null;
					}
				}
			}
			else
			{
				if(mountNotUnmout)
				{
					_hideTimer = new Timer(_hideTimerValue);
					_hideTimer.addEventListener(TimerEvent.TIMER, onHideTimer);
				}
				else
				{
					if(_hideTimer)
					{
						_hideTimer.removeEventListener(TimerEvent.TIMER, onHideTimer);
						_hideTimer = null;
					}
				}
			}
		}
	}
}

