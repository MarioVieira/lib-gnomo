package uk.co.baremedia.gnomo.presentation
{
	import mx.collections.ArrayCollection;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	
	import uk.co.baremedia.gnomo.controls.ControlLogs;
	import uk.co.baremedia.gnomo.enums.EnumsLanguage;
	import uk.co.baremedia.gnomo.models.ModelSharedObject;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	import uk.co.baremedia.gnomo.utils.UtilsResources;
	import uk.co.baremedia.gnomo.vo.VOLogs;
	
	public class PresentationLogs implements IDispose
	{
		[Bindable] public var logs:ArrayCollection; 
		
		private var _control:ControlLogs;
		private var _model:ModelSharedObject;
		
		public function PresentationLogs(control:ControlLogs, modelLogs:ModelSharedObject)
		{
			_control = control;
			_model 	 = modelLogs;
			
			_model.add(onModelChange);
			setUIData();	
		}
		
		private function setUIData():void
		{
			logs = (_model.logs) ? _model.logs.logs : null;
		}
		
		private function onModelChange(change:String):void
		{
			if(change == ModelSharedObject.LOGS)
			{
				Tracer.log(this, "onModelChange");
				logs = _model.logs.logs;
			}
		}
		
		public function requestScreenUnits():void
		{
			_control.requestScreenUnits();
		}
		
		public function requestScreenLogsMain():void
		{
			_control.requestScreenLogsMain();	
		}
		
		public function requestScreenLogsDay():void
		{
			_control.requestScreenLogDay();
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			_model.remove(onModelChange);
		}
	}
}