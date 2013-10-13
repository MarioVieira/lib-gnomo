package uk.co.baremedia.gnomo.presentation
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	
	import mx.core.FlexGlobals;
	import mx.managers.ISystemManager;
	import mx.managers.SystemManager;
	
	import org.as3.mvcsInjector.interfaces.IDispose;
	import org.as3.mvcsInjector.utils.Tracer;
	
	import spark.components.Application;
	import spark.components.supportClasses.StyleableTextField;
	
	import uk.co.baremedia.gnomo.enums.EnumsLanguage;
	import uk.co.baremedia.gnomo.utils.UtilsResources;
	import uk.co.baremedia.gnomo.utils.UtilsStaticUIInfo;
	
	public class PresentationInfo implements IDispose
	{
		private var _view:IComponentInfo;
		private var _fileStream:FileStream;
		
		public function PresentationInfo(componentInfo:IComponentInfo)
		{
			_view = componentInfo;
			setText();
		}
		
		private function oberve():void
		{
			/*_view.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChanging);
			_view.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChanged);
			*/
		}
		
		/*private function onOrientationChanging():void
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
			_webView.reload();
			_webView.historyBack();
			setText();
		}
		
		[Bindable]
		public function get hasHistory():Boolean
		{
			return _webView.isHistoryBackEnabled;
		}*/
		
		private function setText():void
		{
			//textInfoHTML = UtilsResources.getKey(EnumsLanguage.INFORMATION);
			loadFile();
		}
		
		private function loadFile():void{
			var file:File = File.applicationDirectory.resolvePath("assets/helpContent.html");
			_fileStream = new FileStream();
			_fileStream.addEventListener(Event.COMPLETE, onFileLoaded);
			_fileStream.openAsync(file, FileMode.READ);
			
			/*var src:File = File.applicationDirectory.resolvePath("assets/helpContent.html");
			_webView.loadURL("file://" + src.nativePath);*/
		}
		
		protected function onFileLoaded(event:Event):void
		{
			_fileStream.removeEventListener(Event.COMPLETE, onFileLoaded);
			var text:String = _fileStream.readUTFBytes(_fileStream.bytesAvailable);
			_fileStream.close();
			Tracer.log(this, "onFileLoaded - text:\n "+text);
			/*StyleableTextField(_view.textAreaField).htmlText = text;*/
			setTextFlow(text);
		}
		
		private function setTextFlow(text:String):void
		{
			var tmpTextFlow:TextFlow = TextConverter.importToFlow(text, TextConverter.TEXT_FIELD_HTML_FORMAT);
			/*var tmpText:String = String(TextConverter.export(tmpTextFlow,TextConverter.PLAIN_TEXT_FORMAT, ConversionType.STRING_TYPE));*/
			
			_view.htmlTextFlow = tmpTextFlow;
			/*_view.text = tmpText;*/
			/*Tracer.log(this, "setTextFlow - text:\n "+tmpText);*/
		}
		
		public function dispose(recursive:Boolean=true):void
		{
			
		}
	}
}