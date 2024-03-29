package uk.co.baremedia.gnomo.controls
{
	import mx.logging.Log;
	
	import org.as3.mvcsInjector.utils.Tracer;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.models.ModelSettings;
	import uk.co.baremedia.gnomo.models.ModelSharedObject;
	import uk.co.baremedia.gnomo.vo.VOLog;
	import uk.co.baremedia.gnomo.vo.VOLogs;
	
	/**
	 * 
	 * @author Mario Vieira
	 * 
	 */
	public class ControlPersistedData implements IInitializer
	{
		/**
		 * 
		 */
		protected var _model:ModelSharedObject;
		public var importantAlerted:Boolean;
		
		
		public function init(injector:IInjector):void
		{
			var modelSettings:ModelSettings = injector.getInstance(ModelSettings);
			
			_model = injector.getInstance(ModelSharedObject);	
			_model.setup(modelSettings.APP_UID);
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set agreementAccepted(value:Boolean):void
		{
			_model.agreementAccepted = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get agreementAccepted():Boolean
		{
			return _model.agreementAccepted;
		}
		
		/**
		 * 
		 * @param action
		 * @param elapsedAudioTransmission
		 * 
		 */
		public function addLog(elapsedTransmissionMilisec:Number):void
		{
			//Tracer.log(this, "addLogs");
			var now:Date 				 = new Date();
			var log:VOLog 				 = new VOLog();
			log.dateAndTime 			 = now.getTime() - elapsedTransmissionMilisec;
			log.elapsedTransmissionSec   = elapsedTransmissionMilisec;
			
			var logsReference:VOLogs = _model.logs;
			logsReference = (!logsReference) ? new VOLogs() : logsReference;
			//Tracer.log(this, "addLogs - logsReference: "+logsReference);
			logsReference.logs.addItem(log);
			
			_model.logs = logsReference;
		}
		
		public function removeLog(log:VOLog):void
		{
			//Tracer.log(this, "removeLog - log: "+log.dateAndTime);
			
			var tmpLogs			:VOLogs = _model.logs;
			var foundItemIndex	:int = _model.getLogIndex(log.dateAndTime);    
			
			if(foundItemIndex != -1) tmpLogs.logs.removeItemAt(foundItemIndex);
			
			_model.logs = tmpLogs;
		}
		
		public function get logs():VOLogs
		{
			return _model.logs;
		}
		
		public function removeAllLogs():void
		{
			var tmpLogs			:VOLogs = _model.logs;
			tmpLogs.logs.removeAll();
			_model.logs = tmpLogs;
		}
	}
}