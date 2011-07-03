package uk.co.baremedia.gnomo.presentation
{
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	
	import uk.co.baremedia.gnomo.controls.ControlLogs;
	import uk.co.baremedia.gnomo.controls.ControlPersistedData;
	import uk.co.baremedia.gnomo.enums.EnumsLanguage;
	import uk.co.baremedia.gnomo.models.ModelSharedObject;
	import uk.co.baremedia.gnomo.utils.UtilsResources;
	import uk.co.baremedia.gnomo.utils.UtilsStaticUIInfo;
	import uk.co.baremedia.gnomo.vo.VOLog;
	
	public class PresentationLogs implements IDispose
	{
		[Bindable] public var logs				:ArrayCollection; 
		[Bindable] public var textEditButton	:String;
		
		private var _control					:ControlLogs;
		private var _model						:ModelSharedObject;
		private var _controlPersistedData		:ControlPersistedData;
		
		public function PresentationLogs(control:ControlLogs, modelLogs:ModelSharedObject, controlPersistedData:ControlPersistedData)
		{
			_controlPersistedData 	= controlPersistedData;
			_control 				= control;
			_model 	 				= modelLogs;
			
			_model.add(onModelChange);
			setUIData();	
			
			textEditButton = UtilsResources.getKey(EnumsLanguage.OPTIONS)
		}
		
		private function setUIData():void
		{
			logs = (_model.logs) ? _model.logs.logs : null;
		}
		
		private function onModelChange(change:String):void
		{
			if(change == ModelSharedObject.LOGS)
			{
				//Tracer.log(this, "onModelChange");
				logs = _model.logs.logs;
			}
		}
		
		public function optionClick():void
		{
			if(textEditButton == UtilsResources.getKey(EnumsLanguage.OPTIONS))
			{
				FlexGlobals.topLevelApplication.viewMenuOpen = true;
				textEditButton = UtilsResources.getKey(EnumsLanguage.DONE);
			}
			else
			{
				textEditButton = UtilsResources.getKey(EnumsLanguage.OPTIONS);
				editLogs(false);
			}
		}
		
		public function editLogs(openNotClose:Boolean):void
		{
			UtilsStaticUIInfo.logsShowEditButton = openNotClose;
		}
		
		public function removeLog(log:VOLog):void
		{
			_controlPersistedData.removeLog(log);
		}
		
		public function removeAllLogs():void
		{
			_controlPersistedData.removeAllLogs();
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