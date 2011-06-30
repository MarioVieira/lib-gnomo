package uk.co.baremedia.gnomo.models
{
	import com.projectcocoon.p2p.util.Tracer;
	
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.managers.ICursorManager;
	
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
		
		public function set logs(newLogs:VOLogs):void
		{
			Tracer.log(this, "SAVE logs: "+newLogs);
			_sharedObject.data[LOGS] = Serializer.serialize( removeLogsOlderThanSevenDays(newLogs) ).toXMLString();
			flush();
			broadcastModelChange(LOGS);
		}
		
		public function get logs():VOLogs
		{
			var tmpObject:Object = _sharedObject.data[LOGS];
			Tracer.log(this, "GET logs: "+tmpObject);
			return (tmpObject) ? Serializer.deserialize( XML(_sharedObject.data[LOGS]) ) as VOLogs : null;
		}
		
		public function set agreementAccepted(value:Boolean):void
		{
			_sharedObject.data[AGREED] = int(value);
			flush();
			broadcastModelChange(AGREED);
		}
		
		public function get agreementAccepted():Boolean
		{
			return int( _sharedObject.data[AGREED] );
		}
		
		protected function removeLogsOlderThanSevenDays(logs:VOLogs):VOLogs
		{
			/*var nowTime			:Number				= new Date().getTime();
			var sevenDayAgoTime	:Number 			= UtilsDate.getSevenDaysAgoDate().getTime();
			
			var tmpLogs			:ArrayCollection 	= new ArrayCollection(logs.logs.source);
			var foundLogsIndexes:Array 				= [];
			
			for(var i:int; i < tmpLogs.length; i++)
			{
				if(sevenDayAgoTime - tmpLogs[i].dateAndTime < nowTime) 
					foundLogsIndexes.push(i);
			}
			
			for each(var index:int in foundLogsIndexes)
			{
				if(tmpLogs.length >= index) tmpLogs.removeItemAt(index);	
			}
			
			var newLogs:VOLogs = new VOLogs();
			newLogs.logs = tmpLogs;*/
			
			return logs;
		}
		
		public function getLogIndex(logsDateAndTime:Number):int
		{
			var tmpLogs	:ArrayCollection 	= new ArrayCollection(logs.logs.source);
			
			for(var i:int; i < tmpLogs.length; i++)
			{
				if( tmpLogs[i].dateAndTime == logsDateAndTime ) return i;
			}
			
			return -1;
		}


		public function get dataChange():Signal
		{
			return this;
		}

		public function broadcastModelChange(changeType:String):void
		{
			dispatch(changeType);
		}
		
		protected function flush():void
		{
			_sharedObject.flush();
		}
	}
}