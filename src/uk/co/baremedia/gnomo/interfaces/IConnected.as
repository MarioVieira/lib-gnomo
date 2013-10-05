package uk.co.baremedia.gnomo.interfaces
{
	import org.robotlegs.core.IInitializer;
	import org.robotlegs.core.IInjector;

	public interface IConnected extends IInitializer
	{
		function get localNetworkConnected():Boolean;
		function get hasBroadcasterBeenConnected():Boolean;
		function get isBroadcasterInBackgroundMode():Boolean;
		function get isBroadcasterIOS():Boolean;
	}
}