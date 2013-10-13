package uk.co.baremedia.gnomo.models
{
	import com.projectcocoon.p2p.events.MediaBroadcastEvent;
	import com.projectcocoon.p2p.vo.MediaVO;
	
	import flash.media.Microphone;
	import flash.net.NetStream;
	import flash.net.NetStreamInfo;
	import flash.utils.Timer;
	
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.interfaces.IBroadcasting;
	import uk.co.baremedia.gnomo.vo.VOSlider;

	[Bindable] 
	public class ModelAudio extends Signal implements IModelChange, IBroadcasting
	{
		public static const BROADCASTER_MEDIA_AVAILABLE :String = "broadcasterMediaAvailable";
		public static const BROADCAST_CHANGE 			:String = "broadcast";
		public static const ACTIVITY_CHANGE  			:String = "activityChange";
		public static const RECEIVING 		 			:String = "receiving";
		public static const SENSIBILITY_CHANGE			:String = "sensibilityChange";
		public static const NET_STREAM_CHANGE			:String = "netStreamChange";
		public static const DEFAULT_SENSISBILIY			:Number = 2;
		
		public var volume								:Number = 5;
		public var mediaProviderInfo					:MediaVO;
		
		private var _microphone					:Microphone;
		private var _receiving					:Boolean;
		private var _broadcasting				:Boolean;
		private var _sensibilityLevel			:VOSlider = new VOSlider();
		private var _broadcasterInfo			:MediaBroadcastEvent;
		private var _audioActvity				:Boolean;
		private var _lastTransmissionLength		:Number;
		private var _lastTranmissionLenghtTimer	:Timer;
		private var _audioActivityStream		:NetStream;
		private var _audioActvityOnSignal		:Signal;
		private var _audioActivityStreamSignal  :Signal;
		

		
		public function ModelAudio() 
		{
			_audioActvityOnSignal = new Signal(Boolean);
			_audioActivityStreamSignal = new Signal(NetStream);
		}
		
		public function get audioActivityStream():NetStream
		{
			return _audioActivityStream;
		}
		
		public function get audioActivityStreamSignal():Signal
		{
			return _audioActivityStreamSignal;
		}
		
		public function get isPlayingOrBroacasting():Boolean
		{
			return (_audioActivityStream);
		}

		public function set audioActivityStream(value:NetStream):void
		{
			_audioActivityStream = value;
			_audioActivityStreamSignal.dispatch(value);
		}

		public function set microphone(value:Microphone):void
		{
			_microphone = value;
			//updateSilenceLevel();
		}
		
		private function updateSilenceLevel():void
		{
			if(_microphone)
				_microphone.setSilenceLevel(_sensibilityLevel.sliderActualValue);
		}
		
		public function get microphone():Microphone
		{
			return _microphone;
		}
		
		public function get lastTransmissionLength():Number
		{
			return _lastTransmissionLength;
		}

		public function set lastTransmissionLength(value:Number):void
		{
			_lastTransmissionLength = value;
		}

		public function set audioActivityOn(value:Boolean):void
		{
			//Tracer.log(this, "audioActivityOn.DISPATCH: "+value);
			_audioActvity = value;
			_audioActvityOnSignal.dispatch(value);
		}
		
		public function get audioActivityOn():Boolean
		{
			return _audioActvity;
		}
		
		public function get audioActivityOnSignal():Signal
		{
			return _audioActvityOnSignal;
		}
		
		public function set sensibilityLevel(value:VOSlider):void
		{
			Tracer.log(this, "sensibilityLevel - sliderActualValue: "+value.sliderActualValue+" - sliderViewValue: "+value.sliderViewValue);
			
			_sensibilityLevel = value;
			//updateSilenceLevel();
			broadcastModelChange(SENSIBILITY_CHANGE);
		}
		
		public function get sensibilityLevel():VOSlider
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
			//Tracer.log(this, "set broadcasterInfo");
			_broadcasterInfo = value;
			broadcastModelChange(BROADCASTER_MEDIA_AVAILABLE);
		}
		
		[Bindable]
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