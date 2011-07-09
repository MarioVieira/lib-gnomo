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
		[Bindable] public var broadcastMonitorState				: Boolean = true;
		
		private var _localNetworkMessenger						: IP2PMessenger;
		private var _feedbackRequestTimeout						: Timer;
		private var _askFeedbackTimer							: Timer;
		
		private var _connectionIdentifier						: Signal;
		private var _requestCount								: int;
		private var _reponseProvided									: Boolean;
		private var _keepAlive:Boolean;
		
		public function ManagerNetworkMonitor(localNetworkMessenger:IP2PMessenger)
		{
			_connectionIdentifier 	= new Signal(Boolean);
			_localNetworkMessenger 	= localNetworkMessenger;
			
			setupTimers();
		}
		
		public function get connectionStatus():Signal
		{
			return _connectionIdentifier;
		}
		
		private function setupTimers():void
		{
			_feedbackRequestTimeout = new Timer(EnumsLocalNetwork.MONITOR_REQUEST_TIMEOUT);
			_feedbackRequestTimeout.addEventListener(TimerEvent.TIMER, onGroupFeedbackTimeout);
			
			_askFeedbackTimer = new Timer(EnumsLocalNetwork.MONITOR_REQUEST_RESPONSE);
			_askFeedbackTimer.addEventListener(TimerEvent.TIMER, onAskFeedbackTimer);
		}
		
		private function onGroupFeedbackTimeout(event:TimerEvent):void
		{
			if(!_reponseProvided) broadcastConnectionStatus(false);
			else				  _reponseProvided = false;
		}
			
		protected function onAskFeedbackTimer(event:TimerEvent):void
		{
			broadcastToGroup(true);	
		}
		
		public function startNetworkMonitor(startNotStop:Boolean):void
		{
			Tracer.log(this, "startNetworkMonitor - startNotStop: "+startNotStop);
			_keepAlive = startNotStop;
			startFeedbackTimeout(startNotStop);
			startAskFeedbackTimer(startNotStop);
		}
		
		private function startAskFeedbackTimer(startNotStop:Boolean):void
		{
			_askFeedbackTimer.reset();
			if(startNotStop)	_askFeedbackTimer.start();
			else				_askFeedbackTimer.stop();
		}
	
		private function startFeedbackTimeout(startNotStop:Boolean):void
		{
			_feedbackRequestTimeout.reset();
			if(!startNotStop) 	_feedbackRequestTimeout.stop();
			else 				_feedbackRequestTimeout.start();
		}
		
		protected function feedbackReceived():void
		{
			//Tracer.log(this, "feedbackReceived");
			_reponseProvided = true;
			broadcastConnectionStatus(true);
			if(!_keepAlive) startNetworkMonitor(false);
		}
		
		public function defineMessageOperation(message:VOLocalNetworkMessage):void
		{
			//Tracer.log(this, "defineMessageOperation: "+message.messageType);
			if(message.messageType == EnumsLocalNetwork.GROUP_FEEDBACK_RESPONSE) 	 feedbackReceived();
			else if(message.messageType == EnumsLocalNetwork.GROUP_FEEDBACK_REQUEST) broadcastToGroup(false);
			
		}
		
		private function broadcastToGroup(requestNotRespond:Boolean):void
		{
			var message:String = (requestNotRespond) ? EnumsLocalNetwork.GROUP_FEEDBACK_REQUEST : EnumsLocalNetwork.GROUP_FEEDBACK_RESPONSE;
			_localNetworkMessenger.sendMessageToLocalNetwork( UtilsMessenger.getMessage(message, _localNetworkMessenger.deviceType) );
		}
		
		private function broadcastConnectionStatus(connected:Boolean):void
		{
			_connectionIdentifier.dispatch(connected);
		}
	}
}