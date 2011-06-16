package uk.co.baremedia.gnomo.models
{
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	
	import flash.media.Microphone;
	
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;

	[Bindable] 
	public class ModelAudio extends Signal implements IModelChange
	{
		public static const BROADCASTER_MEDIA_AVAILABLE :String = "broadcasterMediaAvailable";
		public static const BROADCAST_CHANGE 			:String = "broadcast";
		public static const ACTIVITY_CHANGE  			:String = "audio";
		public static const RECEIVING 		 			:String = "receiving";
		
		public var microphone		:Microphone;
		
		private var _receiving		:Boolean;
		private var _broadcasting	:Boolean;
		private var _broadcasterInfo:MediaBroadcastEvent;
		
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