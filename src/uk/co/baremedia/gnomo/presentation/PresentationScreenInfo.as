package uk.co.baremedia.gnomo.presentation
{
	import flash.display.Stage;
	import flash.events.StageOrientationEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import mx.core.FlexGlobals;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManager;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	
	import spark.components.Application;
	
	import uk.co.baremedia.gnomo.enums.EnumsLanguage;
	import uk.co.baremedia.gnomo.utils.UtilsResources;
	import uk.co.baremedia.gnomo.utils.UtilsStaticUIInfo;
	
	public class PresentationScreenInfo implements IDispose
	{
		private var _webView:StageWebView;
		private var _view:IComponentInfo;
		
		public function PresentationScreenInfo(componentInfo:IComponentInfo)
		{
			_view = componentInfo;
			setupWebView();
			oberve();
		}
		
		private function oberve():void
		{
			_view.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChanging);
			_view.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChanged);
			
		}
		
		private function onOrientationChanging():void
		{
			removeViewPort(true);
		}
		
		private function removeViewPort(removeNotAdd:Boolean):void
		{
			if(removeNotAdd)
				_webView.viewPort = new Rectangle();
			else
				updateWebView();	
		}
		
		private function onOrientationChanged(e:StageOrientationEvent):void
		{
			updateWebView();
		}
		
		protected function setupWebView():void
		{
			_webView = new StageWebView();			
			_webView.stage = _view.stage;
			setText();
			updateWebView();  
		}
		
		protected function updateWebView():void
		{
			_webView.viewPort = new Rectangle( 0, UtilsStaticUIInfo.actioBarHeight, _view.textGroup.width, _view.textGroup.height);
		}
		
		public function backHistory():void
		{
			/*_webView.reload();
			_webView.historyBack();*/
			setText();
		}
		
		[Bindable]
		public function get hasHistory():Boolean
		{
			return _webView.isHistoryBackEnabled;
		}
		
		private function setText():void
		{
			//textInfoHTML = UtilsResources.getKey(EnumsLanguage.INFORMATION);
			var src:File = File.applicationDirectory.resolvePath("assets/helpContent.html");
			_webView.loadURL("file://" + src.nativePath);
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			if(_webView)
			{
				_webView.dispose();
				_webView = null;
			}
			
			_view.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChanging);
			_view.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChanged);
		}
	}
}