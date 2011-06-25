package uk.co.baremedia.gnomo.models
{
	import com.projectcocoon.p2p.util.Tracer;
	
	import flash.net.SharedObject;
	
	import org.as3.mvcsInjector.interfaces.IModelChange;
	import org.as3.serializer.Serializer;
	import org.osflash.signals.Signal;
	
	import uk.co.baremedia.gnomo.utils.UtilsDate;
	import uk.co.baremedia.gnomo.vo.VOLog;
	import uk.co.baremedia.gnomo.vo.VOLogs;
	
	public class ModelSharedObject extends Signal implements IModelChange
	{
		protected var _sharedObject	:SharedObject;
		
		public static var LOGS		:String = "logs";
		public static var AGREED	:String = "agrement";
		
		public function ModelSharedObject(){}
		
		public function setup(appUID:String):void
		{
			_sharedObject = SharedObject.getLocal(appUID);
		}
		
		public function set logs(logs:VOLogs):void
		{
			Tracer.log(this, "logs: "+logs);
			_sharedObject.data[logs] = Serializer.serialize( removeLogsOlderThanSevenDays(logs) ).toXMLString();
			broadcastModelChange(LOGS);
		}
		
		public function get logs():VOLogs
		{
			return Serializer.deserialize( XML(_sharedObject.data[logs]) );
		}
		
		public function set agreementAccepted(value:Boolean):void
		{
			_sharedObject.data[AGREED] = int(value);
			broadcastModelChange(AGREED);
		}
		
		public function get agreementAccepted():Boolean
		{
			return int( _sharedObject.data[AGREED] );
		}
		
		protected function removeLogsOlderThanSevenDays(logs:VOLogs):VOLogs
		{
			var sevenDayAgoTime:Number 	= UtilsDate.getSevenDaysAgoDate().getTime();
			var vector:Vector.<VOLog> 	= new Vector.<VOLog>(logs);
			
			for(var i:int; i < vector.length; i++)
			{
				if(vector[i].time >= sevenDayAgoTime) logs.logs.splice(i, 1);
			}
			
			return logs;
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