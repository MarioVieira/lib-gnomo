package uk.co.baremedia.gnomo.controls
{
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
		public function addLog(action:String, elapsedAudioTransmission:Number):void
		{
			Tracer.log(this, "addLogs");
			
			var now:Date 				 = new Date();
			var log:VOLog 				 = new VOLog();
			log.action 					 = action;
			log.dateAndTime 			 = now.toString();
			log.time 					 = now.getTime();
			log.elapsedAudioTransmission = elapsedAudioTransmission;
			
			var logsReference:VOLogs = _model.logs;
			logsReference.logs.push(log);
			
			_model.logs = logsReference;
		}
	}
}