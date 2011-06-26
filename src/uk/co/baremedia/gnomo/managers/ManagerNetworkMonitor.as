package uk.co.baremedia.gnomo.managers
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.enums.EnumsLocalNetwork;
	import uk.co.baremedia.gnomo.interfaces.IP2PMessenger;
	import uk.co.baremedia.gnomo.utils.UtilsMessenger;
	import uk.co.baremedia.gnomo.vo.VOLocalNetworkMessage;
	
	public class ManagerNetworkMonitor
	{
		[Bindable] public var stopAskingFeedbackOnFirstResponse	: Boolean;
		
		private var _localNetworkMessenger						: IP2PMessenger;
		private var _feedbackRequestTimer						: Timer;
		private var _connectionIdentifier						: Signal;
		private var _requestCount								: int;
		private var _connected									: Boolean;
		
		public var monitorDebug									: Signal;
		
		
		
		
		public function ManagerNetworkMonitor(localNetworkMessenger:IP2PMessenger)
		{
			monitorDebug			= new Signal();
			_connectionIdentifier 	= new Signal(Boolean);
			_localNetworkMessenger 	= localNetworkMessenger;
			
			setupGroupFeebackTimer( EnumsLocalNetwork.MONITOR_FIRST_CONNECTION_DELAY );
		}
		
		public function get connectionStatus():Signal
		{
			return _connectionIdentifier;
		}
		
		private function setupGroupFeebackTimer(delay:Number):void
		{
			if(!_feedbackRequestTimer)
			{
				//debug("1st CONNECTION TIME: "+delay);
				_feedbackRequestTimer = new Timer(delay);
				_feedbackRequestTimer.addEventListener(TimerEvent.TIMER, onGroupFeedbackTimeoutRequest);
			}
			else if(_feedbackRequestTimer.delay != delay)
			{
				//debug("CONNECTED; CHANGE TIME TO KEEP ALIVE: "+delay);
				_feedbackRequestTimer.reset();
				_feedbackRequestTimer.delay = delay;
				_feedbackRequestTimer.start();
			}
		}
		
		public function askFeedback(monitorActive:Boolean):void
		{
			if(monitorActive)
			{
				broadcastToGroup(true);
				startFeedbackTimer(true);
			}
			else
			{
				broadcastToGroup(false);
				startFeedbackTimer(false);
			}
		}
		
		protected function handleConnectionStatus(connected:Boolean):void
		{
			if(connected) hasExceededWaiting(true);
			
			if(connected)
			{
				setupGroupFeebackTimer( EnumsLocalNetwork.MONITOR_CONNECTION_DELAY );
			}
			else
			{
				setupGroupFeebackTimer( EnumsLocalNetwork.MONITOR_FIRST_CONNECTION_DELAY );
			}
		}
		
		/**
		 *
		 * This is the handler for the group feedback request timer. When called it means no group feedback has been provided, therefore no connection.
		 *  
		 * @param event
		 * 
		 */		
		
		private function onGroupFeedbackTimeoutRequest(event:TimerEvent):void
		{
			//Tracer.log(this, "onGroupFeedbackTimeoutRequest");
			broadcastToGroup(true);
			
			//var canBroadcastConnectionStatus:Boolean = (_connected) ? hasExceededWaiting() : true;
			if( hasExceededWaiting() )
			{
				//Tracer.log(this, "onGroupFeedbackTimeoutRequest - hasExceededWaiting");
				//debug("NO GROUP FEEDBACK");
				_connected = false;
				hasExceededWaiting(true);
				handleConnectionStatus(false);
				broadcastConnectionStatus(false);
			}
			else
			{
				//debug("WAITING GROUP FEEDBACK");
			}
		}
		
		private function hasExceededWaiting(reset:Boolean = false):Boolean
		{
			if(!reset) _requestCount++
			else _requestCount = 0;
			
			return (_requestCount > 2);
		}
		
		private function broadcastToGroup(requestNotResponseFeeback:Boolean):void
		{
			var message:String = (requestNotResponseFeeback) ? EnumsLocalNetwork.GROUP_FEEDBACK_RESPONSE : EnumsLocalNetwork.GROUP_FEEDBACK_REQUEST;
			_localNetworkMessenger.sendMessageToLocalNetwork( UtilsMessenger.getMessage(message, _localNetworkMessenger.deviceType) );
		}
		
		private function startFeedbackTimer(startNotStop:Boolean):void
		{
			Tracer.log(this, "startFeedbackTimer - startNotStop: "+startNotStop);
			
			if(!startNotStop)
			{
				_feedbackRequestTimer.stop();
			}
			else if(startNotStop && !_feedbackRequestTimer.running)
			{
				_feedbackRequestTimer.reset();
				_feedbackRequestTimer.start();
			}
		}
		
		public function defineMessageOperation(message:VOLocalNetworkMessage):void
		{
			if(message.messageType == EnumsLocalNetwork.GROUP_FEEDBACK_RESPONSE)
			{
				groupFeebackReceived();
			}
			else if(message.messageType == EnumsLocalNetwork.GROUP_FEEDBACK_REQUEST)
			{
				broadcastToGroup(false);
			}
		}
		
		private function groupFeebackReceived():void
		{
			//Tracer.log(this, "groupFeebackReceived");
			_connected = true;
			broadcastConnectionStatus(true);
			handleConnectionStatus(true);
			if(stopAskingFeedbackOnFirstResponse) 
				askFeedback(false);			
			//debug("GROUP FEEDBACK RECEIVED");
		}
		
		private function broadcastConnectionStatus(connected:Boolean):void
		{
			_connectionIdentifier.dispatch(connected);
		}
		
		protected function debug(message:String):void
		{
			monitorDebug.dispatch(message);
		}
	}
}