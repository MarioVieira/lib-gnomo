package co.uk.baremedia.gnomo.core
{
	import com.projectcocoon.p2p.util.Tracer;
	
	import org.as3.mvcsc.interfaces.IMappingInjector;
	import org.robotlegs.core.IInjector;
	import co.uk.baremedia.gnomo.models.ModelSettings;
	import co.uk.baremedia.gnomo.models.ModelNetworkManager;
	import co.uk.baremedia.gnomo.models.ModelAudioMonitor;
	import co.uk.baremedia.gnomo.models.ModelBroadcaster;
	import co.uk.baremedia.gnomo.models.ModelModes;

	/**  
	 * 
	 * Maps the application Models
	 * 
	 * @author Mario Vieira
	 *
	 */
	public class MapModels implements IMappingInjector
	{
		/**
		 * 
		 * @param injector
		 * 
		 */
		public function mapRules(injector:IInjector) : void
		{
			Tracer.log(this, "mapRules");
			injector.mapSingleton(ModelSettings);
			injector.mapSingleton(ModelModes);
			injector.mapSingleton(ModelNetworkManager);
			injector.mapSingleton(ModelAudioMonitor);
			injector.mapSingleton(ModelBroadcaster);
		}
	}
}