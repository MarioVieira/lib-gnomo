package uk.co.baremedia.gnomo.core
{
	import com.projectcocoon.p2p.util.Tracer;
	
	import org.as3.mvcsInjector.interfaces.IMappingInjector;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.models.Locale;
	import uk.co.baremedia.gnomo.models.ModelAppState;
	import uk.co.baremedia.gnomo.models.ModelAudio;
	import uk.co.baremedia.gnomo.models.ModelBroadcaster;
	import uk.co.baremedia.gnomo.models.ModelDeviceInfo;
	import uk.co.baremedia.gnomo.models.ModelModes;
	import uk.co.baremedia.gnomo.models.ModelNetworkManager;
	import uk.co.baremedia.gnomo.models.ModelReceiver;
	import uk.co.baremedia.gnomo.models.ModelScreens;
	import uk.co.baremedia.gnomo.models.ModelSettings;

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
			//Tracer.log(this, "mapRules");
			injector.mapSingleton(Locale);
			injector.mapSingleton(ModelReceiver);
			injector.mapSingleton(ModelDeviceInfo);
			injector.mapSingleton(ModelSettings);
			injector.mapSingleton(ModelModes);
			injector.mapSingleton(ModelNetworkManager);
			injector.mapSingleton(ModelAudio);
			injector.mapSingleton(ModelBroadcaster);
			injector.mapSingleton(ModelScreens);
			injector.mapSingleton(ModelAppState);
		}
	}
}