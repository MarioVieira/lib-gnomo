package uk.co.baremedia.gnomo.presentation
{
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	
	import uk.co.baremedia.gnomo.enums.EnumsLanguage;
	import uk.co.baremedia.gnomo.utils.UtilsResources;
	
	public class PresentationScreenInfo implements IDispose
	{
		[Bindable] public var textInfoHTML:String;
		
		public function PresentationScreenInfo()
		{
			setText();	
		}
		
		private function setText():void
		{
			textInfoHTML = UtilsResources.getKey(EnumsLanguage.INFORMATION);
			Tracer.log(this, "setText - textInfoHTML: "+textInfoHTML);
		}

		public function dispose(recursive:Boolean=true):void
		{
			// TODO Auto-generated method stub
		}
	}
}