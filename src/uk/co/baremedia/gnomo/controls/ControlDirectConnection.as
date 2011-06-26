package uk.co.baremedia.gnomo.controls
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	
	public class ControlDirectConnection
	{
		private var _netconnection		:NetConnection;
		private var _client				:Object;
		private var _broadcasterPeerId	:String;
		private var _netStream			:NetStream;
		public var netStreamMessage		:Signal;
		
		public function ControlDirectConnection()
		{
			//_netconnection 		= netconnection;
			//_netStream			= netStream;
			
			netStreamMessage = new Signal();
		}
		
		/*
		public function setupDirectConnection(broadcasterPeerId:String):void
		{
		_broadcasterPeerId 	= broadcasterPeerId;
		}
		protected function setupClient():void
		{
		Tracer.log(this, "setupClient");
		var client:Object = new Object();
		client.onRelay = function(message:String):void{ Tracer.log(this, "directMessage 2 - message: "+message); }
		_netconnection.client = client;
		}
		
		public function sendDirectMessage(message:String):void
		{
		Tracer.log(this, "sendDirectMessage - message: "+message+" _broadcasterPeerId: "+_broadcasterPeerId);
		_netconnection.call("relay", null, _broadcasterPeerId); 
		}
		
		public function onRelay(message:String):void
		{
		Tracer.log(this, "directMessage - message: "+message);
		}*/
		
		public function setupDirectConnection(netStream:NetStream):void
		{
			Tracer.log(this, "setupDirectConnections - netStream: "+netStream);
			_netStream = netStream;
			setupClient();
		}
		
		protected function setupClient():void
		{
			//Tracer.log(this, "setupClient");
			var client:Object = new Object();
			
			client.receive = function receive(message:String, integer:int):void
			{ 
				trace("receive: "+message+"  integer: "+integer);
				netStreamMessage.dispatch(message, integer);
			}
			
			_netStream.client = client;
		}
		
		public function sendDirectMessage(message:String, integer:int):void
		{
			Tracer.log(this, "sendDirectMessage - message: "+message+"  integer: "+integer);
			_netStream.send("receive", message, integer);
		}
	}
}