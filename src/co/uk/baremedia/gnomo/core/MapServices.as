package co.uk.baremedia.gnomo.core
{
	import org.as3.mvcsc.interfaces.IMappingInjector;
	import org.robotlegs.core.IInjector;
	
	/**  
	 * 
	 * Maps the application Servivces to their Mediators
	 * 
	 * @author Mario Vieira
	 * 
	 */
	public class MapServices implements IMappingInjector
	{
		public function mapRules(injector : IInjector) : void
		{
			//Tracer.log(this, "mapRules");
			//injector.mapSingletonOf(IServiceLogger, ServiceLogger);
		}
	}
}