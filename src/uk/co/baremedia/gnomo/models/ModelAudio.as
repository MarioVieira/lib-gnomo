package uk.co.baremedia.gnomo.models
{
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	
	import flash.media.Microphone;
	import flash.utils.Timer;
	
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;

	[Bindable] 
	public class ModelAudio extends Signal implements IModelChange
	{
		public static const BROADCASTER_MEDIA_AVAILABLE :String = "broadcasterMediaAvailable";
		public static const BROADCAST_CHANGE 			:String = "broadcast";
		public static const ACTIVITY_CHANGE  			:String = "activityChange";
		public static const RECEIVING 		 			:String = "receiving";
		public static const SENSIBILITY_CHANGE			:String = "sensibilityChange";
		public static const DEFAULT_SENSISBILIY			:Number = 50;
		
		public var microphone					:Microphone;
		
		private var _receiving					:Boolean;
		private var _broadcasting				:Boolean;
		private var _sensibilityLevel			:Number	= DEFAULT_SENSISBILIY;
		private var _broadcasterInfo			:MediaBroadcastEvent;
		private var _audioActvity				:Boolean;
		private var _lastTransmissionLength		:Number;
		private var _lastTranmissionLenghtTimer	:Timer;
		
		
		public function get lastTransmissionLength():Number
		{
			return _lastTransmissionLength;
		}

		public function set lastTransmissionLength(value:Number):void
		{
			_lastTransmissionLength = value;
		}

		public function set audioActvity(value:Boolean):void
		{
			_audioActvity = value;
			broadcastModelChange(ACTIVITY_CHANGE);
		}
		
		public function get audioActvity():Boolean
		{
			return _audioActvity;
		}
		
		public function set sensibilityLevel(value:Number):void
		{
			Tracer.log(this, "sensibilityLevel - value: "+value);
			_sensibilityLevel = value;
			broadcastModelChange(SENSIBILITY_CHANGE);
		}
		
		public function get sensibilityLevel():Number
		{
			return _sensibilityLevel;
		}
		
		public function set receiving(value:Boolean):void
		{
			_receiving = value;
			broadcastModelChange(RECEIVING);
		}
		
		public function get receiving():Boolean
		{
			return _receiving;
		}
		
		public function set broadcasterInfo(value:MediaBroadcastEvent):void
		{
			Tracer.log(this, "set broadcasterInfo");
			_broadcasterInfo = value;
			broadcastModelChange(BROADCASTER_MEDIA_AVAILABLE);
		}
		
		public function get broadcasterInfo():MediaBroadcastEvent
		{
			return _broadcasterInfo;
		}
		
		public function get broadcasting():Boolean
		{
			return _broadcasting;
		}

		public function set broadcasting(value:Boolean):void
		{
			_broadcasting = value;
			broadcastModelChange(BROADCAST_CHANGE);
		}
		
		public function broadcastModelChange(changeType:String):void
		{
			dispatch(changeType);
		}
		
		
		public function get dataChange():Signal
		{
			return this;
		}
		
	}
}