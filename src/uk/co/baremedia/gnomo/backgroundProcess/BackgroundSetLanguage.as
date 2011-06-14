package uk.co.baremedia.gnomo.backgroundProcess
{
	import org.as3.mvcsInjector.core.Language;
	import org.as3.mvcsInjector.utils.Tracer;
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;
	
	import uk.co.baremedia.gnomo.descriptors.DescriptorLanguage;
	import uk.co.baremedia.gnomo.enums.EnumsAppState;
	import uk.co.baremedia.gnomo.enums.EnumsScreens;
	import uk.co.baremedia.gnomo.models.ModelAppState;
	import uk.co.baremedia.gnomo.models.Locale;
	import uk.co.baremedia.gnomo.models.ModelScreens;
	import uk.co.baremedia.gnomo.signals.SignalViewNavigation;
	import uk.co.baremedia.gnomo.utils.UtilsScreens;
	
	
	public class BackgroundSetLanguage implements IInitializer
	{
		protected var _locale		 :Language
		protected var _languageModel :Locale;
	
		public function init(injector:IInjector):void
		{
			_languageModel  = injector.getInstance(Locale);
			_locale			= injector.getInstance(Language);
			
			setLanguage();
		}
		
		protected function setLanguage():void
		{
			_languageModel.setLanguage(DescriptorLanguage(_locale.locale));
			Tracer.log(this, "setLanguage() test: "+Locale.screenModesButtonWireless);
		}
	}
}