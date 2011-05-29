package co.uk.baremedia.gnomo.controls
{
	import co.uk.baremedia.gnomo.models.ModelBroadcaster;
	import co.uk.baremedia.gnomo.utils.UtilsMedia;
	import co.uk.baremedia.gnomo.vo.VOBroadcasterInfo;
	
	import flash.media.Microphone;
	
	import org.robotlegs.core.IInjector;

	
	//NOT TOO SURE WE NEED THIS CLASS
	public class ControlBroadcaster
	{
		[Inject]
		public var injector:IInjector;
		
		protected var _model:ModelBroadcaster;
		
		[PostConstruct]
		public function init():void
		{
			_model = injector.getInstance(ModelBroadcaster);
		}
		
		public function broadcastAudio(broadcaster:ModelBroadcaster):Microphone
		{
			//UNSURE: stop start broadcasting funcitonality or relt on NetConnection coming back?
			//if(_model.broadcasting)
			var mic:Microphone = UtilsMedia.getDefaultMicrophone();
			
			if(mic)
			{
				_model.broadcaster  = true;
				_model.mediaInfo.
			}
			
			//did not manage
			return null;
		}
	}
}