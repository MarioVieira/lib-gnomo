package uk.co.baremedia.gnomo.helper
{
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.interfaces.IConnected;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelBroadcaster;
	import uk.co.baremedia.gnomo.models.ModelModes;
	import uk.co.baremedia.gnomo.models.ModelNetworkManager;
	import uk.co.baremedia.gnomo.models.ModelReceiver;
	import uk.co.baremedia.gnomo.models.ModelSharedObject;
	import uk.co.baremedia.gnomo.utils.UtilsDeviceInfo;
	import uk.co.baremedia.gnomo.utils.UtilsMedia;
	import uk.co.baremedia.gnomo.utils.UtilsMessenger;
	
	public class HelperConnection implements IConnected
	{
		private var _modelAudio:ModelAudio;
		private var _modelBroadcaster:ModelBroadcaster;
		private var _modelNetworkManager:ModelNetworkManager;
		private var _modelSharedObject:ModelSharedObject;
		private var _modelModes:ModelModes;
		
		
		public function init(injector:IInjector):void
		{
			_modelAudio = injector.getInstance(ModelAudio);
			_modelModes = injector.getInstance(ModelModes);
			_modelBroadcaster = injector.getInstance(ModelBroadcaster);
			_modelNetworkManager = injector.getInstance(ModelNetworkManager);
			_modelSharedObject = injector.getInstance(ModelSharedObject);
		}

		public function get localNetworkConnected():Boolean
		{
			return _modelModes.localNetworkConnected;
		}
		
		public function get isBroadcasterInBackgroundMode():Boolean
		{
			return _modelAudio.audioActivityStream && isBroadcasterIOS;
		}

		public function get hasBroadcasterBeenConnected():Boolean
		{
			return true;
		}
		
		[Bindable]
		public function get isBroadcasterIOS():Boolean
		{
			return (_modelAudio.broadcasterInfo && _modelAudio.broadcasterInfo.mediaInfo) ?  UtilsDeviceInfo.isIOSDevice(UtilsDeviceInfo.IPAD) : false;
			//return (_modelAudio.broadcasterInfo && _modelAudio.broadcasterInfo.mediaInfo) ?  UtilsDeviceInfo.isIOSDevice(_modelAudio.broadcasterInfo.mediaInfo.deviceVersion) : false;
		}
	}
}