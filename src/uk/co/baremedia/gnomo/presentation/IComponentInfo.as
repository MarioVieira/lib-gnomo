package uk.co.baremedia.gnomo.presentation
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	import flashx.textLayout.elements.TextFlow;
	
	import mx.core.IUIComponent;
	
	import spark.components.TextArea;

	public interface IComponentInfo extends IEventDispatcher
	{
		function get textGroup():IUIComponent;
		function get stage():Stage;
		
		function set htmlTextFlow(value:TextFlow):void;
		function get htmlTextFlow():TextFlow;
		
		function set text(value:String):void;
		function get text():String;
		/*function get textAreaField():TextArea;*/
	}
}