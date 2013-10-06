package uk.co.baremedia.gnomo.presentation
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	import mx.core.IUIComponent;

	public interface IComponentInfo extends IEventDispatcher
	{
		function get textGroup():IUIComponent;
		function get validStage():Stage;
		function get stage():Stage;
	}
}