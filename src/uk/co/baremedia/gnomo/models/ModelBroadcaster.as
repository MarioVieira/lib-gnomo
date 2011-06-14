package uk.co.baremedia.gnomo.models
{
	import com.projectcocoon.p2p.vo.MediaVO;
	
	import flash.media.Microphone;
	
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.osflash.signals.Signal;
	
	public class ModelBroadcaster extends Signal implements IModelChange
	{
		//maybe, too few vars for now:
		//public var broadcaterInfo				:VOBroadcasterInfo;
		
		public var broadcasting :Boolean;
		public var broadcaster  :Boolean;
		public var type			:String;
		public var mediaInfo	:MediaVO;
		public var microphone	:Microphone;
		
		public function ModelBroadcaster()
		{
			
		}
		
		public function get dataChange():Signal
		{
			return this;
		}
		
		public function broadcastModelChange(changeType:String):void
		{
			dispatch(changeType);
		}
	}
}