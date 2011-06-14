package uk.co.baremedia.gnomo.controls
{
	import uk.co.baremedia.gnomo.models.ModelBroadcaster;

	//NOT TOO SURE WE NEED THIS CLASS
	public class ControlBroadcaster
	{
		protected var _model:ModelBroadcaster;
		
		public function ControlBroadcaster(model:ModelBroadcaster) 
		{
			_model = model;
		}
	}
}