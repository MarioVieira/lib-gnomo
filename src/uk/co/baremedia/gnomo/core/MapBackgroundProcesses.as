package uk.co.baremedia.gnomo.core
{
	import org.as3.mvcsInjector.descriptors.DescriptoViews;
	import org.as3.mvcsInjector.interfaces.IBackgroundProcesses;
	import org.as3.mvcsInjector.interfaces.IScreenInitializer;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.backgroundProcess.BackgroundProcessSetupLocalNetwork;
	import uk.co.baremedia.gnomo.backgroundProcess.BackgroundProcessUnitsControl;
	import uk.co.baremedia.gnomo.backgroundProcess.BackgroundProcessViewNavigator;
	import uk.co.baremedia.gnomo.backgroundProcess.BackgroundSetLanguage;

	/**
	 * @author Mario Vieira
	 * 	
	 * 	This class is responsible to all is a background process, and in anything that will happen independent of displaying a graphic user interface
	 */
	 
	public class MapBackgroundProcesses implements IBackgroundProcesses
	{
		/** @private **/
		private var _setLanguage	   :IInitializer;
		private var _setupLanguage	   :IInitializer;
		private var _setupLocalNetwork :IInitializer;
		private var _unitsControlSetup :IInitializer;
		private var _viewNavigation    :IScreenInitializer;
		
		public function initializeProcesses(injector:IInjector):void
		{
			//Tracer.log(this, "initializeProcesses");
			mapRules(injector);
			
			_setLanguage		= injector.getInstance(BackgroundSetLanguage);
			_setupLocalNetwork	= injector.getInstance(BackgroundProcessSetupLocalNetwork);
			_unitsControlSetup	= injector.getInstance(BackgroundProcessUnitsControl);
			_viewNavigation		= injector.getInstance(BackgroundProcessViewNavigator);
		}
		
		public function mapRules(injector : IInjector):void
		{
			injector.mapSingleton(BackgroundSetLanguage);
			injector.mapSingleton(BackgroundProcessSetupLocalNetwork);
			injector.mapSingleton(BackgroundProcessUnitsControl);
			injector.mapSingleton(BackgroundProcessViewNavigator);
		}

		public function setupAppScreens(appScreens:DescriptoViews):void
		{
			_viewNavigation.setupAppScreens(appScreens);
		}
	}
}
