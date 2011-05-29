package co.uk.baremedia.gnomo.controls
{
	import co.uk.baremedia.gnomo.enums.EnumsModes;
	import co.uk.baremedia.gnomo.models.ModelModes;
	
	import org.robotlegs.core.IInjector;

	public class ControlModes
	{
		[Inject]
		public var injector				:IInjector;
		
		public var _model				:ModelModes;
		
		public var _networkConnection	:ControlNetworkManager;
		
		[PostConstruct]
		public function init():void
		{
			_model 				= injector.getInstance(ModelModes);
			_networkConnection 	= injector.getInstance(ControlNetworkManager);
		}
		
		public function setMode(mode:int):void
		{
			if(mode == EnumsModes.MODE_CONNECTED)
			{
				tryLocalNetworkConnection();	
			}
			else if(mode == EnumsModes.MODE_DISCONECTED)
			{
				
			}
		}

		protected function tryLocalNetworkConnection():void
		{
			_networkConnection.connect();	
		}
		
		protected function canChangeMode(mode:int):Boolean
		{
			//no baby unit registered
			if(_model.noModeSelected)
			{
				if(_model.)
				{
					
				}
				return true;
			}
			else if(mode == EnumsModes.MODE_CONNECTED)
			{
					
			}
			else if(mode == EnumsModes.MODE_DISCONECTED)
			{
				
			}
		}
	}
}